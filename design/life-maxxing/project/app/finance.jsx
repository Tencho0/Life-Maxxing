// app/finance.jsx — Finance, Food, Activities, Steps
window.SCREENS = window.SCREENS || {};
(function(){
const { useState, useEffect } = React;

function AddBtn({ sheet }) {
  const nav = useNav();
  return <div onClick={()=>nav.openSheet(sheet)} style={{ width:38, height:38, borderRadius:12, background:T.accent,
    display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}><Icon name="plus" size={20} color="#0C0D11" sw={2.3}/></div>;
}
function Tabs({ tabs, value, onChange }) {
  return (
    <div style={{ display:'flex', gap:4, background:T.card, border:`1px solid ${T.border}`, borderRadius:13, padding:4, marginBottom:14 }}>
      {tabs.map(t=>(
        <button key={t} onClick={()=>onChange(t)} style={{ flex:1, fontFamily:FS, fontSize:13.5, fontWeight:600,
          padding:'9px', borderRadius:10, cursor:'pointer', border:'none',
          background: value===t?T.accentSoft:'transparent', color: value===t?T.accent:T.textDim }}>{t}</button>
      ))}
    </div>
  );
}

// ── Finance radial menu (quarter-circle from top-right +) ─────────
function FinRadial({ onClose, onPick }) {
  const items = [
    { id:'expense', label:'Разход', icon:'expense', color:T.red,   rc:58,  tc:118 },
    { id:'income',  label:'Приход', icon:'income',  color:T.green, rc:122, tc:54  },
  ];
  return (
    <div style={{ position:'absolute', inset:0, zIndex:45 }}>
      <div onClick={onClose} style={{ position:'absolute', inset:0, background:'rgba(8,9,12,0.6)', backdropFilter:'blur(2px)' }}/>
      {/* faint quarter-circle guide anchored to the corner */}
      <div style={{ position:'absolute', right:-55, top:-59, width:180, height:180, borderRadius:'50%',
        border:'1px dashed rgba(255,255,255,0.16)' }}/>
      {/* close (×) where the + was */}
      <div onClick={onClose} style={{ position:'absolute', top:12, right:16, width:38, height:38, borderRadius:12,
        background:T.accent, display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer', zIndex:2 }}>
        <Icon name="close" size={20} color="#0C0D11" sw={2.4}/>
      </div>
      {items.map((it)=>(
        <div key={it.id} onClick={()=>onPick(it.id)} style={{ position:'absolute', right:it.rc-32, top:it.tc-27,
          width:64, display:'flex', flexDirection:'column', alignItems:'center', gap:6, cursor:'pointer' }}>
          <div style={{ width:54, height:54, borderRadius:'50%', background:it.color+'26', border:`1px solid ${it.color}`,
            display:'flex', alignItems:'center', justifyContent:'center', boxShadow:`0 6px 18px ${it.color}33` }}>
            <Icon name={it.icon} size={24} color={it.color}/></div>
          <span style={{ fontFamily:FS, fontSize:12, fontWeight:600, color:T.text }}>{it.label}</span>
        </div>
      ))}
    </div>
  );
}

// ── Finance ───────────────────────────────────────────────────────
function Finance() {
  const nav = useNav();
  const [period, setPeriod] = useState('Месец');
  const [tab, setTab] = useState('Разходи');
  const [fab, setFab] = useState(false);
  const total = EXPENSE_CATS.reduce((s,c)=>s+c.value,0);
  return (
    <>
      <TopBar title="Финанси" sub="май 2026" right={
        <div onClick={()=>setFab(true)} style={{ width:38, height:38, borderRadius:12, background:T.accent,
          display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}><Icon name="plus" size={20} color="#0C0D11" sw={2.3}/></div>}/>
      <Body>
        <PeriodChips value={period} onChange={setPeriod}/>
        <div style={{ background:'linear-gradient(135deg,#15241c,#14161d)', border:'1px solid rgba(95,208,138,0.25)',
          borderRadius:18, padding:18, marginBottom:12 }}>
          <Eyebrow style={{ color:T.green }}>Баланс за периода</Eyebrow>
          <div style={{ fontFamily:FM, fontSize:34, fontWeight:600, color:T.green, marginTop:6 }}>+1 190 лв.</div>
          <div style={{ display:'flex', gap:20, marginTop:14 }}>
            <div><div style={{ fontFamily:FM, fontSize:18, fontWeight:600, color:T.text }}>3 280</div><div style={{ fontSize:11, color:T.textDim }}>приходи</div></div>
            <div><div style={{ fontFamily:FM, fontSize:18, fontWeight:600, color:T.text }}>2 090</div><div style={{ fontSize:11, color:T.textDim }}>разходи</div></div>
            <div><div style={{ fontFamily:FM, fontSize:18, fontWeight:600, color:T.text }}>70</div><div style={{ fontSize:11, color:T.textDim }}>ср. на ден</div></div>
          </div>
        </div>

        <Card style={{ marginBottom:12 }}>
          <Eyebrow>Приходи срещу разходи</Eyebrow>
          <div style={{ display:'flex', gap:5, alignItems:'flex-end', height:96, marginTop:14 }}>
            {DAYS30.filter((_,i)=>i%2===0).map((d,i)=>(
              <div key={i} style={{ flex:1, display:'flex', flexDirection:'column', justifyContent:'flex-end', gap:2, height:'100%' }}>
                <div style={{ height:`${(d.income/2500)*100}%`, background:T.green, borderRadius:2, minHeight:d.income?3:0 }}/>
                <div style={{ height:`${Math.min(70,(d.expense/200)*70)}%`, background:T.red, borderRadius:2, minHeight:3 }}/>
              </div>
            ))}
          </div>
          <div style={{ display:'flex', gap:16, marginTop:10 }}>
            <Lg c={T.green} l="Приход"/><Lg c={T.red} l="Разход"/>
          </div>
        </Card>

        <Card style={{ marginBottom:6 }}>
          <Eyebrow>Разходи по категории</Eyebrow>
          <div style={{ display:'flex', gap:18, alignItems:'center', marginTop:12 }}>
            <SegRing segs={EXPENSE_CATS} size={104} sw={15}>
              <span style={{ fontFamily:FM, fontSize:17, fontWeight:600, color:T.text }}>2 090</span>
              <span style={{ fontSize:10, color:T.textFaint }}>лв.</span>
            </SegRing>
            <div style={{ flex:1, display:'flex', flexDirection:'column', gap:8 }}>
              {EXPENSE_CATS.map(c=>(
                <div key={c.cat} style={{ display:'flex', alignItems:'center', gap:8 }}>
                  <div style={{ width:9, height:9, borderRadius:3, background:c.color, flexShrink:0 }}/>
                  <span style={{ fontFamily:FS, fontSize:12.5, color:T.textDim, flex:1, overflow:'hidden', textOverflow:'ellipsis', whiteSpace:'nowrap' }}>{c.cat}</span>
                  <span style={{ fontFamily:FM, fontSize:12, color:T.text }}>{Math.round(c.value/total*100)}%</span>
                </div>
              ))}
            </div>
          </div>
        </Card>

        <SectionTitle>Записи</SectionTitle>
        <Tabs tabs={['Разходи','Приходи']} value={tab} onChange={setTab}/>
        <div style={{ display:'flex', flexDirection:'column', gap:8 }}>
          {tab==='Разходи' ? EXPENSES.map(e=>(
            <Row key={e.id} icon="expense" color={e.color} title={e.desc} sub={`${e.cat} · ${e.pay} · ${e.time}`}
              right={<span style={{ fontFamily:FM, fontSize:15, fontWeight:600, color:T.red }}>−{e.amount}</span>}/>
          )) : INCOME.map(i=>(
            <Row key={i.id} icon="income" color={T.green} title={i.source} sub={`${i.cat} · ${i.date}`}
              right={<span style={{ fontFamily:FM, fontSize:15, fontWeight:600, color:T.green }}>+{i.amount}</span>}/>
          ))}
        </div>
      </Body>
      {fab && <FinRadial onClose={()=>setFab(false)} onPick={(id)=>{ setFab(false); nav.openSheet(id); }}/>}
    </>
  );
}
function Lg({ c, l }) { return <div style={{ display:'flex', alignItems:'center', gap:6 }}>
  <div style={{ width:9, height:9, borderRadius:3, background:c }}/><span style={{ fontFamily:FM, fontSize:11, color:T.textDim }}>{l}</span></div>; }

// ── Food ──────────────────────────────────────────────────────────
function Food() {
  const [period, setPeriod] = useState('Днес');
  const totalCals = MEALS.reduce((s,m)=>s+m.cals,0);
  const byType = {};
  MEALS.forEach(m=>{ const k=m.type; byType[k]=(byType[k]||0)+m.cals; });
  return (
    <>
      <TopBar title="Храна" sub="храна и калории" right={<AddBtn sheet="food"/>}/>
      <Body>
        <PeriodChips value={period} onChange={setPeriod}/>
        <Card style={{ marginBottom:12, display:'flex', alignItems:'center', gap:18 }}>
          <Ring value={totalCals} max={TODAY_STATS.calsGoal} color={T.amber} size={104} sw={11}>
            <span style={{ fontFamily:FM, fontSize:20, fontWeight:600, color:T.text }}>{totalCals}</span>
            <span style={{ fontSize:10, color:T.textFaint }}>/ {TODAY_STATS.calsGoal} kcal</span>
          </Ring>
          <div style={{ flex:1, display:'flex', flexDirection:'column', gap:11 }}>
            <Macro label="Протеин" v={TODAY_STATS.protein} max={170} color={T.amber}/>
            <Macro label="Въглехидрати" v={TODAY_STATS.carbs} max={260} color={T.accent}/>
            <Macro label="Мазнини" v={TODAY_STATS.fat} max={90} color={T.pink}/>
          </div>
        </Card>
        <Card style={{ marginBottom:6 }}>
          <Eyebrow>Калории по дни</Eyebrow>
          <div style={{ marginTop:12 }}><MiniBars data={last7.map(d=>d.cals)} w={344} h={70} color={T.amber} gap={6} highlight={6}/></div>
          <div style={{ display:'flex', gap:6, marginTop:7 }}>{last7.map((d,i)=><div key={i} style={{flex:1,textAlign:'center',fontFamily:FM,fontSize:9.5,color:T.textFaint}}>{DOW_BG[d.dow]}</div>)}</div>
        </Card>
        <SectionTitle>Хранения днес · {MEALS.length}</SectionTitle>
        <div style={{ display:'flex', flexDirection:'column', gap:8 }}>
          {MEALS.map(m=>(
            <Row key={m.id} icon="food" color={T.amber} title={m.name}
              sub={`${m.type} · ${m.time}${m.note?' · '+m.note:''}`}
              right={<div style={{ textAlign:'right' }}>
                <div style={{ fontFamily:FM, fontSize:14, fontWeight:600, color:T.text }}>{m.cals}</div>
                <div style={{ fontFamily:FM, fontSize:10, color:T.textFaint }}>П{m.p} В{m.c} М{m.f}</div>
              </div>}/>
          ))}
        </div>
      </Body>
    </>
  );
}
function Macro({ label, v, max, color }) {
  return (
    <div>
      <div style={{ display:'flex', justifyContent:'space-between', marginBottom:5 }}>
        <span style={{ fontFamily:FS, fontSize:12, color:T.textDim }}>{label}</span>
        <span style={{ fontFamily:FM, fontSize:12, color:T.text }}>{v}г</span>
      </div>
      <div style={{ height:6, borderRadius:4, background:'rgba(255,255,255,0.07)', overflow:'hidden' }}>
        <div style={{ width:`${Math.min(100,v/max*100)}%`, height:'100%', background:color }}/>
      </div>
    </div>
  );
}

// ── Activities ────────────────────────────────────────────────────
function Activities() {
  const [period, setPeriod] = useState('7 дни');
  const cats = [
    { cat:'Фитнес', value:6, color:T.green }, { cat:'BJJ', value:4, color:T.accent },
    { cat:'Колоездене', value:3, color:T.purple }, { cat:'Плуване', value:2, color:T.pink },
    { cat:'Бокс', value:2, color:T.amber }, { cat:'Разходка в планината', value:1, color:T.textDim },
  ];
  const actIcon = (c) => ({'Фитнес':'dumbbell','BJJ':'bolt','Бокс':'bolt','Кикбокс':'bolt','ММА':'bolt','Тенис':'star','Разходка в планината':'steps','Народни танци':'star','Колоездене':'run','Плуване':'drop','Ски':'bolt','Друго':'star'}[c] || 'run');
  const total = cats.reduce((s,c)=>s+c.value,0);
  return (
    <>
      <TopBar title="Активности" sub="какво правя с времето си" right={<AddBtn sheet="activity"/>}/>
      <Body>
        <PeriodChips value={period} onChange={setPeriod}/>
        <div style={{ display:'flex', gap:10, marginBottom:12 }}>
          <Card style={{ flex:1 }}><Stat label="Активности" value="18" sub="за 7 дни"/></Card>
          <Card style={{ flex:1 }}><Stat label="Време" value="21" unit="ч" color={T.green}/></Card>
          <Card style={{ flex:1 }}><Stat label="Фитнес" value="6" color={T.green}/></Card>
        </div>
        <Card style={{ marginBottom:12 }}>
          <Eyebrow>Активности по категории</Eyebrow>
          <div style={{ display:'flex', gap:18, alignItems:'center', marginTop:12 }}>
            <SegRing segs={cats} size={100} sw={14}>
              <span style={{ fontFamily:FM, fontSize:20, fontWeight:600, color:T.text }}>{total}</span>
            </SegRing>
            <div style={{ flex:1, display:'flex', flexDirection:'column', gap:8 }}>
              {cats.map(c=>(
                <div key={c.cat} style={{ display:'flex', alignItems:'center', gap:8 }}>
                  <div style={{ width:9, height:9, borderRadius:3, background:c.color }}/>
                  <span style={{ fontFamily:FS, fontSize:12.5, color:T.textDim, flex:1 }}>{c.cat}</span>
                  <span style={{ fontFamily:FM, fontSize:12, color:T.text }}>{c.value}</span>
                </div>
              ))}
            </div>
          </div>
        </Card>
        <SectionTitle>Днес</SectionTitle>
        <div style={{ display:'flex', flexDirection:'column', gap:8 }}>
          {ACTIVITIES.map(a=>(
            <Row key={a.id} icon={actIcon(a.cat)} color={a.color}
              title={a.name} sub={`${a.cat} · ${a.start} · ${a.dur} мин`}
              tag={a.intensity?<Pill color={a.color}>{a.intensity}</Pill>:null}
              right={a.mood?<span style={{ fontFamily:FM, fontSize:12, color:T.textDim }}>☺ {a.mood}</span>:a.productivity?<span style={{ fontFamily:FM, fontSize:12, color:T.textDim }}>⚡ {a.productivity}</span>:null}/>
          ))}
        </div>
      </Body>
    </>
  );
}

// ── Steps ─────────────────────────────────────────────────────────
function Steps() {
  const [period, setPeriod] = useState('30 дни');
  const days = period==='7 дни'?last7:DAYS30;
  return (
    <>
      <TopBar title="Крачки" sub="ръчно въвеждане" right={<AddBtn sheet="steps"/>}/>
      <Body>
        <PeriodChips value={period} onChange={setPeriod}/>
        <Card style={{ marginBottom:12, display:'flex', alignItems:'center', gap:18 }}>
          <Ring value={TODAY_STATS.steps} max={TODAY_STATS.stepsGoal} color={T.purple} size={110} sw={11}>
            <Icon name="steps" size={20} color={T.purple}/>
            <span style={{ fontFamily:FM, fontSize:19, fontWeight:600, color:T.text, marginTop:2 }}>9 420</span>
            <span style={{ fontSize:10, color:T.textFaint }}>днес</span>
          </Ring>
          <div style={{ flex:1, display:'grid', gridTemplateColumns:'1fr 1fr', gap:14 }}>
            <Stat label="Средно/ден" value="8 280" color={T.purple}/>
            <Stat label="Най-много" value="16 240"/>
            <Stat label="Общо" value="248к"/>
            <Stat label="Дни" value="30"/>
          </div>
        </Card>
        <Card style={{ marginBottom:12 }}>
          <Eyebrow>Крачки по дни</Eyebrow>
          <div style={{ marginTop:12 }}><MiniBars data={days.map(d=>d.steps)} w={344} h={90} color={T.purple} gap={days.length>14?2:5} highlight={days.length-1}/></div>
        </Card>
        <SectionTitle>Последни дни</SectionTitle>
        <div style={{ display:'flex', flexDirection:'column', gap:8 }}>
          {[...last7].reverse().map((d,i)=>(
            <Row key={i} icon="steps" color={T.purple} title={fmtDateFull(d.d).replace(' 2026','')}
              sub={i%3===0?'въведено от Дневен отчет':'въведено от Крачки'}
              right={<span style={{ fontFamily:FM, fontSize:15, fontWeight:600, color:T.text }}>{d.steps.toLocaleString('bg-BG')}</span>}/>
          ))}
        </div>
      </Body>
    </>
  );
}

Object.assign(window.SCREENS, { finance:Finance, food:Food, activities:Activities, steps:Steps });
})();
