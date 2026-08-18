// Requires outbound HTTPS allowed for login.microsoftonline.com and graph.microsoft.com in BC admin
codeunit 80801 "PMS SharePoint Mgt"
{
    var
        SecretKey: Label 'PMS_SP_CLIENT_SECRET', Locked = true;

    procedure CreatePropertyFolder(var PropertyRec: Record "PMS Property")
    var
        Setup: Record "PMS Setup";
        AccessToken: Text;
        FolderUrl: Text;
        PropId: Code[20];
    begin
        Setup.GetRecordOnce();
        ValidateSetup(Setup);
        AccessToken := GetAccessToken(Setup);
        EnsureSiteAndDriveIds(Setup, AccessToken);
        PropId := PropertyRec."Property ID";
        EnsureFolder(Setup."SP Graph Drive ID", AccessToken, '', 'Properties');
        EnsureFolder(Setup."SP Graph Drive ID", AccessToken, 'Properties', PropId);
        FolderUrl := EnsureFolder(Setup."SP Graph Drive ID", AccessToken, 'Properties/' + PropId, 'Documents');
        PropertyRec."SharePoint Folder URL" := CopyStr(FolderUrl, 1, MaxStrLen(PropertyRec."SharePoint Folder URL"));
        PropertyRec.Modify(true);
        Message('SharePoint folder created successfully.');
    end;

    procedure CreateJobFolder(var JobRec: Record "PMS Job")
    var
        Setup: Record "PMS Setup";
        AccessToken: Text;
        FolderUrl: Text;
        JobNo: Code[20];
    begin
        Setup.GetRecordOnce();
        ValidateSetup(Setup);
        AccessToken := GetAccessToken(Setup);
        EnsureSiteAndDriveIds(Setup, AccessToken);
        JobNo := JobRec."Job No.";
        EnsureFolder(Setup."SP Graph Drive ID", AccessToken, '', 'Jobs');
        EnsureFolder(Setup."SP Graph Drive ID", AccessToken, 'Jobs', JobNo);
        FolderUrl := EnsureFolder(Setup."SP Graph Drive ID", AccessToken, 'Jobs/' + JobNo, 'Documents');
        JobRec."SharePoint Folder URL" := CopyStr(FolderUrl, 1, MaxStrLen(JobRec."SharePoint Folder URL"));
        JobRec.Modify(true);
        Message('SharePoint folder created successfully.');
    end;

    procedure SetClientSecret(SecretValue: Text)
    var
        Setup: Record "PMS Setup";
    begin
        IsolatedStorage.Set(SecretKey, SecretValue, DataScope::Module);
        Setup.GetRecordOnce();
        Setup."SP Has Client Secret" := true;
        Setup.Modify();
    end;

    procedure ClearClientSecret()
    var
        Setup: Record "PMS Setup";
    begin
        if IsolatedStorage.Contains(SecretKey, DataScope::Module) then
            IsolatedStorage.Delete(SecretKey, DataScope::Module);
        Setup.GetRecordOnce();
        Setup."SP Has Client Secret" := false;
        Setup.Modify();
    end;

    procedure HasClientSecret(): Boolean
    begin
        exit(IsolatedStorage.Contains(SecretKey, DataScope::Module));
    end;

    procedure ValidateConnection(var Setup: Record "PMS Setup")
    var
        AccessToken: Text;
    begin
        ValidateSetup(Setup);
        AccessToken := GetAccessToken(Setup);
        Setup."SP Graph Site ID" := '';
        Setup."SP Graph Drive ID" := '';
        EnsureSiteAndDriveIds(Setup, AccessToken);
        Message('Connection validated.\nSite ID and Drive ID have been cached in setup.');
    end;

    local procedure ValidateSetup(Setup: Record "PMS Setup")
    begin
        Setup.TestField("SP Tenant ID");
        Setup.TestField("SP Client ID");
        Setup.TestField("SP Site Host");
        Setup.TestField("SP Site Path");
        Setup.TestField("SP Document Library");
        if not HasClientSecret() then
            Error('SharePoint client secret is not configured. Use "Set Client Secret" in PMS Setup.');
    end;

    local procedure GetAccessToken(Setup: Record "PMS Setup"): Text
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ClientSecret: Text;
        Body: Text;
        ResponseText: Text;
        JsonObj: JsonObject;
        JToken: JsonToken;
    begin
        if not IsolatedStorage.Get(SecretKey, DataScope::Module, ClientSecret) then
            Error('Failed to retrieve SharePoint client secret from storage.');
        Body := 'grant_type=client_credentials' +
                '&client_id=' + UrlEncode(Setup."SP Client ID") +
                '&client_secret=' + UrlEncode(ClientSecret) +
                '&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default';
        Content.WriteFrom(Body);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        Request.Method := 'POST';
        Request.SetRequestUri(StrSubstNo('https://login.microsoftonline.com/%1/oauth2/v2.0/token', Setup."SP Tenant ID"));
        Request.Content := Content;
        if not Client.Send(Request, Response) then
            Error('Unable to contact Microsoft identity platform. Check network connectivity.');
        Response.Content.ReadAs(ResponseText);
        if not Response.IsSuccessStatusCode() then
            Error('Authentication failed (HTTP %1). Check Azure App Registration settings.\n%2',
                Response.HttpStatusCode(), ResponseText);
        JsonObj.ReadFrom(ResponseText);
        JsonObj.Get('access_token', JToken);
        exit(JToken.AsValue().AsText());
    end;

    local procedure EnsureSiteAndDriveIds(var Setup: Record "PMS Setup"; AccessToken: Text)
    var
        Changed: Boolean;
    begin
        if Setup."SP Graph Site ID" = '' then begin
            Setup."SP Graph Site ID" := LookupSiteId(Setup, AccessToken);
            Changed := true;
        end;
        if Setup."SP Graph Drive ID" = '' then begin
            Setup."SP Graph Drive ID" := LookupDriveId(Setup, AccessToken);
            Changed := true;
        end;
        if Changed then
            Setup.Modify();
    end;

    local procedure LookupSiteId(Setup: Record "PMS Setup"; AccessToken: Text): Text[300]
    var
        ResponseText: Text;
        JsonObj: JsonObject;
        JToken: JsonToken;
        SiteHost: Text;
        SitePath: Text;
    begin
        SiteHost := Setup."SP Site Host";
        SitePath := Setup."SP Site Path";
        // Strip protocol prefix if the user included it
        if SiteHost.StartsWith('https://') then
            SiteHost := SiteHost.Substring(9);
        if SiteHost.StartsWith('http://') then
            SiteHost := SiteHost.Substring(8);
        SiteHost := SiteHost.TrimEnd('/');
        // Ensure path starts with /
        if (SitePath <> '') and not SitePath.StartsWith('/') then
            SitePath := '/' + SitePath;
        ResponseText := GraphGet(
            AccessToken,
            'https://graph.microsoft.com/v1.0/sites/' + SiteHost + ':' + SitePath);
        JsonObj.ReadFrom(ResponseText);
        if not JsonObj.Get('id', JToken) then
            Error('Unexpected Graph API response when looking up site ID. Check SP Site Host and SP Site Path.');
        exit(CopyStr(JToken.AsValue().AsText(), 1, 300));
    end;

    local procedure LookupDriveId(Setup: Record "PMS Setup"; AccessToken: Text): Text[300]
    var
        ResponseText: Text;
        JsonObj: JsonObject;
        JsonArr: JsonArray;
        ArrToken: JsonToken;
        DriveToken: JsonToken;
        NameToken: JsonToken;
        IdToken: JsonToken;
    begin
        ResponseText := GraphGet(
            AccessToken,
            StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives', Setup."SP Graph Site ID"));
        JsonObj.ReadFrom(ResponseText);
        JsonObj.Get('value', ArrToken);
        JsonArr := ArrToken.AsArray();
        foreach DriveToken in JsonArr do
            if DriveToken.AsObject().Get('name', NameToken) then
                if NameToken.AsValue().AsText() = Setup."SP Document Library" then begin
                    DriveToken.AsObject().Get('id', IdToken);
                    exit(CopyStr(IdToken.AsValue().AsText(), 1, 300));
                end;
        Error('Document library "%1" was not found in the SharePoint site.', Setup."SP Document Library");
    end;

    local procedure EnsureFolder(DriveId: Text; AccessToken: Text; ParentPath: Text; FolderName: Text): Text
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
        JsonObj: JsonObject;
        JToken: JsonToken;
        Url: Text;
        FullPath: Text;
    begin
        if ParentPath = '' then begin
            Url := StrSubstNo('https://graph.microsoft.com/v1.0/drives/%1/root/children', DriveId);
            FullPath := FolderName;
        end else begin
            Url := StrSubstNo('https://graph.microsoft.com/v1.0/drives/%1/root:/%2:/children', DriveId, ParentPath);
            FullPath := ParentPath + '/' + FolderName;
        end;
        Content.WriteFrom(StrSubstNo('{"name":"%1","folder":{},"@microsoft.graph.conflictBehavior":"fail"}', FolderName));
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);
        Request.Method := 'POST';
        Request.SetRequestUri(Url);
        Request.Content := Content;
        if not Client.Send(Request, Response) then
            Error('Failed to connect to SharePoint when creating folder "%1".', FolderName);
        Response.Content.ReadAs(ResponseText);
        if Response.IsSuccessStatusCode() then begin
            JsonObj.ReadFrom(ResponseText);
            if JsonObj.Get('webUrl', JToken) then
                exit(JToken.AsValue().AsText());
            exit('');
        end;
        if Response.HttpStatusCode() = 409 then
            exit(GetFolderWebUrl(DriveId, AccessToken, FullPath));
        Error('Could not create SharePoint folder "%1" (HTTP %2).', FolderName, Response.HttpStatusCode());
    end;

    local procedure GetFolderWebUrl(DriveId: Text; AccessToken: Text; FolderPath: Text): Text
    var
        ResponseText: Text;
        JsonObj: JsonObject;
        JToken: JsonToken;
    begin
        ResponseText := GraphGet(
            AccessToken,
            StrSubstNo('https://graph.microsoft.com/v1.0/drives/%1/root:/%2', DriveId, FolderPath));
        JsonObj.ReadFrom(ResponseText);
        if JsonObj.Get('webUrl', JToken) then
            exit(JToken.AsValue().AsText());
        exit('');
    end;

    local procedure GraphGet(AccessToken: Text; Url: Text): Text
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ResponseText: Text;
    begin
        Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);
        Request.Method := 'GET';
        Request.SetRequestUri(Url);
        if not Client.Send(Request, Response) then
            Error('Failed to connect to Microsoft Graph.');
        Response.Content.ReadAs(ResponseText);
        if not Response.IsSuccessStatusCode() then
            Error('Graph API request failed (HTTP %1): %2', Response.HttpStatusCode(), ResponseText);
        exit(ResponseText);
    end;

    local procedure UrlEncode(Value: Text): Text
    var
        Result: Text;
        i: Integer;
        Ch: Text[1];
    begin
        for i := 1 to StrLen(Value) do begin
            Ch := CopyStr(Value, i, 1);
            case Ch of
                ' ':
                    Result += '%20';
                '+':
                    Result += '%2B';
                '/':
                    Result += '%2F';
                '=':
                    Result += '%3D';
                '&':
                    Result += '%26';
                '#':
                    Result += '%23';
                '?':
                    Result += '%3F';
                '@':
                    Result += '%40';
                ':':
                    Result += '%3A';
                '%':
                    Result += '%25';
                else
                    Result += Ch;
            end;
        end;
        exit(Result);
    end;
}
