import sqlite3
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime
import os
import shutil

plt.style.use('seaborn-v0_8-whitegrid' if 'seaborn-v0_8-whitegrid' in plt.style.available else 'default')
plt.rcParams['font.sans-serif'] = 'Helvetica, Arial, sans-serif'
plt.rcParams['axes.edgecolor'] = '#cbd5e1'
plt.rcParams['axes.linewidth'] = 0.8

conn = sqlite3.connect('shiptivity.db')

# ==========================================================
# CHART 1: Daily Active Users Before and After Feature Change
# ==========================================================
df_dau = pd.read_sql_query('''
    SELECT 
        DATE(login_timestamp, 'unixepoch') AS login_date,
        COUNT(DISTINCT user_id) AS dau
    FROM login_history
    GROUP BY login_date
    ORDER BY login_date
''', conn)

df_dau['date'] = pd.to_datetime(df_dau['login_date'])
df_dau['rolling_7d'] = df_dau['dau'].rolling(window=7, min_periods=1).mean()

pre_mask = df_dau['date'] < '2018-06-02'
post_mask = df_dau['date'] >= '2018-06-02'

pre_mean = df_dau.loc[pre_mask, 'dau'].mean()
post_mean = df_dau.loc[post_mask, 'dau'].mean()

fig = plt.figure(figsize=(14, 9), dpi=300)
gs = fig.add_gridspec(2, 2, height_ratios=[1.7, 1], hspace=0.35, wspace=0.25)

# Main Timeline Plot
ax_main = fig.add_subplot(gs[0, :])
ax_main.plot(df_dau['date'], df_dau['dau'], color='#94a3b8', alpha=0.45, linewidth=1, label='Daily DAU')
ax_main.plot(df_dau['date'], df_dau['rolling_7d'], color='#2563eb', linewidth=2.5, label='7-Day Moving Average')

# Before / After spans and horizontal average lines
ax_main.axvspan(df_dau['date'].min(), pd.to_datetime('2018-06-02'), color='#f8fafc', alpha=0.9, label='Pre-Feature Window')
ax_main.axvspan(pd.to_datetime('2018-06-02'), df_dau['date'].max(), color='#eff6ff', alpha=0.7, label='Post-Feature Window')

ax_main.plot([df_dau['date'].min(), pd.to_datetime('2018-06-01')], [pre_mean, pre_mean], 
             color='#dc2626', linestyle='--', linewidth=2, label=f'Pre-Release Avg: {pre_mean:.2f} DAU')
ax_main.plot([pd.to_datetime('2018-06-02'), df_dau['date'].max()], [post_mean, post_mean], 
             color='#16a34a', linestyle='--', linewidth=2, label=f'Post-Release Avg: {post_mean:.2f} DAU')

# Vertical line for launch date
ax_main.axvline(pd.to_datetime('2018-06-02'), color='#d97706', linestyle='-', linewidth=2.2, alpha=0.9)
ax_main.annotate('Kanban Board Released\n(June 2, 2018)', 
                 xy=(mdates.date2num(pd.to_datetime('2018-06-02')), 18.5),
                 xytext=(mdates.date2num(pd.to_datetime('2018-06-15')), 21.5),
                 arrowprops=dict(facecolor='#d97706', shrink=0.08, width=1.5, headwidth=7),
                 bbox=dict(boxstyle='round,pad=0.5', facecolor='#fef3c7', edgecolor='#d97706', linewidth=1.2),
                 fontsize=9.5, fontweight='bold', color='#92400e')

ax_main.set_title('Daily Active Users (DAU) Before and After Kanban Board Release', fontsize=14, fontweight='bold', pad=12, color='#0f172a')
ax_main.set_ylabel('Daily Active Users', fontsize=11, fontweight='semibold', color='#334155')
ax_main.xaxis.set_major_locator(mdates.MonthLocator(interval=1))
ax_main.xaxis.set_major_formatter(mdates.DateFormatter('%b %Y'))
ax_main.set_xlim(df_dau['date'].min(), df_dau['date'].max())
ax_main.set_ylim(0, 25)
ax_main.legend(loc='upper left', frameon=True, facecolor='white', framealpha=0.95, fontsize=9)
ax_main.tick_params(colors='#475569')

# Subplot 1: Bar chart comparing Average DAU
ax_bar = fig.add_subplot(gs[1, 0])
bars = ax_bar.bar(['Pre-Release\n(Feb 03 - Jun 01)', 'Post-Release\n(Jun 02 - Feb 01)'], 
                  [pre_mean, post_mean], 
                  color=['#f87171', '#4ade80'], 
                  edgecolor=['#dc2626', '#16a34a'], 
                  width=0.45, linewidth=1.5)
