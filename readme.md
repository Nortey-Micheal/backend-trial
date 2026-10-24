# Digital Banking Backend API — Complete Project Specification

Technology: Node.js · Express.js · TypeScript · PostgreSQL · Prisma ORM

This version treats the banking API as a proper backend engineering project specification. It includes the business requirements, entity data structures, relationships, UML diagrams, API contracts, transaction workflows, security requirements, and testing criteria.

The goal is to give you enough detail to build the system yourself, rather than simply copying a collection of CRUD endpoints.

## 1. Project definition

Build a simulated digital banking platform in which customers can open bank accounts, maintain balances, transfer funds, make deposits and withdrawals, manage beneficiaries, view statements, and receive notifications. Authorized bank staff can review customer verification requests, manage account restrictions, investigate suspicious activity, and reconcile financial records.

The system will use simulated funds only. It will not connect to real bank accounts or process real customer deposits.

### Core objectives

- Design a normalized relational database.
- Implement secure authentication and role-based authorization.
- Model financial transactions using double-entry accounting.
- Maintain accurate balances under concurrent requests.
- Prevent duplicate financial operations.
- Preserve an auditable history of financial activity.
- Separate business logic from HTTP request handling.
- Build a comprehensive automated test suite.

### Project scope

Core banking engine

Accounts, ledger, balances, deposits, withdrawals, transfers, and statements.

Customer services

Authentication, verification, beneficiaries, limits, notifications, and scheduled transfers.

Bank operations

Staff permissions, account restrictions, reviews, audit logs, and reconciliation.

## 2. User roles and access boundaries

| Role               | Main responsibilities                                             |
| ------------------ | ----------------------------------------------------------------- |
| Customer           | Own profile, accounts, transfers, beneficiaries, statements       |
| Teller             | Authorized simulated deposits and withdrawals                     |
| Compliance officer | KYC reviews and flagged transaction investigations                |
| Bank administrator | Staff access, account restrictions, limits, operational oversight |

A user's role determines which operations they may perform. Account ownership and resource-level authorization determine which specific records they may access.

For example, a customer may have permission to view account details but only for accounts they own or are explicitly authorized to access.

# 3. System architecture

Use a modular monolith first. It is easier to develop, test, and deploy than a collection of microservices, while still allowing clean separation of responsibilities.

\#chatgpt-mermaid-\_r_24m\_{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;fill:rgb(237, 237, 237);}@keyframes edge-animation-frame{from{stroke-dashoffset:0;}}@keyframes dash{to{stroke-dashoffset:0;}}#chatgpt-mermaid-\_r_24m\_ .edge-animation-slow{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 50s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_24m\_ .edge-animation-fast{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 20s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_24m\_ .error-icon{fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_24m\_ .error-text{fill:rgb(237, 237, 237);stroke:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24m\_ .edge-thickness-normal{stroke-width:1px;}#chatgpt-mermaid-\_r_24m\_ .edge-thickness-thick{stroke-width:3.5px;}#chatgpt-mermaid-\_r_24m\_ .edge-pattern-solid{stroke-dasharray:0;}#chatgpt-mermaid-\_r_24m\_ .edge-thickness-invisible{stroke-width:0;fill:none;}#chatgpt-mermaid-\_r_24m\_ .edge-pattern-dashed{stroke-dasharray:3;}#chatgpt-mermaid-\_r_24m\_ .edge-pattern-dotted{stroke-dasharray:2;}#chatgpt-mermaid-\_r_24m\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24m\_ .marker.cross{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24m\_ svg{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;}#chatgpt-mermaid-\_r_24m\_ p{margin:0;}#chatgpt-mermaid-\_r_24m\_ .label{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24m\_ .cluster-label text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24m\_ .cluster-label span{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24m\_ .cluster-label span p{background-color:transparent;}#chatgpt-mermaid-\_r_24m\_ .label text,#chatgpt-mermaid-\_r_24m\_ span{fill:rgb(237, 237, 237);color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24m\_ .node rect,#chatgpt-mermaid-\_r_24m\_ .node circle,#chatgpt-mermaid-\_r_24m\_ .node ellipse,#chatgpt-mermaid-\_r_24m\_ .node polygon,#chatgpt-mermaid-\_r_24m\_ .node path{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);stroke-width:1px;}#chatgpt-mermaid-\_r_24m\_ .rough-node .label text,#chatgpt-mermaid-\_r_24m\_ .node .label text,#chatgpt-mermaid-\_r_24m\_ .image-shape .label,#chatgpt-mermaid-\_r_24m\_ .icon-shape .label{text-anchor:middle;}#chatgpt-mermaid-\_r_24m\_ .node .katex path{fill:#000;stroke:#000;stroke-width:1px;}#chatgpt-mermaid-\_r_24m\_ .rough-node .label,#chatgpt-mermaid-\_r_24m\_ .node .label,#chatgpt-mermaid-\_r_24m\_ .image-shape .label,#chatgpt-mermaid-\_r_24m\_ .icon-shape .label{text-align:center;}#chatgpt-mermaid-\_r_24m\_ .node.clickable{cursor:pointer;}#chatgpt-mermaid-\_r_24m\_ .root .anchor path{fill:rgb(175, 175, 175)!important;stroke-width:0;stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24m\_ .arrowheadPath{fill:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24m\_ .edgePath .path{stroke:rgb(175, 175, 175);stroke-width:1px;}#chatgpt-mermaid-\_r_24m\_ .flowchart-link{stroke:rgb(175, 175, 175);fill:none;}#chatgpt-mermaid-\_r_24m\_ .edgeLabel{background-color:rgb(0, 0, 0);text-align:center;}#chatgpt-mermaid-\_r_24m\_ .edgeLabel p{background-color:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_24m\_ .edgeLabel rect{opacity:0.5;background-color:rgb(0, 0, 0);fill:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_24m\_ .labelBkg{background-color:rgba(0, 0, 0, 0.5);}#chatgpt-mermaid-\_r_24m\_ .cluster rect{fill:rgb(48, 48, 48);stroke:rgba(255, 255, 255, 0.15);stroke-width:1px;}#chatgpt-mermaid-\_r_24m\_ .cluster text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24m\_ .cluster span{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24m\_ div.mermaidTooltip{position:absolute;text-align:center;max-width:200px;padding:2px;font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:12px;background:rgb(48, 48, 48);border:1px solid rgba(255, 255, 255, 0.15);border-radius:2px;pointer-events:none;z-index:100;}#chatgpt-mermaid-\_r_24m\_ .flowchartTitleText{text-anchor:middle;font-size:18px;fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24m\_ rect.text{fill:none;stroke-width:0;}#chatgpt-mermaid-\_r_24m\_ .icon-shape,#chatgpt-mermaid-\_r_24m\_ .image-shape{background-color:rgb(0, 0, 0);text-align:center;}#chatgpt-mermaid-\_r_24m\_ .icon-shape p,#chatgpt-mermaid-\_r_24m\_ .image-shape p{background-color:rgb(0, 0, 0);padding:2px;}#chatgpt-mermaid-\_r_24m\_ .icon-shape .label rect,#chatgpt-mermaid-\_r_24m\_ .image-shape .label rect{opacity:0.5;background-color:rgb(0, 0, 0);fill:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_24m\_ .label-icon{display:inline-block;height:1em;overflow:visible;vertical-align:-0.125em;}#chatgpt-mermaid-\_r_24m\_ .node .label-icon path{fill:currentColor;stroke:revert;stroke-width:revert;}#chatgpt-mermaid-\_r_24m\_ .node .neo-node{stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].node rect,#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].cluster rect,#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].node polygon{stroke:url(#chatgpt-mermaid-\_r_24m\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].swimlane.cluster rect{filter:none;}#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].node path{stroke:url(#chatgpt-mermaid-\_r_24m\_-gradient);stroke-width:1px;}#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].node .outer-path{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].node .neo-line path{stroke:rgb(31, 78, 148);filter:none;}#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].node circle{stroke:url(#chatgpt-mermaid-\_r_24m\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].node circle .state-start{fill:#000000;}#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].icon-shape .icon{fill:url(#chatgpt-mermaid-\_r_24m\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24m\_ [data-look="neo"].icon-shape .icon-neo path{stroke:url(#chatgpt-mermaid-\_r_24m\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24m\_ .node text{font-size:14px;font-weight:600;letter-spacing:normal;fill:rgb(153, 206, 255);}#chatgpt-mermaid-\_r_24m\_ .edgeLabels text{font-size:13px;font-weight:600;letter-spacing:-0.08px;fill:rgb(153, 206, 255);}#chatgpt-mermaid-\_r_24m\_ .node tspan[font-weight="normal"],#chatgpt-mermaid-\_r_24m\_ .edgeLabels tspan[font-weight="normal"]{font-weight:600;}#chatgpt-mermaid-\_r_24m\_ .edgeLabel .label rect{opacity:1;rx:13px;ry:13px;fill:rgb(0, 14, 26);stroke:rgb(26, 62, 95);stroke-width:1px;}#chatgpt-mermaid-\_r_24m\_ .node rect,#chatgpt-mermaid-\_r_24m\_ .node circle,#chatgpt-mermaid-\_r_24m\_ .node ellipse,#chatgpt-mermaid-\_r_24m\_ .node polygon,#chatgpt-mermaid-\_r_24m\_ .node path{fill:rgb(0, 40, 77);stroke:rgba(255, 255, 255, 0.1);stroke-width:1px;}#chatgpt-mermaid-\_r_24m\_ .node rect{rx:16px;ry:16px;}#chatgpt-mermaid-\_r_24m\_ .node.mermaid-decision .label-container{fill:rgb(0, 14, 26);stroke:rgb(26, 62, 95);stroke-dasharray:2,2;}#chatgpt-mermaid-\_r_24m\_ .edgePaths .flowchart-link{stroke:rgb(175, 175, 175);stroke-width:1px;stroke-linecap:round;stroke-linejoin:round;}#chatgpt-mermaid-\_r_24m\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24m\_ :root{--mermaid-font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";}Client / API ConsumerExpress.js REST APIMiddleware LayerAuthentication &AuthorizationBusiness ModulesAccount ServiceTransaction ServiceLedger ServiceKYC & ComplianceNotification ServicePostgreSQLTransactional OutboxBackground WorkerEmail / Notification ProviderScheduled Transfers &Reconciliation

### Responsibilities of each layer

- Routes: Define HTTP endpoints and attach middleware.
- Controllers: Parse validated requests and format responses.
- Services: Enforce business rules and coordinate operations.
- Repositories: Read and write database records.
- Database: Enforce relational constraints and transaction atomicity.
- Background workers: Process scheduled transfers, notifications, and reconciliation tasks.
- Audit subsystem: Record sensitive actions without exposing confidential information.

Do not put financial logic directly in route handlers. A transfer service should be callable and testable independently of Express.

## 4. UML use-case diagram

This diagram describes the major interactions each role has with the system.

