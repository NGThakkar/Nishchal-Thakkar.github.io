# Developer Daily Log


## 18 Mar 2026

> Focused on issue-fixing work in the bridgingapi — both commits landed on the `R349_Issue_Fixing` branch and centred on correcting the scorecard/approval message behaviour in the Application view.

### bridgingapi

**Fix**
- Re-arranged the reprocess warning message (`SRRWN` system setting) in the scorecard details panel — moved it from rendering inline per-security inside the `@foreach` loop to a single consolidated `alert-warning` block above the list; old per-security block is now commented out. (`Presentation/Views/Application/View.cshtml`)
- Fixed the selector used to build the pending-approval message list (`#MsgApppendingApproval`) — updated from `.nav-link[data-basicdetailsid]` to `.spSecurityHeader[data-basicdetailsid]`; also added `spSecurityHeader` class and `data-basicdetailsid` attribute to the Security heading `<span>` so the selector resolves correctly. (`Presentation/Views/Application/View.cshtml`)

---

## 19 Mar 2026

> Focused on the bridgingapi repository. The day centred on adding verification detail pop-ups (Mobile & Email, and Delphi) to the Application View, backed by new DTOs, repository interfaces, and service changes, along with a fix for issue #0037299.

### bridgingapi

**Feature**
- Added `Mobile & Email verification details pop-up` — introduced a pop-up to display mobile and email verification details in the Application View. (`Presentation/Views/Application/View.cshtml`)
- Added `Delphi pop-up` — implemented a Delphi verification pop-up with supporting DTO, repository interface update, credit search repository implementation, verification status service, and view changes. (`Application/Services/VerificationStatusService.cs`, `Domain/DTO/VerificationStatusDTO.cs`, `Domain/Interfaces/Repositories/ICreditSearchRepository.cs`, `Infrastructure/Data/Repositories/CreditSearchRepository.cs`, `Presentation/Views/Application/View.cshtml`)

**Fix**
- Fixed issue `#0037299` in the Application View. (`Presentation/Views/Application/View.cshtml`)

---

## 24 Mar 2026

> A focused day on `bridgingapi`, working across email/notification dispatch for underwriters and the ADFVF proceed-loan flow, extending Credas integration to cover directors and shareholders, and patching email body key replacement and a table name mismatch.

### bridgingapi

**Feature**
- Extended `CreditSearchCredasIntegrationService` to support Credas identity checks for directors and shareholders (`Application/Services/CreditSearchCredasIntegrationService.cs`)
- Implemented proceed-loan email notification logic � added `ApplicationMailDetailsDTO`, updated `IBridgingApplicationRepository` interface, and added repository methods to fetch mail details for the ADFVF flow (`Application/Services/Application/BridgingApplicationServices.cs`, `Domain/DTO/Application/ApplicationMailDetailsDTO.cs`, `Domain/Interfaces/Application/IBridgingApplicationRepository.cs`, `Infrastructure/Data/Repositories/Application/BridgingApplicationRepository.cs`)
- Extended `VerificationNotificationService` and `VerificationNotificationRepository` to dispatch underwriter notification emails with new DTO fields and a new repository interface method (`Application/Services/VerificationNotificationService.cs`, `Domain/DTO/VerificationNotificationDTO.cs`, `Domain/Interfaces/IVerificationNotificationRepository.cs`, `Infrastructure/Data/Repositories/VerificationNotificationRepository.cs`)
- Updated Credas and GBG credit search integration to include underwriter-specific logic; extended `GBGCreditSearchIntegrationService`, `TwoFAService`, and related interfaces (`Application/Services/GBG/GBGCreditSearchIntegrationService.cs`, `Application/Services/TwoFA/TwoFAService.cs`, `Domain/Interfaces/GBG/IGBGCreditSearchIntegrationService.cs`, `Domain/Interfaces/ICreditSearchCredasIntegrationService.cs`)

