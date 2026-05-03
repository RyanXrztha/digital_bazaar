<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Performance Simulator – DigitalBazaar</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg-base:    #0f172a;
            --bg-card:    #111827;
            --bg-elevated:#1e293b;
            --border:     #1f2937;
            --border-mid: #334155;
            --accent-cyan:#22d3ee;
            --accent-blue:#3b82f6;
            --accent-glow:rgba(34,211,238,0.15);
            --text-primary:#e5e7eb;
            --text-muted:  #94a3b8;
            --text-dim:    #6b7280;
            --danger:      #ef4444;
            --success:     #22c55e;
            --warning:     #f59e0b;
            --purple:      #a855f7;
            --sidebar-w:   240px;
            --font-ui:     'Sora', sans-serif;
            --font-mono:   'JetBrains Mono', monospace;
        }

        body {
            font-family: var(--font-ui);
            background: var(--bg-base);
            color: var(--text-primary);
            display: flex;
            min-height: 100vh;
        }

        /* ========== SIDEBAR ========== */
        .sidebar {
            width: var(--sidebar-w);
            height: 100vh;
            background: #020617;
            border-right: 1px solid var(--border);
            position: fixed;
            top: 0; left: 0;
            display: flex;
            flex-direction: column;
            z-index: 100;
        }
        .logo { padding: 28px 20px 24px; border-bottom: 1px solid var(--border); }
        .logo h2 { font-size: 17px; font-weight: 700; color: var(--accent-blue); letter-spacing: -0.3px; }
        .logo span { color: var(--accent-cyan); }
        .sidebar-label {
            font-size: 10px; font-weight: 600; letter-spacing: 1.5px;
            text-transform: uppercase; color: var(--text-dim); padding: 20px 20px 8px;
        }
        .menu { list-style: none; padding: 0 10px; }
        .menu li {
            display: flex; align-items: center; gap: 10px;
            padding: 11px 14px; border-radius: 8px; cursor: pointer;
            color: var(--text-muted); font-size: 13.5px; font-weight: 500;
            transition: all .18s ease; margin-bottom: 2px;
        }
        .menu li:hover { background: var(--bg-elevated); color: var(--text-primary); }
        .menu li.active {
            background: linear-gradient(135deg, rgba(59,130,246,.18), rgba(34,211,238,.08));
            color: var(--accent-cyan);
            border: 1px solid rgba(34,211,238,.15);
        }
        .menu li .icon { font-size: 16px; width: 20px; text-align: center; }
        .sidebar-footer { margin-top: auto; padding: 16px 10px; border-top: 1px solid var(--border); }
        .logout-btn {
            display: flex; align-items: center; gap: 10px;
            width: 100%; padding: 10px 14px; border-radius: 8px;
            background: transparent; border: 1px solid var(--danger);
            color: var(--danger); font-family: var(--font-ui); font-size: 13px;
            font-weight: 500; cursor: pointer; transition: all .18s;
        }
        .logout-btn:hover { background: var(--danger); color: white; }

        /* ========== MAIN ========== */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .topbar {
            height: 60px; background: var(--bg-card); border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 28px; position: sticky; top: 0; z-index: 50;
        }
        .topbar-left { display: flex; align-items: center; gap: 14px; }
        .page-badge {
            background: linear-gradient(135deg, rgba(168,85,247,.12), rgba(59,130,246,.08));
            border: 1px solid rgba(168,85,247,.25);
            color: var(--purple); font-size: 11px; font-weight: 600;
            letter-spacing: .8px; text-transform: uppercase; padding: 4px 10px; border-radius: 20px;
        }
        .topbar h1 { font-size: 15px; font-weight: 600; color: var(--text-primary); }
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .avatar {
            width: 34px; height: 34px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-blue), var(--accent-cyan));
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 700; color: var(--bg-base); cursor: pointer;
        }
        .chip {
            display: inline-flex; align-items: center; gap: 4px;
            background: rgba(168,85,247,.12); border: 1px solid rgba(168,85,247,.2);
            border-radius: 20px; padding: 3px 10px; font-size: 11px;
            font-weight: 500; color: var(--purple);
        }

        /* ========== CONTENT ========== */
        .content { padding: 28px; }

        /* Config bar */
        .config-bar {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 20px 24px;
            margin-bottom: 24px;
            display: grid;
            grid-template-columns: repeat(4, 1fr) auto;
            gap: 16px;
            align-items: end;
        }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        label {
            font-size: 11px; font-weight: 600; text-transform: uppercase;
            letter-spacing: .7px; color: var(--text-dim);
        }
        select {
            background: var(--bg-elevated); border: 1px solid var(--border-mid);
            border-radius: 8px; color: var(--text-primary); font-family: var(--font-ui);
            font-size: 12.5px; padding: 9px 12px; outline: none;
            transition: border-color .15s; width: 100%; -webkit-appearance: none; appearance: none;
        }
        select:focus { border-color: var(--accent-cyan); }
        select option { background: var(--bg-card); color: var(--text-primary); }
        .btn-simulate {
            padding: 10px 22px; background: linear-gradient(135deg, var(--accent-blue), var(--accent-cyan));
            border: none; border-radius: 9px; color: var(--bg-base);
            font-family: var(--font-ui); font-size: 13px; font-weight: 700;
            cursor: pointer; white-space: nowrap; transition: opacity .15s, transform .1s;
            letter-spacing: .2px; align-self: flex-end;
        }
        .btn-simulate:hover { opacity: .9; transform: translateY(-1px); }

        /* Selected hardware banner */
        .hardware-banner {
            background: linear-gradient(135deg, rgba(34,211,238,.06), rgba(59,130,246,.04));
            border: 1px solid rgba(34,211,238,.15);
            border-radius: 12px;
            padding: 14px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }
        .hw-label { font-size: 11px; color: var(--text-dim); font-weight: 600; letter-spacing: .6px; text-transform: uppercase; }
        .hw-pill {
            display: inline-flex; align-items: center; gap: 6px;
            background: rgba(34,211,238,.08); border: 1px solid rgba(34,211,238,.18);
            border-radius: 8px; padding: 5px 12px;
            font-size: 12px; font-weight: 500; color: var(--accent-cyan);
        }
        .hw-pill .tag {
            background: rgba(34,211,238,.15); border-radius: 4px;
            padding: 1px 5px; font-size: 10px; font-weight: 600; color: var(--accent-cyan);
        }
        .hw-divider { width: 1px; height: 24px; background: var(--border-mid); }

        /* Cards */
        .card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 14px; overflow: hidden; }
        .card-header {
            padding: 16px 20px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
        }
        .card-header h3 {
            font-size: 13.5px; font-weight: 600; color: var(--text-primary);
            display: flex; align-items: center; gap: 8px;
        }
        .card-body { padding: 20px; }

        /* Tab strip */
        .tab-strip {
            display: flex; gap: 4px;
            background: var(--bg-elevated); padding: 4px; border-radius: 9px;
        }
        .tab {
            padding: 6px 14px; border-radius: 6px; cursor: pointer;
            font-size: 12px; font-weight: 500; color: var(--text-muted);
            transition: all .15s;
        }
        .tab.active {
            background: var(--bg-card); color: var(--accent-cyan);
            box-shadow: 0 0 0 1px rgba(34,211,238,.15);
        }

        /* Main grid */
        .sim-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .sim-grid-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }

        /* FPS Table */
        .fps-table { width: 100%; border-collapse: collapse; }
        .fps-table thead tr { border-bottom: 1px solid var(--border); }
        .fps-table th {
            padding: 8px 12px; text-align: left;
            font-size: 10.5px; font-weight: 600; text-transform: uppercase;
            letter-spacing: .7px; color: var(--text-dim);
        }
        .fps-table td {
            padding: 10px 12px; font-size: 12.5px;
            border-bottom: 1px solid rgba(31,41,55,.6);
        }
        .fps-table tr:last-child td { border: none; }
        .fps-table tr:hover td { background: rgba(30,41,59,.4); }
        .game-name { font-weight: 500; color: var(--text-primary); }
        .game-genre { font-size: 10.5px; color: var(--text-dim); margin-top: 1px; }
        .fps-val {
            font-family: var(--font-mono); font-weight: 600;
            font-size: 13px;
        }
        .fps-high  { color: var(--success); }
        .fps-mid   { color: var(--warning); }
        .fps-low   { color: var(--danger); }

        /* Bar in table */
        .fps-bar-cell { width: 120px; }
        .fps-mini-bar { height: 5px; background: var(--border); border-radius: 3px; overflow: hidden; margin-top: 3px; }
        .fps-mini-fill { height: 100%; border-radius: 3px; }
        .fill-green { background: linear-gradient(90deg, #16a34a, var(--success)); }
        .fill-yellow{ background: linear-gradient(90deg, #d97706, var(--warning)); }
        .fill-red   { background: linear-gradient(90deg, #b91c1c, var(--danger)); }

        /* Setting badges */
        .setting-badge {
            display: inline-block; padding: 2px 7px; border-radius: 5px;
            font-size: 10.5px; font-weight: 600; font-family: var(--font-mono);
        }
        .s-ultra  { background: rgba(168,85,247,.15); color: var(--purple); }
        .s-high   { background: rgba(34,211,238,.12); color: var(--accent-cyan); }
        .s-medium { background: rgba(245,158,11,.12); color: var(--warning); }
        .s-low    { background: rgba(239,68,68,.12);  color: var(--danger); }

        /* Resolution toggles */
        .res-toggle { display: flex; gap: 6px; }
        .res-btn {
            padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 600;
            cursor: pointer; border: 1px solid var(--border-mid); background: transparent;
            color: var(--text-muted); font-family: var(--font-ui); transition: all .15s;
        }
        .res-btn.active {
            background: rgba(34,211,238,.1); border-color: var(--accent-cyan);
            color: var(--accent-cyan);
        }

        /* Stat cards */
        .stat-card {
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px 18px;
            text-align: center;
        }
        .stat-icon { font-size: 24px; margin-bottom: 8px; }
        .stat-value {
            font-family: var(--font-mono); font-size: 22px; font-weight: 700;
            color: var(--accent-cyan); line-height: 1;
        }
        .stat-unit { font-size: 12px; color: var(--text-dim); margin-top: 2px; }
        .stat-label { font-size: 11.5px; color: var(--text-muted); margin-top: 6px; }

        /* Workload table */
        .workload-table { width: 100%; border-collapse: collapse; }
        .workload-table th {
            padding: 8px 14px; text-align: left;
            font-size: 10.5px; font-weight: 600; text-transform: uppercase;
            letter-spacing: .7px; color: var(--text-dim);
            border-bottom: 1px solid var(--border);
        }
        .workload-table td {
            padding: 11px 14px; font-size: 12.5px;
            border-bottom: 1px solid rgba(31,41,55,.5);
        }
        .workload-table tr:last-child td { border: none; }
        .workload-table tr:hover td { background: rgba(30,41,59,.4); }

        /* Score bar */
        .score-wrap { display: flex; align-items: center; gap: 10px; }
        .score-bar { flex: 1; height: 6px; background: var(--border); border-radius: 3px; overflow: hidden; }
        .score-fill { height: 100%; border-radius: 3px; background: linear-gradient(90deg, var(--accent-blue), var(--accent-cyan)); }
        .score-num { font-family: var(--font-mono); font-size: 12px; color: var(--accent-cyan); width: 52px; text-align: right; flex-shrink: 0; }

        /* Pairing section */
        .pairing-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }
        .pairing-card {
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 14px 16px;
            cursor: pointer;
            transition: all .2s;
        }
        .pairing-card:hover {
            border-color: var(--accent-cyan);
            background: rgba(34,211,238,.04);
        }
        .pairing-card.selected {
            border-color: var(--accent-cyan);
            background: rgba(34,211,238,.06);
            box-shadow: 0 0 0 1px rgba(34,211,238,.15);
        }
        .pairing-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 10px;
        }
        .pairing-title { font-size: 12.5px; font-weight: 600; color: var(--text-primary); }
        .pairing-score-badge {
            font-family: var(--font-mono); font-size: 11px; font-weight: 700;
            padding: 2px 7px; border-radius: 5px;
        }
        .score-s { background: rgba(34,197,94,.15); color: var(--success); }
        .score-a { background: rgba(34,211,238,.15); color: var(--accent-cyan); }
        .score-b { background: rgba(59,130,246,.15); color: var(--accent-blue); }
        .score-c { background: rgba(245,158,11,.15); color: var(--warning); }
        .pairing-components { display: flex; flex-direction: column; gap: 4px; margin-bottom: 10px; }
        .pairing-comp {
            display: flex; align-items: center; gap: 6px;
            font-size: 11.5px; color: var(--text-muted);
        }
        .pairing-comp .comp-tag {
            font-size: 9.5px; font-weight: 700; text-transform: uppercase;
            letter-spacing: .5px; background: var(--border); color: var(--text-dim);
            padding: 1px 5px; border-radius: 3px;
        }
        .bottleneck-bar { display: flex; flex-direction: column; gap: 4px; }
        .bn-row { display: flex; align-items: center; gap: 8px; font-size: 11px; color: var(--text-dim); }
        .bn-label { width: 32px; flex-shrink: 0; }
        .bn-track { flex: 1; height: 4px; background: var(--border); border-radius: 3px; overflow: hidden; }
        .bn-fill-cpu { background: var(--accent-blue); height: 100%; border-radius: 3px; }
        .bn-fill-gpu { background: var(--accent-cyan); height: 100%; border-radius: 3px; }
        .bn-fill-ram { background: var(--purple); height: 100%; border-radius: 3px; }
        .bn-pct { font-family: var(--font-mono); font-size: 10.5px; width: 30px; text-align: right; }

        /* Overall score ring */
        .score-ring-wrap {
            display: flex; flex-direction: column; align-items: center;
            justify-content: center; padding: 16px;
        }
        .score-ring-label {
            font-size: 12px; color: var(--text-muted); margin-top: 10px;
        }
        svg.ring { width: 110px; height: 110px; }
        .ring-track { fill: none; stroke: var(--border); stroke-width: 10; }
        .ring-fill {
            fill: none; stroke-width: 10; stroke-linecap: round;
            transform-origin: center; transform: rotate(-90deg);
            stroke: url(#ringGradient);
        }
        .ring-text { font-family: var(--font-mono); font-size: 18px; font-weight: 700; fill: var(--accent-cyan); }
        .ring-sub  { font-size: 9px; fill: var(--text-dim); }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--border-mid); border-radius: 3px; }

        .divider { height: 1px; background: var(--border); margin: 14px 0; }
        .section-title {
            font-size: 11px; font-weight: 600; text-transform: uppercase;
            letter-spacing: 1px; color: var(--text-dim); margin-bottom: 12px;
        }
    </style>
</head>
<body>

<!-- ===== SIDEBAR ===== -->
<aside class="sidebar">
    <div class="logo"><h2>Digital<span>Bazaar</span></h2></div>
    <div class="sidebar-label">Main Menu</div>
    <ul class="menu">
        <li onclick="window.location.href='${pageContext.request.contextPath}/dashboard'">
            <span class="icon">🏠</span> Dashboard
        </li>
        <li onclick="window.location.href='${pageContext.request.contextPath}/shop'">
            <span class="icon">🛍️</span> Shop
        </li>
        <li onclick="window.location.href='${pageContext.request.contextPath}/pcBuilder'">
            <span class="icon">🖥️</span> PC Builder
        </li>
        <li class="active">
            <span class="icon">📊</span> Perf Simulator
        </li>
    </ul>
    <div class="sidebar-label">Account</div>
    <ul class="menu">
        <li><span class="icon">👤</span> Profile</li>
        <li><span class="icon">🔔</span> Notifications</li>
        <li><span class="icon">⚙️</span> Settings</li>
    </ul>
    <div class="sidebar-footer">
        <button class="logout-btn" onclick="window.location.href='${pageContext.request.contextPath}/logout'">
            <span>⏻</span> Logout
        </button>
    </div>
</aside>

<!-- ===== MAIN ===== -->
<div class="main">
    <div class="topbar">
        <div class="topbar-left">
            <span class="page-badge">📊 Simulator</span>
            <h1>Performance Simulator</h1>
        </div>
        <div class="topbar-right">
            <span class="chip">⚡ Real-time estimates</span>
            <div class="avatar">U</div>
        </div>
    </div>

    <div class="content">

        <!-- Config Bar -->
        <div class="config-bar">
            <div class="form-group">
                <label>CPU</label>
                <select id="selCpu">
                    <option>Intel Core i9-14900K</option>
                    <option>Intel Core i7-14700K</option>
                    <option selected>Intel Core i5-13600K</option>
                    <option>AMD Ryzen 9 7950X</option>
                    <option>AMD Ryzen 7 7700X</option>
                    <option>AMD Ryzen 5 7600X</option>
                </select>
            </div>
            <div class="form-group">
                <label>GPU</label>
                <select id="selGpu">
                    <option>NVIDIA RTX 4090 24GB</option>
                    <option>NVIDIA RTX 4080 Super</option>
                    <option>NVIDIA RTX 4070 Ti</option>
                    <option selected>NVIDIA RTX 4060 + i5-12400F</option>
                    <option>AMD RX 7900 XTX</option>
                    <option>AMD RX 7800 XT</option>
                    <option>AMD RX 6700 XT</option>
                </select>
            </div>
            <div class="form-group">
                <label>RAM Config</label>
                <select>
                    <option>16GB DDR4-3200</option>
                    <option selected>32GB DDR5-6000</option>
                    <option>64GB DDR5-5600</option>
                </select>
            </div>
            <div class="form-group">
                <label>Workload</label>
                <select>
                    <option selected>Gaming</option>
                    <option>Video Editing</option>
                    <option>3D Rendering</option>
                    <option>AI / ML Training</option>
                    <option>General Productivity</option>
                </select>
            </div>
            <button class="btn-simulate" onclick="runSim()">▶ Simulate</button>
        </div>

        <!-- Hardware banner -->
        <div class="hardware-banner">
            <span class="hw-label">Active Config</span>
            <div class="hw-pill"><span class="tag">CPU</span> Intel Core i5-13600K</div>
            <div class="hw-divider"></div>
            <div class="hw-pill"><span class="tag">GPU</span> NVIDIA RTX 4060</div>
            <div class="hw-divider"></div>
            <div class="hw-pill"><span class="tag">RAM</span> 32GB DDR5-6000</div>
            <div class="hw-divider"></div>
            <div class="hw-pill" style="background:rgba(34,197,94,.08);border-color:rgba(34,197,94,.2);color:var(--success)">
                <span class="tag" style="background:rgba(34,197,94,.15);color:var(--success)">BTN</span>
                No Bottleneck Detected
            </div>
        </div>

        <!-- Stat cards row -->
        <div class="sim-grid-3" style="margin-bottom:20px">
            <div class="stat-card">
                <div class="stat-icon">🎮</div>
                <div class="stat-value">144</div>
                <div class="stat-unit">avg FPS @ 1080p / High</div>
                <div class="stat-label">Gaming Performance</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🎬</div>
                <div class="stat-value">4.2</div>
                <div class="stat-unit">min to render 1-min 4K clip</div>
                <div class="stat-label">Video Render Time</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🔥</div>
                <div class="stat-value">620</div>
                <div class="stat-unit">W peak system TDP</div>
                <div class="stat-label">Power Draw</div>
            </div>
        </div>

        <!-- FPS by Game + Pairings -->
        <div class="sim-grid" style="margin-bottom:20px">
            <!-- FPS Table -->
            <div class="card">
                <div class="card-header">
                    <h3>🎮 FPS by Game</h3>
                    <div class="res-toggle">
                        <button class="res-btn active" onclick="setRes(this)">1080p</button>
                        <button class="res-btn" onclick="setRes(this)">1440p</button>
                        <button class="res-btn" onclick="setRes(this)">4K</button>
                    </div>
                </div>
                <div class="card-body" style="padding:12px 0">
                    <table class="fps-table">
                        <thead>
                            <tr>
                                <th>Game</th>
                                <th>Setting</th>
                                <th>FPS</th>
                                <th class="fps-bar-cell">Load</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><div class="game-name">Cyberpunk 2077</div><div class="game-genre">Open World RPG</div></td>
                                <td><span class="setting-badge s-high">High</span></td>
                                <td><span class="fps-val fps-high">138</span></td>
                                <td><div class="fps-mini-bar"><div class="fps-mini-fill fill-green" style="width:92%"></div></div></td>
                            </tr>
                            <tr>
                                <td><div class="game-name">Call of Duty: Warzone</div><div class="game-genre">Battle Royale FPS</div></td>
                                <td><span class="setting-badge s-high">High</span></td>
                                <td><span class="fps-val fps-high">172</span></td>
                                <td><div class="fps-mini-bar"><div class="fps-mini-fill fill-green" style="width:100%"></div></div></td>
                            </tr>
                            <tr>
                                <td><div class="game-name">Microsoft Flight Sim 2024</div><div class="game-genre">Simulation</div></td>
                                <td><span class="setting-badge s-medium">Med</span></td>
                                <td><span class="fps-val fps-mid">68</span></td>
                                <td><div class="fps-mini-bar"><div class="fps-mini-fill fill-yellow" style="width:45%"></div></div></td>
                            </tr>
                            <tr>
                                <td><div class="game-name">Counter-Strike 2</div><div class="game-genre">Tactical FPS</div></td>
                                <td><span class="setting-badge s-high">High</span></td>
                                <td><span class="fps-val fps-high">290</span></td>
                                <td><div class="fps-mini-bar"><div class="fps-mini-fill fill-green" style="width:100%"></div></div></td>
                            </tr>
                            <tr>
                                <td><div class="game-name">Alan Wake 2</div><div class="game-genre">Action Horror</div></td>
                                <td><span class="setting-badge s-medium">Med</span></td>
                                <td><span class="fps-val fps-mid">74</span></td>
                                <td><div class="fps-mini-bar"><div class="fps-mini-fill fill-yellow" style="width:49%"></div></div></td>
                            </tr>
                            <tr>
                                <td><div class="game-name">Elden Ring</div><div class="game-genre">Action RPG</div></td>
                                <td><span class="setting-badge s-ultra">Ultra</span></td>
                                <td><span class="fps-val fps-high">152</span></td>
                                <td><div class="fps-mini-bar"><div class="fps-mini-fill fill-green" style="width:100%"></div></div></td>
                            </tr>
                            <tr>
                                <td><div class="game-name">Forza Horizon 5</div><div class="game-genre">Racing</div></td>
                                <td><span class="setting-badge s-ultra">Ultra</span></td>
                                <td><span class="fps-val fps-high">148</span></td>
                                <td><div class="fps-mini-bar"><div class="fps-mini-fill fill-green" style="width:98%"></div></div></td>
                            </tr>
                            <tr>
                                <td><div class="game-name">Hogwarts Legacy</div><div class="game-genre">Action RPG</div></td>
                                <td><span class="setting-badge s-high">High</span></td>
                                <td><span class="fps-val fps-mid">96</span></td>
                                <td><div class="fps-mini-bar"><div class="fps-mini-fill fill-yellow" style="width:64%"></div></div></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- CPU-GPU Pairings -->
            <div class="card">
                <div class="card-header">
                    <h3>🔗 Best CPU-GPU Pairings</h3>
                    <div class="tab-strip">
                        <div class="tab active" onclick="setTab(this)">Gaming</div>
                        <div class="tab" onclick="setTab(this)">Editing</div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="pairing-grid">
                        <div class="pairing-card selected" onclick="selectPairing(this)">
                            <div class="pairing-header">
                                <div class="pairing-title">Balanced Mid</div>
                                <span class="pairing-score-badge score-a">A+</span>
                            </div>
                            <div class="pairing-components">
                                <div class="pairing-comp"><span class="comp-tag">GPU</span> RTX 4060</div>
                                <div class="pairing-comp"><span class="comp-tag">CPU</span> i5-12400F</div>
                            </div>
                            <div class="bottleneck-bar">
                                <div class="bn-row"><span class="bn-label">CPU</span><div class="bn-track"><div class="bn-fill-cpu" style="width:72%"></div></div><span class="bn-pct">72%</span></div>
                                <div class="bn-row"><span class="bn-label">GPU</span><div class="bn-track"><div class="bn-fill-gpu" style="width:88%"></div></div><span class="bn-pct">88%</span></div>
                            </div>
                        </div>
                        <div class="pairing-card" onclick="selectPairing(this)">
                            <div class="pairing-header">
                                <div class="pairing-title">High-End</div>
                                <span class="pairing-score-badge score-s">S</span>
                            </div>
                            <div class="pairing-components">
                                <div class="pairing-comp"><span class="comp-tag">GPU</span> RTX 4080 Super</div>
                                <div class="pairing-comp"><span class="comp-tag">CPU</span> i7-14700K</div>
                            </div>
                            <div class="bottleneck-bar">
                                <div class="bn-row"><span class="bn-label">CPU</span><div class="bn-track"><div class="bn-fill-cpu" style="width:81%"></div></div><span class="bn-pct">81%</span></div>
                                <div class="bn-row"><span class="bn-label">GPU</span><div class="bn-track"><div class="bn-fill-gpu" style="width:94%"></div></div><span class="bn-pct">94%</span></div>
                            </div>
                        </div>
                        <div class="pairing-card" onclick="selectPairing(this)">
                            <div class="pairing-header">
                                <div class="pairing-title">Budget Pick</div>
                                <span class="pairing-score-badge score-b">B</span>
                            </div>
                            <div class="pairing-components">
                                <div class="pairing-comp"><span class="comp-tag">GPU</span> RX 7600 XT</div>
                                <div class="pairing-comp"><span class="comp-tag">CPU</span> Ryzen 5 7600</div>
                            </div>
                            <div class="bottleneck-bar">
                                <div class="bn-row"><span class="bn-label">CPU</span><div class="bn-track"><div class="bn-fill-cpu" style="width:68%"></div></div><span class="bn-pct">68%</span></div>
                                <div class="bn-row"><span class="bn-label">GPU</span><div class="bn-track"><div class="bn-fill-gpu" style="width:80%"></div></div><span class="bn-pct">80%</span></div>
                            </div>
                        </div>
                        <div class="pairing-card" onclick="selectPairing(this)">
                            <div class="pairing-header">
                                <div class="pairing-title">Workstation</div>
                                <span class="pairing-score-badge score-s">S+</span>
                            </div>
                            <div class="pairing-components">
                                <div class="pairing-comp"><span class="comp-tag">GPU</span> RTX 4090</div>
                                <div class="pairing-comp"><span class="comp-tag">CPU</span> Ryzen 9 7950X</div>
                            </div>
                            <div class="bottleneck-bar">
                                <div class="bn-row"><span class="bn-label">CPU</span><div class="bn-track"><div class="bn-fill-cpu" style="width:95%"></div></div><span class="bn-pct">95%</span></div>
                                <div class="bn-row"><span class="bn-label">GPU</span><div class="bn-track"><div class="bn-fill-gpu" style="width:97%"></div></div><span class="bn-pct">97%</span></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Benchmarks + Overall Score -->
        <div class="sim-grid">
            <!-- Workload Benchmarks -->
            <div class="card">
                <div class="card-header">
                    <h3>📐 Benchmark Scores</h3>
                    <div class="tab-strip">
                        <div class="tab active" onclick="setTab(this)">CPU</div>
                        <div class="tab" onclick="setTab(this)">GPU</div>
                        <div class="tab" onclick="setTab(this)">Combined</div>
                    </div>
                </div>
                <div class="card-body" style="padding:12px 0">
                    <table class="workload-table">
                        <thead>
                            <tr>
                                <th>Benchmark</th>
                                <th>Category</th>
                                <th colspan="2">Score</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="font-weight:500;color:var(--text-primary)">Cinebench R23 Multi</td>
                                <td style="font-size:11.5px;color:var(--text-dim)">CPU Render</td>
                                <td><div class="score-wrap"><div class="score-bar"><div class="score-fill" style="width:76%"></div></div><span class="score-num">24,100</span></div></td>
                            </tr>
                            <tr>
                                <td style="font-weight:500;color:var(--text-primary)">Cinebench R23 Single</td>
                                <td style="font-size:11.5px;color:var(--text-dim)">CPU Single Core</td>
                                <td><div class="score-wrap"><div class="score-bar"><div class="score-fill" style="width:82%"></div></div><span class="score-num">2,050</span></div></td>
                            </tr>
                            <tr>
                                <td style="font-weight:500;color:var(--text-primary)">3DMark TimeSpy</td>
                                <td style="font-size:11.5px;color:var(--text-dim)">GPU DX12</td>
                                <td><div class="score-wrap"><div class="score-bar"><div class="score-fill" style="width:70%"></div></div><span class="score-num">14,800</span></div></td>
                            </tr>
                            <tr>
                                <td style="font-weight:500;color:var(--text-primary)">Blender BMW CPU</td>
                                <td style="font-size:11.5px;color:var(--text-dim)">3D Render</td>
                                <td><div class="score-wrap"><div class="score-bar"><div class="score-fill" style="width:68%"></div></div><span class="score-num">3.8 min</span></div></td>
                            </tr>
                            <tr>
                                <td style="font-weight:500;color:var(--text-primary)">PCMark 10 Overall</td>
                                <td style="font-size:11.5px;color:var(--text-dim)">Productivity</td>
                                <td><div class="score-wrap"><div class="score-bar"><div class="score-fill" style="width:88%"></div></div><span class="score-num">8,900</span></div></td>
                            </tr>
                            <tr>
                                <td style="font-weight:500;color:var(--text-primary)">CrystalDiskMark (NVMe)</td>
                                <td style="font-size:11.5px;color:var(--text-dim)">Storage Read</td>
                                <td><div class="score-wrap"><div class="score-bar"><div class="score-fill" style="width:90%"></div></div><span class="score-num">7,100 MB/s</span></div></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Overall Score Ring -->
            <div class="card" style="display:flex;flex-direction:column">
                <div class="card-header">
                    <h3>🏆 Overall Build Score</h3>
                </div>
                <div class="card-body" style="display:flex;align-items:center;gap:28px;flex:1">
                    <div class="score-ring-wrap">
                        <svg class="ring" viewBox="0 0 110 110">
                            <defs>
                                <linearGradient id="ringGradient" x1="0%" y1="0%" x2="100%" y2="0%">
                                    <stop offset="0%" stop-color="#3b82f6"/>
                                    <stop offset="100%" stop-color="#22d3ee"/>
                                </linearGradient>
                            </defs>
                            <circle class="ring-track" cx="55" cy="55" r="42"/>
                            <circle class="ring-fill" cx="55" cy="55" r="42"
                                stroke-dasharray="236" stroke-dashoffset="59"/>
                            <text class="ring-text" x="55" y="51" text-anchor="middle">78</text>
                            <text class="ring-sub" x="55" y="64" text-anchor="middle">out of 100</text>
                        </svg>
                        <div class="score-ring-label">Performance Score</div>
                    </div>

                    <div style="flex:1">
                        <div class="section-title">Category Breakdown</div>
                        <div style="display:flex;flex-direction:column;gap:10px">
                            <div>
                                <div style="display:flex;justify-content:space-between;font-size:12px;color:var(--text-muted);margin-bottom:4px"><span>Gaming</span><span style="font-family:var(--font-mono);color:var(--accent-cyan)">88 / 100</span></div>
                                <div style="height:5px;background:var(--border);border-radius:3px;overflow:hidden"><div style="height:100%;width:88%;background:linear-gradient(90deg,var(--accent-blue),var(--accent-cyan));border-radius:3px"></div></div>
                            </div>
                            <div>
                                <div style="display:flex;justify-content:space-between;font-size:12px;color:var(--text-muted);margin-bottom:4px"><span>Video Editing</span><span style="font-family:var(--font-mono);color:var(--accent-cyan)">74 / 100</span></div>
                                <div style="height:5px;background:var(--border);border-radius:3px;overflow:hidden"><div style="height:100%;width:74%;background:linear-gradient(90deg,var(--accent-blue),var(--accent-cyan));border-radius:3px"></div></div>
                            </div>
                            <div>
                                <div style="display:flex;justify-content:space-between;font-size:12px;color:var(--text-muted);margin-bottom:4px"><span>AI / ML</span><span style="font-family:var(--font-mono);color:var(--accent-cyan)">61 / 100</span></div>
                                <div style="height:5px;background:var(--border);border-radius:3px;overflow:hidden"><div style="height:100%;width:61%;background:linear-gradient(90deg,var(--accent-blue),var(--accent-cyan));border-radius:3px"></div></div>
                            </div>
                            <div>
                                <div style="display:flex;justify-content:space-between;font-size:12px;color:var(--text-muted);margin-bottom:4px"><span>Productivity</span><span style="font-family:var(--font-mono);color:var(--accent-cyan)">92 / 100</span></div>
                                <div style="height:5px;background:var(--border);border-radius:3px;overflow:hidden"><div style="height:100%;width:92%;background:linear-gradient(90deg,var(--accent-blue),var(--accent-cyan));border-radius:3px"></div></div>
                            </div>
                            <div>
                                <div style="display:flex;justify-content:space-between;font-size:12px;color:var(--text-muted);margin-bottom:4px"><span>Thermal / Power</span><span style="font-family:var(--font-mono);color:var(--warning)">68 / 100</span></div>
                                <div style="height:5px;background:var(--border);border-radius:3px;overflow:hidden"><div style="height:100%;width:68%;background:linear-gradient(90deg,#d97706,var(--warning));border-radius:3px"></div></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    function runSim() {
        const btn = document.querySelector('.btn-simulate');
        btn.textContent = '⏳ Simulating…';
        btn.disabled = true;
        setTimeout(() => { btn.textContent = '▶ Simulate'; btn.disabled = false; }, 1200);
    }
    function setRes(el) {
        el.closest('.res-toggle').querySelectorAll('.res-btn').forEach(b => b.classList.remove('active'));
        el.classList.add('active');
    }
    function setTab(el) {
        el.closest('.tab-strip').querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        el.classList.add('active');
    } q	
    function selectPairing(el) {
        el.closest('.pairing-grid').querySelectorAll('.pairing-card').forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');
    }
</script>
</body>
</html>