# KSEYE Project Memory

> Single source of truth for project rules, conventions, and gotchas.  
> **Read this before answering any question about this codebase.**

---

## Architecture

- Two generations co-exist: **Generation 1** (.NET Framework 4.8 — `bridgingclasslibrary`, `btlclasslibrary`, `backoffice`, `frontend`, `btlapi`) and **Generation 2** (.NET 8 — `bridgingapi`, `commonapi`, `hometrackapi`, `valuerportal`, `solicitorportal`, `corelibrary`).
- Do not mix generation 1 and generation 2 code — they cannot reference each other's packages.
- Modern apps follow Clean Architecture–inspired layering: `Domain → Infrastructure → Application → Presentation`.
- Simpler modern apps (`commonapi`, `hometrackapi`, `valuerportal`, `solicitorportal`) use a flat 3-layer structure: `Core/{Domain, Repositories, Services}` + `Presentation/{API, FrontEnd}`.
- `corelibrary` is the shared foundation for all modern apps — provides `IDapper`, `IEncryptFunction`, `ISystemSetting`, `IEmailTemplates`, `IAuditTrailNew`, `ICommonFunction`, `IUser`, PDF (PuppeteerSharp), Excel/Word (ClosedXML), and browser detection helpers.
- `bridgingapi` is the most evolved project and is the reference implementation. Follow its patterns when building new modern code.
- All dependencies are registered in a static `Dependencies.cs` class (`Presentation/Models/Dependencies.cs`) called from `Program.cs` as `Dependencies.InjectDependencies(ref builder)`.

---

## Naming conventions

- **Controllers**: `[Entity]Controller` — e.g. `ApplicantController`.
- **Services**: `[Entity]Services` (plural **-Services** not -Service) — e.g. `ApplicantServices`, `FacilityServices`.
- **Interfaces**: `I[Entity]Services`, `I[Entity]Repository`.
- **Repository implementations**: `[Entity]Repository`.
- **Route pattern** (bridgingapi): `[Route("api/revolvingcredit/[controller]")]`.
- **Route pattern** (all other modern APIs): `[Route("api/[controller]/[action]")]`.
- **Entity and DTO models** (bridgingapi): nested static classes inside a parent class — `ApplicantEntity.ApplicantDetails`. Always add `using static Domain.Model.Entity.RCF.EntityName;` to avoid verbose references.
- **DB column / entity property names**: all **lowercase** matching the SQL column exactly — e.g. `flagactive`, `flagdeleted`, `rcfinvitationguid`, `createdby`, `createdon`, `updatedby`, `updatedon`. Using PascalCase breaks Dapper auto-mapping.
- **Legacy class naming** (.NET 4.8): `cls` prefix on all class names (`clsBridgingApplicationBAL`), `BAL`/`DAL` suffixes. Do not apply this pattern in new code.

---

## Coding patterns

### Data access
- All data access uses **raw SQL via Dapper** — no EF Core, no LINQ-to-DB, no stored procedure abstraction layer.
- Always pass queries as parameterised `DynamicParameters` — never string interpolation.
- Always pass a `":: MethodName ::"` string as the `strFunctionName` parameter to `IDapper` — used for logging.
- **Soft-delete filter is not applied globally** — every query must explicitly include `WHERE ISNULL(flagactive, 1) = 1 AND ISNULL(flagdeleted, 0) = 0`.
- **PII encryption**: sensitive columns (names, emails, addresses) are encrypted at rest with SQL Server `ENCRYPTBYPASSPHRASE`. All SELECT queries for such columns must wrap them: `CONVERT(NVARCHAR(MAX), DECRYPTBYPASSPHRASE(@passphrasekey, column))` and pass `passphrasekey` via `DynamicParameters` using `CoreLibrary.Domain.Enums.PassPhraseEnum.PassPhrase`.
- Use local variables for query strings in all new code — avoid class-level `gblStrQuery` fields (concurrency risk in singletons).

### Dependency injection lifetimes
- **Repositories** → `AddSingleton`.
- **Services** (application/business logic) → `AddScoped`.
- Never inject a scoped service into a singleton constructor (captive dependency).

### Response contracts
- `bridgingapi` uses `APIResponse<T>` (PascalCase JSON) with `APIResponse.CreateSuccessResponse(data, message)`.
- All other modern APIs use `ref CommonResponse<T>` / `CommonResponseSingle<T>` (void service methods with by-reference output parameter). Never mix the two.

### Error handling (bridgingapi)
- Services extend `BaseService` and throw domain exceptions: `ValidationException`, `NotFoundException`, `BusinessException` (all in `Domain.Exceptions`). These are caught by `GlobalExceptionFilter` in Presentation.