**Fix**
- Fixed email body placeholder key replacement in `BridgingApplicationServices` � corrected keys used in outgoing ADFVF emails (`Application/Services/Application/BridgingApplicationServices.cs`)
- Corrected table name in `BridgingApplicationRepository` to match the database schema (`Infrastructure/Data/Repositories/Application/BridgingApplicationRepository.cs`)
- Reworked `GBGAuthenticateService` to align with underwriter flow requirements (`Application/Services/GBG/GBGAuthenticateService.cs`)

**Chore**
- Merged branch `R349_Issue_Fixing` into `CLI_Issue_Fixing_24032026`

---

## 25 Mar 2026

> Focused on `bridgingapi`, restructuring the daily verification scheduler from a background service into an HTTP-triggered `SchedulerController`, adding GBG rule failure handling to underwriter notification emails, and refining Credas status processing in `VerificationNotificationService`.

### bridgingapi

**Feature**
- Added `SchedulerController` — exposes `GET /api/Scheduler/SendVerificationNotifications` for external triggers (Windows Task Scheduler / cron), replacing the background `DailyVerificationSchedulerService`. (`Presentation/Controllers/SchedulerController.cs`)
- Added GBG rule failure notifications to underwriter mail — extended `VerificationNotificationService` to surface GBG verification rule failures in outgoing underwriter emails. (`Application/Services/VerificationNotificationService.cs`)

**Fix**
- Updated Credas status handling in `VerificationNotificationService` — refined how Credas verification statuses are read and included in notification emails. (`Application/Services/VerificationNotificationService.cs`)
- Handled GBG rule-level failures in `VerificationNotificationService` — added logic to process and report GBG rule failures within the verification notification pipeline. (`Application/Services/VerificationNotificationService.cs`)

**Refactor**
- Removed `DailyVerificationSchedulerService` background service — migrated scheduling responsibility to `SchedulerController` for cleaner, externally-triggered execution. (`Application/Services/DailyVerificationSchedulerService.cs`)

**Chore**
- Updated `VerificationNotificationDTO` — minor model adjustment to support new notification fields. (`Domain/DTO/VerificationNotification/VerificationNotificationDTO.cs`)
- Updated `appsettings.json` — added scheduler-related configuration entries. (`Presentation/appsettings.json`)
- Removed `DailyVerificationSchedulerService` registration from DI container. (`Presentation/Models/Dependencies.cs`)

---

## 26 Mar 2026

> A heavy issue-fixing day across `bridgingapi` and `backoffice`. Resolved nine Mantis tickets on `CLI_Issue_Fixing_24032026` covering application views, 2FA flows, direct debit, bank validation, and credit search; fixed a drawdown date validation bug on `mst_Issue_Fixing_17032026` in backoffice; and merged `mst_TaskIssue_Fixing_26032026` into Development.

### bridgingapi

**Fix**
- Fixed Mantis #0037455 — resolved issue in application view. (`Presentation/Views/Application/View.cshtml`)
- Fixed Delphi popover result right-alignment — corrected credit search result popover alignment. (`Infrastructure/Data/Repositories/CreditSearchRepository.cs`, `Presentation/Views/Application/View.cshtml`)
- Fixed Mantis #0037485 — resolved issue in application view. (`Presentation/Views/Application/View.cshtml`)
- Fixed Mantis #0037481 — resolved issue in application view. (`Presentation/Views/Application/View.cshtml`)
- Fixed Mantis #0037480 — resolved issue in credit search repository. (`Infrastructure/Data/Repositories/CreditSearchRepository.cs`)
- Fixed Mantis #0037479 — resolved issue in application view. (`Presentation/Views/Application/View.cshtml`)
- Fixed Mantis #0037477 — resolved issue in application view. (`Presentation/Views/Application/View.cshtml`)
- Fixed Mantis #0037476 — resolved issue in 2FA repository and application controller. (`Infrastructure/Data/Repositories/TwoFARepository.cs`, `Presentation/Controllers/BridgingApplicationController.cs`)
- Fixed Mantis #0037471 — resolved issue in application view. (`Presentation/Views/Application/View.cshtml`)
- Fixed Mantis #0037475 — resolved issues across multiple shared and application views including 2FA override/verification, bank validation, direct debit, and application version. (`Presentation/Views/Application/View.cshtml`, `Presentation/Views/Application/_ApplicationVersion.cshtml`, `Presentation/Views/Shared/_ApplicationChangeStatus.cshtml`, `Presentation/Views/Shared/_BankValidationVerification.cshtml`, `Presentation/Views/Shared/_DirectDebit.cshtml`, `Presentation/Views/TwoFA/_2FAOverride.cshtml`, `Presentation/Views/TwoFA/_2FAVerification.cshtml`)