\#chatgpt-mermaid-\_r_24v\_{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;fill:rgb(237, 237, 237);}@keyframes edge-animation-frame{from{stroke-dashoffset:0;}}@keyframes dash{to{stroke-dashoffset:0;}}#chatgpt-mermaid-\_r_24v\_ .edge-animation-slow{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 50s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_24v\_ .edge-animation-fast{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 20s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_24v\_ .error-icon{fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_24v\_ .error-text{fill:rgb(237, 237, 237);stroke:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24v\_ .edge-thickness-normal{stroke-width:1px;}#chatgpt-mermaid-\_r_24v\_ .edge-thickness-thick{stroke-width:3.5px;}#chatgpt-mermaid-\_r_24v\_ .edge-pattern-solid{stroke-dasharray:0;}#chatgpt-mermaid-\_r_24v\_ .edge-thickness-invisible{stroke-width:0;fill:none;}#chatgpt-mermaid-\_r_24v\_ .edge-pattern-dashed{stroke-dasharray:3;}#chatgpt-mermaid-\_r_24v\_ .edge-pattern-dotted{stroke-dasharray:2;}#chatgpt-mermaid-\_r_24v\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24v\_ .marker.cross{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24v\_ svg{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;}#chatgpt-mermaid-\_r_24v\_ p{margin:0;}#chatgpt-mermaid-\_r_24v\_ .label{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24v\_ .cluster-label text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24v\_ .cluster-label span{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24v\_ .cluster-label span p{background-color:transparent;}#chatgpt-mermaid-\_r_24v\_ .label text,#chatgpt-mermaid-\_r_24v\_ span{fill:rgb(237, 237, 237);color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24v\_ .node rect,#chatgpt-mermaid-\_r_24v\_ .node circle,#chatgpt-mermaid-\_r_24v\_ .node ellipse,#chatgpt-mermaid-\_r_24v\_ .node polygon,#chatgpt-mermaid-\_r_24v\_ .node path{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);stroke-width:1px;}#chatgpt-mermaid-\_r_24v\_ .rough-node .label text,#chatgpt-mermaid-\_r_24v\_ .node .label text,#chatgpt-mermaid-\_r_24v\_ .image-shape .label,#chatgpt-mermaid-\_r_24v\_ .icon-shape .label{text-anchor:middle;}#chatgpt-mermaid-\_r_24v\_ .node .katex path{fill:#000;stroke:#000;stroke-width:1px;}#chatgpt-mermaid-\_r_24v\_ .rough-node .label,#chatgpt-mermaid-\_r_24v\_ .node .label,#chatgpt-mermaid-\_r_24v\_ .image-shape .label,#chatgpt-mermaid-\_r_24v\_ .icon-shape .label{text-align:center;}#chatgpt-mermaid-\_r_24v\_ .node.clickable{cursor:pointer;}#chatgpt-mermaid-\_r_24v\_ .root .anchor path{fill:rgb(175, 175, 175)!important;stroke-width:0;stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24v\_ .arrowheadPath{fill:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24v\_ .edgePath .path{stroke:rgb(175, 175, 175);stroke-width:1px;}#chatgpt-mermaid-\_r_24v\_ .flowchart-link{stroke:rgb(175, 175, 175);fill:none;}#chatgpt-mermaid-\_r_24v\_ .edgeLabel{background-color:rgb(0, 0, 0);text-align:center;}#chatgpt-mermaid-\_r_24v\_ .edgeLabel p{background-color:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_24v\_ .edgeLabel rect{opacity:0.5;background-color:rgb(0, 0, 0);fill:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_24v\_ .labelBkg{background-color:rgba(0, 0, 0, 0.5);}#chatgpt-mermaid-\_r_24v\_ .cluster rect{fill:rgb(48, 48, 48);stroke:rgba(255, 255, 255, 0.15);stroke-width:1px;}#chatgpt-mermaid-\_r_24v\_ .cluster text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24v\_ .cluster span{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24v\_ div.mermaidTooltip{position:absolute;text-align:center;max-width:200px;padding:2px;font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:12px;background:rgb(48, 48, 48);border:1px solid rgba(255, 255, 255, 0.15);border-radius:2px;pointer-events:none;z-index:100;}#chatgpt-mermaid-\_r_24v\_ .flowchartTitleText{text-anchor:middle;font-size:18px;fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_24v\_ rect.text{fill:none;stroke-width:0;}#chatgpt-mermaid-\_r_24v\_ .icon-shape,#chatgpt-mermaid-\_r_24v\_ .image-shape{background-color:rgb(0, 0, 0);text-align:center;}#chatgpt-mermaid-\_r_24v\_ .icon-shape p,#chatgpt-mermaid-\_r_24v\_ .image-shape p{background-color:rgb(0, 0, 0);padding:2px;}#chatgpt-mermaid-\_r_24v\_ .icon-shape .label rect,#chatgpt-mermaid-\_r_24v\_ .image-shape .label rect{opacity:0.5;background-color:rgb(0, 0, 0);fill:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_24v\_ .label-icon{display:inline-block;height:1em;overflow:visible;vertical-align:-0.125em;}#chatgpt-mermaid-\_r_24v\_ .node .label-icon path{fill:currentColor;stroke:revert;stroke-width:revert;}#chatgpt-mermaid-\_r_24v\_ .node .neo-node{stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].node rect,#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].cluster rect,#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].node polygon{stroke:url(#chatgpt-mermaid-\_r_24v\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].swimlane.cluster rect{filter:none;}#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].node path{stroke:url(#chatgpt-mermaid-\_r_24v\_-gradient);stroke-width:1px;}#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].node .outer-path{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].node .neo-line path{stroke:rgb(31, 78, 148);filter:none;}#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].node circle{stroke:url(#chatgpt-mermaid-\_r_24v\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].node circle .state-start{fill:#000000;}#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].icon-shape .icon{fill:url(#chatgpt-mermaid-\_r_24v\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24v\_ [data-look="neo"].icon-shape .icon-neo path{stroke:url(#chatgpt-mermaid-\_r_24v\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_24v\_ .node text{font-size:14px;font-weight:600;letter-spacing:normal;fill:rgb(153, 206, 255);}#chatgpt-mermaid-\_r_24v\_ .edgeLabels text{font-size:13px;font-weight:600;letter-spacing:-0.08px;fill:rgb(153, 206, 255);}#chatgpt-mermaid-\_r_24v\_ .node tspan[font-weight="normal"],#chatgpt-mermaid-\_r_24v\_ .edgeLabels tspan[font-weight="normal"]{font-weight:600;}#chatgpt-mermaid-\_r_24v\_ .edgeLabel .label rect{opacity:1;rx:13px;ry:13px;fill:rgb(0, 14, 26);stroke:rgb(26, 62, 95);stroke-width:1px;}#chatgpt-mermaid-\_r_24v\_ .node rect,#chatgpt-mermaid-\_r_24v\_ .node circle,#chatgpt-mermaid-\_r_24v\_ .node ellipse,#chatgpt-mermaid-\_r_24v\_ .node polygon,#chatgpt-mermaid-\_r_24v\_ .node path{fill:rgb(0, 40, 77);stroke:rgba(255, 255, 255, 0.1);stroke-width:1px;}#chatgpt-mermaid-\_r_24v\_ .node rect{rx:16px;ry:16px;}#chatgpt-mermaid-\_r_24v\_ .node.mermaid-decision .label-container{fill:rgb(0, 14, 26);stroke:rgb(26, 62, 95);stroke-dasharray:2,2;}#chatgpt-mermaid-\_r_24v\_ .edgePaths .flowchart-link{stroke:rgb(175, 175, 175);stroke-width:1px;stroke-linecap:round;stroke-linejoin:round;}#chatgpt-mermaid-\_r_24v\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_24v\_ :root{--mermaid-font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";}Digital Banking APIAuthenticateManage ProfileOpen AccountView Balances & StatementsTransfer FundsDeposit / WithdrawManage BeneficiariesSubmit KYCReview KYCInvestigate TransactionsFreeze / Unfreeze AccountsManage Staff & LimitsReconcile LedgerCustomerBank TellerCompliance OfficerBank Administrator

# 5. Database entities and data structures

This is the central part of the specification. Each entity below defines the data your application needs, its purpose, and the constraints it should follow.

Use UUIDs for internal identifiers. Keep public account numbers and transaction references separate from internal primary keys.

## 5.1 `users` — Authentication identity

Represents every person who can log in, including customers and bank staff.

| Field               | Data type    | Constraints / purpose                                     |
| ------------------- | ------------ | --------------------------------------------------------- |
| `id`                | UUID         | Primary key                                               |
| `email`             | VARCHAR(254) | Unique, nullable if phone-only login is supported         |
| `phone`             | VARCHAR(20)  | Unique when present                                       |
| `password_hash`     | VARCHAR(255) | Required                                                  |
| `status`            | ENUM         | `PENDING_VERIFICATION`, `ACTIVE`, `LOCKED`, `DEACTIVATED` |
| `email_verified_at` | TIMESTAMPTZ  | Nullable                                                  |
| `phone_verified_at` | TIMESTAMPTZ  | Nullable                                                  |
| `last_login_at`     | TIMESTAMPTZ  | Nullable                                                  |
| `created_at`        | TIMESTAMPTZ  | Required                                                  |
| `updated_at`        | TIMESTAMPTZ  | Required                                                  |

Rules: At least one supported login identifier must exist. Normalize email addresses and phone numbers before enforcing uniqueness. Use database constraints to prevent duplicate normalized identifiers.

## 5.2 `roles` and `user_roles` — Access control

Keep roles separate from users so that permissions can be extended later.

`roles`

| Field         | Type        | Purpose          |
| ------------- | ----------- | ---------------- |
| `id`          | UUID        | Primary key      |
| `name`        | VARCHAR(50) | Unique role name |
| `description` | TEXT        | Role description |
| `created_at`  | TIMESTAMPTZ | Creation time    |

`user_roles`

| Field         | Type        | Purpose                                       |
| ------------- | ----------- | --------------------------------------------- |
| `user_id`     | UUID        | FK → `users.id`                               |
| `role_id`     | UUID        | FK → `roles.id`                               |
| `assigned_by` | UUID        | FK → `users.id`, nullable for initial seeding |
| `assigned_at` | TIMESTAMPTZ | Assignment time                               |

Use a composite primary key on `(user_id, role_id)`.

Initial roles: `CUSTOMER`, `TELLER`, `COMPLIANCE_OFFICER`, `BANK_ADMIN`.

If you introduce fine-grained permissions, add `permissions` and `role_permissions` tables rather than scattering permission strings throughout the application.

## 5.3 `customer_profiles` — Customer information

| Field            | Type         | Purpose                            |
| ---------------- | ------------ | ---------------------------------- |
| `id`             | UUID         | Primary key                        |
| `user_id`        | UUID         | Unique FK → `users.id`             |
| `first_name`     | VARCHAR(100) | Required                           |
| `middle_name`    | VARCHAR(100) | Nullable                           |
| `last_name`      | VARCHAR(100) | Required                           |
| `date_of_birth`  | DATE         | Required for the chosen KYC policy |
| `address_line_1` | VARCHAR(255) | Required where applicable          |
| `address_line_2` | VARCHAR(255) | Nullable                           |
| `city`           | VARCHAR(100) | Required where applicable          |
| `region`         | VARCHAR(100) | Nullable                           |
| `country_code`   | CHAR(2)      | ISO country code                   |
| `created_at`     | TIMESTAMPTZ  | Creation time                      |
| `updated_at`     | TIMESTAMPTZ  | Last modification                  |

A customer profile is separate from authentication credentials. This allows account identity and authentication data to be managed independently.

## 5.4 `sessions` and `refresh_tokens` — Session management

`sessions`

| Field          | Type         | Purpose                            |
| -------------- | ------------ | ---------------------------------- |
| `id`           | UUID         | Primary key                        |
| `user_id`      | UUID         | FK → `users.id`                    |
| `device_label` | VARCHAR(100) | Nullable                           |
| `ip_address`   | INET         | Nullable; handle as sensitive data |
| `user_agent`   | TEXT         | Nullable                           |
| `created_at`   | TIMESTAMPTZ  | Session creation                   |
| `last_seen_at` | TIMESTAMPTZ  | Last activity                      |
| `expires_at`   | TIMESTAMPTZ  | Expiration                         |
| `revoked_at`   | TIMESTAMPTZ  | Nullable                           |

`refresh_tokens`

| Field        | Type         | Purpose                   |
| ------------ | ------------ | ------------------------- |
| `id`         | UUID         | Primary key               |
| `session_id` | UUID         | FK → `sessions.id`        |
| `token_hash` | VARCHAR(255) | Hash of the refresh token |
| `family_id`  | UUID         | Token-rotation family     |
| `expires_at` | TIMESTAMPTZ  | Expiration                |
| `used_at`    | TIMESTAMPTZ  | Nullable                  |
| `revoked_at` | TIMESTAMPTZ  | Nullable                  |
| `created_at` | TIMESTAMPTZ  | Creation time             |

Refresh-token rotation should detect reuse of a previously consumed token and revoke the relevant token family according to your security policy.

## 5.5 `kyc_cases` and `kyc_documents` — Verification

`kyc_cases`

| Field             | Type        | Purpose                                                                                |
| ----------------- | ----------- | -------------------------------------------------------------------------------------- |
| `id`              | UUID        | Primary key                                                                            |
| `customer_id`     | UUID        | FK → `customer_profiles.id`                                                            |
| `status`          | ENUM        | `NOT_STARTED`, `PENDING`, `UNDER_REVIEW`, `VERIFIED`, `REJECTED`, `MORE_INFO_REQUIRED` |
| `submitted_at`    | TIMESTAMPTZ | Nullable                                                                               |
| `reviewed_by`     | UUID        | FK → `users.id`, nullable                                                              |
| `reviewed_at`     | TIMESTAMPTZ | Nullable                                                                               |
| `decision_reason` | TEXT        | Nullable                                                                               |
| `created_at`      | TIMESTAMPTZ | Creation time                                                                          |
| `updated_at`      | TIMESTAMPTZ | Last update                                                                            |

`kyc_documents`

| Field                     | Type         | Purpose                             |
| ------------------------- | ------------ | ----------------------------------- |
| `id`                      | UUID         | Primary key                         |
| `kyc_case_id`             | UUID         | FK → `kyc_cases.id`                 |
| `document_type`           | VARCHAR(50)  | Identity document category          |
| `storage_key`             | VARCHAR(500) | Private object-storage reference    |
| `document_reference_hash` | VARCHAR(255) | Optional protected lookup value     |
| `status`                  | ENUM         | `SUBMITTED`, `ACCEPTED`, `REJECTED` |
| `uploaded_at`             | TIMESTAMPTZ  | Upload time                         |
| `reviewed_at`             | TIMESTAMPTZ  | Nullable                            |

Document access must be restricted. Never expose storage keys as public download URLs, and never log raw identity-document contents.

## 5.6 `bank_accounts` — Customer bank accounts

| Field            | Type        | Purpose                                                            |
| ---------------- | ----------- | ------------------------------------------------------------------ |
| `id`             | UUID        | Primary key                                                        |
| `account_number` | VARCHAR(34) | Unique public account number                                       |
| `account_type`   | ENUM        | `SAVINGS`, `CURRENT`                                               |
| `currency_code`  | CHAR(3)     | ISO currency code                                                  |
| `status`         | ENUM        | `PENDING_VERIFICATION`, `ACTIVE`, `FROZEN`, `RESTRICTED`, `CLOSED` |
| `opened_at`      | TIMESTAMPTZ | Nullable until opened                                              |
| `closed_at`      | TIMESTAMPTZ | Nullable                                                           |
| `created_at`     | TIMESTAMPTZ | Creation time                                                      |
| `updated_at`     | TIMESTAMPTZ | Last update                                                        |

Account ownership is stored separately in `account_holders`. This supports joint accounts and authorized signatories without duplicating account records.

## 5.7 `account_holders` — Ownership and authorization

| Field               | Type        | Purpose                                        |
| ------------------- | ----------- | ---------------------------------------------- |
| `id`                | UUID        | Primary key                                    |
| `account_id`        | UUID        | FK → `bank_accounts.id`                        |
| `customer_id`       | UUID        | FK → `customer_profiles.id`                    |
| `relationship_type` | ENUM        | `OWNER`, `JOINT_OWNER`, `AUTHORIZED_SIGNATORY` |
| `can_view`          | BOOLEAN     | Viewing permission                             |
| `can_transact`      | BOOLEAN     | Transaction permission                         |
| `started_at`        | TIMESTAMPTZ | Start of authorization                         |
| `ended_at`          | TIMESTAMPTZ | Nullable end of authorization                  |

