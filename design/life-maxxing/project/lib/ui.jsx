// lib/ui.jsx — LifeMaxxing design system: dark, data-driven dashboard
// Tokens, primitives, line-icon set, and tiny hand-built SVG charts.
// Exports to window for use across babel script files.

const T = {
  bg:        '#0C0D11',
  bg2:       '#111319',
  card:      '#15171E',
  cardHi:    '#1B1E27',
  border:    'rgba(255,255,255,0.07)',
  borderHi:  'rgba(255,255,255,0.13)',
  text:      '#F3F5F9',
  textDim:   '#99A0AE',
  textFaint: '#5C636F',
  accent:    '#6AA8FF',
  accentSoft:'rgba(106,168,255,0.14)',
  green:     '#5FD08A',
  greenSoft: 'rgba(95,208,138,0.14)',
  red:       '#FF7A6B',
  redSoft:   'rgba(255,122,107,0.14)',
  amber:     '#F5C36B',
  amberSoft: 'rgba(245,195,107,0.14)',
  purple:    '#C9A8FF',
  purpleSoft:'rgba(201,168,255,0.14)',
  pink:      '#FF9EC4',
};

const FS = "'IBM Plex Sans', system-ui, sans-serif";
const FM = "'IBM Plex Mono', ui-monospace, monospace";

// ── Card ──────────────────────────────────────────────────────────
function Card({ children, style, onClick, pad = 16, hi = false }) {
  return (
    <div onClick={onClick} style={{
      background: hi ? T.cardHi : T.card,
      border: `1px solid ${T.border}`,
      borderRadius: 18, padding: pad, boxSizing: 'border-box',
      ...(onClick ? { cursor: 'pointer' } : {}),
      ...style,
    }}>{children}</div>
  );
}

// ── Section label (uppercase mono eyebrow) ────────────────────────
function Eyebrow({ children, style }) {
  return (
    <div style={{
      fontFamily: FM, fontSize: 11, letterSpacing: 1.5, textTransform: 'uppercase',
      color: T.textFaint, fontWeight: 500, ...style,
    }}>{children}</div>
  );
}

// ── Pill / chip ───────────────────────────────────────────────────
function Pill({ children, color = T.accent, bg, style }) {
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 5,
      fontFamily: FM, fontSize: 11, fontWeight: 500, letterSpacing: 0.3,
      color, background: bg || 'rgba(255,255,255,0.05)',
      padding: '3px 9px', borderRadius: 100, lineHeight: 1.4, ...style,
    }}>{children}</span>
  );
}

// ── Delta indicator (▲/▼ with % ) ─────────────────────────────────
function Delta({ value, invert = false, suffix = '%' }) {
  const up = value >= 0;
  const good = invert ? !up : up;
  const col = good ? T.green : T.red;
  return (
    <span style={{ fontFamily: FM, fontSize: 12, color: col, display: 'inline-flex', alignItems: 'center', gap: 2 }}>
      <span style={{ fontSize: 9 }}>{up ? '▲' : '▼'}</span>{Math.abs(value)}{suffix}
    </span>
  );
}