---

### backoffice

**Fix** *(mst_Issue_Fixing_17032026)*
- Fixed drawdown date validation — corrected date validation logic for drawdown creation. (`Models/clsLoan.cs`, `Views/Loan/_CreateDrawdownModal.cshtml`)

**Fix** *(CLI_Issue_Fixing_24032026)*
- Fixed Mantis #0037455 — resolved mobile email verification issue. (`Views/Application/_MobileEmailVerification.cshtml`)
- Fixed Mantis #0037267 — resolved Delphi report active list display issue. (`Views/Shared/_DelphiReportActiveList.cshtml`)

**Chore** *(mst_TaskIssue_Fixing_26032026)*
- Merged `mst_TaskIssue_Fixing_26032026` into `Development`.

---

### btlclasslibrary

**Fix** *(mst_Issue_Fixing_17032026)*
- Direct Debit mail changes — updated direct debit logic to consider only loans with active status when sending mail. (`Models/BAL/clsDirectDebitBAL.cs`, `Models/DAL/clsDirectDebitDAL.cs`)

**Fix** *(mst_TaskIssue_Fixing_26032026)*
- Updated LMS amount in direct debit once loan settles — ensured LMS amount is synced correctly upon loan settlement. (`Models/BAL/clsDirectDebitBAL.cs`, `Models/DAL/clsDirectDebitDAL.cs`)

---

## 27 Mar 2026

> Short cross-repo fix day. Both `bridgingapi` and `backoffice` received the same correction for ticket `#0037478` — the missing-info section headers in the Application View were unconditionally prefixing every section name with "Applicant: X", including shared/common sections. A conditional now suppresses the applicant prefix for sections that are not applicant-specific.

### bridgingapi

**Fix**
- Fixed issue `#0037478` — corrected missing-info section headers (`info-content-header` and `info-subtosub-header`) in the Application View to conditionally show the "Applicant: X" prefix only for applicant-specific sections (`applicantseq < intMissingApplicantCount`); common sections now display the section name alone. (`Presentation/Views/Application/View.cshtml`)

---

### backoffice

**Fix**
- Fixed issue `#0037478` — same conditional header fix applied to the back-office Application View. (`Views/Application/View.cshtml`)

---

> Issue #0036941 was the focal point today — fixes were applied across the solicitor portal's registration flow (controller, partial view, frontend script) and the backoffice create view, with supporting BTL class library models pulled in via merge.

### backoffice

**Fix**
- `(0036941)` Fixed solicitor portal create view. (`Views/SolicitorPortal/Create.cshtml`)

**Chore**
- Merged `mst_Issue_Fixing_17032026` into `mst_TaskIssue_Fixing_26032026`.

---

### solicitorportal

**Fix**
- `(0036941)` Updated solicitor registration controller, registration partial view, and registration script. (`Presentation/SolicitorAPI/Controllers/SolicitorRegistration.cs`, `Presentation/SolicitorFrontEnd/Views/Registration/Partial/_SolicitorBasicDetails.cshtml`, `Presentation/SolicitorFrontEnd/wwwroot/Scripts/SolicitorRegistration.js`)
- `(0036941)` Subsequent fix to registration partial view and script. (`Presentation/SolicitorFrontEnd/Views/Registration/Partial/_SolicitorBasicDetails.cshtml`, `Presentation/SolicitorFrontEnd/wwwroot/Scripts/SolicitorRegistration.js`)

