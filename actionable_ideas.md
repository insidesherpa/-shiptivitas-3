# Shiptivitas: Actionable Growth Ideas

This document presents three actionable feature recommendations aimed at improving the Daily Active Users (DAU) metric, designed in response to the user activity patterns analyzed in the database.

---

## 1. Smart Notification System & Daily Activity Digest

### A. Hypothesis
Users who actively interact with cards are highly engaged, but activity drops when teammates are offline. By sending automated, personalized daily digest emails and real-time push alerts of card movements, we can create habit loops that prompt users to log back into the app daily.

### B. Expected Impact
* **Engagement Lift:** +15-25% increase in Daily Active Users (DAU).
* **Retention:** Re-engages inactive users by notifying them when tasks they are watching receive status updates.

### C. What the Feature Is
An automated notification suite comprising:
1. **Morning Digest:** An email summarizing cards assigned to the user, upcoming due dates, and cards that moved to "In Progress" yesterday.
2. **Real-time Alerting:** Push notifications triggered instantly when a card is moved or assigned.

### D. Workflow Diagram
```
[ Card Status Changes ] ──> [ Notification Server ] ──> [ Email Digest / Alert ] 
                                                               │
[ Return Logins (DAU) ] <── [ User Clicks Notification Link ] <┘
```

---

## 2. In-Card Comments & @Mentions Collaboration

### A. Hypothesis
The database audit revealed 16 regression events where completed or in-progress cards had to be moved backward. This indicates communication gaps. Providing direct collaboration tools inside the card view will bring team discussions off external chat apps and onto Shiptivitas, increasing return visits.

### B. Expected Impact
* **Engagement Lift:** +20-30% increase in DAU.
* **Session Length:** Extends active session duration as discussion threads centralize details.

### C. What the Feature Is
A collaboration panel embedded inside the expanded card modal allowing:
1. **Threads:** Team members can write comments and attach files.
2. **Mentions:** Tagging team members using `@username` triggers instant email/push notifications.

### D. Interface Sketch (Wireframe Quality)
```
┌─────────────────────────────────────────────────────────────┐
│ CARD DETAIL: Refactor Database Schema (ID: 42)              │
├─────────────────────────────────────────────────────────────┤
│ Status: In-Progress                                         │
│                                                             │
│ 💬 Comments                                                 │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ @john I moved this back to In-Progress because we need  │ │
│ │ to verify the indexes first.                            │ │
│ │ ── Sarah (2 hours ago)                                  │ │
│ └─────────────────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Write a comment (Use @ to tag)...                       │ │
│ └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Progress Streaks & Team Velocity Leaderboards

### A. Hypothesis
With 51.5% of cards completing the full workflow journey, user motivation is heavily driven by progress completion. Implementing progress streaks (daily login streaks) and team velocity leaderboards will gamify task management, prompting users to check in daily to maintain their streaks.

### B. Expected Impact
* **Engagement Lift:** +10-20% increase in DAU.
* **Daily Consistency:** Reduces the standard deviation of daily logins, smoothing out weekly user drop-offs.

### C. What the Feature Is
A sidebar widget displaying:
1. **Login Streak:** Visual badges showing consecutive active days (e.g. "5-Day Streak 🔥").
2. **Weekly Velocity:** Bar chart widgets showcasing card completions compared to prior weeks.

### D. Interface Sketch (Wireframe Quality)
```
┌──────────────────────────────────────┐
│  🔥 My Activity Streak               │
│  [M] [T] [W] [T] [F] [S] [S]         │
│  [✓] [✓] [✓] [✓] [ ] [ ] [ ]         │
│  Active Streak: 4 Days               │
├──────────────────────────────────────┤
│  🏆 Weekly Team Leaderboard          │
│  1. Sarah   (12 cards) 🥇            │
│  2. John    (9 cards)                │
│  3. You     (7 cards)                │
└──────────────────────────────────────┘
```