Enforce a unique active ownership/authorization relationship for the same account and customer. The exact constraint depends on whether you retain historical relationships in the same table.

## 5.8 `ledger_accounts` — Accounting accounts

This table represents the accounting accounts used by the ledger. It is distinct from the customer's public bank account.

| Field               | Type         | Purpose                                              |
| ------------------- | ------------ | ---------------------------------------------------- |
| `id`                | UUID         | Primary key                                          |
| `code`              | VARCHAR(50)  | Unique accounting code                               |
| `name`              | VARCHAR(150) | Account name                                         |
| `account_type`      | ENUM         | `ASSET`, `LIABILITY`, `EQUITY`, `REVENUE`, `EXPENSE` |
| `currency_code`     | CHAR(3)      | Currency                                             |
| `bank_account_id`   | UUID         | Nullable FK → `bank_accounts.id`                     |
| `is_system_account` | BOOLEAN      | Marks internal clearing/control accounts             |
| `status`            | ENUM         | `ACTIVE`, `INACTIVE`                                 |
| `created_at`        | TIMESTAMPTZ  | Creation time                                        |

For the initial model, every customer bank account maps to a corresponding customer-deposit liability account. System accounts can represent simulated cash, clearing, fees, and other required accounting balances.

The ledger account code must be unique, and customer-linked ledger accounts must obey your mapping constraints.

## 5.9 `transactions` — Financial operation records

Represents the business operation requested by a user or generated by the system.

| Field                    | Type          | Purpose                                                              |
| ------------------------ | ------------- | -------------------------------------------------------------------- |
| `id`                     | UUID          | Primary key                                                          |
| `reference`              | VARCHAR(64)   | Unique public reference                                              |
| `type`                   | ENUM          | `DEPOSIT`, `WITHDRAWAL`, `TRANSFER`, `FEE`, `REVERSAL`, `ADJUSTMENT` |
| `status`                 | ENUM          | `PENDING`, `PROCESSING`, `POSTED`, `FAILED`, `CANCELLED`, `REVERSED` |
| `initiated_by`           | UUID          | FK → `users.id`, nullable for system operations                      |
| `source_account_id`      | UUID          | Nullable FK → `bank_accounts.id`                                     |
| `destination_account_id` | UUID          | Nullable FK → `bank_accounts.id`                                     |
| `amount`                 | NUMERIC(19,4) | Positive transaction amount                                          |
| `currency_code`          | CHAR(3)       | Transaction currency                                                 |
| `fee_amount`             | NUMERIC(19,4) | Defaults to zero                                                     |
| `description`            | VARCHAR(255)  | Nullable                                                             |
| `idempotency_key`        | VARCHAR(128)  | Request deduplication key                                            |
| `failure_code`           | VARCHAR(100)  | Nullable                                                             |
| `failure_message`        | TEXT          | Sanitized message, nullable                                          |
| `created_at`             | TIMESTAMPTZ   | Initiation time                                                      |
| `completed_at`           | TIMESTAMPTZ   | Nullable                                                             |

The exact source and destination requirements vary by transaction type. For example, a deposit may originate from an external simulated funding source, while an internal transfer has both bank accounts.

Use constraints and application-level validation to enforce type-specific requirements. Scope idempotency keys to the authenticated actor and endpoint or operation type.

## 5.10 `journal_entries` — Accounting journal headers

A journal groups the postings associated with one financial event.

| Field               | Type        | Purpose                       |
| ------------------- | ----------- | ----------------------------- |
| `id`                | UUID        | Primary key                   |
| `transaction_id`    | UUID        | FK → `transactions.id`        |
| `journal_reference` | VARCHAR(64) | Unique journal reference      |
| `status`            | ENUM        | `DRAFT`, `POSTED`, `REVERSED` |
| `effective_at`      | TIMESTAMPTZ | Accounting-effective time     |
| `posted_at`         | TIMESTAMPTZ | Nullable                      |
| `created_at`        | TIMESTAMPTZ | Creation time                 |

For the initial design, enforce the intended cardinality between transactions and original journals. Reversals should create additional, linked journals rather than rewriting the original journal.

## 5.11 `ledger_postings` — Debit and credit entries

| Field               | Type          | Purpose                   |
| ------------------- | ------------- | ------------------------- |
| `id`                | UUID          | Primary key               |
| `journal_entry_id`  | UUID          | FK → `journal_entries.id` |
| `ledger_account_id` | UUID          | FK → `ledger_accounts.id` |
| `side`              | ENUM          | `DEBIT`, `CREDIT`         |
| `amount`            | NUMERIC(19,4) | Positive amount           |
| `currency_code`     | CHAR(3)       | Posting currency          |
| `created_at`        | TIMESTAMPTZ   | Posting creation time     |

Every posted journal must balance independently for each currency.

Do not permit ordinary application code to update or delete posted ledger entries. Corrections must be performed through authorized compensating entries.

## 5.12 `account_balance_projections` and `account_holds`

These support efficient balance queries while keeping the ledger authoritative.

`account_balance_projections`

| Field               | Type          | Purpose                        |
| ------------------- | ------------- | ------------------------------ |
| `account_id`        | UUID          | PK and FK → `bank_accounts.id` |
| `ledger_balance`    | NUMERIC(19,4) | Cached posted balance          |
| `available_balance` | NUMERIC(19,4) | Cached spendable balance       |
| `updated_at`        | TIMESTAMPTZ   | Last update                    |

`account_holds`

| Field            | Type          | Purpose                                     |
| ---------------- | ------------- | ------------------------------------------- |
| `id`             | UUID          | Primary key                                 |
| `account_id`     | UUID          | FK → `bank_accounts.id`                     |
| `transaction_id` | UUID          | FK → `transactions.id`                      |
| `amount`         | NUMERIC(19,4) | Positive held amount                        |
| `status`         | ENUM          | `ACTIVE`, `RELEASED`, `CAPTURED`, `EXPIRED` |
| `expires_at`     | TIMESTAMPTZ   | Nullable expiration                         |
| `created_at`     | TIMESTAMPTZ   | Creation time                               |
| `released_at`    | TIMESTAMPTZ   | Nullable                                    |

Define the balance policy precisely. One common model is:

- Ledger balance = posted credits minus posted debits for the customer's liability account, interpreted from the customer's perspective.
- Available balance = ledger balance minus active holds.

In production accounting, the normal debit/credit balance conventions differ by account type. Your application must implement a consistent customer-facing balance calculation and reconcile it to the ledger.

## 5.13 `beneficiaries` — Saved recipients

| Field                        | Type         | Purpose                                     |
| ---------------------------- | ------------ | ------------------------------------------- |
| `id`                         | UUID         | Primary key                                 |
| `customer_id`                | UUID         | FK → `customer_profiles.id`                 |
| `beneficiary_name`           | VARCHAR(150) | Display name                                |
| `bank_account_id`            | UUID         | Nullable FK for internal beneficiaries      |
| `external_account_reference` | VARCHAR(255) | Nullable, protected external identifier     |
| `bank_name`                  | VARCHAR(150) | Nullable                                    |
| `status`                     | ENUM         | `PENDING_VERIFICATION`, `ACTIVE`, `BLOCKED` |
| `verified_at`                | TIMESTAMPTZ  | Nullable                                    |
| `created_at`                 | TIMESTAMPTZ  | Creation time                               |

Require exactly one valid recipient reference according to the beneficiary type. For this project, prioritize internal beneficiaries before supporting external-bank recipients.

## 5.14 `transaction_limits` and `fee_rules`

`transaction_limits`

| Field               | Type          | Purpose                    |
| ------------------- | ------------- | -------------------------- |
| `id`                | UUID          | Primary key                |
| `account_type`      | ENUM          | Applicable account type    |
| `transaction_type`  | ENUM          | Applicable transaction     |
| `currency_code`     | CHAR(3)       | Currency                   |
| `max_single_amount` | NUMERIC(19,4) | Nullable upper bound       |
| `max_daily_amount`  | NUMERIC(19,4) | Nullable daily bound       |
| `max_daily_count`   | INTEGER       | Nullable transaction count |
| `status`            | ENUM          | `ACTIVE`, `INACTIVE`       |
| `created_by`        | UUID          | FK → `users.id`            |
| `created_at`        | TIMESTAMPTZ   | Creation time              |

`fee_rules`

| Field              | Type          | Purpose               |
| ------------------ | ------------- | --------------------- |
| `id`               | UUID          | Primary key           |
| `transaction_type` | ENUM          | Applicable operation  |
| `currency_code`    | CHAR(3)       | Currency              |
| `fee_type`         | ENUM          | `FIXED`, `PERCENTAGE` |
| `fee_value`        | NUMERIC(19,4) | Rule value            |
| `minimum_fee`      | NUMERIC(19,4) | Nullable              |
| `maximum_fee`      | NUMERIC(19,4) | Nullable              |
| `effective_from`   | TIMESTAMPTZ   | Start time            |
| `effective_until`  | TIMESTAMPTZ   | Nullable end time     |
| `status`           | ENUM          | `ACTIVE`, `INACTIVE`  |

For reproducible accounting, snapshot the fee actually charged on the transaction. Do not recalculate historical fees from current rules.

## 5.15 `scheduled_transfers` and `transfer_attempts`

`scheduled_transfers`

| Field                    | Type          | Purpose                                      |
| ------------------------ | ------------- | -------------------------------------------- |
| `id`                     | UUID          | Primary key                                  |
| `customer_id`            | UUID          | FK → `customer_profiles.id`                  |
| `source_account_id`      | UUID          | FK → `bank_accounts.id`                      |
| `destination_account_id` | UUID          | FK → `bank_accounts.id`                      |
| `amount`                 | NUMERIC(19,4) | Positive amount                              |
| `currency_code`          | CHAR(3)       | Currency                                     |
| `frequency`              | ENUM          | `ONCE`, `DAILY`, `WEEKLY`, `MONTHLY`         |
| `next_run_at`            | TIMESTAMPTZ   | Next execution                               |
| `end_at`                 | TIMESTAMPTZ   | Nullable                                     |
| `status`                 | ENUM          | `ACTIVE`, `PAUSED`, `COMPLETED`, `CANCELLED` |
| `created_at`             | TIMESTAMPTZ   | Creation time                                |

`transfer_attempts`

| Field                   | Type         | Purpose                             |
| ----------------------- | ------------ | ----------------------------------- |
| `id`                    | UUID         | Primary key                         |
| `scheduled_transfer_id` | UUID         | FK → `scheduled_transfers.id`       |
| `transaction_id`        | UUID         | Nullable FK → `transactions.id`     |
| `attempt_number`        | INTEGER      | Sequential attempt                  |
| `status`                | ENUM         | `PROCESSING`, `SUCCEEDED`, `FAILED` |
| `started_at`            | TIMESTAMPTZ  | Attempt start                       |
| `finished_at`           | TIMESTAMPTZ  | Nullable                            |
| `failure_code`          | VARCHAR(100) | Nullable                            |

Create a unique constraint on `(scheduled_transfer_id, attempt_number)`. The worker must be idempotent so a job retry cannot execute the same scheduled transfer twice.

## 5.16 `notifications`

| Field        | Type         | Purpose                      |
| ------------ | ------------ | ---------------------------- |
| `id`         | UUID         | Primary key                  |
| `user_id`    | UUID         | FK → `users.id`              |
| `type`       | VARCHAR(80)  | Notification category        |
| `title`      | VARCHAR(150) | Short title                  |
| `message`    | TEXT         | User-facing message          |
| `data`       | JSONB        | Optional structured metadata |
| `read_at`    | TIMESTAMPTZ  | Nullable                     |
| `created_at` | TIMESTAMPTZ  | Creation time                |

Index `(user_id, created_at)` and consider a partial index for unread notifications.

Never include passwords, authentication tokens, full identity-document details, or unnecessary account data in notification metadata.

## 5.17 `fraud_alerts` and `review_cases`

`fraud_alerts`

| Field            | Type        | Purpose                                          |
| ---------------- | ----------- | ------------------------------------------------ |
| `id`             | UUID        | Primary key                                      |
| `transaction_id` | UUID        | FK → `transactions.id`                           |
| `rule_code`      | VARCHAR(80) | Rule that triggered the alert                    |
| `severity`       | ENUM        | `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`              |
| `status`         | ENUM        | `OPEN`, `UNDER_REVIEW`, `DISMISSED`, `CONFIRMED` |
| `details`        | JSONB       | Non-sensitive supporting facts                   |
| `created_at`     | TIMESTAMPTZ | Creation time                                    |
| `resolved_at`    | TIMESTAMPTZ | Nullable                                         |

`review_cases`

| Field            | Type        | Purpose                                        |
| ---------------- | ----------- | ---------------------------------------------- |
| `id`             | UUID        | Primary key                                    |
| `fraud_alert_id` | UUID        | FK → `fraud_alerts.id`                         |
| `assigned_to`    | UUID        | FK → `users.id`, nullable                      |
| `status`         | ENUM        | `OPEN`, `IN_PROGRESS`, `ESCALATED`, `RESOLVED` |
| `resolution`     | TEXT        | Nullable                                       |
| `created_at`     | TIMESTAMPTZ | Creation time                                  |
| `resolved_at`    | TIMESTAMPTZ | Nullable                                       |

Keep review notes and decisions auditable. Access to these records must be restricted to authorized staff.

## 5.18 `audit_logs`