for bar in bars:
    yval = bar.get_height()
    ax_bar.text(bar.get_x() + bar.get_width()/2.0, yval + 0.35, f'{yval:.2f} users/day', ha='center', va='bottom', fontsize=10.5, fontweight='bold', color='#0f172a')

# Add growth tag
ax_bar.annotate('+224.8% Increase\n(3.25x Growth)', 
                xy=(1, post_mean), xytext=(0.5, 8.5),
                arrowprops=dict(arrowstyle="->", connectionstyle="arc3,rad=.2", color='#059669', lw=1.8),
                bbox=dict(boxstyle='round,pad=0.4', facecolor='#dcfce7', edgecolor='#16a34a', lw=1),
                fontsize=9.5, fontweight='bold', color='#166534', ha='center')

ax_bar.set_title('Average Daily Active Users (DAU)', fontsize=12, fontweight='bold', color='#0f172a')
ax_bar.set_ylabel('Users / Day', fontsize=10, fontweight='semibold', color='#334155')
ax_bar.set_ylim(0, 15)

# Subplot 2: Total Distinct Users Engaged
distinct_pre = pd.read_sql_query("SELECT COUNT(DISTINCT user_id) FROM login_history WHERE date(login_timestamp, 'unixepoch') < '2018-06-02'", conn).iloc[0,0]
distinct_post = pd.read_sql_query("SELECT COUNT(DISTINCT user_id) FROM login_history WHERE date(login_timestamp, 'unixepoch') >= '2018-06-02'", conn).iloc[0,0]

ax_pie = fig.add_subplot(gs[1, 1])
bars2 = ax_pie.bar(['Pre-Release Period', 'Post-Release Period'], 
                   [distinct_pre, distinct_post], 
                   color=['#93c5fd', '#3b82f6'], 
                   edgecolor=['#1d4ed8', '#1e40af'], 
                   width=0.45, linewidth=1.5)
for bar in bars2:
    yval = bar.get_height()
    ax_pie.text(bar.get_x() + bar.get_width()/2.0, yval + 2, f'{int(yval)} / 100 users ({int(yval)}%)', ha='center', va='bottom', fontsize=10.5, fontweight='bold', color='#0f172a')

ax_pie.set_title('Total Reach: Unique Users Active in Period', fontsize=12, fontweight='bold', color='#0f172a')
ax_pie.set_ylabel('Active Users (out of 100)', fontsize=10, fontweight='semibold', color='#334155')
ax_pie.set_ylim(0, 115)

chart1_path = 'daily_active_users_before_after.png'
plt.savefig(chart1_path, dpi=300, bbox_inches='tight')
plt.close()
print('Chart 1 updated successfully.')

# ==========================================================
# CHART 2: Number of Status Changes by Card & Lifecycle Analysis
# ==========================================================
df_cards = pd.read_sql_query('''
    SELECT 
        c.id AS card_id,
        c.name AS card_name,
        c.status AS current_status,
        c.priority AS current_priority,
        SUM(CASE WHEN ch.oldStatus IS NOT NULL AND ch.oldStatus != '' AND ch.oldStatus != ch.newStatus THEN 1 ELSE 0 END) AS status_changes
    FROM card c
    LEFT JOIN card_change_history ch ON c.id = ch.cardID
    GROUP BY c.id
    ORDER BY status_changes DESC, c.id ASC
''', conn)

fig2 = plt.figure(figsize=(15, 10.5), dpi=300)
gs2 = fig2.add_gridspec(2, 2, hspace=0.35, wspace=0.3)

# Panel 1: Distribution of status changes per card
ax_dist = fig2.add_subplot(gs2[0, 0])
counts = df_cards['status_changes'].value_counts().sort_index()
colors = ['#94a3b8', '#38bdf8', '#22c55e', '#eab308', '#f97316', '#ef4444']
bars_dist = ax_dist.bar(counts.index, counts.values, color=colors[:len(counts)], edgecolor='#334155', linewidth=1.2, width=0.6)

for bar in bars_dist:
    yval = bar.get_height()
    pct = (yval / len(df_cards)) * 100
    ax_dist.text(bar.get_x() + bar.get_width()/2.0, yval + 1.8, f'{int(yval)}\n({pct:.1f}%)', 
                 ha='center', va='bottom', fontsize=9.5, fontweight='bold', color='#1e293b')

