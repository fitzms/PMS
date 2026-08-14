# Vendor Invoice Import — Changes Required

**Object:** XMLPort 80811 `PMS Vendor Invoice Import CRE`  
**Related:** TableExtension 80852 `PMS Vend Inv Import Buf. Ext.`  
**Date:** August 2026  
**Source:** Code review + import-scenario analysis  

---

## Contents

1. [Bug Fixes](#1-bug-fixes)
2. [Dead Code Removal](#2-dead-code-removal)
3. [Code Quality](#3-code-quality)
4. [Enhancement — Dual Import Scenario Support](#4-enhancement--dual-import-scenario-support)

---

## 1. Bug Fixes

### 1.1 `GetCurrencyCode` — wrong error label (HIGH)

**Location:** `procedure GetCurrencyCode`  
**Problem:** The `Error` call uses `Text004` (`'%1 No. %2 does not exist on line no. %3'`) but only passes one argument (`CurrCode`). The resulting error message will show raw `%2` and `%3` placeholders.  
**Fix:** Replace `Text004` with `Text008` (`'Currency Code %1 does not exist on line no. %2'`), or introduce a dedicated label with a single `%1`.

```al
// Before
Error(StrSubstNo(Text004, CurrCode));

// After — Text008 already has the correct signature for a currency error
Error(StrSubstNo(Text008, CurrCode, ''));
```

---

### 1.2 `CreateInvoices` — unguarded `FindFirst()` for VAT difference (HIGH)

**Location:** `procedure CreateInvoices` — two occurrences (mid-document-loop and end-of-loop)  
**Problem:** `PurchLine.FindFirst()` is called after filtering on `"VAT Prod. Posting Group" = EquisoftSetup."VAT Prod. Posting Group"`. If all lines on a document use the *No-VAT* group the filter returns no records and a runtime error fires.  
**Fix:** Guard both calls.

```al
// Before
PurchLine.FindFirst();
PurchLine."VAT Difference" := PurchHeader."Document Total CRE" - cDocumentTotal;
PurchLine.Modify(true);

// After
if PurchLine.FindFirst() then begin
    PurchLine."VAT Difference" := PurchHeader."Document Total CRE" - cDocumentTotal;
    PurchLine.Modify(true);
end;
```

---

## 2. Dead Code Removal

All items below are safe to delete — none are referenced anywhere in the object.

| Item | Type | Reason |
|---|---|---|
| `StrOut` in `GetNumber` | Local variable | Declared but never assigned or returned |
| `ReleaseDoc` in `CreateInvoices` | Local variable | Codeunit declared but never called |
| `FormatDate: Date` in `FormatData` | Local variable | Unreachable — DateTime branch handles dates via `Dt2Date` |
| `varText` | Global variable | Unused leftover from base CRE object |
| `strFilename` | Global variable | Unused leftover from base CRE object |
| `strFile` | Global variable | Unused leftover from base CRE object |
| `ErrorFile` | Global variable | Unused leftover from base CRE object |
| `DocType` | Global variable | Unused leftover from base CRE object |
| `II` | Global variable | Unused leftover from base CRE object |
| `bErrorFile` | Global variable | Unused leftover from base CRE object |
| `Text011` | Label | Declared but never referenced |

---

## 3. Code Quality

### 3.1 `iRec` not reset before `CheckEntries`

**Location:** `procedure CheckEntries`  
**Problem:** `iRec` is a global integer used to drive the progress window. It is never reset to `0` before iterating, so if called after any prior increment the progress percentage will be wrong.  
**Fix:** Add `iRec := 0;` at the start of `CheckEntries`.

---

### 3.2 `SingleInvoiceRecord` is never set

**Location:** Global variable; referenced in `CheckEntries`  
**Problem:** Defaults to `false` and nothing in this object sets it to `true`, making the vendor/duplicate-check guard permanently inactive.  
**Action:** Either add a public setter or remove the guard if the mode is no longer needed.

```al
procedure SetSingleInvoiceMode(Value: Boolean)
begin
    SingleInvoiceRecord := Value;
end;
```

---

### 3.3 Deprecated `with` statement in `CheckEntries`

**Location:** `with TempImportBuffer do` block in `procedure CheckEntries`  
**Problem:** Deprecated in modern AL; flagged by the AL compiler.  
**Fix:** Replace all unqualified field references with explicit `TempImportBuffer.<Field>` references.

---

### 3.4 `'ú'` currency symbol in `GetNumber`

**Location:** `procedure GetNumber`  
**Problem:** The character `'ú'` (U+00FA) is likely a Windows-1252 encoding artefact rather than a genuine currency symbol.  
**Action:** Confirm with the business whether this case ever fires in practice; remove if not.

---

## 4. Enhancement — Dual Import Scenario Support

### Background

Some source systems supply all three explicit line amounts (`NetLineAmount`, `VATLineAmount`, `GrossLineAmount`) plus a `DocumentGrossTotal`. Others supply only `Quantity` and `Direct Unit Cost`. Both formats should be accepted without user intervention — the XMLPort detects which variant was supplied from the data itself.

---

### 4.1 Detection and derivation — `OnAfterInsertRecord`

If `NetLineAmount = 0` and `"Direct Unit Cost" <> 0` after the XML row is parsed, the file is using the unit-cost variant. Add **before** the `TempImportBuffer.Insert()` call:

```al
// Derive line amounts from Qty × Direct Unit Cost when not supplied by the file
if (VendorInvoiceBuffer.NetLineAmount = 0) and (VendorInvoiceBuffer."Direct Unit Cost" <> 0) then begin
    VendorInvoiceBuffer.NetLineAmount :=
        Round(VendorInvoiceBuffer.Quantity * VendorInvoiceBuffer."Direct Unit Cost", 0.01);
    VendorInvoiceBuffer.GrossLineAmount :=
        VendorInvoiceBuffer.NetLineAmount + VendorInvoiceBuffer.VATLineAmount;
end;
```

After this, `CheckEntries` runs unchanged regardless of how the amounts were populated.

---

### 4.2 `DocumentGrossTotal` when using unit-cost-only files

**Preferred:** Require the source file to always supply `DocumentGrossTotal` — this preserves the cross-system audit trail.

**Alternative:** Compute it from the buffer lines in `OnPostXmlPort` before calling `CheckEntries`, by grouping on `DocumentID` and summing `GrossLineAmount` where `DocumentGrossTotal = 0`.

---

### 4.3 Rounding tolerance in `CheckEntries` (optional)

When amounts are derived by multiplication, small decimal differences (e.g. `3 × 11.111 = 33.333` vs file-supplied `33.33`) can cause the line check to fail falsely. If the source system rounds independently, apply a tolerance:

```al
// Before
if (NetLineAmount + VATLineAmount) <> GrossLineAmount then

// After
if Abs((NetLineAmount + VATLineAmount) - GrossLineAmount) > 0.005 then
```

Apply the same tolerance to the document total check.

---

## Summary Priority

| # | Item | Priority |
|---|---|---|
| 1.1 | Fix `GetCurrencyCode` error label | High |
| 1.2 | Guard `FindFirst()` in `CreateInvoices` | High |
| 3.3 | Remove deprecated `with` statement | Medium |
| 3.1 | Reset `iRec` in `CheckEntries` | Medium |
| 3.2 | Resolve `SingleInvoiceRecord` dead guard | Medium |
| 4.x | Dual import scenario support | Enhancement |
| 2.x | Dead code removal | Low |
| 3.4 | Verify `'ú'` currency symbol | Low |
