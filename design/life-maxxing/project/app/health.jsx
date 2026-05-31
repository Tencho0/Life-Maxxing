// app/health.jsx — Health hub: vitals, blood pressure, meds, events, lab tests
window.SCREENS = window.SCREENS || {};
(function(){
const { useState } = React;

function AddBtn({ sheet }) {
  const nav = useNav();
  return <div onClick={()=>nav.openSheet(sheet)} style={{ width:38, height:38, borderRadius:12, background:T.accent,
    display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}><Icon name="plus" size={20} color="#0C0D11" sw={2.3}/></div>;
}
function Tabs({ tabs, value, onChange }) {
  return (
    <div style={{ display:'flex', gap:3, background:T.card, border:`1px solid ${T.border}`, borderRadius:13, padding:4, marginBottom:14 }}>
      {tabs.map(t=>(
        <button key={t} onClick={()=>onChange(t)} style={{ flex:1, fontFamily:FS, fontSize:12.5, fontWeight:600,
          padding:'9px 4px', borderRadius:10, cursor:'pointer', border:'none',
          background: value===t?T.accentSoft:'transparent', color: value===t?T.accent:T.textDim }}>{t}</button>
      ))}
    </div>
  );
}

function bpColor(sys) { return sys < 120 ? T.green : sys < 130 ? T.accent : sys < 140 ? T.amber : T.red; }

function Health() {
  const nav = useNav();
  const [period, setPeriod] = useState('30 дни');
  const [tab, setTab] = useState('Кръвно');
  const days = period==='7 дни'?last7:DAYS30;
  const sheetFor = { 'Кръвно':'bp', 'Добавки':'med', 'Събития':null, 'Изследвания':null }[tab];
  return (
    <>
      <TopBar title="Здраве" sub="лична здравна история"
        right={sheetFor ? <AddBtn sheet={sheetFor}/> : null}/>
      <Body>
        <PeriodChips value={period} onChange={setPeriod}/>

        {/* vitals row */}
        <div style={{ display:'flex', gap:10, marginBottom:12 }}>
          <Card style={{ flex:1.3 }}>
            <Eyebrow style={{ color:T.pink }}>Последно кръвно · 08:20</Eyebrow>
            <div style={{ fontFamily:FM, fontSize:30, fontWeight:600, color:T.text, marginTop:5 }}>124<span style={{ color:T.textFaint }}>/</span>78</div>
            <div style={{ display:'flex', alignItems:'center', gap:6, marginTop:4 }}>
              <Pill color={T.green} bg={T.greenSoft}>нормално</Pill>
              <span style={{ fontFamily:FM, fontSize:12, color:T.textDim }}>♥ 71</span>
            </div>
          </Card>
          <Card style={{ flex:1, display:'flex', flexDirection:'column', justifyContent:'space-between' }}>
            <Stat label="Ср. пулс" value="73" sub="за периода"/>
            <div style={{ marginTop:8 }}><Sparkline data={days.map(d=>d.pulse)} w={120} h={30} color={T.pink}/></div>
          </Card>
        </div>

        {/* counts */}
        <div style={{ display:'flex', gap:10, marginBottom:14 }}>
          <Card style={{ flex:1 }}><Stat label="Измервания" value={HEALTH_STATS.bpCount}/></Card>
          <Card style={{ flex:1 }}><Stat label="Събития" value={HEALTH_STATS.eventsCount}/></Card>
          <Card style={{ flex:1 }}><Stat label="Изследвания" value={HEALTH_STATS.labsCount}/></Card>
        </div>

        {/* BP chart */}
        <Card style={{ marginBottom:6 }}>
          <div style={{ display:'flex', justifyContent:'space-between', alignItems:'baseline' }}>
            <Eyebrow>Кръвно налягане във времето</Eyebrow>
            <span style={{ fontFamily:FM, fontSize:12, color:T.textDim }}>ср. 126/79</span>
          </div>
          <div style={{ marginTop:14 }}>
            <Sparkline data={days.map(d=>d.sys)} w={344} h={56} color={T.pink}/>
            <div style={{ height:4 }}/>
            <Sparkline data={days.map(d=>d.dia)} w={344} h={40} color="rgba(255,158,196,0.55)" fill={false} sw={1.6}/>
          </div>
          <div style={{ display:'flex', gap:16, marginTop:8 }}>
            <Lg c={T.pink} l="Систолично"/><Lg c="rgba(255,158,196,0.55)" l="Диастолично"/>
          </div>
        </Card>

        <SectionTitle>История</SectionTitle>
        <Tabs tabs={['Кръвно','Добавки','Събития','Изследвания']} value={tab} onChange={setTab}/>

        <div style={{ display:'flex', flexDirection:'column', gap:8 }}>
          {tab==='Кръвно' && BP_LOGS.map(b=>(
            <Row key={b.id} icon="pulse" color={bpColor(b.sys)} title={`${b.sys}/${b.dia} · ♥ ${b.pulse}`}
              sub={`${b.date} · ${b.time} · ${b.note}`}
              right={<div style={{ width:8, height:8, borderRadius:4, background:bpColor(b.sys) }}/>}/>
          ))}
          {tab==='Добавки' && MEDS.map(m=>(
            <Row key={m.id} icon="pill" color={m.status==='Прието'?T.green:T.textFaint} title={m.name}
              sub={`${m.type} · ${m.dose} · ${m.time}`}
              right={<Pill color={m.status==='Прието'?T.green:T.red} bg={m.status==='Прието'?T.greenSoft:T.redSoft}>{m.status}</Pill>}/>
          ))}
          {tab==='Събития' && HEALTH_EVENTS.map(h=>(
            <Row key={h.id} icon="event" color={T.accent} title={`${h.type}${h.sub?' · '+h.sub:''}`}
              sub={`${h.clinic} · ${h.what}`}
              right={<div style={{ textAlign:'right' }}>
                <div style={{ fontFamily:FM, fontSize:12.5, color:T.text }}>{h.date}</div>
                {h.price&&<div style={{ fontFamily:FM, fontSize:10.5, color:T.textFaint }}>{h.price} лв.</div>}
              </div>}/>
          ))}
          {tab==='Изследвания' && LAB_TESTS.map(l=>(
            <div key={l.id} style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:15, padding:14 }}>
              <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center' }}>
                <div style={{ display:'flex', alignItems:'center', gap:10 }}>
                  <div style={{ width:38, height:38, borderRadius:12, background:'rgba(255,255,255,0.05)', display:'flex', alignItems:'center', justifyContent:'center' }}>
                    <Icon name="labs" size={19} color={T.accent}/></div>
                  <div>
                    <div style={{ fontFamily:FS, fontSize:14, fontWeight:600, color:T.text }}>{l.lab} · {l.reason}</div>
                    <div style={{ fontFamily:FM, fontSize:11, color:T.textFaint }}>{l.date} · {l.photos} снимки</div>
                  </div>
                </div>
              </div>
              <pre style={{ fontFamily:FM, fontSize:11.5, color:T.textDim, margin:'12px 0 0', whiteSpace:'pre-wrap',
                background:T.bg, border:`1px solid ${T.border}`, borderRadius:11, padding:'11px 12px', lineHeight:1.6 }}>{l.results}</pre>
            </div>
          ))}
        </div>

        {tab==='Събития' && (
          <div style={{ marginTop:12, background:T.amberSoft, border:'1px solid rgba(245,195,107,0.3)', borderRadius:14,
            padding:'13px 15px', display:'flex', alignItems:'center', gap:11 }}>
            <Icon name="calendar" size={19} color={T.amber}/>
            <div style={{ fontSize:13, color:T.text }}>Следващ зъболекар: <b>18 ное 2026</b></div>
          </div>
        )}
      </Body>
    </>
  );
}
function Lg({ c, l }) { return <div style={{ display:'flex', alignItems:'center', gap:6 }}>
  <div style={{ width:9, height:9, borderRadius:3, background:c }}/><span style={{ fontFamily:FM, fontSize:11, color:T.textDim }}>{l}</span></div>; }

Object.assign(window.SCREENS, { health:Health });
})();