| Field           | Type         | Purpose                                       |
| --------------- | ------------ | --------------------------------------------- |
| `id`            | UUID         | Primary key                                   |
| `actor_user_id` | UUID         | Nullable FK → `users.id`                      |
| `action`        | VARCHAR(100) | Action performed                              |
| `entity_type`   | VARCHAR(100) | Entity category                               |
| `entity_id`     | UUID         | Identifier of affected record                 |
| `request_id`    | UUID         | Request correlation ID                        |
| `reason`        | TEXT         | Required for sensitive administrative actions |
| `metadata`      | JSONB        | Redacted, non-sensitive context               |
| `created_at`    | TIMESTAMPTZ  | Event time                                    |

Use append-only access policies where possible. Audit logs must not contain credentials, full payment secrets, or raw identity documents.

## 5.19 `idempotency_keys`

| Field             | Type         | Purpose                            |
| ----------------- | ------------ | ---------------------------------- |
| `id`              | UUID         | Primary key                        |
| `actor_user_id`   | UUID         | FK → `users.id`                    |
| `operation`       | VARCHAR(100) | Operation namespace                |
| `key`             | VARCHAR(128) | Client-provided unique key         |
| `request_hash`    | VARCHAR(128) | Hash of canonical request          |
| `resource_id`     | UUID         | Nullable resulting transaction     |
| `response_status` | INTEGER      | Nullable HTTP status               |
| `response_body`   | JSONB        | Optional sanitized replay response |
| `created_at`      | TIMESTAMPTZ  | Creation time                      |
| `expires_at`      | TIMESTAMPTZ  | Retention deadline                 |

Enforce a unique constraint on `(actor_user_id, operation, key)`. Reusing the same key with a different request hash must be rejected. Retain financial-operation idempotency records long enough to prevent harmful duplicate processing.

## 5.20 `reconciliation_runs`

| Field                 | Type        | Purpose                                                 |
| --------------------- | ----------- | ------------------------------------------------------- |
| `id`                  | UUID        | Primary key                                             |
| `started_by`          | UUID        | Nullable FK → `users.id`                                |
| `status`              | ENUM        | `RUNNING`, `COMPLETED`, `FAILED`, `DISCREPANCIES_FOUND` |
| `started_at`          | TIMESTAMPTZ | Start time                                              |
| `completed_at`        | TIMESTAMPTZ | Nullable                                                |
| `accounts_checked`    | INTEGER     | Number of accounts checked                              |
| `discrepancies_found` | INTEGER     | Number of discrepancies                                 |
| `summary`             | JSONB       | Sanitized results                                       |

For a detailed implementation, add a `reconciliation_discrepancies` table containing the run, affected account or journal, expected amount, observed amount, and resolution status.

# 6. Entity relationship diagram (ERD)

The following ERD shows how the principal entities connect. It is a conceptual diagram: fields and constraints in Section 5 define the detailed schema.

\#chatgpt-mermaid-\_r_258\_{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;fill:rgb(237, 237, 237);}@keyframes edge-animation-frame{from{stroke-dashoffset:0;}}@keyframes dash{to{stroke-dashoffset:0;}}#chatgpt-mermaid-\_r_258\_ .edge-animation-slow{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 50s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_258\_ .edge-animation-fast{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 20s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_258\_ .error-icon{fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_258\_ .error-text{fill:rgb(237, 237, 237);stroke:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_258\_ .edge-thickness-normal{stroke-width:1px;}#chatgpt-mermaid-\_r_258\_ .edge-thickness-thick{stroke-width:3.5px;}#chatgpt-mermaid-\_r_258\_ .edge-pattern-solid{stroke-dasharray:0;}#chatgpt-mermaid-\_r_258\_ .edge-thickness-invisible{stroke-width:0;fill:none;}#chatgpt-mermaid-\_r_258\_ .edge-pattern-dashed{stroke-dasharray:3;}#chatgpt-mermaid-\_r_258\_ .edge-pattern-dotted{stroke-dasharray:2;}#chatgpt-mermaid-\_r_258\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_258\_ .marker.cross{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_258\_ svg{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;}#chatgpt-mermaid-\_r_258\_ p{margin:0;}#chatgpt-mermaid-\_r_258\_ .entityBox{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_258\_ .relationshipLabelBox{fill:rgb(48, 48, 48);opacity:0.7;background-color:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_258\_ .relationshipLabelBox rect{opacity:0.5;}#chatgpt-mermaid-\_r_258\_ .labelBkg{background-color:rgba(48, 48, 48, 0.5);}#chatgpt-mermaid-\_r_258\_ .edgeLabel{background-color:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_258\_ .edgeLabel .label rect{fill:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_258\_ .edgeLabel .label text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_258\_ .edgeLabel .label{fill:rgb(31, 78, 148);font-size:14px;}#chatgpt-mermaid-\_r_258\_ .label{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_258\_ .edge-pattern-dashed{stroke-dasharray:8,8;}#chatgpt-mermaid-\_r_258\_ .node rect,#chatgpt-mermaid-\_r_258\_ .node circle,#chatgpt-mermaid-\_r_258\_ .node ellipse,#chatgpt-mermaid-\_r_258\_ .node polygon{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);stroke-width:1px;}#chatgpt-mermaid-\_r_258\_ .relationshipLine{stroke:rgb(175, 175, 175);stroke-width:1px;fill:none;}#chatgpt-mermaid-\_r_258\_ .marker{fill:none!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_258\_ [data-look=neo].labelBkg{background-color:rgba(48, 48, 48, 0.5);}#chatgpt-mermaid-\_r_258\_ .node .neo-node{stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_258\_ [data-look="neo"].node rect,#chatgpt-mermaid-\_r_258\_ [data-look="neo"].cluster rect,#chatgpt-mermaid-\_r_258\_ [data-look="neo"].node polygon{stroke:url(#chatgpt-mermaid-\_r_258\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_258\_ [data-look="neo"].swimlane.cluster rect{filter:none;}#chatgpt-mermaid-\_r_258\_ [data-look="neo"].node path{stroke:url(#chatgpt-mermaid-\_r_258\_-gradient);stroke-width:1px;}#chatgpt-mermaid-\_r_258\_ [data-look="neo"].node .outer-path{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_258\_ [data-look="neo"].node .neo-line path{stroke:rgb(31, 78, 148);filter:none;}#chatgpt-mermaid-\_r_258\_ [data-look="neo"].node circle{stroke:url(#chatgpt-mermaid-\_r_258\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_258\_ [data-look="neo"].node circle .state-start{fill:#000000;}#chatgpt-mermaid-\_r_258\_ [data-look="neo"].icon-shape .icon{fill:url(#chatgpt-mermaid-\_r_258\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_258\_ [data-look="neo"].icon-shape .icon-neo path{stroke:url(#chatgpt-mermaid-\_r_258\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_258\_ :root{--mermaid-font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";}USERSUSER_ROLESROLESCUSTOMER_PROFILESSESSIONSREFRESH_TOKENSKYC_CASESKYC_DOCUMENTSBANK_ACCOUNTSACCOUNT_HOLDERSACCOUNT_BALANCE_PROJECTIONSACCOUNT_HOLDSTRANSACTIONSJOURNAL_ENTRIESLEDGER_POSTINGSLEDGER_ACCOUNTSBENEFICIARIESSCHEDULED_TRANSFERSTRANSFER_ATTEMPTSNOTIFICATIONSFRAUD_ALERTSREVIEW_CASESAUDIT_LOGSIDEMPOTENCY_KEYSRECONCILIATION_RUNShasassignedownsopensrotatessubmitscontainsreviewshasholdssummarizesreservescausesrecordscontainsreceivesinitiatessourcedestinationsavesschedulesexecutesrecordsreceivestriggersinvestigatedassignedperformsownsstarts

### Relationship explanations

| Relationship                      | Cardinality                            | Meaning                                                                     |
| --------------------------------- | -------------------------------------- | --------------------------------------------------------------------------- |
| User → Customer profile           | One-to-zero-or-one                     | A user may have a customer profile, while staff accounts do not require one |
| User ↔ Role                       | Many-to-many                           | Users can hold multiple roles                                               |
| Customer → Bank account           | Many-to-many through `account_holders` | Supports joint accounts and authorized signatories                          |
| Bank account → Balance projection | One-to-zero-or-one                     | An optional cached balance record per account                               |
| Transaction → Journal             | One-to-many                            | A transaction can have an original journal and separate reversal journals   |
| Journal → Ledger posting          | One-to-many                            | A journal contains the debit and credit entries                             |
| Ledger account → Ledger posting   | One-to-many                            | An accounting account receives many postings                                |
| Transaction → Fraud alert         | One-to-many                            | One transaction may trigger several rules                                   |
| Scheduled transfer → Attempt      | One-to-many                            | Each execution attempt is preserved                                         |
| User → Notification               | One-to-many                            | Each user can receive many notifications                                    |

Important design distinction: `bank_accounts` represents the customer's banking product, whereas `ledger_accounts` represents the accounting record used to calculate its financial position. Do not conflate the two.

## 7. UML class diagram

The class diagram below describes the core domain objects and their associations. These are domain models, not necessarily one-to-one mappings to TypeScript classes or Prisma models.

\#chatgpt-mermaid-\_r_25h\_{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;fill:rgb(237, 237, 237);}@keyframes edge-animation-frame{from{stroke-dashoffset:0;}}@keyframes dash{to{stroke-dashoffset:0;}}#chatgpt-mermaid-\_r_25h\_ .edge-animation-slow{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 50s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_25h\_ .edge-animation-fast{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 20s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_25h\_ .error-icon{fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_25h\_ .error-text{fill:rgb(237, 237, 237);stroke:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25h\_ .edge-thickness-normal{stroke-width:1px;}#chatgpt-mermaid-\_r_25h\_ .edge-thickness-thick{stroke-width:3.5px;}#chatgpt-mermaid-\_r_25h\_ .edge-pattern-solid{stroke-dasharray:0;}#chatgpt-mermaid-\_r_25h\_ .edge-thickness-invisible{stroke-width:0;fill:none;}#chatgpt-mermaid-\_r_25h\_ .edge-pattern-dashed{stroke-dasharray:3;}#chatgpt-mermaid-\_r_25h\_ .edge-pattern-dotted{stroke-dasharray:2;}#chatgpt-mermaid-\_r_25h\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25h\_ .marker.cross{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25h\_ svg{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;}#chatgpt-mermaid-\_r_25h\_ p{margin:0;}#chatgpt-mermaid-\_r_25h\_ g.classGroup text{fill:rgb(31, 78, 148);stroke:none;font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:10px;}#chatgpt-mermaid-\_r_25h\_ g.classGroup text .title{font-weight:bolder;}#chatgpt-mermaid-\_r_25h\_ .cluster-label text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25h\_ .cluster-label span{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25h\_ .cluster-label span p{background-color:transparent;}#chatgpt-mermaid-\_r_25h\_ .cluster rect{fill:rgb(48, 48, 48);stroke:rgba(255, 255, 255, 0.15);stroke-width:1px;}#chatgpt-mermaid-\_r_25h\_ .cluster text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25h\_ .cluster span{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25h\_ .nodeLabel,#chatgpt-mermaid-\_r_25h\_ .edgeLabel{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25h\_ .noteLabel .nodeLabel,#chatgpt-mermaid-\_r_25h\_ .noteLabel .edgeLabel{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25h\_ .edgeLabel .label rect{fill:rgb(9, 23, 44);}#chatgpt-mermaid-\_r_25h\_ .label text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25h\_ .labelBkg{background:rgb(9, 23, 44);}#chatgpt-mermaid-\_r_25h\_ .edgeLabel .label span{background:rgb(9, 23, 44);}#chatgpt-mermaid-\_r_25h\_ .classTitle{font-weight:bolder;}#chatgpt-mermaid-\_r_25h\_ .node rect,#chatgpt-mermaid-\_r_25h\_ .node circle,#chatgpt-mermaid-\_r_25h\_ .node ellipse,#chatgpt-mermaid-\_r_25h\_ .node polygon,#chatgpt-mermaid-\_r_25h\_ .node path{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ .divider{stroke:rgb(31, 78, 148);stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ g.clickable{cursor:pointer;}#chatgpt-mermaid-\_r_25h\_ g.classGroup rect{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_25h\_ g.classGroup line{stroke:rgb(31, 78, 148);stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ .classLabel .box{stroke:none;stroke-width:0;fill:rgb(9, 23, 44);opacity:0.5;}#chatgpt-mermaid-\_r_25h\_ .classLabel .label{fill:rgb(31, 78, 148);font-size:10px;}#chatgpt-mermaid-\_r_25h\_ .relation{stroke:rgb(175, 175, 175);stroke-width:1;fill:none;}#chatgpt-mermaid-\_r_25h\_ .dashed-line{stroke-dasharray:3;}#chatgpt-mermaid-\_r_25h\_ .dotted-line{stroke-dasharray:1 2;}#chatgpt-mermaid-\_r_25h\_ [id$="-compositionStart"],#chatgpt-mermaid-\_r_25h\_ .composition{fill:rgb(175, 175, 175)!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ [id$="-compositionEnd"],#chatgpt-mermaid-\_r_25h\_ .composition{fill:rgb(175, 175, 175)!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ [id$="-dependencyStart"],#chatgpt-mermaid-\_r_25h\_ .dependency{fill:rgb(175, 175, 175)!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ [id$="-dependencyEnd"],#chatgpt-mermaid-\_r_25h\_ .dependency{fill:rgb(175, 175, 175)!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ [id$="-extensionStart"],#chatgpt-mermaid-\_r_25h\_ .extension{fill:transparent!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ [id$="-extensionEnd"],#chatgpt-mermaid-\_r_25h\_ .extension{fill:transparent!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ [id$="-aggregationStart"],#chatgpt-mermaid-\_r_25h\_ .aggregation{fill:transparent!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ [id$="-aggregationEnd"],#chatgpt-mermaid-\_r_25h\_ .aggregation{fill:transparent!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ [id$="-lollipopStart"],#chatgpt-mermaid-\_r_25h\_ .lollipop{fill:rgb(9, 23, 44)!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ [id$="-lollipopEnd"],#chatgpt-mermaid-\_r_25h\_ .lollipop{fill:rgb(9, 23, 44)!important;stroke:rgb(175, 175, 175)!important;stroke-width:1;}#chatgpt-mermaid-\_r_25h\_ .edgeTerminals{font-size:11px;line-height:initial;}#chatgpt-mermaid-\_r_25h\_ .classTitleText{text-anchor:middle;font-size:18px;fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25h\_ .edgeLabel[data-look="neo"]{background-color:rgb(0, 0, 0);text-align:center;}#chatgpt-mermaid-\_r_25h\_ .edgeLabel[data-look="neo"] p{background-color:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_25h\_ .edgeLabel[data-look="neo"] rect{opacity:0.5;background-color:rgb(0, 0, 0);fill:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_25h\_ .label-icon{display:inline-block;height:1em;overflow:visible;vertical-align:-0.125em;}#chatgpt-mermaid-\_r_25h\_ .node .label-icon path{fill:currentColor;stroke:revert;stroke-width:revert;}#chatgpt-mermaid-\_r_25h\_ .node .neo-node{stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].node rect,#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].cluster rect,#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].node polygon{stroke:url(#chatgpt-mermaid-\_r_25h\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].swimlane.cluster rect{filter:none;}#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].node path{stroke:url(#chatgpt-mermaid-\_r_25h\_-gradient);stroke-width:1px;}#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].node .outer-path{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].node .neo-line path{stroke:rgb(31, 78, 148);filter:none;}#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].node circle{stroke:url(#chatgpt-mermaid-\_r_25h\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].node circle .state-start{fill:#000000;}#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].icon-shape .icon{fill:url(#chatgpt-mermaid-\_r_25h\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25h\_ [data-look="neo"].icon-shape .icon-neo path{stroke:url(#chatgpt-mermaid-\_r_25h\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25h\_ :root{--mermaid-font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";}User+UUID id+String email+String status+authenticate()+revokeSessions()CustomerProfile+UUID id+UUID userId+String firstName+String lastName+Date dateOfBirthBankAccount+UUID id+String accountNumber+String currencyCode+String status+getBalance()+validateDebit()AccountHolder+UUID id+String relationshipType+Boolean canView+Boolean canTransactTransaction+UUID id+String reference+String type+String status+Decimal amount+validate()+execute()JournalEntry+UUID id+String status+DateTime effectiveAt+post()+validateBalance()LedgerPosting+UUID id+String side+Decimal amount+String currencyCodeLedgerAccount+UUID id+String code+String accountType+String currencyCodeAccountHold+UUID id+Decimal amount+String status+release()+capture()profilerelationshipsholdersholdsjournalspostingsentriesreserves111111110..10..\*1..\*0..\*0..\*2..\*0..\*0..\*

