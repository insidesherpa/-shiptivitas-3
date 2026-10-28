# Shiptivitas Product Strategy: Three Actionable Feature Proposals

## Context & Analytics Summary
Following the release of the Kanban Board on June 2, 2018, daily active users increased by +224.8% (from 3.63 to 11.79 users/day). However, two clear friction points emerged from the usage data:
1. **Low Daily Engagement vs. Total User Base:** 99 unique users logged in post-release, but average DAU is only ~12 (12% daily retention). Users lack personal accountability and daily triggers.
2. **Backlog Stagnation & In-Progress Bottleneck:** 38 out of 200 cards (19%) never left the backlog, while 58 cards (29%) are currently stuck in `in-progress` with 11 cards pushed backward due to blockage.

Below are three data-informed product proposals designed to address these findings.

---

## Feature 1: Card Ownership, Due Dates & Daily Morning Digest

### 1. Hypothesis
If we allow team members to assign cards to specific users and set explicit due dates, paired with an automated 9:00 AM daily digest email ("Your Focus Today: 2 tasks due"), users will have a personal reason to open Shiptivitas every morning, establishing a daily habit and preventing unassigned cards from languishing in the backlog.

### 2. Expected Impact
* **DAU Growth:** Increase average DAU from **11.8 to 18–22 users/day** (+50% to +85% growth) by establishing a morning pull mechanism.
* **Backlog Velocity:** Reduce 0-change stagnant backlog cards by **60%**, as every created card requires an assigned owner.
* **Turnaround Time:** Decrease average card completion time from 14 days to 6 days.

### 3. What the Feature Is
* **Assignee & Due Date Fields:** Extends the `card` table with `assignee_id` (foreign key to `user.id`) and `due_date`.
* **Personalized View Filter:** A single-click "My Cards" toggle on the Kanban board to filter cards assigned to the logged-in user.
* **Visual Urgency Indicators:** Cards within 24 hours of their deadline display an amber clock tag; overdue cards display a red badge.
* **Morning Digest Notification:** An automated summary delivered to Slack or Email at 9:00 AM listing today's assigned tasks and newly assigned items.

### 4. Wireframe & User Flow

```
+-----------------------------------------------------------------------------------+
|  [Shiptivitas]    [+ New Card]     Filter: [ All | (•) Assigned to Me ]   [Standup] |
+-----------------------------------------------------------------------------------+
|  BACKLOG (44)              |  IN-PROGRESS (58)          |  COMPLETE (98)          |
|  ------------------------- |  ------------------------- |  ---------------------- |
|  +-----------------------+ |  +-----------------------+ |  +--------------------+ |
|  | #102 Payment Gateway  | |  | #187 Kutch-Mueller    | |  | #93 Stripe Sync    | |
|  | Priority: High (1)    | |  | Priority: High (2)    | |  | Priority: Med      | |
|  | Due: Tomorrow [Oct 29]| |  | Due: TODAY ⚠️ [Oct 28] | |  | Finished: Yesterday| |
|  | Owner: [Avatar: KD]   | |  | Owner: [Avatar: Alice]| |  | Owner: [Avatar: Bob]| |
|  +-----------------------+ |  +-----------------------+ |  +--------------------+ |
+-----------------------------------------------------------------------------------+
```

```
[User Receives 9 AM Digest Email / Slack]
                 │
                 ▼
        [Clicks Task Link]
                 │
                 ▼
   [Opens Shiptivitas Board (DAU +1)]
                 │
                 ▼
      [Views Filtered "My Cards"]
                 │
                 ▼
[Moves Card to Complete or Updates Status]
```

---

## Feature 2: WIP (Work-in-Progress) Limits & Subtask Checklists

### 1. Hypothesis
The bottleneck in `in-progress` (58 cards, 29% of total) and backward transitions (`in-progress ➔ backlog`, 11 instances) occur because tasks are too broad and users take on too many items at once. By introducing column WIP limits and in-card subtask checklists with visual progress meters, users will break large tasks into daily achievable increments and finish existing work before starting new tasks.

### 2. Expected Impact
* **Bottleneck Relief:** Reduce cards stuck in `in-progress` from 58 cards down to <25 cards.
* **Eliminate Regressions:** Reduce backward transitions (`in-progress ➔ backlog`) by **75%**.
* **Daily Engagement:** Encourages multiple micro-interactions per day as users check off subtasks, boosting daily session count and active minutes per user.