// ── Icon set (24x24 stroke icons) ─────────────────────────────────
function Icon({ name, size = 22, color = 'currentColor', sw = 1.7, fill = 'none', style }) {
  const P = {
    home:    <><path d="M3 10.5 12 3l9 7.5"/><path d="M5 9.5V20h14V9.5"/></>,
    bolt:    <path d="M13 2 4 13h6l-1 9 9-12h-6l1-8z"/>,
    food:    <><path d="M5 3v7a2 2 0 0 0 4 0V3"/><path d="M7 10v11"/><path d="M17 3c-1.5 0-3 1.8-3 5s1 4 1 4v9"/></>,
    expense: <><rect x="2.5" y="6" width="19" height="12" rx="2"/><circle cx="12" cy="12" r="2.6"/></>,
    income:  <><path d="M12 3v13"/><path d="m7 11 5 5 5-5"/><path d="M5 21h14"/></>,
    heart:   <><path d="M12 20s-7-4.3-9.2-8.6C1.3 8.2 3 5 6 5c2 0 3.2 1.3 4 2.5C10.8 6.3 12 5 14 5c3 0 4.7 3.2 3.2 6.4C19 15.7 12 20 12 20z"/></>,
    pulse:   <><path d="M2 12h4l2-6 4 14 3-9 2 3h5"/></>,
    pill:    <><rect x="3.5" y="9" width="17" height="6" rx="3" transform="rotate(45 12 12)"/><path d="M8.5 8.5 15.5 15.5"/></>,
    run:     <><circle cx="14" cy="4.5" r="2"/><path d="M11 21l1.5-6L9 12l1-5 4 2 3 1"/><path d="m6 10 3-2"/><path d="m11 15-3 1-2 4"/></>,
    steps:   <><path d="M7 4c1.5 0 2.5 1.5 2.5 4S8.5 14 7 14s-2.5-1.2-2.5-4S5.5 4 7 4z"/><path d="M5 16c2 0 3 1 3 2.5S7 21 5.5 21 3 20 3 18.5 3.5 16 5 16z"/><path d="M17 7c1.5 0 2.5 1.5 2.5 4S18.5 17 17 17s-2.5-1.2-2.5-4S15.5 7 17 7z"/><path d="M15 19c2 0 3 .5 3 1.5" opacity="0"/></>,
    camera:  <><path d="M4 8h3l1.5-2h7L17 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1z"/><circle cx="12" cy="13" r="3.2"/></>,
    bucket:  <><path d="m12 3 2.3 5.6 6 .5-4.6 4 1.4 5.9L12 20.9 6.9 24l1.4-5.9-4.6-4 6-.5L12 3z" transform="scale(0.92) translate(1 -1)"/></>,
    trip:    <><path d="M2 16l8-2 4-9 1.5.4-1.8 8 5.3-1.4 1-2 1.2.3-.6 3.3L20 15l-1 3.6L4 21z"/></>,
    labs:    <><path d="M9 3h6"/><path d="M10 3v6l-5 9a1.6 1.6 0 0 0 1.5 2.3h11A1.6 1.6 0 0 0 19 18l-5-9V3"/><path d="M7.5 15h9"/></>,
    event:   <><rect x="3.5" y="5" width="17" height="16" rx="2"/><path d="M3.5 9.5h17"/><path d="M8 3v4M16 3v4"/><path d="M12 12.5v4M10 14.5h4"/></>,
    chart:   <><path d="M4 4v16h16"/><rect x="7" y="11" width="3" height="6"/><rect x="12.5" y="7" width="3" height="10"/><rect x="18" y="13" width="0" height="4" opacity="0"/></>,
    export:  <><path d="M12 15V3"/><path d="m8 7 4-4 4 4"/><path d="M5 13v6a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-6"/></>,
    search:  <><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></>,
    calendar:<><rect x="3.5" y="5" width="17" height="16" rx="2"/><path d="M3.5 9.5h17M8 3v4M16 3v4"/></>,
    plus:    <><path d="M12 5v14M5 12h14"/></>,
    chevR:   <path d="m9 5 7 7-7 7"/>,
    chevL:   <path d="m15 5-7 7 7 7"/>,
    chevD:   <path d="m5 9 7 7 7-7"/>,
    close:   <><path d="M6 6l12 12M18 6 6 18"/></>,
    check:   <path d="m4 12 5 5L20 6"/>,
    edit:    <><path d="M4 20h4L19 9l-4-4L4 16v4z"/><path d="m14 6 4 4"/></>,
    trash:   <><path d="M4 7h16M9 7V4h6v3M6 7l1 13h10l1-13"/></>,
    mood:    <><circle cx="12" cy="12" r="9"/><path d="M8.5 14.5s1.3 2 3.5 2 3.5-2 3.5-2"/><path d="M9 9.5h.01M15 9.5h.01"/></>,
    clock:   <><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/></>,
    drop:    <><path d="M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11z"/></>,
    screen:  <><rect x="6" y="2.5" width="12" height="19" rx="2.5"/><path d="M10.5 18.5h3"/></>,
    dumbbell:<><path d="M6.5 8v8M3.5 9.5v5M17.5 8v8M20.5 9.5v5M6.5 12h11"/></>,
    star:    <path d="m12 3 2.6 6.3 6.8.5-5.2 4.4 1.6 6.6L12 17.7 6.2 21.3l1.6-6.6L2.6 9.8l6.8-.5L12 3z"/>,
    flag:    <><path d="M5 21V4M5 4h11l-2 4 2 4H5"/></>,
    pin:     <><path d="M12 21s7-5.5 7-11a7 7 0 1 0-14 0c0 5.5 7 11 7 11z"/><circle cx="12" cy="10" r="2.5"/></>,
    arrowR:  <><path d="M5 12h14M13 6l6 6-6 6"/></>,
    filter:  <><path d="M3 5h18l-7 8v6l-4 2v-8L3 5z"/></>,
    dots:    <><circle cx="5" cy="12" r="1.4"/><circle cx="12" cy="12" r="1.4"/><circle cx="19" cy="12" r="1.4"/></>,
    sun:     <><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M2 12h2M20 12h2M5 5l1.5 1.5M17.5 17.5 19 19M19 5l-1.5 1.5M6.5 17.5 5 19"/></>,
  };
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={color}
      strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, ...style }}>
      {P[name] || P.dots}
    </svg>
  );
}