The `validateDebit()` and `validateBalance()` operations represent domain responsibilities. Their implementation should coordinate with transactional services and database constraints; they should not simply check values in memory and assume those values remain unchanged.

# 8. UML sequence diagrams

These diagrams describe how the backend components collaborate during the most important operations.

## 8.1 Internal money transfer

Outbox WorkerPostgreSQLTransfer ServiceExpress APIOutbox WorkerPostgreSQLTransfer ServiceExpress API#chatgpt-mermaid-\_r_25q\_{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;fill:rgb(237, 237, 237);}@keyframes edge-animation-frame{from{stroke-dashoffset:0;}}@keyframes dash{to{stroke-dashoffset:0;}}#chatgpt-mermaid-\_r_25q\_ .edge-animation-slow{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 50s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_25q\_ .edge-animation-fast{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 20s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_25q\_ .error-icon{fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_25q\_ .error-text{fill:rgb(237, 237, 237);stroke:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_25q\_ .edge-thickness-normal{stroke-width:1px;}#chatgpt-mermaid-\_r_25q\_ .edge-thickness-thick{stroke-width:3.5px;}#chatgpt-mermaid-\_r_25q\_ .edge-pattern-solid{stroke-dasharray:0;}#chatgpt-mermaid-\_r_25q\_ .edge-thickness-invisible{stroke-width:0;fill:none;}#chatgpt-mermaid-\_r_25q\_ .edge-pattern-dashed{stroke-dasharray:3;}#chatgpt-mermaid-\_r_25q\_ .edge-pattern-dotted{stroke-dasharray:2;}#chatgpt-mermaid-\_r_25q\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25q\_ .marker.cross{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25q\_ svg{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;}#chatgpt-mermaid-\_r_25q\_ p{margin:0;}#chatgpt-mermaid-\_r_25q\_ .actor{stroke:rgb(31, 78, 148);fill:rgb(9, 23, 44);stroke-width:1;}#chatgpt-mermaid-\_r_25q\_ rect.actor.outer-path[data-look="neo"]{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25q\_ rect.note[data-look="neo"]{stroke:rgb(58, 132, 63);fill:rgb(48, 48, 48);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25q\_ text.actor>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_25q\_ .actor-line{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25q\_ .innerArc{stroke-width:1.5;stroke-dasharray:none;}#chatgpt-mermaid-\_r_25q\_ .messageLine0{stroke-width:1.5;stroke-dasharray:none;stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25q\_ .messageLine1{stroke-width:1.5;stroke-dasharray:2,2;stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25q\_ [id$="-arrowhead"] path{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25q\_ .sequenceNumber{fill:#505050;}#chatgpt-mermaid-\_r_25q\_ [id$="-sequencenumber"]{fill:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25q\_ [id$="-crosshead"] path{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_25q\_ .messageText{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_25q\_ .labelBox{stroke:rgba(255, 255, 255, 0.15);fill:rgb(0, 0, 0);filter:none;}#chatgpt-mermaid-\_r_25q\_ .labelText,#chatgpt-mermaid-\_r_25q\_ .labelText>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_25q\_ .loopText,#chatgpt-mermaid-\_r_25q\_ .loopText>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_25q\_ .sectionTitle,#chatgpt-mermaid-\_r_25q\_ .sectionTitle>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_25q\_ .loopLine{stroke-width:2px;stroke-dasharray:2,2;stroke:rgba(255, 255, 255, 0.15);fill:rgba(255, 255, 255, 0.15);}#chatgpt-mermaid-\_r_25q\_ .note{stroke:rgb(58, 132, 63);fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_25q\_ .noteText,#chatgpt-mermaid-\_r_25q\_ .noteText>tspan{fill:rgb(237, 237, 237);stroke:none;font-weight:normal;}#chatgpt-mermaid-\_r_25q\_ .activation0{fill:rgb(48, 48, 48);stroke:hsl(0, 0%, 8.8235294118%);}#chatgpt-mermaid-\_r_25q\_ .activation1{fill:rgb(48, 48, 48);stroke:hsl(0, 0%, 8.8235294118%);}#chatgpt-mermaid-\_r_25q\_ .activation2{fill:rgb(48, 48, 48);stroke:hsl(0, 0%, 8.8235294118%);}#chatgpt-mermaid-\_r_25q\_ .actorPopupMenu{position:absolute;}#chatgpt-mermaid-\_r_25q\_ .actorPopupMenuPanel{position:absolute;fill:rgb(9, 23, 44);box-shadow:0px 8px 16px 0px rgba(0,0,0,0.2);filter:drop-shadow(3px 5px 2px rgb(0 0 0 / 0.4));}#chatgpt-mermaid-\_r_25q\_ .actor-man circle,#chatgpt-mermaid-\_r_25q\_ line{fill:rgb(9, 23, 44);stroke-width:2px;}#chatgpt-mermaid-\_r_25q\_ g rect.rect{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_25q\_ .node .neo-node{stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].node rect,#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].cluster rect,#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].node polygon{stroke:url(#chatgpt-mermaid-\_r_25q\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].swimlane.cluster rect{filter:none;}#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].node path{stroke:url(#chatgpt-mermaid-\_r_25q\_-gradient);stroke-width:1px;}#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].node .outer-path{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].node .neo-line path{stroke:rgb(31, 78, 148);filter:none;}#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].node circle{stroke:url(#chatgpt-mermaid-\_r_25q\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].node circle .state-start{fill:#000000;}#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].icon-shape .icon{fill:url(#chatgpt-mermaid-\_r_25q\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25q\_ [data-look="neo"].icon-shape .icon-neo path{stroke:url(#chatgpt-mermaid-\_r_25q\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_25q\_ :root{--mermaid-font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";}CustomerPOST /transfers + Idempotency-KeyAuthenticate and validate requestinitiateTransfer(command)Begin transactionClaim idempotency keyLock source and destination accountsValidate status, ownership, limits, balanceInsert transaction and journalInsert balanced ledger postingsUpdate balance projectionsInsert audit and outbox recordsCommit transactionCommitted resultTransfer result201 CreatedRead pending outbox eventsDeliver notificationsMark event deliveredCustomer

If validation or posting fails before commit, the database transaction must roll back all related financial changes. Notifications must not be sent as if a transfer succeeded before the financial transaction commits.

If the client retries with the same idempotency key, the API returns the existing operation's result instead of creating a second transfer.

## 8.2 Deposit workflow

PostgreSQLDeposit ServiceExpress APIPostgreSQLDeposit ServiceExpress API#chatgpt-mermaid-\_r_263\_{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;fill:rgb(237, 237, 237);}@keyframes edge-animation-frame{from{stroke-dashoffset:0;}}@keyframes dash{to{stroke-dashoffset:0;}}#chatgpt-mermaid-\_r_263\_ .edge-animation-slow{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 50s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_263\_ .edge-animation-fast{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 20s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_263\_ .error-icon{fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_263\_ .error-text{fill:rgb(237, 237, 237);stroke:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_263\_ .edge-thickness-normal{stroke-width:1px;}#chatgpt-mermaid-\_r_263\_ .edge-thickness-thick{stroke-width:3.5px;}#chatgpt-mermaid-\_r_263\_ .edge-pattern-solid{stroke-dasharray:0;}#chatgpt-mermaid-\_r_263\_ .edge-thickness-invisible{stroke-width:0;fill:none;}#chatgpt-mermaid-\_r_263\_ .edge-pattern-dashed{stroke-dasharray:3;}#chatgpt-mermaid-\_r_263\_ .edge-pattern-dotted{stroke-dasharray:2;}#chatgpt-mermaid-\_r_263\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_263\_ .marker.cross{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_263\_ svg{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;}#chatgpt-mermaid-\_r_263\_ p{margin:0;}#chatgpt-mermaid-\_r_263\_ .actor{stroke:rgb(31, 78, 148);fill:rgb(9, 23, 44);stroke-width:1;}#chatgpt-mermaid-\_r_263\_ rect.actor.outer-path[data-look="neo"]{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_263\_ rect.note[data-look="neo"]{stroke:rgb(58, 132, 63);fill:rgb(48, 48, 48);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_263\_ text.actor>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_263\_ .actor-line{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_263\_ .innerArc{stroke-width:1.5;stroke-dasharray:none;}#chatgpt-mermaid-\_r_263\_ .messageLine0{stroke-width:1.5;stroke-dasharray:none;stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_263\_ .messageLine1{stroke-width:1.5;stroke-dasharray:2,2;stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_263\_ [id$="-arrowhead"] path{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_263\_ .sequenceNumber{fill:#505050;}#chatgpt-mermaid-\_r_263\_ [id$="-sequencenumber"]{fill:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_263\_ [id$="-crosshead"] path{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_263\_ .messageText{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_263\_ .labelBox{stroke:rgba(255, 255, 255, 0.15);fill:rgb(0, 0, 0);filter:none;}#chatgpt-mermaid-\_r_263\_ .labelText,#chatgpt-mermaid-\_r_263\_ .labelText>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_263\_ .loopText,#chatgpt-mermaid-\_r_263\_ .loopText>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_263\_ .sectionTitle,#chatgpt-mermaid-\_r_263\_ .sectionTitle>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_263\_ .loopLine{stroke-width:2px;stroke-dasharray:2,2;stroke:rgba(255, 255, 255, 0.15);fill:rgba(255, 255, 255, 0.15);}#chatgpt-mermaid-\_r_263\_ .note{stroke:rgb(58, 132, 63);fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_263\_ .noteText,#chatgpt-mermaid-\_r_263\_ .noteText>tspan{fill:rgb(237, 237, 237);stroke:none;font-weight:normal;}#chatgpt-mermaid-\_r_263\_ .activation0{fill:rgb(48, 48, 48);stroke:hsl(0, 0%, 8.8235294118%);}#chatgpt-mermaid-\_r_263\_ .activation1{fill:rgb(48, 48, 48);stroke:hsl(0, 0%, 8.8235294118%);}#chatgpt-mermaid-\_r_263\_ .activation2{fill:rgb(48, 48, 48);stroke:hsl(0, 0%, 8.8235294118%);}#chatgpt-mermaid-\_r_263\_ .actorPopupMenu{position:absolute;}#chatgpt-mermaid-\_r_263\_ .actorPopupMenuPanel{position:absolute;fill:rgb(9, 23, 44);box-shadow:0px 8px 16px 0px rgba(0,0,0,0.2);filter:drop-shadow(3px 5px 2px rgb(0 0 0 / 0.4));}#chatgpt-mermaid-\_r_263\_ .actor-man circle,#chatgpt-mermaid-\_r_263\_ line{fill:rgb(9, 23, 44);stroke-width:2px;}#chatgpt-mermaid-\_r_263\_ g rect.rect{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_263\_ .node .neo-node{stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_263\_ [data-look="neo"].node rect,#chatgpt-mermaid-\_r_263\_ [data-look="neo"].cluster rect,#chatgpt-mermaid-\_r_263\_ [data-look="neo"].node polygon{stroke:url(#chatgpt-mermaid-\_r_263\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_263\_ [data-look="neo"].swimlane.cluster rect{filter:none;}#chatgpt-mermaid-\_r_263\_ [data-look="neo"].node path{stroke:url(#chatgpt-mermaid-\_r_263\_-gradient);stroke-width:1px;}#chatgpt-mermaid-\_r_263\_ [data-look="neo"].node .outer-path{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_263\_ [data-look="neo"].node .neo-line path{stroke:rgb(31, 78, 148);filter:none;}#chatgpt-mermaid-\_r_263\_ [data-look="neo"].node circle{stroke:url(#chatgpt-mermaid-\_r_263\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_263\_ [data-look="neo"].node circle .state-start{fill:#000000;}#chatgpt-mermaid-\_r_263\_ [data-look="neo"].icon-shape .icon{fill:url(#chatgpt-mermaid-\_r_263\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_263\_ [data-look="neo"].icon-shape .icon-neo path{stroke:url(#chatgpt-mermaid-\_r_263\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_263\_ :root{--mermaid-font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";}CustomerTellerRequest simulated depositvalidateDeposit()Create pending transactionTransaction referencePending depositDeposit referenceConfirm eligible depositconfirmDeposit(reference)Begin transactionLock pending transactionValidate authorization and statusPost balanced journalUpdate projection and auditCommitPostedSuccessful depositConfirmationCustomerTeller