ax_dist.set_title('Card Distribution by Number of Status Changes', fontsize=12, fontweight='bold', color='#0f172a')
ax_dist.set_xlabel('Number of Status Changes', fontsize=10, fontweight='semibold', color='#334155')
ax_dist.set_ylabel('Number of Cards (Total = 200)', fontsize=10, fontweight='semibold', color='#334155')
ax_dist.set_ylim(0, 118)
ax_dist.set_xticks(counts.index)

# Panel 2: Transition Types Breakdown
ax_trans = fig2.add_subplot(gs2[0, 1])
df_trans = pd.read_sql_query('''
    SELECT 
        oldStatus || ' -> ' || newStatus AS transition,
        COUNT(*) as count
    FROM card_change_history
    WHERE oldStatus IS NOT NULL AND oldStatus != ''
    GROUP BY oldStatus, newStatus
    ORDER BY count ASC
''', conn)

bar_colors = ['#ef4444', '#f59e0b', '#10b981', '#3b82f6']
bars_trans = ax_trans.barh(df_trans['transition'], df_trans['count'], color=bar_colors, edgecolor='#334155', linewidth=1.1, height=0.55)
for bar in bars_trans:
    xval = bar.get_width()
    pct = (xval / df_trans['count'].sum()) * 100
    ax_trans.text(xval + 3, bar.get_y() + bar.get_height()/2.0, f'{int(xval)} ({pct:.1f}%)', 
                  ha='left', va='center', fontsize=9.5, fontweight='bold', color='#1e293b')

ax_trans.set_title('Status Transitions Breakdown (286 Total Moves)', fontsize=12, fontweight='bold', color='#0f172a')
ax_trans.set_xlabel('Transition Count', fontsize=10, fontweight='semibold', color='#334155')
ax_trans.set_xlim(0, 205)

# Panel 3: Top 12 Cards with Highest Activity (Churn/Thrash)
ax_top = fig2.add_subplot(gs2[1, 0])
top_cards = df_cards.head(12).sort_values('status_changes', ascending=True)
top_labels = [f"#{row.card_id} {row.card_name[:17]}" for _, row in top_cards.iterrows()]
bars_top = ax_top.barh(top_labels, top_cards['status_changes'], color='#6366f1', edgecolor='#3730a3', linewidth=1.1, height=0.6)

for bar in bars_top:
    xval = bar.get_width()
    ax_top.text(xval + 0.1, bar.get_y() + bar.get_height()/2.0, f'{int(xval)} changes', 
                ha='left', va='center', fontsize=9, fontweight='semibold', color='#1e293b')

ax_top.set_title('Top 12 Most Active Cards (Highest Changes)', fontsize=12, fontweight='bold', color='#0f172a')
ax_top.set_xlabel('Number of Status Changes', fontsize=10, fontweight='semibold', color='#334155')
ax_top.set_xlim(0, 6)

# Panel 4: Current Status Distribution (Kanban Board State)
ax_curr = fig2.add_subplot(gs2[1, 1])
status_counts = df_cards['current_status'].value_counts()
labels = [f"{s.title()}\n({status_counts[s]} cards)" for s in status_counts.index]
pie_colors = ['#22c55e', '#3b82f6', '#94a3b8']
wedges, texts, autotexts = ax_curr.pie(status_counts.values, 
                                       labels=labels, 
                                       autopct='%1.1f%%',
                                       pctdistance=0.75,
                                       startangle=140, 
                                       colors=pie_colors,
                                       textprops=dict(fontsize=9.5, color='#1e293b'),
                                       wedgeprops=dict(width=0.45, edgecolor='white', linewidth=2))
for autotext in autotexts:
    autotext.set_color('white')
    autotext.set_fontweight('bold')
    autotext.set_fontsize(10.5)

ax_curr.set_title('Current Kanban Board Distribution (200 Cards)', fontsize=12, fontweight='bold', color='#0f172a')

chart2_path = 'card_status_changes.png'
plt.savefig(chart2_path, dpi=300, bbox_inches='tight')
plt.close()
print('Chart 2 updated successfully.')

conn.close()

# Copy to artifacts directory
artifact_dir = '/Users/keerthiga/.gemini/antigravity-ide/brain/563920d5-c311-4df8-98c6-a0ea5900a3d3'
os.makedirs(artifact_dir, exist_ok=True)
shutil.copy('daily_active_users_before_after.png', os.path.join(artifact_dir, 'daily_active_users_before_after.png'))
shutil.copy('card_status_changes.png', os.path.join(artifact_dir, 'card_status_changes.png'))
print('Charts copied to artifact directory.')
