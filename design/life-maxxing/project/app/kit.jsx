// app/kit.jsx — navigation context, shell chrome, bottom sheet + form controls.
// Loaded after lib/ui + lib/data, before screen modules. Exports to window.
const { useState, useContext, createContext, useRef, useEffect } = React;

const NavCtx = createContext(null);
const useNav = () => useContext(NavCtx);

// ── Top bar (back + title + right slot) ───────────────────────────
function TopBar({ title, sub, right, onBack }) {
  const nav = useNav();
  const back = onBack || (nav && nav.canBack ? nav.back : null);
  return (
    <div style={{ display:'flex', alignItems:'center', gap:12, padding:'12px 16px 10px',
      position:'sticky', top:0, zIndex:5, background:'rgba(12,13,17,0.86)',
      backdropFilter:'blur(12px)', borderBottom:`1px solid ${T.border}` }}>
      {back && (
        <div onClick={back} style={{ width:38, height:38, borderRadius:12, background:T.card,
          border:`1px solid ${T.border}`, display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}>
          <Icon name="chevL" size={20} color={T.text}/>
        </div>
      )}
      <div style={{ flex:1, minWidth:0 }}>
        <div style={{ fontFamily:FS, fontSize:18, fontWeight:700, letterSpacing:-0.3, color:T.text }}>{title}</div>
        {sub && <div style={{ fontFamily:FM, fontSize:11.5, color:T.textFaint }}>{sub}</div>}
      </div>
      {right}
    </div>
  );
}

// ── Scrollable screen body ────────────────────────────────────────
function Body({ children, style }) {
  return <div style={{ flex:1, overflowY:'auto', overflowX:'hidden', WebkitOverflowScrolling:'touch',
    padding:'14px 16px 22px', ...style }}>{children}</div>;
}

// ── Period selector ───────────────────────────────────────────────
const PERIODS = ['Днес','7 дни','30 дни','Месец','Custom'];
function PeriodChips({ value, onChange }) {
  return (
    <div style={{ display:'flex', gap:7, overflowX:'auto', paddingBottom:2, marginBottom:14 }}>
      {PERIODS.map(p => (
        <button key={p} onClick={()=>onChange&&onChange(p)} style={{
          flexShrink:0, fontFamily:FM, fontSize:12, padding:'7px 13px', borderRadius:100, cursor:'pointer',
          border:`1px solid ${value===p?T.accent:T.border}`,
          background: value===p?T.accentSoft:'transparent', color: value===p?T.accent:T.textDim }}>{p}</button>
      ))}
    </div>
  );
}

// ── Stat number block ─────────────────────────────────────────────
function Stat({ label, value, unit, color = T.text, sub }) {
  return (
    <div>
      <Eyebrow>{label}</Eyebrow>
      <div style={{ fontFamily:FM, fontSize:22, fontWeight:600, color, marginTop:4, lineHeight:1.1 }}>
        {value}{unit && <span style={{ fontSize:12, color:T.textFaint, fontWeight:400 }}> {unit}</span>}
      </div>
      {sub && <div style={{ fontSize:11, color:T.textDim, marginTop:2 }}>{sub}</div>}
    </div>
  );
}

// ── Generic list row ──────────────────────────────────────────────
function Row({ icon, color, title, sub, right, onClick, tag }) {
  return (
    <div onClick={onClick} style={{ display:'flex', alignItems:'center', gap:13, padding:'12px 14px',
      background:T.card, border:`1px solid ${T.border}`, borderRadius:15, cursor:onClick?'pointer':'default' }}>
      {icon && <div style={{ width:40, height:40, borderRadius:12, background:'rgba(255,255,255,0.05)',
        display:'flex', alignItems:'center', justifyContent:'center', flexShrink:0 }}>
        <Icon name={icon} size={20} color={color||T.textDim}/></div>}
      <div style={{ flex:1, minWidth:0 }}>
        <div style={{ display:'flex', alignItems:'center', gap:8 }}>
          <span style={{ fontFamily:FS, fontSize:14, fontWeight:600, color:T.text, overflow:'hidden', textOverflow:'ellipsis', whiteSpace:'nowrap' }}>{title}</span>
          {tag}
        </div>
        {sub && <div style={{ fontSize:12, color:T.textDim, marginTop:2, overflow:'hidden', textOverflow:'ellipsis', whiteSpace:'nowrap' }}>{sub}</div>}
      </div>
      {right}
    </div>
  );
}

function SectionTitle({ children, action }) {
  return (
    <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', margin:'18px 2px 10px' }}>
      <Eyebrow>{children}</Eyebrow>
      {action}
    </div>
  );
}

// ── Bottom nav ────────────────────────────────────────────────────
function BottomNav() {
  const nav = useNav();
  const active = nav.screen;
  const items = [
    { id:'home', icon:'home', label:'Начало' },
    { id:'stats', icon:'chart', label:'Графики' },
    { id:'plus' },
    { id:'memories', icon:'camera', label:'Спомени' },
    { id:'more', icon:'dots', label:'Още' },
  ];
  return (
    <div style={{ display:'flex', alignItems:'center', justifyContent:'space-around', flexShrink:0,
      padding:'8px 10px 8px', background:'rgba(12,13,17,0.94)', borderTop:`1px solid ${T.border}`, backdropFilter:'blur(12px)' }}>
      {items.map(it => it.id==='plus' ? (
        <div key="plus" onClick={()=>nav.openSheet('quick')} style={{ width:52, height:52, borderRadius:18, background:T.accent,
          display:'flex', alignItems:'center', justifyContent:'center', marginTop:-22, cursor:'pointer',
          boxShadow:'0 8px 22px rgba(106,168,255,0.45)' }}>
          <Icon name="plus" size={26} color="#0C0D11" sw={2.4}/>
        </div>
      ) : (
        <div key={it.id} onClick={()=>nav.tab(it.id)} style={{ display:'flex', flexDirection:'column', alignItems:'center',
          gap:3, width:60, cursor:'pointer' }}>
          <Icon name={it.icon} size={22} color={active===it.id?T.accent:T.textFaint}/>
          <span style={{ fontFamily:FS, fontSize:10, color:active===it.id?T.accent:T.textFaint }}>{it.label}</span>
        </div>
      ))}
    </div>
  );
}

// ── Bottom sheet ──────────────────────────────────────────────────
function Sheet({ title, sub, children, onClose, footer, maxH = '90%' }) {
  return (
    <div style={{ position:'absolute', inset:0, zIndex:40, display:'flex', flexDirection:'column',
      justifyContent:'flex-end' }}>
      <div onClick={onClose} style={{ position:'absolute', inset:0, background:'rgba(0,0,0,0.55)' }}/>
      <div style={{ position:'relative', background:T.bg2, borderTopLeftRadius:26, borderTopRightRadius:26,
        border:`1px solid ${T.border}`, borderBottom:'none', maxHeight:maxH, display:'flex', flexDirection:'column' }}>
        <div style={{ padding:'10px 0 4px', display:'flex', justifyContent:'center' }}>
          <div style={{ width:38, height:4, borderRadius:3, background:'rgba(255,255,255,0.18)' }}/>
        </div>
        <div style={{ display:'flex', alignItems:'flex-start', justifyContent:'space-between', padding:'6px 18px 12px' }}>
          <div>
            <div style={{ fontFamily:FS, fontSize:19, fontWeight:700, color:T.text, letterSpacing:-0.3 }}>{title}</div>
            {sub && <div style={{ fontFamily:FM, fontSize:11.5, color:T.textFaint, marginTop:2 }}>{sub}</div>}
          </div>
          <div onClick={onClose} style={{ width:34, height:34, borderRadius:11, background:T.card, border:`1px solid ${T.border}`,
            display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}>
            <Icon name="close" size={18} color={T.textDim}/></div>
        </div>
        <div style={{ overflowY:'auto', padding:'2px 18px 16px' }}>{children}</div>
        {footer && <div style={{ padding:'12px 18px calc(16px + env(safe-area-inset-bottom))', borderTop:`1px solid ${T.border}`,
          background:T.bg2 }}>{footer}</div>}
      </div>
    </div>
  );
}

// ── Buttons ───────────────────────────────────────────────────────
function Btn({ children, onClick, variant = 'primary', full, icon, style }) {
  const v = {
    primary: { background:T.accent, color:'#0C0D11', border:'none' },
    ghost:   { background:T.card, color:T.text, border:`1px solid ${T.border}` },
    danger:  { background:T.redSoft, color:T.red, border:`1px solid rgba(255,122,107,0.3)` },
  }[variant];
  return (
    <button onClick={onClick} style={{ ...v, fontFamily:FS, fontSize:15, fontWeight:600, padding:'13px 18px',
      borderRadius:14, cursor:'pointer', width:full?'100%':'auto', display:'inline-flex', alignItems:'center',
      justifyContent:'center', gap:8, ...style }}>
      {icon && <Icon name={icon} size={18} color={variant==='primary'?'#0C0D11':'currentColor'} sw={2}/>}
      {children}
    </button>
  );
}

// ── Form controls ─────────────────────────────────────────────────
function Field({ label, children, required, hint }) {
  return (
    <div style={{ marginBottom:14 }}>
      <div style={{ display:'flex', gap:6, alignItems:'center', marginBottom:7 }}>
        <span style={{ fontFamily:FM, fontSize:11, letterSpacing:0.8, textTransform:'uppercase', color:T.textDim }}>{label}</span>
        {required && <span style={{ color:T.accent, fontSize:11 }}>•</span>}
        {hint && <span style={{ fontSize:11, color:T.textFaint, marginLeft:'auto', fontFamily:FM }}>{hint}</span>}
      </div>
      {children}
    </div>
  );
}
const inputStyle = { width:'100%', boxSizing:'border-box', background:T.card, border:`1px solid ${T.border}`,
  borderRadius:13, padding:'13px 14px', color:T.text, fontFamily:FS, fontSize:15, outline:'none' };
function Input(props) {
  return <input {...props} style={{ ...inputStyle, ...(props.style||{}) }}
    onFocus={e=>e.target.style.borderColor=T.accent} onBlur={e=>e.target.style.borderColor=T.border}/>;
}
function TextArea(props) {
  return <textarea {...props} style={{ ...inputStyle, minHeight:84, resize:'none', fontSize:14, lineHeight:1.5, fontFamily:props.mono?FM:FS, ...(props.style||{}) }}
    onFocus={e=>e.target.style.borderColor=T.accent} onBlur={e=>e.target.style.borderColor=T.border}/>;
}
function Segmented({ options, value, onChange, cols }) {
  return (
    <div style={{ display: cols?'grid':'flex', gridTemplateColumns: cols?`repeat(${cols},1fr)`:undefined,
      flexWrap: cols?undefined:'wrap', gap:7 }}>
      {options.map(o => {
        const v = typeof o === 'string' ? o : o.v;
        const lbl = typeof o === 'string' ? o : o.label;
        const sel = value===v;
        return <button key={v} onClick={()=>onChange(v)} style={{ flex: cols?undefined:'1 1 auto',
          fontFamily:FS, fontSize:13.5, fontWeight:sel?600:500, padding:'10px 12px', borderRadius:12, cursor:'pointer',
          border:`1px solid ${sel?T.accent:T.border}`, background:sel?T.accentSoft:T.card, color:sel?T.accent:T.textDim,
          whiteSpace:'nowrap' }}>{lbl}</button>;
      })}
    </div>
  );
}
function YesNo({ value, onChange }) {
  return (
    <div style={{ display:'flex', gap:8 }}>
      {[['да','Да'],['не','Не']].map(([v,l]) => {
        const sel = value===v;
        const col = v==='да'?T.green:T.red;
        return <button key={v} onClick={()=>onChange(v)} style={{ flex:1, fontFamily:FS, fontSize:15, fontWeight:600,
          padding:'13px', borderRadius:13, cursor:'pointer', border:`1px solid ${sel?col:T.border}`,
          background: sel? (v==='да'?T.greenSoft:T.redSoft):T.card, color: sel?col:T.textDim }}>{l}</button>;
      })}
    </div>
  );
}
function Scale10({ value, onChange, color = T.accent }) {
  return (
    <div style={{ display:'flex', gap:5 }}>
      {Array.from({length:10},(_,i)=>i+1).map(n => {
        const sel = value===n;
        return <button key={n} onClick={()=>onChange(n)} style={{ flex:1, aspectRatio:'1', fontFamily:FM, fontSize:13,
          fontWeight:600, borderRadius:10, cursor:'pointer', border:`1px solid ${sel?color:T.border}`,
          background: sel?color:T.card, color: sel?'#0C0D11':T.textDim, padding:0 }}>{n}</button>;
      })}
    </div>
  );
}
// Prominent mood gauge for the daily report — color shifts red→amber→green
const moodColor = (v) => `oklch(0.74 0.15 ${Math.round(25 + (v - 1) / 9 * 125)})`;
const moodLabel = (v) => v <= 2 ? 'много лошо' : v <= 4 ? 'лошо' : v <= 6 ? 'средно' : v <= 8 ? 'добре' : v <= 9 ? 'много добре' : 'страхотно';
function MoodPicker({ value, onChange }) {
  const col = moodColor(value);
  return (
    <div style={{ background:T.card, border:`1px solid ${col}`, borderRadius:15, padding:'13px 14px 14px',
      transition:'border-color .25s' }}>
      <div style={{ display:'flex', alignItems:'baseline', justifyContent:'space-between', marginBottom:11 }}>
        <div style={{ display:'flex', alignItems:'baseline', gap:11 }}>
          <span style={{ fontFamily:FM, fontSize:34, fontWeight:600, lineHeight:1, color:col, transition:'color .25s', minWidth:40 }}>{value}</span>
          <div>
            <div style={{ fontFamily:FS, fontSize:14, fontWeight:700, color:col, transition:'color .25s' }}>{moodLabel(value)}</div>
            <div style={{ fontFamily:FM, fontSize:10.5, color:T.textFaint, marginTop:1 }}>как се чувстваш днес?</div>
          </div>
        </div>
        <span style={{ fontFamily:FM, fontSize:11, color:T.textFaint }}>/ 10</span>
      </div>
      <div style={{ display:'flex', gap:4 }}>
        {Array.from({length:10},(_,i)=>i+1).map(n => {
          const on = n <= value, sel = n === value;
          return <button key={n} onClick={()=>onChange(n)} aria-label={'настроение '+n} style={{
            flex:1, height:34, borderRadius:8, cursor:'pointer', padding:0, position:'relative',
            border:`1px solid ${sel ? col : on ? 'transparent' : T.border}`,
            background: sel ? col : on ? `oklch(0.74 0.15 ${Math.round(25 + (n - 1) / 9 * 125)} / 0.32)` : T.bg2,
            fontFamily:FM, fontSize:11.5, fontWeight:600,
            color: sel ? '#0C0D11' : on ? T.text : T.textFaint, transition:'background .15s, border-color .15s' }}>{n}</button>;
        })}
      </div>
      <div style={{ display:'flex', justifyContent:'space-between', marginTop:7 }}>
        <span style={{ fontFamily:FM, fontSize:10, color:T.textFaint }}>1 · много лошо</span>
        <span style={{ fontFamily:FM, fontSize:10, color:T.textFaint }}>10 · страхотно</span>
      </div>
    </div>
  );
}
function Stepper({ value, onChange, step = 1, suffix }) {
  return (
    <div style={{ display:'flex', alignItems:'center', gap:10, background:T.card, border:`1px solid ${T.border}`,
      borderRadius:13, padding:'6px 10px' }}>
      <button onClick={()=>onChange(value-step)} style={{ width:38, height:38, borderRadius:10, border:'none',
        background:'rgba(255,255,255,0.06)', color:T.text, fontSize:22, cursor:'pointer' }}>−</button>
      <div style={{ flex:1, textAlign:'center', fontFamily:FM, fontSize:20, fontWeight:600 }}>{value}{suffix&&<span style={{fontSize:12,color:T.textFaint}}> {suffix}</span>}</div>
      <button onClick={()=>onChange(value+step)} style={{ width:38, height:38, borderRadius:10, border:'none',
        background:'rgba(255,255,255,0.06)', color:T.text, fontSize:22, cursor:'pointer' }}>+</button>
    </div>
  );
}
function PhotoAdd({ label = 'Добави снимка', multi }) {
  return (
    <div style={{ border:`1.5px dashed ${T.borderHi}`, borderRadius:14, padding:'20px', display:'flex',
      flexDirection:'column', alignItems:'center', gap:8, cursor:'pointer', background:'rgba(255,255,255,0.02)' }}>
      <Icon name="camera" size={24} color={T.textFaint}/>
      <span style={{ fontFamily:FS, fontSize:13, color:T.textDim }}>{label}</span>
      {multi && <span style={{ fontFamily:FM, fontSize:10.5, color:T.textFaint }}>може няколко</span>}
    </div>
  );
}

// ── Photo placeholder tile (honest visual-memory stand-in) ────────
function PhotoTile({ date, hue = 220, ratio = '1', label, style }) {
  return (
    <div style={{ aspectRatio:ratio, borderRadius:14, overflow:'hidden', position:'relative',
      background:`linear-gradient(150deg, oklch(0.4 0.06 ${hue}), oklch(0.26 0.05 ${hue+30}))`,
      border:`1px solid ${T.border}`, ...style }}>
      <div style={{ position:'absolute', inset:0, opacity:0.5,
        backgroundImage:`repeating-linear-gradient(135deg, rgba(255,255,255,0.05) 0 2px, transparent 2px 9px)` }}/>
      <div style={{ position:'absolute', top:8, left:9 }}><Icon name="camera" size={15} color="rgba(255,255,255,0.6)"/></div>
      {date && <div style={{ position:'absolute', bottom:7, left:9, fontFamily:FM, fontSize:10.5,
        color:'rgba(255,255,255,0.82)' }}>{date}</div>}
      {label && <div style={{ position:'absolute', bottom:7, right:9, fontFamily:FM, fontSize:10,
        color:'rgba(255,255,255,0.7)' }}>{label}</div>}
    </div>
  );
}

// ── Bars with x labels (chart) ────────────────────────────────────
function BarChart({ data, labels, color = T.accent, h = 130, fmt, highlightLast }) {
  const max = Math.max(...data) || 1;
  return (
    <div>
      <div style={{ display:'flex', alignItems:'flex-end', gap:4, height:h }}>
        {data.map((v,i)=>(
          <div key={i} style={{ flex:1, display:'flex', flexDirection:'column', justifyContent:'flex-end', height:'100%', gap:5 }}>
            <div style={{ height:`${Math.max(3,(v/max)*100)}%`, borderRadius:5,
              background: (highlightLast&&i===data.length-1)?color:`${color}`,
              opacity:(highlightLast&&i!==data.length-1)?0.4:1, minHeight:3 }}/>
          </div>
        ))}
      </div>
      {labels && <div style={{ display:'flex', gap:4, marginTop:7 }}>
        {labels.map((l,i)=><div key={i} style={{ flex:1, textAlign:'center', fontFamily:FM, fontSize:9.5, color:T.textFaint }}>{l}</div>)}
      </div>}
    </div>
  );
}

// ── Toast ─────────────────────────────────────────────────────────
function Toast({ msg }) {
  if (!msg) return null;
  return (
    <div style={{ position:'absolute', left:0, right:0, bottom:84, display:'flex', justifyContent:'center', zIndex:60, pointerEvents:'none' }}>
      <div style={{ background:T.cardHi, border:`1px solid ${T.borderHi}`, color:T.text, fontFamily:FS, fontSize:13.5,
        fontWeight:500, padding:'11px 18px', borderRadius:13, display:'flex', alignItems:'center', gap:9,
        boxShadow:'0 12px 30px rgba(0,0,0,0.5)' }}>
        <Icon name="check" size={17} color={T.green} sw={2.4}/>{msg}
      </div>
    </div>
  );
}

Object.assign(window, {
  NavCtx, useNav, TopBar, Body, PeriodChips, PERIODS, Stat, Row, SectionTitle, BottomNav, Sheet,
  Btn, Field, Input, TextArea, Segmented, YesNo, Scale10, MoodPicker, moodColor, moodLabel, Stepper, PhotoAdd, PhotoTile, BarChart, Toast,
});