For a more advanced version, implement a separate simulated cash-clearing account and record the staff member, authorization, and deposit reference. Repeated confirmation requests must not post the deposit twice.

## 8.3 KYC review workflow

PostgreSQLKYC ServiceExpress APIPostgreSQLKYC ServiceExpress API#chatgpt-mermaid-\_r_26c\_{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;fill:rgb(237, 237, 237);}@keyframes edge-animation-frame{from{stroke-dashoffset:0;}}@keyframes dash{to{stroke-dashoffset:0;}}#chatgpt-mermaid-\_r_26c\_ .edge-animation-slow{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 50s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_26c\_ .edge-animation-fast{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 20s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_26c\_ .error-icon{fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_26c\_ .error-text{fill:rgb(237, 237, 237);stroke:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_26c\_ .edge-thickness-normal{stroke-width:1px;}#chatgpt-mermaid-\_r_26c\_ .edge-thickness-thick{stroke-width:3.5px;}#chatgpt-mermaid-\_r_26c\_ .edge-pattern-solid{stroke-dasharray:0;}#chatgpt-mermaid-\_r_26c\_ .edge-thickness-invisible{stroke-width:0;fill:none;}#chatgpt-mermaid-\_r_26c\_ .edge-pattern-dashed{stroke-dasharray:3;}#chatgpt-mermaid-\_r_26c\_ .edge-pattern-dotted{stroke-dasharray:2;}#chatgpt-mermaid-\_r_26c\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_26c\_ .marker.cross{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_26c\_ svg{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;}#chatgpt-mermaid-\_r_26c\_ p{margin:0;}#chatgpt-mermaid-\_r_26c\_ .actor{stroke:rgb(31, 78, 148);fill:rgb(9, 23, 44);stroke-width:1;}#chatgpt-mermaid-\_r_26c\_ rect.actor.outer-path[data-look="neo"]{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_26c\_ rect.note[data-look="neo"]{stroke:rgb(58, 132, 63);fill:rgb(48, 48, 48);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_26c\_ text.actor>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_26c\_ .actor-line{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_26c\_ .innerArc{stroke-width:1.5;stroke-dasharray:none;}#chatgpt-mermaid-\_r_26c\_ .messageLine0{stroke-width:1.5;stroke-dasharray:none;stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_26c\_ .messageLine1{stroke-width:1.5;stroke-dasharray:2,2;stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_26c\_ [id$="-arrowhead"] path{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_26c\_ .sequenceNumber{fill:#505050;}#chatgpt-mermaid-\_r_26c\_ [id$="-sequencenumber"]{fill:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_26c\_ [id$="-crosshead"] path{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_26c\_ .messageText{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_26c\_ .labelBox{stroke:rgba(255, 255, 255, 0.15);fill:rgb(0, 0, 0);filter:none;}#chatgpt-mermaid-\_r_26c\_ .labelText,#chatgpt-mermaid-\_r_26c\_ .labelText>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_26c\_ .loopText,#chatgpt-mermaid-\_r_26c\_ .loopText>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_26c\_ .sectionTitle,#chatgpt-mermaid-\_r_26c\_ .sectionTitle>tspan{fill:rgb(237, 237, 237);stroke:none;}#chatgpt-mermaid-\_r_26c\_ .loopLine{stroke-width:2px;stroke-dasharray:2,2;stroke:rgba(255, 255, 255, 0.15);fill:rgba(255, 255, 255, 0.15);}#chatgpt-mermaid-\_r_26c\_ .note{stroke:rgb(58, 132, 63);fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_26c\_ .noteText,#chatgpt-mermaid-\_r_26c\_ .noteText>tspan{fill:rgb(237, 237, 237);stroke:none;font-weight:normal;}#chatgpt-mermaid-\_r_26c\_ .activation0{fill:rgb(48, 48, 48);stroke:hsl(0, 0%, 8.8235294118%);}#chatgpt-mermaid-\_r_26c\_ .activation1{fill:rgb(48, 48, 48);stroke:hsl(0, 0%, 8.8235294118%);}#chatgpt-mermaid-\_r_26c\_ .activation2{fill:rgb(48, 48, 48);stroke:hsl(0, 0%, 8.8235294118%);}#chatgpt-mermaid-\_r_26c\_ .actorPopupMenu{position:absolute;}#chatgpt-mermaid-\_r_26c\_ .actorPopupMenuPanel{position:absolute;fill:rgb(9, 23, 44);box-shadow:0px 8px 16px 0px rgba(0,0,0,0.2);filter:drop-shadow(3px 5px 2px rgb(0 0 0 / 0.4));}#chatgpt-mermaid-\_r_26c\_ .actor-man circle,#chatgpt-mermaid-\_r_26c\_ line{fill:rgb(9, 23, 44);stroke-width:2px;}#chatgpt-mermaid-\_r_26c\_ g rect.rect{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_26c\_ .node .neo-node{stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].node rect,#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].cluster rect,#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].node polygon{stroke:url(#chatgpt-mermaid-\_r_26c\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].swimlane.cluster rect{filter:none;}#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].node path{stroke:url(#chatgpt-mermaid-\_r_26c\_-gradient);stroke-width:1px;}#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].node .outer-path{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].node .neo-line path{stroke:rgb(31, 78, 148);filter:none;}#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].node circle{stroke:url(#chatgpt-mermaid-\_r_26c\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].node circle .state-start{fill:#000000;}#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].icon-shape .icon{fill:url(#chatgpt-mermaid-\_r_26c\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_26c\_ [data-look="neo"].icon-shape .icon-neo path{stroke:url(#chatgpt-mermaid-\_r_26c\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_26c\_ :root{--mermaid-font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";}CustomerCompliance OfficerSubmit verificationsubmitCase()Save case and document referencesPending reviewSubmission receivedOpen review casereviewCase()Verify officer permissionRecord decision and reviewerUpdated statusDecision savedRecord notification eventCustomerCompliance Officer

The final implementation should enforce valid status transitions and ensure that customers cannot approve their own KYC cases.

# 9. Complete API specification

Use `/api/v1` for all routes. The tables below describe the endpoints you should implement, their authorization requirements, and the expected behavior.

## 9.1 Authentication and customer accounts

| Method | Endpoint                        | Authorization      | Functionality                   |
| ------ | ------------------------------- | ------------------ | ------------------------------- |
| POST   | `/auth/register`                | Public             | Register a user                 |
| POST   | `/auth/login`                   | Public             | Authenticate                    |
| POST   | `/auth/refresh`                 | Refresh token      | Rotate refresh token            |
| POST   | `/auth/logout`                  | Authenticated      | Revoke current session          |
| POST   | `/auth/logout-all`              | Authenticated      | Revoke all sessions             |
| POST   | `/auth/forgot-password`         | Public             | Request password reset          |
| POST   | `/auth/reset-password`          | Reset token        | Reset password                  |
| POST   | `/auth/verify-email`            | Verification token | Verify email                    |
| GET    | `/customers/me`                 | Customer           | Get profile                     |
| PATCH  | `/customers/me`                 | Customer           | Update permitted profile fields |
| POST   | `/customers/me/change-password` | Customer           | Change password                 |
| GET    | `/customers/me/sessions`        | Customer           | List active sessions            |
| DELETE | `/customers/me/sessions/:id`    | Customer           | Revoke a session                |

Required validations: Validate all request fields, prevent privilege escalation, rate-limit authentication attempts, and return generic errors where detailed errors could expose account existence.

## 9.2 KYC and account management

| Method | Endpoint                         | Authorization     | Functionality                           |
| ------ | -------------------------------- | ----------------- | --------------------------------------- |
| POST   | `/kyc/cases`                     | Customer          | Submit a verification case              |
| GET    | `/kyc/cases/me`                  | Customer          | View own cases                          |
| POST   | `/kyc/cases/:id/documents`       | Customer          | Add document references                 |
| GET    | `/staff/kyc/cases`               | Compliance        | List cases for review                   |
| GET    | `/staff/kyc/cases/:id`           | Compliance        | Inspect a permitted case                |
| POST   | `/staff/kyc/cases/:id/decision`  | Compliance        | Approve, reject, or request information |
| POST   | `/accounts`                      | Verified customer | Request account opening                 |
| GET    | `/accounts`                      | Authorized holder | List accessible accounts                |
| GET    | `/accounts/:id`                  | Authorized holder | View account details                    |
| GET    | `/accounts/:id/balance`          | Authorized holder | View balance information                |
| POST   | `/accounts/:id/closure-requests` | Authorized holder | Request account closure                 |
| GET    | `/accounts/:id/statement`        | Authorized holder | Generate statement                      |

Account opening should create the necessary bank-account and ledger-account mapping in a controlled workflow. Account closure must not erase the financial history.

## 9.3 Deposits, withdrawals, and transfers

| Method | Endpoint                         | Authorization                          | Functionality                          |
| ------ | -------------------------------- | -------------------------------------- | -------------------------------------- |
| POST   | `/deposits`                      | Authorized customer or teller workflow | Initiate a simulated deposit           |
| POST   | `/staff/deposits/:id/confirm`    | Teller                                 | Confirm an eligible deposit            |
| POST   | `/withdrawals`                   | Authorized customer                    | Request a withdrawal                   |
| POST   | `/staff/withdrawals/:id/process` | Teller                                 | Process an eligible teller withdrawal  |
| POST   | `/transfers`                     | Authorized customer                    | Initiate a transfer                    |
| GET    | `/transfers/:id`                 | Transaction participant                | View transfer status                   |
| GET    | `/transactions/:id`              | Authorized participant or staff        | View permitted transaction details     |
| GET    | `/transactions`                  | Authorized customer                    | Search own transactions                |
| POST   | `/transactions/:id/cancel`       | Authorized participant                 | Cancel an eligible pending transaction |
| POST   | `/transactions/:id/reversals`    | Authorized staff or approved workflow  | Request a reversal                     |
| GET    | `/accounts/:id/transactions`     | Authorized holder                      | View account transactions              |

Financial endpoints must support idempotency, strict amount validation, account-status checks, and transaction-level authorization.

## 9.4 Beneficiaries and scheduled transfers

| Method | Endpoint                            | Authorization                     | Functionality                      |
| ------ | ----------------------------------- | --------------------------------- | ---------------------------------- |
| POST   | `/beneficiaries`                    | Customer                          | Add a beneficiary                  |
| GET    | `/beneficiaries`                    | Customer                          | List beneficiaries                 |
| PATCH  | `/beneficiaries/:id`                | Owner                             | Update permitted fields            |
| DELETE | `/beneficiaries/:id`                | Owner                             | Remove a beneficiary               |
| POST   | `/beneficiaries/:id/verify`         | Owner with step-up authentication | Verify beneficiary                 |
| POST   | `/scheduled-transfers`              | Customer                          | Create a scheduled transfer        |
| GET    | `/scheduled-transfers`              | Customer                          | List scheduled transfers           |
| PATCH  | `/scheduled-transfers/:id`          | Owner                             | Pause or modify eligible schedules |
| POST   | `/scheduled-transfers/:id/cancel`   | Owner                             | Cancel a schedule                  |
| GET    | `/scheduled-transfers/:id/attempts` | Owner                             | View execution history             |

## 9.5 Staff operations and administration

| Method | Endpoint                          | Authorization                 | Functionality                 |
| ------ | --------------------------------- | ----------------------------- | ----------------------------- |
| GET    | `/staff/accounts`                 | Authorized staff              | Search permitted accounts     |
| PATCH  | `/staff/accounts/:id/status`      | Privileged staff              | Freeze, restrict, or unfreeze |
| GET    | `/staff/fraud-alerts`             | Compliance                    | View flagged transactions     |
| POST   | `/staff/fraud-alerts/:id/assign`  | Compliance                    | Assign a review               |
| POST   | `/staff/review-cases/:id/resolve` | Authorized compliance officer | Record resolution             |
| GET    | `/staff/audit-logs`               | Authorized staff              | Search audit history          |
| GET    | `/admin/users`                    | Bank admin                    | Manage users                  |
| POST   | `/admin/users/:id/roles`          | Bank admin                    | Assign roles                  |
| GET    | `/admin/transaction-limits`       | Bank admin                    | View limits                   |
| POST   | `/admin/transaction-limits`       | Bank admin                    | Create a limit rule           |
| POST   | `/admin/fee-rules`                | Bank admin                    | Create a fee rule             |
| POST   | `/admin/reconciliation-runs`      | Authorized operator           | Start reconciliation          |
| GET    | `/admin/reconciliation-runs/:id`  | Authorized operator           | View results                  |