**Chore**
- Merged `mst_Issue_Fixing_17032026` into `mst_TaskIssue_Fixing_26032026`.

---
## 30 Mar 2026

> A focused issue-fixing day on `bridgingapi`, applying bug fixes across 7 separate tickets spanning the presentation, application, and infrastructure layers � covering the application view, 2FA service/repository, applicant repository, bridging application controller, and verification notification components.

### bridgingapi

**Fix**
- `(0037471)` Fixed issue in application view. (`Presentation/Views/Application/View.cshtml`)
- `(0037475)` Further fix to application view. (`Presentation/Views/Application/View.cshtml`)
- `(0037530)` Fixed 2FA service and repository � resolved across two commits touching the service, repository interface, and implementation. (`Application/Services/TwoFA/TwoFAService.cs`, `Domain/Interfaces/Repositories/ITwoFARepository.cs`, `Infrastructure/Data/Repositories/TwoFARepository.cs`)
- `(0037487)` Fixed bridging application controller. (`Presentation/Controllers/BridgingApplicationController.cs`)
- `(0037532)` Fixed verification notification repository. (`Infrastructure/Data/Repositories/VerificationNotificationRepository.cs`)
- `(0037542)` Fixed applicant repository. (`Infrastructure/Data/Repositories/Application/ApplicantRepository.cs`)
- `(0037535)` Fixed verification notification service. (`Application/Services/VerificationNotificationService.cs`)

---

## 31 Mar 2026

> All activity today was in `bridgingapi` on the `CLI_Issue_Fixing_24032026` branch. The day centred on five bug fixes: correcting applicant display name logic for company/shareholder types in the controller, fixing SVG icon fill colours across multiple views, and three successive refinements to the verification notification email HTML — per-applicant CREDAS AML detection, column header relabelling, and font size adjustments.

### bridgingapi

**Fix**
- `(0037471)` Fixed applicant display name in `BridgingApplicationController` — company (`"C"`) and shareholder (`"S"`) applicants with a non-empty `companyname` now use `companyname` rather than falling back to first/last name. (`Presentation/Controllers/BridgingApplicationController.cs`)
- `(0037475)` Fixed SVG icon fill colours across multiple views — updated inline SVG `fill` from `#828282` to `#000` and added base `.btn-type3 svg` fill CSS rules for consistent dark icon colouring. (`Presentation/Views/Application/View.cshtml`, `Presentation/Views/Application/_ApplicationVersion.cshtml`, `Presentation/Views/Shared/_ApplicationChangeStatus.cshtml`, `Presentation/Views/Shared/_BankValidationVerification.cshtml`, `Presentation/Views/Shared/_BusinessDecisioning.cshtml`, `Presentation/Views/Shared/_OverrideReportDecision.cshtml`, `Presentation/Views/TwoFA/_2FAOverride.cshtml`, `Presentation/Views/TwoFA/_2FAVerification.cshtml`)
- `(0037546)` Fixed CREDAS AML detection in `VerificationNotificationService` — switched to per-applicant tracking for individuals using new `CredasLoanApplicationTypeIds` / `CredasDatesByTypeId` collections; directors/shareholders retain app-level detection; also adjusted CREDAS detail table cell padding. (`Application/Services/VerificationNotificationService.cs`, `Domain/DTO/VerificationNotification/VerificationNotificationDTO.cs`, `Infrastructure/Data/Repositories/VerificationNotificationRepository.cs`)
- `(0037538)` Fixed email table column header in `VerificationNotificationService` — renamed "Name" column to "Applicant" in `BuildChangesSection` and `BuildSummaryTableRows`. (`Application/Services/VerificationNotificationService.cs`)
- `(0037534)` Fixed email table font sizes in `VerificationNotificationService` — bumped `font-size` from `11px` to `13px` across all generated HTML email tables and status badges. (`Application/Services/VerificationNotificationService.cs`)

---
