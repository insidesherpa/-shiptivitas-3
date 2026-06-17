# Shiptivitas Analytics: Complete Change & Implementation Logs

This document contains the complete documentation of every modification made during the development of the Shiptivitas feature release analysis. It chronicles the transition from raw database queries to the final dashboard design, highlighting the rationale behind each iteration and how the deliverables map to the project's acceptance criteria.

---

## 1. Traceability Matrix: Acceptance Criteria vs. Deliverables

| # | Acceptance Criterion (README.md) | Deliverable / Implementation | Location | Rationale & Alignment |
| :-: | :--- | :--- | :--- | :--- |
| **1** | Graph created mapping out the daily average users before and after the feature change. | Interactive Line Chart showing Daily Active Users (DAU) over time with a vertical indicator marker. | analytics_dashboard.html | Visually graphs the DAU trend lines and details the shift in average user count before vs. after June 2, 2018. |
| **2** | Graph of the number of status changes by card. | Card Status Changes Distribution Bar Chart and Flow Diagram. | analytics_dashboard.html | Classifies card updates into active status change frequencies and maps out task velocity through backlog, in-progress, and complete states. |
| **3** | Upload the SQL queries that can generate this information. | Production SQL queries structured and commented. | answer.sql | Includes data extraction logic for DAU cohorts, card status changes, distribution buckets, and state transition flow rates. |
| **4** | Three actionable ideas formatted with: Hypothesis, Expected Impact, and Feature Explanation. | Product growth section with three structured ideas. | analytics_dashboard.html | Details product features (Notifications, Mentions, Gamification) tailored specifically to the user behaviors found in the dataset. |

---

## 2. Chronological Log of Modifications

### Phase 1: Database Schema Exploration & Database Audit
* **Change:** Inspected shiptivity.db using sqlite schema commands to identify tables (user, login_history, card, card_change_history).
* **Why:** To understand the relations, key constraints, and timestamp formats (Unix epoch) before crafting queries.
* **Alignment:** Allowed us to identify the release date boundary (2018-06-02) and transition histories.

### Phase 2: SQL Query Implementation (answer.sql)
* **Change:** Wrote multi-part queries in answer.sql.
  * **Part 1 (Daily Active Users)**: Query 1A extracts daily active users classified by period. Query 1B computes the exact daily average before the release (3.62) and after the release (11.79).
  * **Part 2 (Status Changes by Card)**: Query 2A lists status changes per card sorted desc. Query 2B computes the distribution of changes. Query 2C & 2D perform transition flows and daily trends over time.
* **Why:** To capture the exact dataset needed to analyze user engagement shifts and card workflow habits.
* **Alignment:** Fully satisfies Acceptance Criterion 3.

### Phase 3: Dashboard Layout Iterations (analytics_dashboard.html)
To satisfy Acceptance Criteria 1 and 2, we created an interactive visual dashboard. The design evolved through three distinct iterations based on feedback:

#### Iteration A: Dark-Themed Glassmorphism
* **Change:** Built a dark dashboard utilizing backdrop blurs, glow effects, and modern Outfit typography.
* **Why:** To make the analytics immediately readable and visually engaging.

#### Iteration B: Flat Color Aesthetic (Removal of Complex Gradients)
* **Change:** Removed multicolored gradients (e.g. Indigo to Green header text and radial backgrounds) in favor of solid background panels (#0f172a, #1e293b) and flat colors.
* **Why:** The complex multicolor transitions detracted from the professional clarity of the data. Emphasizing solid colors, sharp text, and flat design styles aligns with clean SaaS product design.

#### Iteration C: White Background Sidebar Layout
* **Change:** Restructured the app grid to feature a left sidebar navigation panel and shifted the color scheme to a solid white background canvas (#f8fafc workspace, #ffffff card backdrops).
* **Why:** Sidebars organize dashboard content logically and feel more intuitive than simple stacked columns. The white background is standard for analytical interfaces, minimizing visual clutter and maximizing readability.

#### Iteration D: Sidebar Menu Clean-Up
* **Change:** Removed empty tabs (Engagement, Task Flows, Growth Ideas) in the sidebar, retaining only the active Overview tab.
* **Why:** To eliminate dead links and ensure the dashboard is clean, simple, and production-ready.