Administrative actions need reason codes, audit logging, and appropriate separation of duties. High-risk actions should require an approval workflow instead of a single unrestricted endpoint.

# 10. Request and response data structures

These examples define the expected API contracts. They are examples of payloads, not implementations of the business logic.

## 10.1 Register a customer

`POST /api/v1/auth/register`

Request:

```
{
  "email": "customer@example.com",
  "phone": "+233200000000",
  "password": "Example-Password-123!",
  "firstName": "Ama",
  "lastName": "Mensah",
  "dateOfBirth": "1998-06-15"
}
```

Successful response: `201 Created`

```
{
  "data": {
    "userId": "0f7c7e25-2b6c-4cb5-9cc4-c88e47a98a10",
    "status": "PENDING_VERIFICATION",
    "emailVerificationRequired": true
  }
}
```

The server should not return the password hash, password-reset token, or other credentials.

## 10.2 Open a bank account

`POST /api/v1/accounts`

Request:

```
{
  "accountType": "SAVINGS",
  "currencyCode": "GHS"
}
```

Successful response: `201 Created`

```
{
  "data": {
    "accountId": "4e1f8e9a-66e4-42e7-a9df-b6eb9b7f240a",
    "accountNumber": "SIM0000000001",
    "accountType": "SAVINGS",
    "currencyCode": "GHS",
    "status": "ACTIVE",
    "ledgerBalance": "0.0000",
    "availableBalance": "0.0000"
  }
}
```

The account number is illustrative. The application must generate unique account numbers and verify all opening requirements before activating an account.

## 10.3 Initiate a transfer

`POST /api/v1/transfers`

Headers:

```
Authorization: Bearer <access-token>
Idempotency-Key: 5f71a0cb-unique-transfer-request
Content-Type: application/json
```

Request:

```
{
  "sourceAccountId": "4e1f8e9a-66e4-42e7-a9df-b6eb9b7f240a",
  "destinationAccountNumber": "SIM0000000002",
  "amount": "100.00",
  "currencyCode": "GHS",
  "description": "Monthly contribution"
}
```

Successful response: `201 Created`

```
{
  "data": {
    "transactionId": "d4c37e83-6a8c-4d80-b5f6-b6b63c9b8f91",
    "reference": "TRF-EXAMPLE-0001",
    "type": "TRANSFER",
    "status": "POSTED",
    "amount": "100.00",
    "feeAmount": "0.00",
    "currencyCode": "GHS",
    "createdAt": "2026-10-23T12:00:00Z",
    "completedAt": "2026-10-23T12:00:00Z"
  }
}
```

A real implementation must use generated references and actual persisted timestamps. Do not copy these sample identifiers or values into the database as fixed values.

## 10.4 Retrieve an account balance

`GET /api/v1/accounts/:id/balance`

Response:

```
{
  "data": {
    "accountId": "4e1f8e9a-66e4-42e7-a9df-b6eb9b7f240a",
    "currencyCode": "GHS",
    "ledgerBalance": "850.00",
    "availableBalance": "800.00",
    "activeHolds": "50.00",
    "asOf": "2026-10-23T12:00:00Z"
  }
}
```

The response must be generated from a consistent database view. Balance projections should be checked against the ledger during reconciliation.

## 10.5 Retrieve transaction history

`GET /api/v1/accounts/:id/transactions?from=2026-10-01&to=2026-10-31&limit=20`

Response:

```
{
  "data": [
    {
      "transactionId": "d4c37e83-6a8c-4d80-b5f6-b6b63c9b8f91",
      "reference": "TRF-EXAMPLE-0001",
      "type": "TRANSFER",
      "status": "POSTED",
      "direction": "DEBIT",
      "amount": "100.00",
      "currencyCode": "GHS",
      "description": "Monthly contribution",
      "createdAt": "2026-10-23T12:00:00Z"
    }
  ],
  "pagination": {
    "limit": 20,
    "nextCursor": null
  }
}
```

Use cursor-based pagination for large histories. Define whether the end date is inclusive and how time zones are interpreted.

## 10.6 Error response format

Use a consistent error structure across the API.

```
{
  "error": {
    "code": "INSUFFICIENT_FUNDS",
    "message": "The available balance is insufficient for this transaction.",
    "requestId": "5f71a0cb-unique-request"
  }
}
```

Suggested HTTP statuses:

| Status | Use                                                    |
| ------ | ------------------------------------------------------ |
| `400`  | Malformed request                                      |
| `401`  | Missing or invalid authentication                      |
| `403`  | Authenticated but not authorized                       |
| `404`  | Resource not found or intentionally concealed          |
| `409`  | State conflict or idempotency conflict                 |
| `422`  | Valid request structure but failed business validation |
| `429`  | Rate limit exceeded                                    |
| `500`  | Unexpected internal error                              |

Never return database stack traces, SQL statements, or internal secrets to clients.

# 11. Financial business rules and transaction integrity

The banking engine must have explicit invariants: conditions that remain true regardless of how many requests arrive or what failures occur.

## 11.1 Monetary representation

Choose one monetary representation and use it consistently.

For this project, use PostgreSQL `NUMERIC(19,4)` and a validated decimal arithmetic library in TypeScript. Serialize monetary values as decimal strings in JSON, not JavaScript floating-point numbers.

Define a currency-specific rounding policy. Although GHS amounts are ordinarily expressed to two decimal places, keeping four decimal places internally may be useful for calculations. Round according to your documented policy when producing customer-facing amounts and posting final amounts.

Do not silently mix currencies. A transfer between accounts of different currencies must be rejected until an explicit exchange-rate and foreign-exchange accounting workflow is implemented.

## 11.2 Double-entry accounting rules

For each posted journal:

\\[ \sum \text{Debits} = \sum \text{Credits} \\]

This equality must hold independently for each currency.

For a transfer of GH₵100 with no fee:

| Posting | Ledger account                | Debit  | Credit |
| ------- | ----------------------------- | ------ | ------ |
| 1       | Sender's deposit liability    | 100.00 | 0.00   |
| 2       | Recipient's deposit liability | 0.00   | 100.00 |

For a deposit of GH₵100 through a simulated cash-clearing account:

| Posting | Ledger account                  | Debit  | Credit |
| ------- | ------------------------------- | ------ | ------ |
| 1       | Simulated cash / clearing asset | 100.00 | 0.00   |
| 2       | Customer deposit liability      | 0.00   | 100.00 |

For a withdrawal of GH₵100:

| Posting | Ledger account                  | Debit  | Credit |
| ------- | ------------------------------- | ------ | ------ |
| 1       | Customer deposit liability      | 100.00 | 0.00   |
| 2       | Simulated cash / clearing asset | 0.00   | 100.00 |

These entries follow normal accounting conventions. The customer's displayed balance is the credit balance of their deposit liability account, adjusted for applicable holds.

If a fee is charged, add appropriate fee-revenue and settlement postings. The transaction, fee, and journal must all agree on the amounts and currency.

## 11.3 Atomicity and concurrency

For every financial operation, use a single PostgreSQL transaction for all changes that must succeed or fail together.

A transfer should:

1. Claim the idempotency key.
2. Lock the relevant account records in a consistent order.
3. Validate account ownership, status, currency, limits, and available funds.
4. Insert the transaction record.
5. Insert the journal header and balanced postings.
6. Update the balance projections and applicable holds.
7. Write the audit record and transactional outbox event.
8. Commit the transaction.

If any required operation fails, roll back the financial changes.

For concurrent requests, use row locking, conditional updates, and suitable database isolation. Locking accounts in a consistent order helps avoid deadlocks when two transfers involve the same accounts in opposite directions.

Do not assume that a preliminary balance check performed outside the transaction remains valid when the transfer is eventually posted.

## 11.4 Transaction state machine

\#chatgpt-mermaid-\_r_28g\_{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;fill:rgb(237, 237, 237);}@keyframes edge-animation-frame{from{stroke-dashoffset:0;}}@keyframes dash{to{stroke-dashoffset:0;}}#chatgpt-mermaid-\_r_28g\_ .edge-animation-slow{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 50s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_28g\_ .edge-animation-fast{stroke-dasharray:9,5!important;stroke-dashoffset:900;animation:dash 20s linear infinite;stroke-linecap:round;}#chatgpt-mermaid-\_r_28g\_ .error-icon{fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_28g\_ .error-text{fill:rgb(237, 237, 237);stroke:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_28g\_ .edge-thickness-normal{stroke-width:1px;}#chatgpt-mermaid-\_r_28g\_ .edge-thickness-thick{stroke-width:3.5px;}#chatgpt-mermaid-\_r_28g\_ .edge-pattern-solid{stroke-dasharray:0;}#chatgpt-mermaid-\_r_28g\_ .edge-thickness-invisible{stroke-width:0;fill:none;}#chatgpt-mermaid-\_r_28g\_ .edge-pattern-dashed{stroke-dasharray:3;}#chatgpt-mermaid-\_r_28g\_ .edge-pattern-dotted{stroke-dasharray:2;}#chatgpt-mermaid-\_r_28g\_ .marker{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_28g\_ .marker.cross{stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_28g\_ svg{font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";font-size:16px;}#chatgpt-mermaid-\_r_28g\_ p{margin:0;}#chatgpt-mermaid-\_r_28g\_ defs [id$="-barbEnd"]{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_28g\_ g.stateGroup text{fill:rgb(31, 78, 148);stroke:none;font-size:10px;}#chatgpt-mermaid-\_r_28g\_ g.stateGroup text{fill:rgb(237, 237, 237);stroke:none;font-size:10px;}#chatgpt-mermaid-\_r_28g\_ g.stateGroup .state-title{font-weight:bolder;fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_28g\_ g.stateGroup rect{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_28g\_ g.stateGroup line{stroke:rgb(175, 175, 175);stroke-width:1;}#chatgpt-mermaid-\_r_28g\_ .transition{stroke:rgb(175, 175, 175);stroke-width:1;fill:none;}#chatgpt-mermaid-\_r_28g\_ .stateGroup .composit{fill:transparent;border-bottom:1px;}#chatgpt-mermaid-\_r_28g\_ .stateGroup .alt-composit{fill:#e0e0e0;border-bottom:1px;}#chatgpt-mermaid-\_r_28g\_ .state-note{stroke:rgb(58, 132, 63);fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_28g\_ .state-note text{fill:rgb(237, 237, 237);stroke:none;font-size:10px;}#chatgpt-mermaid-\_r_28g\_ .stateLabel .box{stroke:none;stroke-width:0;fill:rgb(9, 23, 44);opacity:0.5;}#chatgpt-mermaid-\_r_28g\_ .edgeLabel .label rect{fill:rgb(9, 23, 44);opacity:0.5;}#chatgpt-mermaid-\_r_28g\_ .edgeLabel{background-color:rgb(0, 0, 0);text-align:center;}#chatgpt-mermaid-\_r_28g\_ .edgeLabel p{background-color:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_28g\_ .edgeLabel rect{opacity:0.5;background-color:rgb(0, 0, 0);fill:rgb(0, 0, 0);}#chatgpt-mermaid-\_r_28g\_ .edgeLabel .label text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_28g\_ .label div .edgeLabel{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_28g\_ .stateLabel text{fill:rgb(237, 237, 237);font-size:10px;font-weight:bold;}#chatgpt-mermaid-\_r_28g\_ .node circle.state-start{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_28g\_ .node .fork-join{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_28g\_ .node circle.state-end{fill:rgb(31, 78, 148);stroke:transparent;stroke-width:1.5;}#chatgpt-mermaid-\_r_28g\_ .end-state-inner{fill:transparent;stroke-width:1.5;}#chatgpt-mermaid-\_r_28g\_ .node rect{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);stroke-width:1px;}#chatgpt-mermaid-\_r_28g\_ .node polygon{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);stroke-width:1px;}#chatgpt-mermaid-\_r_28g\_ [id$="-barbEnd"]{fill:rgb(175, 175, 175);}#chatgpt-mermaid-\_r_28g\_ .statediagram-cluster rect{fill:rgb(9, 23, 44);stroke:rgb(31, 78, 148);stroke-width:1px;}#chatgpt-mermaid-\_r_28g\_ .cluster-label,#chatgpt-mermaid-\_r_28g\_ .nodeLabel{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_28g\_ .statediagram-cluster rect.outer{rx:5px;ry:5px;}#chatgpt-mermaid-\_r_28g\_ .statediagram-state .divider{stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_28g\_ .statediagram-state .title-state{rx:5px;ry:5px;}#chatgpt-mermaid-\_r_28g\_ .statediagram-cluster.statediagram-cluster .inner{fill:transparent;}#chatgpt-mermaid-\_r_28g\_ .statediagram-cluster.statediagram-cluster-alt .inner{fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_28g\_ .statediagram-cluster .inner{rx:0;ry:0;}#chatgpt-mermaid-\_r_28g\_ .statediagram-state rect.basic{rx:5px;ry:5px;}#chatgpt-mermaid-\_r_28g\_ .statediagram-state rect.divider{stroke-dasharray:10,10;fill:rgb(48, 48, 48);}#chatgpt-mermaid-\_r_28g\_ .note-edge{stroke-dasharray:5;}#chatgpt-mermaid-\_r_28g\_ .statediagram-note rect{fill:rgb(48, 48, 48);stroke:rgb(58, 132, 63);stroke-width:1px;rx:0;ry:0;}#chatgpt-mermaid-\_r_28g\_ .statediagram-note rect{fill:rgb(48, 48, 48);stroke:rgb(58, 132, 63);stroke-width:1px;rx:0;ry:0;}#chatgpt-mermaid-\_r_28g\_ .statediagram-note text{fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_28g\_ .statediagram-note .nodeLabel{color:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_28g\_ .statediagram .edgeLabel{color:red;}#chatgpt-mermaid-\_r_28g\_ [id$="-dependencyStart"],#chatgpt-mermaid-\_r_28g\_ [id$="-dependencyEnd"]{fill:rgb(175, 175, 175);stroke:rgb(175, 175, 175);stroke-width:1;}#chatgpt-mermaid-\_r_28g\_ .statediagramTitleText{text-anchor:middle;font-size:18px;fill:rgb(237, 237, 237);}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].statediagram-cluster rect{fill:rgb(9, 23, 44);stroke:url(#chatgpt-mermaid-\_r_28g\_-gradient);stroke-width:1;}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].statediagram-cluster rect.outer{rx:5px;ry:5px;filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_28g\_ .node .neo-node{stroke:rgb(31, 78, 148);}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].node rect,#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].cluster rect,#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].node polygon{stroke:url(#chatgpt-mermaid-\_r_28g\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].swimlane.cluster rect{filter:none;}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].node path{stroke:url(#chatgpt-mermaid-\_r_28g\_-gradient);stroke-width:1px;}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].node .outer-path{filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].node .neo-line path{stroke:rgb(31, 78, 148);filter:none;}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].node circle{stroke:url(#chatgpt-mermaid-\_r_28g\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].node circle .state-start{fill:#000000;}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].icon-shape .icon{fill:url(#chatgpt-mermaid-\_r_28g\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_28g\_ [data-look="neo"].icon-shape .icon-neo path{stroke:url(#chatgpt-mermaid-\_r_28g\_-gradient);filter:drop-shadow( 1px 2px 2px rgba(185,185,185,1));}#chatgpt-mermaid-\_r_28g\_ :root{--mermaid-font-family:-apple-system-body,ui-sans-serif,-apple-system,system-ui,"Segoe UI",Helvetica,"Apple Color Emoji",Arial,sans-serif,"Segoe UI Emoji","Segoe UI Symbol";}PENDINGPROCESSINGCANCELLEDFAILEDPOSTEDREVERSED

