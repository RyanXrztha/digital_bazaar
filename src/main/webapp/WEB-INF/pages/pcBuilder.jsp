<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.List, java.util.Map, com.DigitalBazaar.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart PC Builder – DigitalBazaar</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg-base:     #0f172a;
            --bg-card:     #111827;
            --bg-elevated: #1e293b;
            --border:      #1f2937;
            --border-mid:  #334155;
            --accent-cyan: #22d3ee;
            --accent-blue: #3b82f6;
            --accent-purple:#a855f7;
            --text-primary:#e5e7eb;
            --text-muted:  #94a3b8;
            --text-dim:    #6b7280;
            --danger:      #ef4444;
            --success:     #22c55e;
            --warning:     #f59e0b;
            --sidebar-w:   240px;
            --font-ui:     'Sora', sans-serif;
            --font-mono:   'JetBrains Mono', monospace;
            --topbar-h:    60px;
            --mobile-bar:  56px;
        }
        html { height: 100%; }
        body { font-family: var(--font-ui); background: var(--bg-base); color: var(--text-primary); display: flex; min-height: 100vh; overflow-x: hidden; }

        .sidebar-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.65); z-index: 110; }
        .sidebar-overlay.active { display: block; }

        .sidebar { width: var(--sidebar-w); height: 100vh; background: #020617; border-right: 1px solid var(--border); position: fixed; top: 0; left: 0; display: flex; flex-direction: column; z-index: 120; transition: transform .28s cubic-bezier(.4,0,.2,1); overflow-y: auto; }
        .logo { padding: 28px 20px 24px; border-bottom: 1px solid var(--border); flex-shrink: 0; }
        .logo h2 { font-size: 17px; font-weight: 700; color: var(--accent-blue); }
        .logo span { color: var(--accent-cyan); }
        .sidebar-label { font-size: 10px; font-weight: 600; letter-spacing: 1.5px; text-transform: uppercase; color: var(--text-dim); padding: 20px 20px 8px; flex-shrink: 0; }
        .menu { list-style: none; padding: 0 10px; flex-shrink: 0; }
        .menu li { display: flex; align-items: center; gap: 10px; padding: 11px 14px; border-radius: 8px; cursor: pointer; color: var(--text-muted); font-size: 13.5px; font-weight: 500; transition: all .18s; margin-bottom: 2px; border: 1px solid transparent; }
        .menu li:hover { background: var(--bg-elevated); color: var(--text-primary); }
        .menu li.active { background: linear-gradient(135deg,rgba(59,130,246,.18),rgba(34,211,238,.08)); color: var(--accent-cyan); border-color: rgba(34,211,238,.15); }
        .menu li .icon { font-size: 16px; width: 20px; text-align: center; }
        .sidebar-footer { margin-top: auto; padding: 16px 10px; border-top: 1px solid var(--border); flex-shrink: 0; }
        .logout-btn { display: flex; align-items: center; gap: 10px; width: 100%; padding: 10px 14px; border-radius: 8px; background: transparent; border: 1px solid var(--danger); color: var(--danger); font-family: var(--font-ui); font-size: 13px; font-weight: 500; cursor: pointer; transition: all .18s; }
        .logout-btn:hover { background: var(--danger); color: white; }

        .mobile-topbar { display: none; position: fixed; top: 0; left: 0; right: 0; height: var(--mobile-bar); background: #020617; border-bottom: 1px solid var(--border); align-items: center; justify-content: space-between; padding: 0 16px; z-index: 100; }
        .mobile-topbar .m-logo { font-size: 15px; font-weight: 700; color: var(--accent-blue); }
        .mobile-topbar .m-logo span { color: var(--accent-cyan); }
        .hamburger { background: none; border: none; color: var(--text-muted); font-size: 22px; cursor: pointer; padding: 6px; line-height: 1; touch-action: manipulation; -webkit-tap-highlight-color: transparent; }

        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; min-height: 100vh; min-width: 0; }
        .topbar { height: var(--topbar-h); background: var(--bg-card); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; padding: 0 28px; position: sticky; top: 0; z-index: 50; flex-shrink: 0; }
        .topbar-left { display: flex; align-items: center; gap: 14px; }
        .page-badge { background: linear-gradient(135deg,rgba(34,211,238,.12),rgba(59,130,246,.08)); border: 1px solid rgba(34,211,238,.2); color: var(--accent-cyan); font-size: 11px; font-weight: 600; letter-spacing: .8px; text-transform: uppercase; padding: 4px 10px; border-radius: 20px; white-space: nowrap; }
        .topbar h1 { font-size: 15px; font-weight: 600; }
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg,var(--accent-blue),var(--accent-cyan)); display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: var(--bg-base); cursor: pointer; flex-shrink: 0; }
        .chip { display: inline-flex; align-items: center; gap: 4px; background: rgba(59,130,246,.12); border: 1px solid rgba(59,130,246,.2); border-radius: 20px; padding: 3px 10px; font-size: 11px; font-weight: 500; color: var(--accent-blue); white-space: nowrap; }
        .content { padding: 28px; flex: 1; min-width: 0; }

        .wizard-steps { display: flex; align-items: center; margin-bottom: 32px; overflow-x: auto; padding-bottom: 4px; scrollbar-width: none; }
        .wizard-steps::-webkit-scrollbar { display: none; }
        .step { display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
        .step-num { width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; border: 2px solid var(--border-mid); color: var(--text-dim); background: var(--bg-card); transition: all .25s; flex-shrink: 0; }
        .step.active .step-num { background: var(--accent-cyan); border-color: var(--accent-cyan); color: var(--bg-base); box-shadow: 0 0 16px rgba(34,211,238,.4); }
        .step.done  .step-num { background: var(--success); border-color: var(--success); color: white; }
        .step-label { font-size: 12.5px; font-weight: 500; color: var(--text-dim); white-space: nowrap; }
        .step.active .step-label { color: var(--accent-cyan); }
        .step.done  .step-label { color: var(--success); }
        .step-connector { flex-shrink: 0; width: 40px; height: 2px; background: var(--border); margin: 0 8px; }

        .builder-grid { display: grid; grid-template-columns: 1fr 380px; gap: 24px; align-items: start; }

        .card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 14px; overflow: hidden; margin-bottom: 20px; }
        .card:last-child { margin-bottom: 0; }
        .card-header { padding: 18px 22px 16px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 8px; }
        .card-header h3 { font-size: 14px; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .card-body { padding: 22px; }

        .persona-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 12px; }
        .persona-card { background: var(--bg-elevated); border: 2px solid var(--border); border-radius: 12px; padding: 16px 12px; cursor: pointer; transition: all .2s; text-align: center; -webkit-tap-highlight-color: transparent; touch-action: manipulation; position: relative; }
        .persona-card:hover { border-color: var(--accent-cyan); background: rgba(34,211,238,.05); transform: translateY(-2px); }
        .persona-card.selected { border-color: var(--accent-cyan); background: rgba(34,211,238,.08); box-shadow: 0 0 0 1px rgba(34,211,238,.2); }
        .pc-icon { font-size: 26px; margin-bottom: 7px; }
        .pc-label { font-size: 12.5px; font-weight: 600; margin-bottom: 3px; }
        .persona-card.selected .pc-label { color: var(--accent-cyan); }
        .pc-desc { font-size: 10.5px; color: var(--text-muted); line-height: 1.4; }
        .persona-badge { position: absolute; top: -6px; right: 8px; font-size: 9px; font-weight: 700; letter-spacing: .6px; text-transform: uppercase; padding: 2px 7px; border-radius: 10px; pointer-events: none; }
        .badge-power    { background: rgba(239,68,68,.2);   color: #fca5a5; border: 1px solid rgba(239,68,68,.3); }
        .badge-balanced { background: rgba(34,197,94,.15);  color: #86efac; border: 1px solid rgba(34,197,94,.25); }
        .badge-budget   { background: rgba(245,158,11,.15); color: #fcd34d; border: 1px solid rgba(245,158,11,.25); }

        .persona-info { background: var(--bg-elevated); border-radius: 12px; border: 1px solid var(--border-mid); padding: 16px; margin-top: 16px; }
        .persona-info-header { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
        .persona-info-icon { font-size: 22px; }
        .persona-info-title { font-size: 13px; font-weight: 600; }
        .persona-info-sub { font-size: 11px; color: var(--text-muted); margin-top: 2px; }
        .priority-bars { display: flex; flex-direction: column; gap: 8px; }
        .priority-row { display: flex; align-items: center; gap: 10px; }
        .priority-label { font-size: 11px; color: var(--text-muted); width: 60px; flex-shrink: 0; }
        .priority-track { flex: 1; height: 6px; background: var(--border); border-radius: 3px; overflow: hidden; }
        .priority-fill { height: 100%; border-radius: 3px; transition: width .5s cubic-bezier(.4,0,.2,1); }
        .fill-gpu    { background: linear-gradient(90deg,#a855f7,#ec4899); }
        .fill-cpu    { background: linear-gradient(90deg,#3b82f6,#06b6d4); }
        .fill-ram    { background: linear-gradient(90deg,#22d3ee,#34d399); }
        .fill-storage{ background: linear-gradient(90deg,#f59e0b,#f97316); }
        .priority-pct { font-family: var(--font-mono); font-size: 11px; color: var(--text-muted); width: 30px; text-align: right; flex-shrink: 0; }

        .budget-value { font-family: var(--font-mono); font-size: 24px; font-weight: 600; color: var(--accent-cyan); margin-bottom: 10px; }
        input[type="range"] { width: 100%; -webkit-appearance: none; appearance: none; background: transparent; cursor: pointer; padding: 6px 0; }
        input[type="range"]::-webkit-slider-runnable-track { height: 4px; background: var(--border-mid); border-radius: 4px; }
        input[type="range"]::-webkit-slider-thumb { -webkit-appearance: none; width: 18px; height: 18px; background: var(--accent-cyan); border-radius: 50%; margin-top: -7px; box-shadow: 0 0 10px rgba(34,211,238,.5); cursor: pointer; }
        input[type="range"]::-moz-range-track { height: 4px; background: var(--border-mid); border-radius: 4px; }
        input[type="range"]::-moz-range-thumb { width: 18px; height: 18px; background: var(--accent-cyan); border: none; border-radius: 50%; }
        .range-labels { display: flex; justify-content: space-between; margin-top: 4px; }
        .range-labels span { font-size: 11px; color: var(--text-dim); font-family: var(--font-mono); }
        .budget-hint { font-size: 12px; color: var(--text-muted); margin-top: 10px; padding: 10px 14px; background: rgba(59,130,246,.06); border-radius: 8px; border-left: 2px solid var(--accent-blue); line-height: 1.5; }
        .budget-tiers { display: flex; gap: 6px; margin-top: 14px; }
        .tier-pill { flex: 1; padding: 6px 4px; border-radius: 8px; text-align: center; font-size: 10px; font-weight: 600; border: 1px solid var(--border); color: var(--text-dim); cursor: pointer; transition: all .2s; }
        .tier-pill.active { color: var(--accent-cyan); border-color: var(--accent-cyan); background: rgba(34,211,238,.08); }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        label { font-size: 11px; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: .6px; }
        select { background: var(--bg-elevated); border: 1px solid var(--border-mid); border-radius: 8px; color: var(--text-primary); font-family: var(--font-ui); font-size: 13px; padding: 9px 12px; outline: none; width: 100%; -webkit-appearance: none; appearance: none; transition: border-color .15s; }
        select:focus { border-color: var(--accent-cyan); }
        select option { background: var(--bg-card); color: var(--text-primary); }

        .rec-banner { display: flex; align-items: flex-start; gap: 10px; padding: 12px 14px; background: rgba(168,85,247,.07); border: 1px solid rgba(168,85,247,.2); border-radius: 10px; margin-bottom: 16px; }
        .rec-banner-icon { font-size: 18px; flex-shrink: 0; margin-top: 1px; }
        .rec-banner-text { font-size: 12px; color: var(--text-muted); line-height: 1.55; }
        .rec-banner-text strong { color: var(--accent-purple); font-weight: 600; }

        .component-slots { display: flex; flex-direction: column; gap: 12px; }
        .component-slot { background: var(--bg-elevated); border: 1px solid var(--border); border-radius: 12px; overflow: hidden; transition: border-color .2s; }
        .component-slot:hover { border-color: var(--border-mid); }
        .component-slot.priority-slot { border-color: rgba(168,85,247,.3); background: rgba(168,85,247,.04); }
        .component-slot.priority-slot:hover { border-color: rgba(168,85,247,.5); }

        .slot-header { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-bottom: 1px solid var(--border); }
        .slot-icon { width: 32px; height: 32px; border-radius: 7px; flex-shrink: 0; background: linear-gradient(135deg,rgba(34,211,238,.12),rgba(59,130,246,.08)); display: flex; align-items: center; justify-content: center; font-size: 15px; }
        .priority-slot .slot-icon { background: linear-gradient(135deg,rgba(168,85,247,.2),rgba(236,72,153,.1)); }
        .slot-label-text { f ,ont-size: 13px; font-weight: 600; color: #374151; flex: 1; text-transform: uppercase; }
        .slot-priority-tag { font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; padding: 2px 7px; border-radius: 4px; background: rgba(168,85,247,.2); color: #c084fc; border: 1px solid rgba(168,85,247,.3); }
        .slot-price-badge { font-family: var(--font-mono); font-size: 13px; font-weight: 700; color: var(--accent-cyan); background: rgba(34,211,238,.08); padding: 3px 10px; border-radius: 6px; white-space: nowrap; }
        .slot-body { padding: 12px 14px; }
        .slot-select-wrap { position: relative; }
        .slot-select-wrap::after { content: '▾'; position: absolute; right: 10px; top: 50%; transform: translateY(-50%); color: var(--text-muted); pointer-events: none; font-size: 12px; }
        .slot-native-select { width: 100%; background: var(--bg-card); border: 1px solid var(--border-mid); border-radius: 8px; color: var(--text-primary); font-family: var(--font-ui); font-size: 12.5px; padding: 9px 34px 9px 12px; outline: none; -webkit-appearance: none; appearance: none; cursor: pointer; transition: border-color .15s; }
        .slot-native-select:focus { border-color: var(--accent-cyan); }
        .slot-native-select option { background: #111827; color: var(--text-primary); padding: 4px; }
        .slot-native-select option:disabled { color: var(--text-dim); }
        .slot-actions { display: flex; gap: 6px; margin-top: 8px; }
        .slot-upgrade-btn   { font-size: 10.5px; font-weight: 600; padding: 5px 12px; border-radius: 6px; border: 1px solid rgba(34,211,238,.25); background: rgba(34,211,238,.06); color: var(--accent-cyan); cursor: pointer; transition: all .15s; }
        .slot-upgrade-btn:hover { background: rgba(34,211,238,.15); }
        .slot-downgrade-btn { font-size: 10.5px; font-weight: 600; padding: 5px 12px; border-radius: 6px; border: 1px solid rgba(245,158,11,.25); background: rgba(245,158,11,.06); color: var(--warning); cursor: pointer; transition: all .15s; }
        .slot-downgrade-btn:hover { background: rgba(245,158,11,.15); }
        .slot-stock-badge { font-size: 10px; color: var(--text-dim); margin-left: auto; align-self: center; font-family: var(--font-mono); }
        .stock-low  { color: var(--warning); }
        .stock-out  { color: var(--danger); }
        .stock-ok   { color: var(--success); }
        .build-note { margin-top: 16px; font-size: 12px; color: var(--text-muted); line-height: 1.6; padding: 12px 14px; background: rgba(245,158,11,.06); border-left: 3px solid var(--warning); border-radius: 0 8px 8px 0; }

        .summary-card { position: sticky; top: calc(var(--topbar-h) + 16px); }
        .budget-gauge-wrap { margin-bottom: 4px; }
        .budget-gauge-track { height: 8px; background: var(--border); border-radius: 4px; overflow: hidden; margin-bottom: 8px; }
        .budget-gauge-fill { height: 100%; border-radius: 4px; transition: width .4s ease, background .3s; }
        .gauge-ok   { background: linear-gradient(90deg,#22c55e,#34d399); }
        .gauge-warn { background: linear-gradient(90deg,#f59e0b,#fbbf24); }
        .gauge-over { background: linear-gradient(90deg,#ef4444,#f97316); }
        .budget-nums { display: flex; justify-content: space-between; font-size: 11px; color: var(--text-muted); }
        .budget-nums .spent { font-family: var(--font-mono); font-weight: 600; }
        .budget-status { display: flex; align-items: center; gap: 8px; padding: 10px 14px; border-radius: 8px; font-size: 12px; font-weight: 600; margin-top: 10px; }
        .budget-ok-pill   { background: rgba(34,197,94,.08);  color: var(--success); border: 1px solid rgba(34,197,94,.2); }
        .budget-over-pill { background: rgba(239,68,68,.08);  color: var(--danger);  border: 1px solid rgba(239,68,68,.2); }
        .budget-warn-pill { background: rgba(245,158,11,.08); color: var(--warning); border: 1px solid rgba(245,158,11,.2); }

        .price-breakdown { display: flex; flex-direction: column; }
        .price-row { display: flex; justify-content: space-between; align-items: center; padding: 9px 0; font-size: 12.5px; border-bottom: 1px solid var(--border); gap: 8px; }
        .price-row:last-child { border: none; }
        .price-row-left { display: flex; align-items: center; gap: 8px; min-width: 0; flex: 1; }
        .price-row-icon { font-size: 14px; flex-shrink: 0; }
        .price-row-info { min-width: 0; flex: 1; }
        .price-row-label { color: var(--text-muted); font-size: 10.5px; text-transform: uppercase; letter-spacing: .4px; }
        .price-row-name { color: var(--text-primary); font-size: 11.5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 170px; }
        .price-row-val { font-family: var(--font-mono); font-size: 13px; font-weight: 600; color: var(--text-primary); flex-shrink: 0; }
        .price-row-val.priority { color: var(--accent-purple); }
        .price-row-val.none { color: var(--text-dim); font-style: italic; }
        .divider { height: 1px; background: var(--border-mid); margin: 12px 0 0; }
        .price-total-row { display: flex; justify-content: space-between; align-items: baseline; padding: 14px 0 0; }
        .price-total-label { font-size: 14px; font-weight: 600; }
        .price-total-val { font-family: var(--font-mono); color: var(--accent-cyan); font-size: 22px; font-weight: 700; }
        .price-per-day { font-size: 11px; color: var(--text-dim); text-align: right; margin-top: 2px; font-family: var(--font-mono); }

        .btn-primary { width: 100%; padding: 13px; background: linear-gradient(135deg,var(--accent-blue),var(--accent-cyan)); border: none; border-radius: 10px; color: var(--bg-base); font-family: var(--font-ui); font-size: 13.5px; font-weight: 700; cursor: pointer; margin-top: 16px; transition: opacity .15s, transform .1s; touch-action: manipulation; }
        .btn-primary:hover { opacity: .9; transform: translateY(-1px); }
        .btn-primary:active { transform: translateY(0); }
        .btn-secondary { width: 100%; padding: 11px; background: transparent; border: 1px solid var(--border-mid); border-radius: 10px; color: var(--text-muted); font-family: var(--font-ui); font-size: 13px; font-weight: 500; cursor: pointer; margin-top: 8px; transition: all .15s; touch-action: manipulation; }
        .btn-secondary:hover { border-color: var(--accent-cyan); color: var(--accent-cyan); }
        .btn-optimize { width: 100%; padding: 11px; background: rgba(168,85,247,.1); border: 1px solid rgba(168,85,247,.3); border-radius: 10px; color: #c084fc; font-family: var(--font-ui); font-size: 13px; font-weight: 600; cursor: pointer; margin-top: 8px; transition: all .15s; display: flex; align-items: center; justify-content: center; gap: 6px; }
        .btn-optimize:hover { background: rgba(168,85,247,.2); border-color: rgba(168,85,247,.5); }

        .mobile-summary-bar { display: none; position: fixed; bottom: 0; left: 0; right: 0; background: var(--bg-card); border-top: 1px solid var(--border); padding: 10px 16px; z-index: 90; align-items: center; gap: 12px; }
        .ms-total { flex: 1; min-width: 0; }
        .ms-label { font-size: 11px; color: var(--text-muted); }
        .ms-price { font-family: var(--font-mono); font-size: 18px; font-weight: 700; color: var(--accent-cyan); }
        .ms-btn { background: linear-gradient(135deg,var(--accent-blue),var(--accent-cyan)); border: none; border-radius: 8px; color: var(--bg-base); font-family: var(--font-ui); font-size: 13px; font-weight: 700; padding: 10px 20px; cursor: pointer; white-space: nowrap; flex-shrink: 0; touch-action: manipulation; }

        @keyframes slotIn { from { opacity:0; transform:translateY(8px); } to { opacity:1; transform:translateY(0); } }
        .slot-anim { animation: slotIn .22s ease forwards; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background: var(--border-mid); border-radius: 3px; }

        @media (max-width: 1280px) { .builder-grid { grid-template-columns: 1fr 340px; } }
        @media (max-width: 1100px) { .builder-grid { grid-template-columns: 1fr; } .summary-card { position: static; } }
        @media (max-width: 900px) {
            .sidebar { transform: translateX(calc(-1 * var(--sidebar-w))); }
            .sidebar.mobile-open { transform: translateX(0); box-shadow: 4px 0 32px rgba(0,0,0,.6); }
            .mobile-topbar { display: flex; }
            .mobile-summary-bar { display: flex; }
            .topbar { display: none; }
            .main { margin-left: 0; padding-top: var(--mobile-bar); }
            .content { padding: 16px 16px 80px; }
            .builder-grid > .summary-card { display: none; }
            .persona-grid { grid-template-columns: repeat(2,1fr); }
            .form-row { grid-template-columns: 1fr; gap: 12px; }
        }
        @media (max-width: 480px) {
            .step-label { display: none; }
            .step-connector { width: 20px; margin: 0 4px; }
            .card-body { padding: 14px; }
            .card-header { padding: 14px; }
            .persona-card { padding: 12px 8px; }
            .pc-icon { font-size: 22px; }
            .pc-label { font-size: 11.5px; }
            .pc-desc { display: none; }
            .budget-value { font-size: 20px; }
            .budget-tiers { flex-wrap: wrap; }
            .price-row-name { max-width: 120px; }
        }
    </style>
</head>
<body>

<div class="mobile-topbar">
    <div class="m-logo">Digital<span>Bazaar</span></div>
    <button class="hamburger" onclick="toggleSidebar()" aria-label="Toggle menu">☰</button>
</div>
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<aside class="sidebar" id="sidebar">
    <div class="logo"><h2>Digital<span>Bazaar</span></h2></div>
    <div class="sidebar-label">Main Menu</div>
    <ul class="menu">
        <li onclick="location.href='<%= request.getContextPath() %>/dashboard'"><span class="icon">🏠</span> Dashboard</li>
        <li onclick="location.href='<%= request.getContextPath() %>/shop'"><span class="icon">🛍️</span> Shop</li>
        <li onclick="location.href='<%= request.getContextPath() %>/pcbuilder'" class="active"><span class="icon">🖥️</span> PC Builder</li>
        <li onclick="location.href='<%= request.getContextPath() %>/performanceSimulator'"><span class="icon">📊</span> Perf Simulator</li>
    </ul>
    <div class="sidebar-label">Account</div>
    <ul class="menu">
        <li><span class="icon">👤</span> Profile</li>
        <li><span class="icon">🔔</span> Notifications</li>
        <li><span class="icon">⚙️</span> Settings</li>
    </ul>
    <div class="sidebar-footer">
        <button class="logout-btn" onclick="location.href='<%= request.getContextPath() %>/logout'">⏻ Logout</button>
    </div>
</aside>

<div class="main">
    <div class="topbar">
        <div class="topbar-left">
            <span class="page-badge">🖥️ Smart Builder</span>
            <h1>PC Builder</h1>
        </div>
        <div class="topbar-right">
            <span class="chip">✓ Live DB Products</span>
            <div class="avatar">U</div>
        </div>
    </div>

    <div class="content">
        <div class="wizard-steps">
            <div class="step done"><div class="step-num">✓</div><div class="step-label">Persona</div></div>
            <div class="step-connector"></div>
            <div class="step active"><div class="step-num">2</div><div class="step-label">Configure</div></div>
            <div class="step-connector"></div>
            <div class="step"><div class="step-num">3</div><div class="step-label">Review</div></div>
            <div class="step-connector"></div>
            <div class="step"><div class="step-num">4</div><div class="step-label">Add to Cart</div></div>
        </div>

        <div class="builder-grid">
            <!-- LEFT COLUMN -->
            <div>
                <!-- Persona -->
                <div class="card">
                    <div class="card-header"><h3>🎯 Who is this build for?</h3></div>
                    <div class="card-body">
                        <div class="persona-grid">
                            <div class="persona-card selected" onclick="selectPersona(this,'gamer')">
                                <span class="persona-badge badge-balanced">Popular</span>
                                <div class="pc-icon">🎮</div><div class="pc-label">Gamer</div><div class="pc-desc">High FPS, 1440p/4K</div>
                            </div>
                            <div class="persona-card" onclick="selectPersona(this,'streamer')">
                                <div class="pc-icon">📡</div><div class="pc-label">Streamer</div><div class="pc-desc">Stream &amp; play together</div>
                            </div>
                            <div class="persona-card" onclick="selectPersona(this,'editor')">
                                <div class="pc-icon">🎬</div><div class="pc-label">Video Editor</div><div class="pc-desc">Fast exports, 4K timelines</div>
                            </div>
                            <div class="persona-card" onclick="selectPersona(this,'datascience')">
                                <span class="persona-badge badge-balanced">Data</span>
                                <div class="pc-icon">📊</div><div class="pc-label">Data Scientist</div><div class="pc-desc">Pandas, Jupyter, big data</div>
                            </div>
                            <div class="persona-card" onclick="selectPersona(this,'ml')">
                                <span class="persona-badge badge-power">Power</span>
                                <div class="pc-icon">🤖</div><div class="pc-label">ML Engineer</div><div class="pc-desc">Model training, high VRAM</div>
                            </div>
                            <div class="persona-card" onclick="selectPersona(this,'developer')">
                                <div class="pc-icon">💻</div><div class="pc-label">Developer</div><div class="pc-desc">IDEs, Docker, compilation</div>
                            </div>
                            <div class="persona-card" onclick="selectPersona(this,'3d')">
                                <span class="persona-badge badge-power">GPU</span>
                                <div class="pc-icon">🧊</div><div class="pc-label">3D Artist</div><div class="pc-desc">Blender, Maya, renders</div>
                            </div>
                            <div class="persona-card" onclick="selectPersona(this,'budget')">
                                <span class="persona-badge badge-budget">Value</span>
                                <div class="pc-icon">💸</div><div class="pc-label">Budget Build</div><div class="pc-desc">Best value, everyday use</div>
                            </div>
                        </div>
                        <div id="personaInfo" class="persona-info"></div>
                    </div>
                </div>

                <!-- Budget -->
                <div class="card">
                    <div class="card-header"><h3>💰 Budget Range</h3></div>
                    <div class="card-body">
                        <div class="budget-value" id="budgetDisplay">$1,500</div>
                        <input type="range" min="400" max="6000" step="50" value="1500" id="budgetSlider" oninput="onBudgetChange(this.value)">
                        <div class="range-labels"><span>$400</span><span>$6,000</span></div>
                        <div class="budget-hint" id="budgetHint">Mid-range build — solid 1440p gaming or creative work.</div>
                        <div class="budget-tiers">
                            <div class="tier-pill" onclick="setTier(700)">Entry<br><span style="font-family:var(--font-mono);font-size:9px;">≤$700</span></div>
                            <div class="tier-pill" onclick="setTier(1200)">Mid<br><span style="font-family:var(--font-mono);font-size:9px;">≤$1.2k</span></div>
                            <div class="tier-pill active" onclick="setTier(1800)">High<br><span style="font-family:var(--font-mono);font-size:9px;">≤$1.8k</span></div>
                            <div class="tier-pill" onclick="setTier(2800)">Ultra<br><span style="font-family:var(--font-mono);font-size:9px;">≤$2.8k</span></div>
                            <div class="tier-pill" onclick="setTier(6000)">No-limit<br><span style="font-family:var(--font-mono);font-size:9px;">$6k</span></div>
                        </div>
                    </div>
                </div>

                <!-- Priorities -->
                <div class="card">
                    <div class="card-header"><h3>⚙️ Customise Priorities</h3></div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Prioritise</label>
                                <select id="priority" onchange="reApplyDefaults()">
                                    <option value="balanced">Balanced all-round</option>
                                    <option value="cpu">CPU-heavy workloads</option>
                                    <option value="gpu">GPU performance</option>
                                    <option value="ram">Maximum RAM</option>
                                    <option value="storage">Fast / large storage</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Form Factor</label>
                                <select id="formFactor">
                                    <option value="atx">ATX (full tower)</option>
                                    <option value="matx">Micro-ATX</option>
                                    <option value="itx">Mini-ITX</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Components -->
                <div class="card">
                    <div class="card-header">
                        <h3>🔩 Select Components</h3>
                        <span class="chip" id="personaChip">🎮 Gamer</span>
                    </div>
                    <div class="card-body">
                        <div id="recBanner"></div>
                        <div class="component-slots" id="componentSlots"></div>
                        <div class="build-note" id="buildNote" style="display:none;"></div>
                    </div>
                </div>
            </div>

            <!-- RIGHT COLUMN -->
            <div class="summary-card">
                <div class="card">
                    <div class="card-header"><h3>📊 Budget vs Build</h3></div>
                    <div class="card-body">
                        <div class="budget-gauge-wrap">
                            <div class="budget-gauge-track">
                                <div class="budget-gauge-fill gauge-ok" id="budgetGaugeFill" style="width:0%"></div>
                            </div>
                            <div class="budget-nums">
                                <span class="spent" id="budgetSpent">$0</span>
                                <span id="budgetOf">of $1,500</span>
                            </div>
                        </div>
                        <div id="budgetStatus" class="budget-status budget-ok-pill">✓ Within budget</div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header"><h3>🧾 Price Summary</h3></div>
                    <div class="card-body">
                        <div class="price-breakdown" id="priceBreakdown"></div>
                        <div class="divider"></div>
                        <div class="price-total-row">
                            <span class="price-total-label">Total</span>
                            <span class="price-total-val" id="totalPrice">$0.00</span>
                        </div>
                        <div class="price-per-day" id="pricePerDay"></div>
                        <button class="btn-primary" onclick="addToCart()">🛒 Add Build to Cart</button>
                        <button class="btn-optimize" onclick="optimizeBuild()">✨ Optimize for Budget</button>
                        <button class="btn-secondary" onclick="saveBuild()">💾 Save Build</button>
                        <button class="btn-secondary" onclick="shareBuild()">📤 Share Build</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="mobile-summary-bar">
    <div class="ms-total">
        <div class="ms-label">Build Total</div>
        <div class="ms-price" id="mobileTotalPrice">$0.00</div>
    </div>
    <button class="ms-btn" onclick="addToCart()">🛒 Add to Cart</button>
</div>

<!-- ═══ JAVA → JS DATA BRIDGE ═══ -->
<script>
<%
    @SuppressWarnings("unchecked")
    Map<String, List<Product>> byCategory =
        (Map<String, List<Product>>) request.getAttribute("productsByCategory");

    if (byCategory == null || byCategory.isEmpty()) {
        out.println("const DB = {};");
    } else {
        out.println("const DB = {");
        boolean firstCat = true;
        for (Map.Entry<String, List<Product>> entry : byCategory.entrySet()) {
            if (!firstCat) out.println(",");
            firstCat = false;
            String cat = entry.getKey().replace("\"","\\\"");
            out.print("  \"" + cat + "\": [");
            boolean firstProd = true;
            for (Product p : entry.getValue()) {
                if (!firstProd) out.print(",");
                firstProd = false;
                String safeName = p.getName()
                    .replace("\\","\\\\").replace("\"","\\\"")
                    .replace("\n","").replace("\r","");
                String safeImg = p.getImage() != null ? p.getImage().replace("\"","\\\"") : "";
                out.print("{id:" + p.getId()
                    + ",name:\"" + safeName + "\""
                    + ",price:" + p.getPrice()
                    + ",stock:" + p.getStock()
                    + ",img:\"" + safeImg + "\"}");
            }
            out.print("]");
        }
        out.println("\n};");
    }
%>

const DB_MAP = {};
Object.keys(DB).forEach(function(rawKey) {
    DB_MAP[rawKey.trim().toLowerCase()] = DB[rawKey];
});
console.log('[PCBuilder] DB categories:', Object.keys(DB));
console.log('[PCBuilder] Total products:', Object.values(DB).reduce(function(s,a){ return s+a.length; }, 0));

const SLOTS = [
    { key:'gpu',         label:'GPU',         icon:'🖥️',  cat:'GPU'         },
    { key:'cpu',         label:'CPU',         icon:'🧠',  cat:'CPU'         },
    { key:'motherboard', label:'Motherboard', icon:'🎛️', cat:'Motherboard' },
    { key:'ram',         label:'RAM',         icon:'💾',  cat:'RAM'         },
    { key:'storage',     label:'Storage',     icon:'💿',  cat:'Storage'     },
    { key:'cooler',      label:'Cooler',      icon:'❄️',  cat:'Cooler'      },
    { key:'psu',         label:'PSU',         icon:'⚡',  cat:'PSU'         },
    { key:'case',        label:'Case',        icon:'📦',  cat:'Case'        },
];

// ─── PERSONAS (defined ONCE — no duplicates) ───────────────────────────────
const PERSONAS = {
    gamer: {
        label: '🎮 Gamer', color: '#22d3ee',
        tagline: 'High FPS & visual fidelity at 1440p/4K',
        note: 'GPU is king for gaming — prioritise VRAM and bandwidth. A fast 6-core+ CPU eliminates bottlenecking. DDR5 speeds up texture streaming.',
        priorities: { gpu:10, cpu:7, ram:5, motherboard:4, storage:4, cooler:5, psu:4, case:3 },
        budgetWeights: { gpu:.38, cpu:.17, motherboard:.10, ram:.10, storage:.08, cooler:.07, psu:.06, case:.04 },
        prioritySlots: ['gpu','cpu','cooler'],
        tiers: {
            entry:   { gpu:'RX 7600 8GB',           cpu:'Ryzen 5 5600X',        motherboard:'TUF Gaming B650',          ram:'OLOy Blade 16GB',                   storage:'Kingston NV3 1TB',    cooler:'Deepcool AK620',               psu:'EVGA 650W',           case:'Antec NX800' },
            mid:     { gpu:'RTX 4060 Ti 8GB',        cpu:'Intel Core i5-14600K', motherboard:'MSI MAG Z790 Tomahawk',    ram:'Corsair Vengeance 32GB DDR5-5200',   storage:'Samsung 990 Pro 1TB', cooler:'NZXT Kraken 240',              psu:'Corsair RM850x',      case:'NZXT H9 Flow' },
            high:    { gpu:'RTX 4070 Ti Super 16GB', cpu:'Intel Core i5-14600K', motherboard:'MSI MAG Z790 Tomahawk',    ram:'Corsair Vengeance 32GB DDR5-5200',   storage:'Samsung 990 Pro 1TB', cooler:'NZXT Kraken 240',              psu:'Corsair RM850x',      case:'Lian Li PC-O11 Dynamic EVO' },
            ultra:   { gpu:'RTX 4080 Super 16GB',    cpu:'Intel Core i7-14700K', motherboard:'ASUS ROG Strix Z790-E',    ram:'G.Skill Trident Z5 32GB DDR5-6000', storage:'Samsung 990 Pro 2TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Corsair HX1000',      case:'Lian Li PC-O11 Dynamic EVO' },
            nolimit: { gpu:'RTX 4090 24GB',          cpu:'Intel Core i9-14900K', motherboard:'ASUS ROG Maximus Z790',    ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'NZXT Kraken 360 Elite',        psu:'Seasonic Prime TX-1000', case:'Corsair 7000D Airflow' },
        },
    },
    streamer: {
        label: '📡 Streamer', color: '#f472b6',
        tagline: 'Play & stream simultaneously without frame drops',
        note: 'Streaming while gaming needs high multi-core counts. The i7-14700K handles OBS x264 encoding on dedicated cores without stealing GPU bandwidth.',
        priorities: { gpu:8, cpu:10, ram:7, motherboard:5, storage:5, cooler:6, psu:5, case:4 },
        budgetWeights: { gpu:.30, cpu:.22, motherboard:.12, ram:.13, storage:.08, cooler:.07, psu:.05, case:.03 },
        prioritySlots: ['cpu','ram','cooler'],
        tiers: {
            entry:   { gpu:'RTX 4060 8GB',           cpu:'Intel Core i5-13600K', motherboard:'ASUS TUF Gaming Z790-Plus', ram:'Corsair Vengeance 16GB DDR5-4800',  storage:'Kingston NV3 1TB',    cooler:'be quiet! Dark Rock 4',        psu:'EVGA 650W',           case:'Antec NX800' },
            mid:     { gpu:'RTX 4060 Ti 8GB',        cpu:'Intel Core i7-13700K', motherboard:'MSI MAG Z790 Tomahawk',     ram:'Corsair Vengeance 32GB DDR5-5200',  storage:'WD Black SN850X 1TB', cooler:'Corsair H100i Elite Capellix', psu:'Corsair RM850x',      case:'Fractal Design Torrent' },
            high:    { gpu:'RTX 4070 Super 12GB',    cpu:'Intel Core i7-14700K', motherboard:'ASUS ROG Strix Z790-E',     ram:'G.Skill Trident Z5 32GB DDR5-6000', storage:'WD Black SN850X 2TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Seasonic Focus GX-1000', case:'Corsair 5000D Airflow' },
            ultra:   { gpu:'RTX 4080 Super 16GB',    cpu:'Intel Core i7-14700K', motherboard:'ASUS ROG Strix Z790-E',     ram:'G.Skill Ripjaws S5 32GB DDR5-5600', storage:'WD Black SN850X 2TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Seasonic Focus GX-1000', case:'Corsair 5000D Airflow' },
            nolimit: { gpu:'RTX 4090 24GB',          cpu:'Intel Core i9-14900K', motherboard:'ASUS ROG Maximus Z790',     ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'NZXT Kraken 360 Elite',        psu:'Seasonic Prime TX-1000', case:'Corsair 7000D Airflow' },
        },
    },
    editor: {
        label: '🎬 Video Editor', color: '#fb923c',
        tagline: 'Fast 4K exports & smooth timeline scrubbing',
        note: 'Multi-core throughput speeds rendering; 64GB RAM prevents swap on 4K timelines. CUDA acceleration in Premiere & DaVinci means GPU matters too.',
        priorities: { gpu:7, cpu:10, ram:9, motherboard:5, storage:7, cooler:6, psu:5, case:3 },
        budgetWeights: { gpu:.24, cpu:.22, motherboard:.10, ram:.17, storage:.12, cooler:.07, psu:.05, case:.03 },
        prioritySlots: ['cpu','ram','storage'],
        tiers: {
            entry:   { gpu:'RTX 4060 8GB',           cpu:'AMD Ryzen 5 5600X',    motherboard:'ASUS TUF Gaming B650-Plus', ram:'Corsair Vengeance 32GB DDR5-5200',  storage:'WD Black SN850X 1TB', cooler:'be quiet! Dark Rock 4',        psu:'Corsair RM750x',      case:'Fractal Design Define 7 Silent' },
            mid:     { gpu:'RTX 4060 Ti 16GB',       cpu:'AMD Ryzen 7 7700X',    motherboard:'ASUS TUF Gaming X670E-Plus',ram:'Kingston Fury Beast 64GB DDR5-5200',storage:'Samsung 990 Pro 2TB', cooler:'Noctua NH-D15',                psu:'Corsair RM850x',      case:'Fractal Design Define 7 Silent' },
            high:    { gpu:'RTX 4070 Super 12GB',    cpu:'AMD Ryzen 9 7900X',    motherboard:'MSI MEG X670E ACE',         ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'Samsung 990 Pro 2TB', cooler:'be quiet! Dark Rock Pro 5',    psu:'Corsair RM850x',      case:'Fractal Design Define 7 Silent' },
            ultra:   { gpu:'RTX 4070 Ti Super 16GB', cpu:'AMD Ryzen 9 7950X',    motherboard:'MSI MEG X670E ACE',         ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Corsair HX1000',      case:'Fractal Design Define 7 Silent' },
            nolimit: { gpu:'RTX 4080 Super 16GB',    cpu:'AMD Ryzen 9 7950X',    motherboard:'ASUS ROG Crosshair X670E',  ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Seasonic Prime TX-1000', case:'Corsair 7000D Airflow' },
        },
    },
    datascience: {
        label: '📊 Data Scientist', color: '#34d399',
        tagline: 'Large DataFrames, Jupyter, statistical workloads',
        note: 'RAM is the #1 bottleneck — a 64GB dataset needs 64GB+ RAM to avoid disk swapping. Strong multi-core CPU speeds up Pandas and scikit-learn.',
        priorities: { gpu:6, cpu:9, ram:10, motherboard:5, storage:8, cooler:5, psu:5, case:3 },
        budgetWeights: { gpu:.20, cpu:.22, motherboard:.10, ram:.22, storage:.12, cooler:.06, psu:.05, case:.03 },
        prioritySlots: ['ram','cpu','storage'],
        tiers: {
            entry:   { gpu:'Arc A750 8GB',           cpu:'AMD Ryzen 5 7600',     motherboard:'ASUS TUF Gaming B650-Plus', ram:'Corsair Vengeance 32GB DDR5-5200',   storage:'Kingston NV3 2TB',    cooler:'Deepcool AK620',               psu:'EVGA 650W',              case:'Antec NX800' },
            mid:     { gpu:'RTX 4060 8GB',           cpu:'AMD Ryzen 7 7700X',    motherboard:'ASUS TUF Gaming X670E-Plus',ram:'Kingston Fury Beast 64GB DDR5-5200', storage:'WD Black SN850X 2TB', cooler:'Noctua NH-U12S Redux',         psu:'Corsair RM750x',         case:'Fractal Design Torrent' },
            high:    { gpu:'RTX 4060 Ti 16GB',       cpu:'AMD Ryzen 9 7900X',    motherboard:'MSI MEG X670E ACE',         ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 2TB', cooler:'Noctua NH-D15',                psu:'Seasonic Focus GX-850',  case:'Fractal Design Define 7 Silent' },
            ultra:   { gpu:'RTX 4070 Super 12GB',   cpu:'AMD Ryzen 9 7950X',    motherboard:'MSI MEG X670E ACE',         ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'Noctua NH-D15',                psu:'Corsair RM850x',         case:'Fractal Design Define 7 Silent' },
            nolimit: { gpu:'RTX 4080 Super 16GB',    cpu:'AMD Ryzen 9 7950X',    motherboard:'ASUS ROG Crosshair X670E',  ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Corsair HX1000',         case:'Phanteks Enthoo Pro 2' },
        },
    },
    ml: {
        label: '🤖 ML Engineer', color: '#a855f7',
        tagline: 'Model training, fine-tuning, high VRAM workloads',
        note: 'GPU VRAM and bandwidth are everything for ML. A powerful CPU feeds data pipelines; 64GB RAM stores large datasets. High-wattage PSU is critical.',
        priorities: { gpu:10, cpu:9, ram:8, motherboard:5, storage:7, cooler:7, psu:8, case:3 },
        budgetWeights: { gpu:.42, cpu:.18, motherboard:.09, ram:.13, storage:.08, cooler:.05, psu:.04, case:.01 },
        prioritySlots: ['gpu','cpu','psu'],
        tiers: {
            entry:   { gpu:'RTX 3070 8GB',           cpu:'AMD Ryzen 5 5600X',    motherboard:'ASUS TUF Gaming B650-Plus', ram:'Corsair Vengeance 32GB DDR5-5200',   storage:'WD Black SN850X 1TB', cooler:'Arctic Liquid Freezer II 280mm',psu:'Seasonic Focus GX-850',  case:'Antec NX800' },
            mid:     { gpu:'RTX 4060 Ti 16GB',       cpu:'AMD Ryzen 7 7700X',    motherboard:'ASUS TUF Gaming X670E-Plus',ram:'Kingston Fury Beast 64GB DDR5-5200', storage:'WD Black SN850X 2TB', cooler:'NZXT Kraken 240 AIO',          psu:'Corsair RM850x',         case:'Fractal Design Torrent' },
            high:    { gpu:'RTX 4070 Ti Super 16GB', cpu:'AMD Ryzen 9 7900X',    motherboard:'MSI MEG X670E ACE',         ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 2TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Seasonic Focus GX-1000', case:'Phanteks Enthoo Pro 2' },
            ultra:   { gpu:'RTX 4080 Super 16GB',    cpu:'AMD Ryzen 9 7950X',    motherboard:'ASUS ROG Crosshair X670E',  ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Corsair HX1000',         case:'Phanteks Enthoo Pro 2' },
            nolimit: { gpu:'RTX 4090 24GB',          cpu:'AMD Ryzen 9 7950X',    motherboard:'ASUS ROG Crosshair X670E',  ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'NZXT Kraken 360 Elite',        psu:'Seasonic Prime TX-1000', case:'Phanteks Enthoo Pro 2' },
        },
    },
    developer: {
        label: '💻 Developer', color: '#60a5fa',
        tagline: 'IDEs, Docker containers, compilation speed',
        note: 'Fast NVMe speeds Docker builds and compilation. Large RAM runs multiple VMs simultaneously. GPU is secondary for most dev work.',
        priorities: { gpu:4, cpu:8, ram:7, motherboard:5, storage:9, cooler:4, psu:4, case:3 },
        budgetWeights: { gpu:.15, cpu:.22, motherboard:.12, ram:.18, storage:.18, cooler:.06, psu:.06, case:.03 },
        prioritySlots: ['storage','ram','cpu'],
        tiers: {
            entry:   { gpu:'Arc A750 8GB',           cpu:'AMD Ryzen 5 5600X',    motherboard:'ASUS TUF Gaming B650-Plus', ram:'Corsair Vengeance 16GB DDR5-4800',  storage:'Kingston NV3 1TB',    cooler:'Noctua NH-U12S Redux',         psu:'EVGA 650W',           case:'Antec NX800' },
            mid:     { gpu:'RTX 4060 8GB',           cpu:'AMD Ryzen 5 7600X',    motherboard:'ASUS TUF Gaming B650-Plus', ram:'Corsair Vengeance 32GB DDR5-5200',  storage:'Samsung 990 Pro 1TB', cooler:'be quiet! Dark Rock 4',        psu:'Corsair RM750x',      case:'Fractal Design Torrent' },
            high:    { gpu:'RTX 4060 Ti 8GB',        cpu:'AMD Ryzen 7 7700X',    motherboard:'ASUS TUF Gaming X670E-Plus',ram:'Kingston Fury Beast 64GB DDR5-5200',storage:'WD Black SN850X 2TB', cooler:'Noctua NH-D15',                psu:'Seasonic Focus GX-850', case:'Fractal Design Define 7 Silent' },
            ultra:   { gpu:'RTX 4060 Ti 16GB',       cpu:'AMD Ryzen 9 7900X',    motherboard:'MSI MEG X670E ACE',         ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'be quiet! Dark Rock Pro 5',    psu:'Corsair RM850x',      case:'Fractal Design Define 7 Silent' },
            nolimit: { gpu:'RTX 4070 Super 12GB',    cpu:'AMD Ryzen 9 7950X',    motherboard:'ASUS ROG Crosshair X670E',  ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Corsair HX1000',      case:'Corsair 7000D Airflow' },
        },
    },
    '3d': {
        label: '🧊 3D Artist', color: '#67e8f9',
        tagline: 'Blender, Maya, GPU-accelerated rendering',
        note: 'GPU VRAM holds scene geometry during rendering — 16GB+ prevents mesh spilling. 64GB RAM handles complex Blender scenes. Fast NVMe for texture libraries.',
        priorities: { gpu:10, cpu:8, ram:8, motherboard:5, storage:7, cooler:6, psu:6, case:4 },
        budgetWeights: { gpu:.38, cpu:.19, motherboard:.10, ram:.15, storage:.08, cooler:.05, psu:.04, case:.01 },
        prioritySlots: ['gpu','ram','cpu'],
        tiers: {
            entry:   { gpu:'RX 7800 XT 16GB',        cpu:'AMD Ryzen 5 5600X',    motherboard:'ASUS TUF Gaming B650-Plus', ram:'Corsair Vengeance 32GB DDR5-5200',   storage:'Kingston NV3 1TB',    cooler:'Deepcool AK620',               psu:'Corsair RM750x',      case:'Antec NX800' },
            mid:     { gpu:'RTX 4060 Ti 16GB',        cpu:'AMD Ryzen 7 7700X',    motherboard:'ASUS TUF Gaming X670E-Plus',ram:'Kingston Fury Beast 64GB DDR5-5200', storage:'Samsung 990 Pro 1TB', cooler:'Noctua NH-D15',                psu:'Seasonic Focus GX-850', case:'Lian Li PC-O11 Dynamic EVO' },
            high:    { gpu:'RTX 4070 Ti Super 16GB',  cpu:'AMD Ryzen 9 7900X',    motherboard:'MSI MEG X670E ACE',         ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'Samsung 990 Pro 2TB', cooler:'Noctua NH-D15',                psu:'Corsair RM850x',      case:'Lian Li PC-O11 Dynamic EVO' },
            ultra:   { gpu:'RTX 4080 Super 16GB',     cpu:'AMD Ryzen 9 7950X',    motherboard:'MSI MEG X670E ACE',         ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'Corsair H150i Elite LCD 360mm',psu:'Corsair HX1000',      case:'Lian Li PC-O11 Dynamic EVO XL' },
            nolimit: { gpu:'RTX 4090 24GB',           cpu:'AMD Ryzen 9 7950X',    motherboard:'ASUS ROG Crosshair X670E',  ram:'G.Skill Trident Z5 64GB DDR5-6000', storage:'WD Black SN850X 4TB', cooler:'NZXT Kraken 360 Elite',        psu:'Seasonic Prime TX-1000', case:'Lian Li PC-O11 Dynamic EVO XL' },
        },
    },
    budget: {
        label: '💸 Budget Build', color: '#fbbf24',
        tagline: '1080p gaming, office work & everyday tasks',
        note: 'Maximum value per dollar. The RX 7600 and Ryzen 5 combo is the best 1080p value. Kingston NV3 gives PCIe 4.0 speeds at a fraction of premium prices.',
        priorities: { gpu:7, cpu:6, ram:4, motherboard:3, storage:4, cooler:3, psu:3, case:2 },
        budgetWeights: { gpu:.32, cpu:.18, motherboard:.12, ram:.12, storage:.10, cooler:.07, psu:.06, case:.03 },
        prioritySlots: ['gpu','cpu'],
        tiers: {
            entry:   { gpu:'RX 7600 8GB',            cpu:'AMD Ryzen 3 4300G',    motherboard:'ASUS TUF Gaming B650-Plus', ram:'OLOy Blade 16GB DDR5-4800',         storage:'Kingston NV3 1TB',    cooler:'Noctua NH-U12S Redux',         psu:'EVGA 650W',           case:'Antec NX800' },
            mid:     { gpu:'RX 7600 8GB',            cpu:'AMD Ryzen 5 5500',     motherboard:'ASUS TUF Gaming B650-Plus', ram:'Kingston Fury Beast 16GB DDR5-4800',storage:'Kingston NV3 1TB',    cooler:'Arctic Liquid Freezer II 280mm',psu:'EVGA 650W',          case:'Antec NX800' },
            high:    { gpu:'RX 6700 XT 12GB',        cpu:'AMD Ryzen 5 5600X',    motherboard:'ASUS TUF Gaming B650-Plus', ram:'Corsair Vengeance 32GB DDR5-5200',  storage:'Kingston NV3 2TB',    cooler:'be quiet! Dark Rock 4',        psu:'EVGA SuperNOVA 850 G6', case:'Fractal Design Torrent' },
            ultra:   { gpu:'RX 7800 XT 16GB',        cpu:'AMD Ryzen 5 7600',     motherboard:'ASUS TUF Gaming B650-Plus', ram:'Corsair Vengeance 32GB DDR5-5200',  storage:'WD Black SN850X 1TB', cooler:'Noctua NH-D15',                psu:'Corsair RM750x',      case:'Fractal Design Torrent' },
            nolimit: { gpu:'RTX 4070 Super 12GB',    cpu:'Intel Core i5-14600K', motherboard:'MSI MAG Z790 Tomahawk',     ram:'Corsair Vengeance 32GB DDR5-5200',  storage:'Samsung 990 Pro 1TB', cooler:'NZXT Kraken 240 AIO',          psu:'Corsair RM850x',      case:'NZXT H9 Flow' },
        },
    },
}; // ← PERSONAS closes exactly ONCE here

let currentPersona = 'gamer';
const slotSelection = {};

function getBudgetTier(budget) {
    if (budget <= 750)  return 'entry';
    if (budget <= 1300) return 'mid';
    if (budget <= 2000) return 'high';
    if (budget <= 3500) return 'ultra';
    return 'nolimit';
}

function getCatProducts(cat) {
    if (!cat) return [];
    return DB_MAP[cat.trim().toLowerCase()] || [];
}
function getProductById(cat, id) {
    if (id == null) return null;
    return getCatProducts(cat).find(function(p) { return p.id === id; }) || null;
}
function findBestMatch(cat, hint) {
    const products = getCatProducts(cat);
    if (!products.length) return null;
    if (!hint) return products[0];
    const kws = hint.toLowerCase().split(/\s+/).filter(Boolean);
    const allMatch = products.find(p => kws.every(k => p.name.toLowerCase().includes(k)));
    if (allMatch) return allMatch;
    const scored = products.map(p => ({
        p, score: kws.filter(k => p.name.toLowerCase().includes(k)).length
    })).filter(x => x.score > 0).sort((a,b) => b.score - a.score);
    if (scored.length) return scored[0].p;
    return products[0];
}
function sortedByPrice(cat) {
    return [...getCatProducts(cat)].sort((a,b) => a.price - b.price);
}

function applyRecommendations() {
    const budget  = Number(document.getElementById('budgetSlider').value);
    const tier    = getBudgetTier(budget);
    const persona = PERSONAS[currentPersona];
    const tierHints = (persona.tiers && persona.tiers[tier]) ? persona.tiers[tier] : {};
    SLOTS.forEach(slot => {
        const hint = tierHints[slot.key] || '';
        const best = findBestMatch(slot.cat, hint);
        slotSelection[slot.key] = best ? best.id : null;
    });
    renderSlots();
    updateSummary();
    renderPersonaInfo();
    const el = document.getElementById('recBanner');
    if (el) {
        const tierLabel = { entry:'Entry', mid:'Mid', high:'High', ultra:'Ultra', nolimit:'No-limit' }[tier] || tier;
        el.innerHTML = '<div class="rec-banner"><span class="rec-banner-icon">✅</span>'
            + '<div class="rec-banner-text"><strong>' + tierLabel + '-tier build loaded</strong> for ' + persona.label + '. '
            + 'Every component is pre-selected from your database — swap anything below to customise.</div></div>';
    }
}

function reApplyDefaults() {
    SLOTS.forEach(s => delete slotSelection[s.key]);
    applyRecommendations();
}

function renderPersonaInfo() {
    const persona = PERSONAS[currentPersona];
    const prio = persona.priorities;
    const bars = [
        { key:'gpu',     label:'GPU',     cls:'fill-gpu'     },
        { key:'cpu',     label:'CPU',     cls:'fill-cpu'     },
        { key:'ram',     label:'RAM',     cls:'fill-ram'     },
        { key:'storage', label:'Storage', cls:'fill-storage' },
    ];
    const barsHTML = bars.map(b => {
        const pct = Math.round((prio[b.key] || 0) * 10);
        return '<div class="priority-row">'
            + '<span class="priority-label">' + b.label + '</span>'
            + '<div class="priority-track"><div class="priority-fill ' + b.cls + '" style="width:' + pct + '%"></div></div>'
            + '<span class="priority-pct">' + pct + '%</span></div>';
    }).join('');
    const parts = persona.label.split(' ');
    const emoji = parts[0];
    const name  = parts.slice(1).join(' ');
    document.getElementById('personaInfo').innerHTML =
        '<div class="persona-info-header"><span class="persona-info-icon">' + emoji + '</span>'
        + '<div><div class="persona-info-title">' + name + '</div>'
        + '<div class="persona-info-sub">' + persona.tagline + '</div></div></div>'
        + '<div class="priority-bars">' + barsHTML + '</div>';
}

function renderSlots() {
    const container = document.getElementById('componentSlots');
    container.innerHTML = '';
    const persona = PERSONAS[currentPersona];
    const prioritySlots = persona.prioritySlots || [];

    SLOTS.forEach((slot, idx) => {
        const products = getCatProducts(slot.cat);
        if (!products.length) {
            container.innerHTML += '<div class="component-slot slot-anim" style="animation-delay:' + (idx*35) + 'ms">'
                + '<div class="slot-header"><div class="slot-icon">' + slot.icon + '</div>'
                + '<span class="slot-label-text">' + slot.label + '</span>'
                + '<span style="font-size:11px;color:var(--text-dim)">No products in DB</span></div></div>';
            return;
        }
        const selectedId   = slotSelection[slot.key];
        const sorted       = sortedByPrice(slot.cat);
        const selectedProd = getProductById(slot.cat, selectedId) || sorted[0];
        slotSelection[slot.key] = selectedProd.id;
        const isPriority = prioritySlots.includes(slot.key);
        const curIdx     = sorted.findIndex(p => p.id === selectedProd.id);

        const optionsHTML = sorted.map(p =>
        `<option value="\${p.id}" \${p.id == selectedProd.id ? 'selected' : ''}>\${p.name} — $\${Number(p.price).toFixed(2)}</option>`
    ).join('');

        const upgradeBtn   = curIdx < sorted.length - 1
            ? '<button class="slot-upgrade-btn" onclick="upgradeSlot(\'' + slot.key + '\',\'' + slot.cat + '\')">▲ Upgrade</button>' : '';
        const downgradeBtn = curIdx > 0
            ? '<button class="slot-downgrade-btn" onclick="downgradeSlot(\'' + slot.key + '\',\'' + slot.cat + '\')">▼ Save Money</button>' : '';

        let stockClass = 'stock-ok', stockText = '';
        if (selectedProd.stock === 0)       { stockClass = 'stock-out'; stockText = '✗ Out of stock'; }
        else if (selectedProd.stock <= 5)   { stockClass = 'stock-low'; stockText = '⚠ Only ' + selectedProd.stock + ' left'; }
        else                                { stockText = '✓ In stock (' + selectedProd.stock + ')'; }

        const priorityTag = isPriority ? '<span class="slot-priority-tag">★ Priority</span>' : '';

        container.innerHTML +=
            '<div class="component-slot ' + (isPriority ? 'priority-slot' : '') + ' slot-anim" style="animation-delay:' + (idx*35) + 'ms" id="slot_' + slot.key + '">'
            + '<div class="slot-header"><div class="slot-icon">' + slot.icon + '</div>'
            + '<span class="slot-label-text">' + slot.label + '</span>'
            + priorityTag
            + '<span class="slot-price-badge" id="slotPrice_' + slot.key + '">$' + Number(selectedProd.price).toFixed(2) + '</span></div>'
            + '<div class="slot-body"><div class="slot-select-wrap">'
            + '<select class="slot-native-select" onchange="onSlotChange(\'' + slot.key + '\',\'' + slot.cat + '\',parseInt(this.value))">'
            + optionsHTML + '</select></div>'
            + '<div class="slot-actions">' + downgradeBtn + upgradeBtn
            + '<span class="slot-stock-badge ' + stockClass + '">' + stockText + '</span></div></div></div>';
    });

    const noteEl = document.getElementById('buildNote');
    if (persona.note) { noteEl.textContent = persona.note; noteEl.style.display = 'block'; }
    else              { noteEl.style.display = 'none'; }
}

function onSlotChange(slotKey, cat, productId) {
    slotSelection[slotKey] = productId;
    const prod = getProductById(cat, productId);
    if (prod) document.getElementById('slotPrice_' + slotKey).textContent = '$' + Number(prod.price).toFixed(2);
    updateSummary();
    renderSlots();
}
function upgradeSlot(slotKey, cat) {
    const sorted = sortedByPrice(cat);
    const curIdx = sorted.findIndex(p => p.id === slotSelection[slotKey]);
    if (curIdx < sorted.length - 1) { slotSelection[slotKey] = sorted[curIdx + 1].id; updateSummary(); renderSlots(); }
}
function downgradeSlot(slotKey, cat) {
    const sorted = sortedByPrice(cat);
    const curIdx = sorted.findIndex(p => p.id === slotSelection[slotKey]);
    if (curIdx > 0) { slotSelection[slotKey] = sorted[curIdx - 1].id; updateSummary(); renderSlots(); }
}

function optimizeBuild() {
    const budget   = Number(document.getElementById('budgetSlider').value);
    const persona  = PERSONAS[currentPersona];
    const weights  = persona.budgetWeights;
    const priority = persona.prioritySlots || [];
    SLOTS.forEach(slot => {
        const products = sortedByPrice(slot.cat);
        if (!products.length) return;
        const isPriority = priority.includes(slot.key);
        const target = budget * (weights[slot.key] || 0.1) * (isPriority ? 1.25 : 1.0);
        let best = products[0];
        for (const p of products) { if (p.price <= target) best = p; }
        slotSelection[slot.key] = best.id;
    });
    renderSlots(); updateSummary();
    const el = document.getElementById('recBanner');
    if (el) el.innerHTML = '<div class="rec-banner"><span class="rec-banner-icon">✨</span>'
        + '<div class="rec-banner-text"><strong>Build optimised for $' + Number(budget).toLocaleString() + '.</strong> '
        + 'Each component selected to maximise performance within your budget.</div></div>';
}

function updateSummary() {
    const breakdown = document.getElementById('priceBreakdown');
    const persona   = PERSONAS[currentPersona];
    const priority  = persona.prioritySlots || [];
    breakdown.innerHTML = '';
    let total = 0;

    SLOTS.forEach(slot => {
        const prod   = getProductById(slot.cat, slotSelection[slot.key]);
        const isPrio = priority.includes(slot.key);
        if (!prod) {
            breakdown.innerHTML += '<div class="price-row"><div class="price-row-left">'
                + '<span class="price-row-icon">' + slot.icon + '</span>'
                + '<div class="price-row-info"><div class="price-row-label">' + slot.label + '</div>'
                + '<div class="price-row-name" style="color:var(--text-dim)">Not available</div></div></div>'
                + '<span class="price-row-val none">—</span></div>';
            return;
        }
        const price = Number(prod.price);
        total += price;
        breakdown.innerHTML += '<div class="price-row"><div class="price-row-left">'
            + '<span class="price-row-icon">' + slot.icon + '</span>'
            + '<div class="price-row-info"><div class="price-row-label">' + slot.label + (isPrio ? ' ★' : '') + '</div>'
            + '<div class="price-row-name" title="' + prod.name + '">' + prod.name + '</div></div></div>'
            + '<span class="price-row-val ' + (isPrio ? 'priority' : '') + '">$' + price.toFixed(2) + '</span></div>';
    });

    const totalStr = '$' + total.toFixed(2);
    document.getElementById('totalPrice').textContent = totalStr;
    document.getElementById('mobileTotalPrice').textContent = totalStr;
    document.getElementById('pricePerDay').textContent = total > 0
        ? '≈ $' + (total / (3 * 365)).toFixed(2) + '/day amortised over 3 years' : '';

    const budget = Number(document.getElementById('budgetSlider').value);
    const pct    = budget > 0 ? Math.min((total / budget) * 100, 100) : 0;
    const fill   = document.getElementById('budgetGaugeFill');
    const statusEl = document.getElementById('budgetStatus');
    document.getElementById('budgetSpent').textContent = '$' + total.toFixed(0);
    document.getElementById('budgetOf').textContent    = 'of $' + budget.toLocaleString();
    fill.style.width = pct + '%';

    if (total > budget && total > 0) {
        fill.className = 'budget-gauge-fill gauge-over';
        statusEl.textContent = '⚠ $' + (total - budget).toFixed(0) + ' over budget';
        statusEl.className   = 'budget-status budget-over-pill';
    } else if (pct > 85) {
        fill.className = 'budget-gauge-fill gauge-warn';
        statusEl.textContent = '✓ $' + (budget - total).toFixed(0) + ' remaining';
        statusEl.className   = 'budget-status budget-warn-pill';
    } else {
        fill.className = 'budget-gauge-fill gauge-ok';
        statusEl.textContent = '✓ $' + (budget - total).toFixed(0) + ' remaining';
        statusEl.className   = 'budget-status budget-ok-pill';
    }
}

function selectPersona(el, key) {
    var card = el.closest ? el.closest('.persona-card') : el;
    document.querySelectorAll('.persona-card').forEach(function(c) { c.classList.remove('selected'); });
    card.classList.add('selected');
    currentPersona = key;
    SLOTS.forEach(function(s) { delete slotSelection[s.key]; });
    document.getElementById('personaChip').textContent = PERSONAS[key].label;
    applyRecommendations();
}

function onBudgetChange(val) {
    val = parseInt(val);
    document.getElementById('budgetDisplay').textContent = '$' + val.toLocaleString();
    const hints = [
        { max:700,  text:'Entry-level — budget build recommended. Great for 1080p and office tasks.' },
        { max:1000, text:'Good range for 1080p gaming and everyday productivity.' },
        { max:1500, text:'Mid-range — solid 1440p gaming or light creative work.' },
        { max:2000, text:'Upper mid-range — strong 1440p or capable creative workstation.' },
        { max:2800, text:'High-end — excellent 1440p/4K gaming or professional workloads.' },
        { max:9999, text:'No-compromise — peak consumer-grade hardware, nothing cut.' },
    ];
    document.getElementById('budgetHint').textContent = (hints.find(h => val <= h.max) || hints[hints.length-1]).text;
    const tiers = [700, 1200, 1800, 2800, 6000];
    document.querySelectorAll('.tier-pill').forEach((pill, i) => {
        pill.classList.toggle('active', val <= tiers[i] && (i === 0 || val > tiers[i-1]));
    });
    SLOTS.forEach(s => delete slotSelection[s.key]);
    applyRecommendations();
}

function setTier(val) {
    const slider = document.getElementById('budgetSlider');
    slider.value = val;
    onBudgetChange(val);
}

function addToCart() {
    let total = 0;
    const lines = SLOTS.map(slot => {
        const prod = getProductById(slot.cat, slotSelection[slot.key]);
        if (!prod) return '';
        total += Number(prod.price);
        return '• ' + prod.name + ' ($' + Number(prod.price).toFixed(2) + ')';
    }).filter(Boolean).join('\n');
    if (!confirm('Add this build to cart?\n\n' + lines + '\n\nTotal: $' + total.toFixed(2))) return;
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '<%= request.getContextPath() %>/cart/addBuild';
    SLOTS.forEach(slot => {
        const prod = getProductById(slot.cat, slotSelection[slot.key]);
        if (prod) { const inp = document.createElement('input'); inp.type='hidden'; inp.name='productId'; inp.value=prod.id; form.appendChild(inp); }
    });
    const pi = document.createElement('input'); pi.type='hidden'; pi.name='persona'; pi.value=currentPersona; form.appendChild(pi);
    document.body.appendChild(form); form.submit();
}

function saveBuild() {
    const data = { persona: currentPersona, budget: document.getElementById('budgetSlider').value, slots: {}, at: new Date().toISOString() };
    SLOTS.forEach(slot => {
        const prod = getProductById(slot.cat, slotSelection[slot.key]);
        if (prod) data.slots[slot.key] = { id: prod.id, name: prod.name, price: prod.price };
    });
    localStorage.setItem('db_build_' + currentPersona, JSON.stringify(data));
    alert('Build saved locally!');
}

function shareBuild() {
    const p = new URLSearchParams({ persona: currentPersona, budget: document.getElementById('budgetSlider').value });
    SLOTS.forEach(slot => { if (slotSelection[slot.key] != null) p.set(slot.key + 'Id', slotSelection[slot.key]); });
    const url = location.origin + location.pathname + '?' + p;
    if (navigator.clipboard) { navigator.clipboard.writeText(url).then(() => alert('Share link copied!')); }
    else { prompt('Copy this link:', url); }
}

function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    const isOpen  = sidebar.classList.toggle('mobile-open');
    overlay.classList.toggle('active', isOpen);
    document.body.style.overflow = isOpen ? 'hidden' : '';
}
window.addEventListener('resize', function() {
    if (window.innerWidth > 900) {
        document.getElementById('sidebar').classList.remove('mobile-open');
        document.getElementById('sidebarOverlay').classList.remove('active');
        document.body.style.overflow = '';
    }
});

(function init() {
    const params = new URLSearchParams(location.search);
    const pp = params.get('persona');
    if (pp && PERSONAS[pp]) {
        currentPersona = pp;
        document.querySelectorAll('.persona-card').forEach(card => {
            const oc = card.getAttribute('onclick') || '';
            card.classList.toggle('selected', oc.includes("'" + pp + "'"));
        });
        SLOTS.forEach(slot => {
            const id = parseInt(params.get(slot.key + 'Id'));
            if (!isNaN(id)) slotSelection[slot.key] = id;
        });
        const budget = params.get('budget');
        if (budget) {
            document.getElementById('budgetSlider').value = budget;
            document.getElementById('budgetDisplay').textContent = '$' + Number(budget).toLocaleString();
        }
        if (SLOTS.some(s => params.get(s.key + 'Id'))) {
            renderSlots(); updateSummary(); renderPersonaInfo();
            document.getElementById('personaChip').textContent = PERSONAS[currentPersona].label;
            return;
        }
    }
    document.getElementById('personaChip').textContent = PERSONAS[currentPersona].label;
    applyRecommendations();
})();
</script>
</body>
</html>
