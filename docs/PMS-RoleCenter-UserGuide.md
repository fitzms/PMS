# Godolphin Property Management System — Role Center User Guide

**Version:** 1.0 (Demo)  
**Prepared by:** Godolphin IT Team  
**Date:** March 2026  

---

## Contents

1. [Overview](#1-overview)  
2. [Getting Started — Accessing the Role Center](#2-getting-started--accessing-the-role-center)  
3. [The Dashboard — KPI Cues](#3-the-dashboard--kpi-cues)  
4. [Navigation Bar](#4-navigation-bar)  
5. [Sections Menu](#5-sections-menu)  
6. [Quick Actions (Top Bar)](#6-quick-actions-top-bar)  
7. [Colour Coding at a Glance](#7-colour-coding-at-a-glance)  
8. [Demo Limitations & What's Coming](#8-demo-limitations--whats-coming)  

---

## 1. Overview

The **Property Management Role Center** is the home page for Property Managers within Microsoft Dynamics 365 Business Central. It brings together the key numbers you need at a glance — properties, contracts and tenants — and gives you fast access to the most common tasks without having to navigate through menus.

> **Note:** This version is a cosmetic demonstration. The counters and drill-through links use placeholder data until the full PMS module is wired in by the development team.

---

## 2. Getting Started — Accessing the Role Center

1. Log in to Business Central.
2. Click your **profile icon** (top-right corner) and choose **My Settings**.
3. In the **Role** field, select **Property Manager**.
4. Click **OK**. The Property Management Role Center will load as your home page.

If **Property Manager** does not appear in the Role list, ask your system administrator to assign the profile to your user account.

---

## 3. The Dashboard — KPI Cues

The top section of the Role Center displays three **cue groups**, each showing coloured tiles with live counts.

---

### 3.1 Properties

| Tile | What it shows |
|---|---|
| **Total** | Total number of property records in the system |
| **Active** | Properties currently occupied or in service |
| **Vacant** | Properties with no active tenancy |

**Tip:** Click any tile to drill through to the filtered list of properties.

---

### 3.2 Contracts

| Tile | What it shows |
|---|---|
| **Active** | Contracts currently in force |
| **Expiring This Month** | Contracts whose end date falls within the current calendar month |
| **Pending Approval** | Contracts awaiting sign-off in the approval workflow |

**Tip:** Keep an eye on **Expiring This Month** — if it turns red, action is needed to renew or terminate those contracts before month end.

---

### 3.3 Tenants

| Tile | What it shows |
|---|---|
| **Total** | All tenant records in the system |
| **New This Month** | Tenants added during the current calendar month |
| **Overdue Rent** | Tenants with outstanding rent payments past their due date |

**Tip:** **Overdue Rent** turning red is your prompt to chase outstanding payments or raise a reminder letter.

---

## 4. Navigation Bar

The navigation bar runs across the top of the page and provides **one-click access** to the three main list pages:

| Button | Destination |
|---|---|
| **Properties** | Full list of all properties |
| **Contracts** | Full list of all contracts |
| **Tenants** | Full list of all tenants |

These shortcuts are always visible regardless of which section of BC you have navigated to.

---

## 5. Sections Menu

The **Sections** menu (below the navigation bar) organises related actions and lists by area.

### Properties
| Action | Description |
|---|---|
| **Properties** | Opens the Properties list |
| **New Property** | Opens a blank Property card ready to fill in |

### Contracts
| Action | Description |
|---|---|
| **Contracts** | Opens the Contracts list |
| **Copy Contract** | Copies an existing contract as the basis for a new one |

### Tenants
| Action | Description |
|---|---|
| **Tenants** | Opens the Tenants list |
| **New Tenant** | Opens a blank Tenant card ready to fill in |

---

## 6. Quick Actions (Top Bar)

The top action bar surfaces the three most-used create/copy actions so you can act immediately without opening a list first:

| Button | What it does |
|---|---|
| **New Property** | Creates a new property record |
| **New Tenant** | Creates a new tenant record |
| **Copy Contract** | Copies an existing contract |

---

## 7. Colour Coding at a Glance

The cue tiles change colour automatically to draw your attention to items that need action:

| Colour | Meaning |
|---|---|
| **Green** | All good — no action required |
| **Amber** | Advisory — worth reviewing (e.g. vacant properties) |
| **Red** | Action required (e.g. overdue rent, expiring contracts) |

---

## 8. Demo Limitations & What's Coming

This Role Center has been built as a **cosmetic demonstration** of the intended look and feel. The following items are placeholders that the development team (Sam) will complete before go-live:

| Area | Current State | Final State |
|---|---|---|
| Cue counters | Return placeholder counts | Will query live PMS Property, Contract and Tenant tables |
| Tile drill-through | Opens Chart of Accounts (placeholder) | Will open the correct filtered PMS list |
| New Property | Opens G/L Account Card (placeholder) | Will open the PMS Property Card |
| New Tenant | Opens G/L Account Card (placeholder) | Will open the PMS Tenant Card |
| Copy Contract | Opens Chart of Accounts (placeholder) | Will launch a dedicated Copy Contract page |

For questions about the demo or the development timeline, contact the Godolphin IT Team.