### 3. What the Feature Is
* **Configurable WIP Column Limits:** Teams set a maximum threshold for the `in-progress` column (e.g., max 5 cards per person or 15 for the board). If exceeded, the column header turns soft amber with a friendly guidance message.
* **Subtask Checklist with Progress Ring:** Users can add checklist items inside card modals (`[x] Draft API schema`, `[ ] Write unit tests`). The card face on the Kanban board shows a progress pill (e.g., `3/4 Subtasks` with a 75% green mini-progress bar).

### 4. Wireframe & User Flow

```
+-----------------------------------------------------------------------+
|  CARD MODAL: #187 Kutch-Mueller Integration                           |
|  Status: [ In-Progress v ]       Priority: [ High (1) v ]             |
|  -------------------------------------------------------------------- |
|  Checklist (2 of 4 completed - 50%)                                   |
|  [=======>          ]                                                 |
|  [x] Connect webhook endpoint                                         |
|  [x] Validate token signature                                         |
|  [ ] Implement retry logic on 500 status                              |
|  [ ] Deploy to staging and test                                       |
|                                                                       |
|  + [Add subtask...]                           [Save & Update Status]  |
+-----------------------------------------------------------------------+
```

```
[User drags card to In-Progress]
                 │
                 ▼
       {WIP Limit Exceeded?}
        /                \
     (Yes)               (No)
      /                    \
[Soft Warning]       [Card enters In-Progress]
                            │
                            ▼
               [User checks subtask 1/3 (Daily login)]
                            │
                            ▼
               [User checks subtask 3/3]
                            │
                            ▼
                 [1-Click Move to Complete]
```

---

## Feature 3: Automated Stale Card Triage & "Daily Standup Mode"

### 1. Hypothesis
19% of cards (38 cards) have zero status changes because backlog grooming is tedious and lacks structure. Introducing an automated "Stale Card Aging Indicator" (cards untouched for >7 days visually fade) and a dedicated "1-Click Standup Presentation Mode" will give teams a frictionless 5-minute daily ritual to review blockers, triage dormant tasks, and celebrate completed work together.

### 2. Expected Impact
* **Daily Ritual DAU:** Drive weekday team-wide participation, elevating daily active users to **25–30 users/day** (+150% growth).
* **Backlog Hygiene:** 100% elimination of stale cards older than 14 days through structured standup triage.
* **Card Velocity:** Increase total completed cards per month by **35%**.

### 3. What the Feature Is
* **Card Aging Heat Indicators:** Cards that haven't recorded a status change in 7 days show a subtle faded tint and an aging badge (`⏳ 12d stale`).
* **Standup Presentation Mode:** A dedicated header button (`[ Start Standup ]`) that enters a clean full-screen view. It highlights:
  1. What was completed in the last 24 hours (Team Wins 🎉).
  2. Cards currently blocked or stale (Need Help 🚨).
  3. Highest priority items for today.

### 4. Wireframe & User Flow

```
+---------------------------------------------------------------------------------------+
|  DAILY STANDUP MODE (Press ESC to exit)                 Time Elapsed: 03:45 / 05:00   |
|  ------------------------------------------------------------------------------------ |
|  [1] YESTERDAY'S WINS (4 Cards)  | [2] BLOCKED & STALE (3 Cards) | [3] TODAY'S FOCUS  |
|  -------------------------------- | ----------------------------- | ------------------ |
|  * #93 Stripe Sync (Bob)         | * #187 Kutch-Mueller (Alice)  | * #102 Payment API |
|  * #71 User Profile V2 (Dave)    |   ⏳ 9 days in progress        |   Owner: Keerthiga |
|  * #5 Kunde Group (Sarah)        |   Status: Waiting on API keys |   Priority: P1     |
|  ------------------------------------------------------------------------------------ |
|  [ Mark as Resolved ]   [ Reassign ]   [ Move to Backlog ]       [ Next Card -> ]     |
+---------------------------------------------------------------------------------------+
```

```
[Team opens Standup Mode at 9:30 AM]
                 │
                 ▼
[Reviews Yesterday's Completed Cards]
                 │
                 ▼
[Triages Stale / Blocked In-Progress Cards]
                 │
                 ▼
    [Assigns Daily Focus Items]
                 │
                 ▼
[All team members logged in simultaneously (Peak DAU)]
```