Treat this as the initial state model, not a rule that every transaction must pass through every state.

- `PENDING`: Created but not yet processed.
- `PROCESSING`: Execution is underway.
- `POSTED`: The financial journal has committed successfully.
- `FAILED`: Processing failed without a successful financial posting.
- `CANCELLED`: Cancelled before posting.
- `REVERSED`: A previously posted transaction has been reversed through compensating entries.

Never move a transaction to `POSTED` before the corresponding ledger entries commit. A reversal must preserve the original transaction and record its own reference and accounting entries.

## 11.5 Idempotency

Consider a client that sends a transfer request and times out before receiving the response. The transfer may already have succeeded.

If the client retries with the same idempotency key:

- Return the existing operation if the request matches.
- Reject the request if the key is reused with a different payload.
- Never create a second financial posting for the same logical operation.
- Preserve the original result so retries remain predictable.

A unique database constraint is essential; checking for the key in application code alone is not sufficient under concurrent requests.

# 12. Additional entities required for a robust implementation

The earlier entity list establishes the main domain. Add the following supporting tables as you implement the more advanced workflows.

## 12.1 `transaction_outbox`

Use the transactional outbox pattern to deliver notifications and background events reliably after financial operations commit.

| Field            | Type         | Purpose                                        |
| ---------------- | ------------ | ---------------------------------------------- |
| `id`             | UUID         | Primary key                                    |
| `event_type`     | VARCHAR(100) | Event category                                 |
| `aggregate_type` | VARCHAR(100) | Entity type                                    |
| `aggregate_id`   | UUID         | Related entity                                 |
| `payload`        | JSONB        | Minimal, non-sensitive event data              |
| `status`         | ENUM         | `PENDING`, `PROCESSING`, `DELIVERED`, `FAILED` |
| `attempt_count`  | INTEGER      | Number of attempts                             |
| `created_at`     | TIMESTAMPTZ  | Creation time                                  |
| `delivered_at`   | TIMESTAMPTZ  | Nullable                                       |

A worker can retry failed deliveries without replaying the financial transaction.

## 12.2 `account_status_history`

| Field             | Type        | Purpose                 |
| ----------------- | ----------- | ----------------------- |
| `id`              | UUID        | Primary key             |
| `account_id`      | UUID        | FK → `bank_accounts.id` |
| `previous_status` | ENUM        | Previous state          |
| `new_status`      | ENUM        | New state               |
| `changed_by`      | UUID        | FK → `users.id`         |
| `reason`          | TEXT        | Required justification  |
| `created_at`      | TIMESTAMPTZ | Change time             |

## 12.3 `transaction_reversals`

| Field                     | Type        | Purpose                                          |
| ------------------------- | ----------- | ------------------------------------------------ |
| `id`                      | UUID        | Primary key                                      |
| `original_transaction_id` | UUID        | FK → `transactions.id`                           |
| `reversal_transaction_id` | UUID        | FK → `transactions.id`                           |
| `requested_by`            | UUID        | FK → `users.id`                                  |
| `approved_by`             | UUID        | Nullable FK → `users.id`                         |
| `reason_code`             | VARCHAR(80) | Reason                                           |
| `status`                  | ENUM        | `REQUESTED`, `APPROVED`, `REJECTED`, `COMPLETED` |
| `created_at`              | TIMESTAMPTZ | Creation time                                    |
| `completed_at`            | TIMESTAMPTZ | Nullable                                         |

Define uniqueness rules so that the same original transaction cannot be reversed more than the permitted amount. For partial reversals, track the total amount reversed and ensure it never exceeds the original posted amount.

## 12.4 `transaction_approvals`

Use this when a transaction requires a second authorized person to approve it.

| Field            | Type        | Purpose                                      |
| ---------------- | ----------- | -------------------------------------------- |
| `id`             | UUID        | Primary key                                  |
| `transaction_id` | UUID        | FK → `transactions.id`                       |
| `requested_by`   | UUID        | FK → `users.id`                              |
| `approved_by`    | UUID        | Nullable FK → `users.id`                     |
| `status`         | ENUM        | `PENDING`, `APPROVED`, `REJECTED`, `EXPIRED` |
| `reason`         | TEXT        | Nullable                                     |
| `created_at`     | TIMESTAMPTZ | Creation time                                |
| `decided_at`     | TIMESTAMPTZ | Nullable                                     |

The approver must not be the requester when the workflow requires separation of duties.

# 13. Relationship map by module

Use this section as a guide when creating your Prisma schema and deciding which foreign keys and constraints belong in the database.

## Identity and access management

- `users` 1 — 0..1 `customer_profiles`
- `users` 1 — many `sessions`
- `sessions` 1 — many `refresh_tokens`
- `users` many — many `roles` through `user_roles`
- `users` 1 — many `audit_logs`
- `users` 1 — many `notifications`

## Customer verification and accounts

- `customer_profiles` 1 — many `kyc_cases`
- `kyc_cases` 1 — many `kyc_documents`
- `users` 1 — many reviewed KYC cases, using `reviewed_by`
- `customer_profiles` 1 — many `account_holders`
- `bank_accounts` 1 — many `account_holders`
- `bank_accounts` 1 — 0..1 `account_balance_projections`
- `bank_accounts` 1 — many `account_holds`

## Transactions and accounting

- `users` 1 — many initiated transactions
- `bank_accounts` 1 — many source transactions
- `bank_accounts` 1 — many destination transactions
- `transactions` 1 — many `journal_entries`
- `journal_entries` 1 — many `ledger_postings`
- `ledger_accounts` 1 — many `ledger_postings`
- `transactions` 1 — many associated `account_holds`
- `transactions` 1 — many `fraud_alerts`
- `transactions` 1 — many reversal records through the original/reversal references

## Scheduled transfers and operations

- `customer_profiles` 1 — many `beneficiaries`
- `customer_profiles` 1 — many `scheduled_transfers`
- `scheduled_transfers` 1 — many `transfer_attempts`
- `transactions` 1 — many `transfer_attempts`, where applicable
- `fraud_alerts` 1 — many `review_cases`
- `users` 1 — many assigned review cases
- `users` 1 — many idempotency records
- `users` 1 — many reconciliation runs, where a run has a human initiator

Use `ON DELETE RESTRICT` for financial records and their essential relationships. Deleting a user should not cascade into deleting transactions, journals, or audit records. Prefer deactivation and retention policies over destructive deletion.

# 14. Implementation requirements beyond the database

## Validation

Validate incoming requests before calling business services.

- UUID format and existence.
- Email and phone formats.
- Positive monetary amounts.
- Supported currency codes.
- Allowed enum values.
- String lengths.
- Date ranges.
- Pagination bounds.
- Request body size.
- Cross-field requirements, such as exactly one supported beneficiary reference.

Validation at the API layer improves error messages; database constraints remain necessary for integrity.

## Authorization

Every protected endpoint must check:

1. Is the user authenticated?
2. Is the user's account active?
3. Does the user have the required role or permission?
4. Does the user own or have authorized access to this particular resource?
5. Is the requested action permitted in the resource's current state?
6. Does the action require additional authentication or approval?

Never assume that an account ID, transaction ID, or KYC case ID supplied by the client is authorized merely because it exists.

## Logging and monitoring

Implement:

- Structured request logs.
- Request correlation IDs.
- Error logs with sanitized context.
- Authentication and authorization failure metrics.
- Transfer success and failure metrics.
- Database latency monitoring.
- Background-job failure monitoring.
- Reconciliation alerts.
- Alerts for repeated idempotency conflicts and unusual transaction patterns.

Do not log passwords, PINs, access tokens, full identity-document data, or other secrets.

## Database migration and seed data

Your initial database setup should create:

- Enumerated types or equivalent constrained status fields.
- All core tables and foreign keys.
- Unique indexes and check constraints.
- Indexes for account ownership, transaction history, ledger lookups, and pending jobs.
- Initial role records.
- System ledger accounts for the supported simulated currency.
- Default transaction limits and fee rules.

Seed data must be reproducible and must never contain production credentials or real customer information.

# 15. Testing specification

Testing should focus on business rules and failure cases, not merely whether endpoints return `200 OK`.

| Test area        | Required scenario                                       | Expected result                              |
| ---------------- | ------------------------------------------------------- | -------------------------------------------- |
| Authentication   | Login with an invalid password                          | Rejected without revealing sensitive details |
| Authorization    | Customer accesses another customer's account            | Denied                                       |
| Account opening  | Duplicate account number generated                      | Database rejects the duplicate               |
| Deposits         | Same deposit confirmed twice                            | One financial posting only                   |
| Withdrawals      | Withdrawal exceeds available funds                      | Rejected without ledger changes              |
| Transfers        | Two simultaneous transfers compete for the same balance | No overspending                              |
| Transfers        | Debit or credit posting fails                           | Entire financial transaction rolls back      |
| Idempotency      | Same key and same payload are retried                   | Existing result returned                     |
| Idempotency      | Same key with different payload                         | Conflict rejected                            |
| Accounting       | A posted journal has unequal debits and credits         | Posting prohibited                           |
| Reversals        | Same transaction is reversed twice                      | Duplicate reversal prevented                 |
| Scheduled jobs   | Worker processes a job more than once                   | One logical transfer only                    |
| KYC              | Customer attempts to approve own verification           | Denied                                       |
| Staff operations | Unauthorized user freezes an account                    | Denied                                       |
| Reconciliation   | Balance projection differs from ledger                  | Discrepancy reported                         |
| Privacy          | Logs are inspected after failed authentication          | No credentials or secrets exposed            |

Run concurrency tests against a real PostgreSQL test database. In-memory mocks cannot reliably reproduce database locking and isolation behavior.

## Suggested acceptance criteria

The project is ready for a portfolio release when:

- Every implemented endpoint has documented input and output schemas.
- Every protected endpoint has authorization tests.
- Database migrations can create a fresh working database.
- The main financial operations use atomic transactions.
- Posted ledger entries are immutable through normal application operations.
- Duplicate financial requests cannot create duplicate postings.
- Balance projections can be reconciled against the ledger.
- Error responses are consistent and sanitized.
- API documentation explains authentication and idempotency.
- A new developer can run the application and its tests from the README instructions.

# 16. Final deliverables

When you finish, your repository should contain these artifacts:

Database schema

Prisma models, relations, constraints, and migrations.

API implementation

Express routes, controllers, services, repositories, and middleware.

UML and ERD diagrams

Use-case, entity relationship, class, and sequence diagrams.

API documentation

OpenAPI specification with request/response schemas and error codes.

Automated tests

Unit, integration, authorization, concurrency, and financial integrity tests.

Seed and test data

Reproducible roles, system accounts, and synthetic customers.

Operational documentation

Environment setup, migration commands, logging, and troubleshooting.

Security documentation

Threat model, access policies, token handling, and audit requirements.

## 17. Recommended implementation order

Do not implement all 20-plus entities and every endpoint at once. Build a working foundation in this order:

1. Authentication, roles, and customer profiles.
2. KYC cases and bank account opening.
3. Ledger accounts, journals, and postings.
4. Balance projections and reconciliation.
5. Deposits and withdrawals.
6. Internal transfers and idempotency.
7. Statements and transaction history.
8. Beneficiaries and scheduled transfers.
9. Notifications and background workers.
10. Staff workflows, fraud reviews, and administrative reporting.

Your first major milestone should be the ledger and internal transfer engine. Once you can demonstrate that two customers can transfer simulated funds safely, that concurrent requests cannot overspend balances, and that every posted journal balances, you will have established the most technically demanding foundation of the project.

One final distinction: this specification describes a serious educational banking simulator. A real banking deployment would additionally require a much broader security assessment, operational resilience, regulatory compliance, financial controls, and independent review before handling actual customer funds.