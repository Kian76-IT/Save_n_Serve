# Save n Serve 🍲♻️

Save n Serve is a robust, production-ready mobile application engineered to bridge the gap between food surplus and food scarcity. By connecting food donors (**Givers**) with food seekers (**Beneficiaries**), the platform optimizes food distribution, actively supporting **UN Sustainable Development Goals (SDGs) 3 (Good Health and Well-being)** and **12 (Responsible Consumption and Production)**.

Built on a decoupled **Client-Server Architecture**, the ecosystem features a fluid Flutter frontend powered by a centralized state-management layer, an isolated Node.js/Express.js backend engine enforcing business rules, and a scalable Supabase database management layer.

---

## 🏗️ Architecture & System Design Overview

Unlike standard monolith apps, Save n Serve implements a strict **Layered Modular Component Design** to decouple core services and maximize security:

1. **Client Layer (Frontend):** Cross-platform mobile clients engineered in **Flutter** using the **Provider** state pattern. It securely captures precise user geolocations via native hardware streams.
2. **API Gatekeeper & Router Layer:** A specialized **Express.js Router** that acts as the single entry point for all mobile traffic. It handles request verification, query boundary guards, and marshals JSON payloads.
3. **Modular Backend Controllers:** Logics are strictly sandboxed into dedicated controllers:
   * `AuthController`: Manages token verification, secure onboarding, and strict role assignments.
   * `ClaimController`: Runs row-level locks on stock counters to strictly enforce **First-Come, First-Served (FCFS)** claim transactions, preventing race conditions.
   * `NotificationController`: Operates via a privileged administrative wrapper (`supabaseAdmin` Service Role) to inject instant transactional event updates.
4. **Data Management Layer:** Powered by **Supabase Cloud Service (PostgreSQL Engine)** handling real-time relational tables (`users`, `food_items`, `claims`, `notifications`) and streaming live event updates back to clients instantly.

---

## ✨ System Features

### 🔐 Core Security & Membership
* **Role-Based Routing:** Completely tailored application environments depending on the user group (**Giver** vs. **Beneficiary**).
* **State-Driven Authentication:** Secure session lifecycles managed seamlessly between frontend state managers and API tokens.

### 📍 Beneficiary Capabilities
* **Geolocated Food Discovery:** Intelligently fetches and sorts active food items closest to the user's current GPS coordinate.
* **Instant FCFS Claims:** Lock-protected transactional workflow that guarantees clear, double-claim proof product reservations.
* **Personal Watchlist:** Reactive item-tracking to bookmark selected donation logs.

### 📢 Giver Capabilities
* **Inventory & Post Management:** Fast multi-part asset posting to publish and manage active donation items with precise stock volume control.
* **Real-time Alert Engine:** Background real-time notification listener that triggers immediate visual alerts on the donor's terminal the second a food item is successfully claimed.

---

## 🛠️ Technical Stack

| Layer | Technology | Key Responsibility / Implementation |
| :--- | :--- | :--- |
| **Frontend Framework** | `Flutter (Dart)` | High-performance reactive native rendering, Material Design UI. |
| **State Management** | `Provider (ChangeNotifier)` | State decoupling, asynchronous UI dispatching, automated list triggers. |
| **Backend Engine** | `Node.js` + `Express.js` | Middleware chaining, isolated business routing, operational controllers. |
| **Cloud Database & Storage** | `Supabase (PostgreSQL)` | Distributed data retention, row locking on mutate, database-level storage. |
| **Real-time Protocol** | `Supabase Realtime Stream` | Persistent duplex connection for instant notification broadcasting. |
| **Hardware Integration** | `Geolocator API` | Native hardware GPS coordinate capturing & geographical sorting. |

---

## 📁 Repository Structure (Monorepo Layout)

```text
SAVE_N_SERVE/
├── android/                  # Native Android configuration
├── ios/                      # Native iOS configuration
├── backend/                  # Isolated API Server Environment
│   ├── src/
│   │   ├── controllers/      # Business logic (AuthController, ClaimController, etc.)
│   │   ├── middleware/       # Token checks & Request validation
│   │   └── server.js         # Express main application launcher
│   └── package.json
├── lib/                      # Flutter Application Core Source
│   ├── components/           # Extracted reusable UI widgets
│   ├── constants/            # Global theme styles & application configurations
│   ├── controllers/          # Client-side API dispatchers (ChangeNotifiers)
│   ├── models/               # Strongly-typed data schemas
│   ├── pages/                # App Views (home_page.dart, splash_screen.dart)
│   ├── services/             # Low-level network engines & API connectors
│   └── main.dart             # Application initialization root
└── pubspec.yaml              # Flutter Package Dependencies