// ── Sparkline (line chart) ────────────────────────────────────────
function Sparkline({ data, w = 120, h = 36, color = T.accent, fill = true, sw = 2 }) {
  const min = Math.min(...data), max = Math.max(...data);
  const rng = max - min || 1;
  const pts = data.map((v, i) => [
    (i / (data.length - 1)) * w,
    h - 3 - ((v - min) / rng) * (h - 6),
  ]);
  const d = pts.map((p, i) => `${i ? 'L' : 'M'}${p[0].toFixed(1)} ${p[1].toFixed(1)}`).join(' ');
  const area = `${d} L${w} ${h} L0 ${h} Z`;
  const id = 'sg' + Math.random().toString(36).slice(2, 7);
  return (
    <svg width={w} height={h} viewBox={`0 0 ${w} ${h}`} style={{ display: 'block' }}>
      {fill && <>
        <defs><linearGradient id={id} x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor={color} stopOpacity="0.28"/>
          <stop offset="100%" stopColor={color} stopOpacity="0"/>
        </linearGradient></defs>
        <path d={area} fill={`url(#${id})`}/>
      </>}
      <path d={d} fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  );
}

// ── Mini bars ─────────────────────────────────────────────────────
function MiniBars({ data, w = 120, h = 40, color = T.accent, gap = 3, highlight = -1 }) {
  const max = Math.max(...data) || 1;
  const bw = (w - gap * (data.length - 1)) / data.length;
  return (
    <svg width={w} height={h} viewBox={`0 0 ${w} ${h}`} style={{ display: 'block' }}>
      {data.map((v, i) => {
        const bh = Math.max(2, (v / max) * (h - 2));
        return <rect key={i} x={i * (bw + gap)} y={h - bh} width={bw} height={bh} rx={Math.min(3, bw / 2)}
          fill={i === highlight ? color : (highlight >= 0 ? 'rgba(255,255,255,0.13)' : color)} />;
      })}
    </svg>
  );
}

// ── Donut / ring ──────────────────────────────────────────────────
function Ring({ value, max = 100, size = 92, sw = 9, color = T.accent, track = 'rgba(255,255,255,0.08)', children }) {
  const r = (size - sw) / 2, c = 2 * Math.PI * r;
  const off = c - Math.min(1, value / max) * c;
  return (
    <div style={{ position: 'relative', width: size, height: size }}>
      <svg width={size} height={size} style={{ transform: 'rotate(-90deg)' }}>
        <circle cx={size/2} cy={size/2} r={r} fill="none" stroke={track} strokeWidth={sw}/>
        <circle cx={size/2} cy={size/2} r={r} fill="none" stroke={color} strokeWidth={sw}
          strokeDasharray={c} strokeDashoffset={off} strokeLinecap="round"
          style={{ transition: 'stroke-dashoffset .6s ease' }}/>
      </svg>
      <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center' }}>{children}</div>
    </div>
  );
}

// ── Segmented donut (categories) ──────────────────────────────────
function SegRing({ segs, size = 96, sw = 14, children }) {
  const r = (size - sw) / 2, c = 2 * Math.PI * r;
  const total = segs.reduce((s, x) => s + x.value, 0) || 1;
  let acc = 0;
  return (
    <div style={{ position: 'relative', width: size, height: size }}>
      <svg width={size} height={size} style={{ transform: 'rotate(-90deg)' }}>
        <circle cx={size/2} cy={size/2} r={r} fill="none" stroke="rgba(255,255,255,0.06)" strokeWidth={sw}/>
        {segs.map((s, i) => {
          const frac = s.value / total;
          const dash = frac * c;
          const el = <circle key={i} cx={size/2} cy={size/2} r={r} fill="none" stroke={s.color} strokeWidth={sw}
            strokeDasharray={`${dash - 1.5} ${c - dash + 1.5}`} strokeDashoffset={-acc * c} strokeLinecap="round"/>;
          acc += frac;
          return el;
        })}
      </svg>
      <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center' }}>{children}</div>
    </div>
  );
}

Object.assign(window, {
  T, FS, FM, Card, Eyebrow, Pill, Delta, Icon, Sparkline, MiniBars, Ring, SegRing,
});