### Logging
- New code: `_logger.LogError(ex, "Descriptive message: {Detail}", someValue)` — template first, structured args second.
- Legacy practice in older services has reversed args (`ex.StackTrace, ex.Message`) — do not replicate.

### JSON serialisation
- `bridgingapi`: `System.Text.Json` with `PropertyNamingPolicy = null` (PascalCase preserved) and `PropertyNameCaseInsensitive = true` for incoming deserialization.
- All other modern APIs: `Newtonsoft.Json`.

### Multiple connection strings
- Default: `SqlConnection`.
- `ValuerSqlConnection` — valuerportal (`ValuerDapperContext`).
- `SeriLogSqlConnection` — Serilog SQL sink.
- Use the optional `strConnectionStringKey` parameter on IDapper methods to switch connections per call.

---

## Authentication / Authorization

- **commonapi + valuerportal**: OAuth2 Bearer via external IdentityServer4 authority; `ValidateAudience = false`; every controller action decorated with `[Authorize]`.
- **solicitorportal**: symmetric JWT (key/issuer/audience from `appsettings Jwt` section); `ClockSkew = TimeSpan.Zero`; `[Authorize]` on controller class.
- **bridgingapi**: no `[Authorize]` attribute — authentication is cryptographic invite-token validation inside the service layer; `BaseController` provides `GetUserIdFromClaims()` and `IsUserAuthenticated()` helpers.
- **hometrackapi**: JWT Bearer registered; in-controller `SecurityKey` validation rather than universal `[Authorize]`.
- `RequireHttpsMetadata = false` only in Development — never set it unconditionally.

---

## Configuration / Environments

- Layered settings: `appsettings.json` → `appsettings.{ENV}.json`.
- Environments: `Development`, `QA`, `UAT`, `Beta`/`Dev`, `Production`.
- Default when `ASPNETCORE_ENVIRONMENT` is unset: **Production**.
- `AllowedCorsOrigins` is a JSON array configured per environment.
- `PropertyNamingPolicy = null` ensures PascalCase is preserved in all JSON responses. Do not remove this.

---

## Gotchas / deprecations

- **`ref CommonResponse<T>` is the established response contract** in all projects except bridgingapi — do not convert to return values.
- **`APIResponse<T>` (bridgingapi) and `CommonResponse<T>` (everywhere else) must never be mixed** across projects.
- **Repositories are singletons** — injecting a scoped dependency into a repository constructor causes a captive dependency bug. Avoid it.
- **Entity/DTO property names are lowercase** (matching SQL columns) in bridgingapi — PascalCase breaks Dapper mapping.
- **HomeTrackAPI Polly config**: retry/timeout values come from `appSettings:RetryCount` / `appSettings:RequestTimeout` (with the `appSettings:` section prefix — not `AppSettings`).
- **SolicitorPortal FrontEnd** does not reference the Repositories project — Services call CoreLibrary repos directly. Do not add a Repositories reference to `SolicitorFrontEnd.csproj`.
- **`cls`-prefixed legacy viewmodels** (e.g. `clsAuditTrailViewModel`) are still actively used in modern service code. Do not rename them.
- **IdentityServer4 is end-of-life** (since 2022) — do not add new dependencies on it.
- **Mapster and FluentValidation** are used only in `bridgingapi` — do not introduce them elsewhere without discussion.
- **`gblStrQuery`** class-level field in older repositories is a concurrency risk in singletons — always use local variables in new repository code.
- **`_logger.LogError(ex.StackTrace, ex.Message)` argument order is wrong** in legacy services — do not replicate; use `_logger.LogError(ex, message)` instead.

---

## Agent Hooks & Automation

- **Hooks live in** `.copilot/.github/hooks/` — workspace-scoped, team-shared.
- **`session-start.json`** fires `SessionStart`: runs `scripts/inject-memory.ps1` which reads `memory.md` + `copilot-instructions.md` and injects both as a `systemMessage` so every agent session has full project context from the first prompt.
- **`session-stop.json`** fires `Stop`: runs `scripts/flag-memory-update.ps1` which writes a `.memory-pending` sentinel in `.copilot/`. The next `SessionStart` detects this flag, includes a reminder to run **auto-memory**, then clears the flag.
- **auto-memory skill** is the standard way to capture new patterns, rules, or gotchas into `memory.md`. Run it whenever a session produces new architectural decisions or naming conventions.
- Do not edit hook scripts without reviewing them in `.copilot/scripts/` first.
