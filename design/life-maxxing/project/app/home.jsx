// app/home.jsx — Home (Direction C) + Stats overview + Memories + More menu
window.SCREENS = window.SCREENS || {};
(function(){
const { useState } = React;

// ── Home header ───────────────────────────────────────────────────
function HomeHead() {
  const nav = useNav();
  return (
    <div style={{ padding:'14px 16px 6px', display:'flex', justifyContent:'space-between', alignItems:'flex-start', flexShrink:0 }}>
      <div>
        <div style={{ fontFamily:FM, fontSize:12.5, color:T.textDim, letterSpacing:0.3 }}>събота · 31 май 2026</div>
        <div style={{ fontFamily:FS, fontSize:23, fontWeight:700, letterSpacing:-0.4, marginTop:3, color:T.text }}>Добър вечер, Мартин</div>
      </div>
      <div style={{ display:'flex', gap:8 }}>
        <Sq icon="search" onClick={()=>nav.go('search')}/>
        <Sq icon="calendar" onClick={()=>nav.go('daily')}/>
      </div>
    </div>
  );
}
function Sq({ icon, onClick }) {
  return <div onClick={onClick} style={{ width:38, height:38, borderRadius:12, background:T.card, border:`1px solid ${T.border}`,
    display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}><Icon name={icon} size={19} color={T.textDim}/></div>;
}

function BigAction({ q }) {
  const nav = useNav();
  return (
    <div onClick={()=>nav.openSheet(q.id)} style={{ flex:1, background:T.card, border:`1px solid ${T.border}`,
      borderRadius:18, padding:'13px 14px', display:'flex', flexDirection:'column', gap:16, minHeight:80, cursor:'pointer' }}>
      <div style={{ width:40, height:40, borderRadius:13, background:'rgba(255,255,255,0.05)',
        display:'flex', alignItems:'center', justifyContent:'center' }}><Icon name={q.icon} size={22} color={q.color}/></div>
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center' }}>
        <span style={{ fontFamily:FS, fontSize:14, fontWeight:600, color:T.text }}>{q.label}</span>
        <Icon name="plus" size={16} color={T.textFaint}/>
      </div>
    </div>
  );
}
function RailCard({ label, value, unit, data, color, to }) {
  const nav = useNav();
  return (
    <div onClick={()=>to&&nav.go(to)} style={{ width:138, flexShrink:0, background:T.card, border:`1px solid ${T.border}`,
      borderRadius:16, padding:14, cursor:to?'pointer':'default' }}>
      <Eyebrow>{label}</Eyebrow>
      <div style={{ fontFamily:FM, fontSize:20, fontWeight:600, marginTop:5, color:T.text }}>{value}<span style={{fontSize:11, color:T.textFaint}}> {unit}</span></div>
      <div style={{ marginTop:10 }}><Sparkline data={data} w={110} h={32} color={color}/></div>
    </div>
  );
}
function TLItem({ icon, color, title, sub, meta, last, onClick }) {
  return (
    <div onClick={onClick} style={{ display:'flex', gap:12, cursor:onClick?'pointer':'default' }}>
      <div style={{ display:'flex', flexDirection:'column', alignItems:'center' }}>
        <div style={{ width:34, height:34, borderRadius:11, background:T.card, border:`1px solid ${T.border}`,
          display:'flex', alignItems:'center', justifyContent:'center' }}><Icon name={icon} size={17} color={color}/></div>
        {!last && <div style={{ width:1.5, flex:1, background:T.border, marginTop:2, minHeight:14 }}/>}
      </div>
      <div style={{ flex:1, paddingBottom:last?0:14, minWidth:0 }}>
        <div style={{ display:'flex', justifyContent:'space-between', gap:8 }}>
          <span style={{ fontFamily:FS, fontSize:13.5, fontWeight:600, color:T.text }}>{title}</span>
          <span style={{ fontFamily:FM, fontSize:11.5, color:T.textFaint, flexShrink:0 }}>{meta}</span>
        </div>
        <div style={{ fontSize:12, color:T.textDim, marginTop:1 }}>{sub}</div>
      </div>
    </div>
  );
}

function Home() {
  const nav = useNav();
  return (
    <>
      <HomeHead/>
      <Body style={{ paddingTop:8 }}>
        <Eyebrow style={{ marginBottom:8 }}>Логни за 2 докосвания</Eyebrow>
        <div style={{ display:'flex', flexDirection:'column', gap:10 }}>
          <div style={{ display:'flex', gap:10 }}><BigAction q={QUICK[0]}/><BigAction q={QUICK[1]}/></div>
          <div style={{ display:'flex', gap:10 }}><BigAction q={QUICK[2]}/><BigAction q={QUICK[3]}/></div>
        </div>

        <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', margin:'20px 2px 10px' }}>
          <Eyebrow>Тази седмица</Eyebrow>
          <span onClick={()=>nav.go('stats')} style={{ fontFamily:FM, fontSize:11.5, color:T.accent, cursor:'pointer' }}>всички графики →</span>
        </div>
        <div style={{ display:'flex', gap:10, overflowX:'auto', margin:'0 -16px', padding:'2px 16px 6px' }}>
          <RailCard label="Настроение" value="7.4" unit="ср." data={last7.map(d=>d.mood)} color={T.accent} to="daily"/>
          <RailCard label="Крачки" value="8.3к" unit="ср." data={last7.map(d=>d.steps)} color={T.purple} to="steps"/>
          <RailCard label="Разход" value="612" unit="лв." data={last7.map(d=>d.expense)} color={T.red} to="finance"/>
          <RailCard label="Пулс" value="73" unit="ср." data={last7.map(d=>d.pulse)} color={T.pink} to="health"/>
        </div>

        <SectionTitle action={<span onClick={()=>nav.go('daily')} style={{fontFamily:FM,fontSize:11.5,color:T.accent,cursor:'pointer'}}>дневник →</span>}>Дневен поток · днес</SectionTitle>
        <div style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:16, padding:16 }}>
          <TLItem icon="pulse" color={T.pink} title="Кръвно 124/78" sub="Сутрин след събуждане · пулс 71" meta="08:20" onClick={()=>nav.go('health')}/>
          <TLItem icon="food" color={T.amber} title="Закуска" sub="Овесена каша с банан · 420 kcal" meta="08:10" onClick={()=>nav.go('food')}/>
          <TLItem icon="pill" color={T.accent} title="Добавки · 3 приети" sub="Витамин D3, Омега-3, Магнезий" meta="08:15" onClick={()=>nav.go('health')}/>
          <TLItem icon="dumbbell" color={T.green} title="Фитнес — гръб и бицепс" sub="65 мин · висока интензивност" meta="18:30" onClick={()=>nav.go('activities')}/>
          <TLItem icon="expense" color={T.red} title="Гориво OMV" sub="Транспорт · с карта" meta="−120 лв." onClick={()=>nav.go('finance')} last/>
        </div>

        <div onClick={()=>nav.openSheet('daily')} style={{ marginTop:14, background:'linear-gradient(135deg,#1a2435,#14161d)',
          border:'1px solid rgba(106,168,255,0.3)', borderRadius:16, padding:'15px 16px', display:'flex',
          alignItems:'center', gap:13, cursor:'pointer' }}>
          <div style={{ width:42, height:42, borderRadius:13, background:T.accentSoft, display:'flex', alignItems:'center', justifyContent:'center' }}>
            <Icon name="sun" size={22} color={T.accent}/></div>
          <div style={{ flex:1 }}>
            <div style={{ fontFamily:FS, fontSize:14.5, fontWeight:600, color:T.text }}>Завърши дневния отчет</div>
            <div style={{ fontSize:12, color:T.textDim, marginTop:1 }}>Настроение, тренировка, screen time…</div>
          </div>
          <Icon name="arrowR" size={18} color={T.accent}/>
        </div>
      </Body>
    </>
  );
}

// ── Stats overview ────────────────────────────────────────────────
function ChartCard({ title, value, sub, children, to }) {
  const nav = useNav();
  return (
    <div onClick={()=>to&&nav.go(to)} style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:18, padding:16, marginBottom:12, cursor:to?'pointer':'default' }}>
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'flex-start', marginBottom:14 }}>
        <div>
          <Eyebrow>{title}</Eyebrow>
          <div style={{ fontFamily:FM, fontSize:21, fontWeight:600, color:T.text, marginTop:4 }}>{value}</div>
          {sub && <div style={{ fontSize:11.5, color:T.textDim, marginTop:2 }}>{sub}</div>}
        </div>
        {to && <Icon name="arrowR" size={17} color={T.textFaint}/>}
      </div>
      {children}
    </div>
  );
}
function Stats() {
  const [period, setPeriod] = useState('30 дни');
  const days = period==='7 дни' ? last7 : DAYS30;
  const labels = days.map((d,i)=> (days.length<=7 || i%5===0) ? DOW_BG[d.dow] : '').map((l,i)=> days.length<=7?DOW_BG[days[i].dow]:l);
  return (
    <>
      <TopBar title="Графики" sub="Всичко на едно място"/>
      <Body>
        <PeriodChips value={period} onChange={setPeriod}/>
        <ChartCard title="Настроение по дни" value="7.4 ср." sub="най-висок ден: 9 · най-нисък: 4" to="daily">
          <Sparkline data={days.map(d=>d.mood)} w={344} h={70} color={T.accent}/>
        </ChartCard>
        <ChartCard title="Приходи срещу разходи" value="+1 190 лв." sub="3 280 приход · 2 090 разход" to="finance">
          <div style={{ display:'flex', gap:6, alignItems:'flex-end', height:90 }}>
            {days.filter((_,i)=>i%Math.ceil(days.length/14)===0).map((d,i)=>(
              <div key={i} style={{ flex:1, display:'flex', flexDirection:'column', justifyContent:'flex-end', gap:2, height:'100%' }}>
                <div style={{ height:`${(d.income/2500)*100}%`, background:T.green, borderRadius:3, minHeight:d.income?3:0 }}/>
                <div style={{ height:`${(d.expense/200)*70}%`, background:T.red, borderRadius:3, minHeight:3 }}/>
              </div>
            ))}
          </div>
          <Legend items={[['Приход',T.green],['Разход',T.red]]}/>
        </ChartCard>
        <ChartCard title="Крачки по дни" value="8 280 ср." sub="общо 248 400 за периода" to="steps">
          <MiniBars data={days.map(d=>d.steps)} w={344} h={74} color={T.purple} gap={days.length>14?2:4} highlight={days.length-1}/>
        </ChartCard>
        <ChartCard title="Кръвно налягане" value="126/79 ср." sub="систолично / диастолично · пулс 73" to="health">
          <Sparkline data={days.map(d=>d.sys)} w={344} h={48} color={T.pink} fill={false}/>
          <div style={{ height:6 }}/>
          <Sparkline data={days.map(d=>d.dia)} w={344} h={36} color="rgba(255,158,196,0.5)" fill={false} sw={1.6}/>
          <Legend items={[['Систолично',T.pink],['Диастолично','rgba(255,158,196,0.5)']]}/>
        </ChartCard>
      </Body>
    </>
  );
}
function Legend({ items }) {
  return (
    <div style={{ display:'flex', gap:16, marginTop:10 }}>
      {items.map(([l,c])=>(
        <div key={l} style={{ display:'flex', alignItems:'center', gap:6 }}>
          <div style={{ width:9, height:9, borderRadius:3, background:c }}/>
          <span style={{ fontFamily:FM, fontSize:11, color:T.textDim }}>{l}</span>
        </div>
      ))}
    </div>
  );
}

// ── Memories (visual diary) ───────────────────────────────────────
function Memories() {
  const nav = useNav();
  return (
    <>
      <TopBar title="Спомени" sub={`${DIARY_DAYS.length} дни със снимка · ${TRIPS.length} пътувания`}
        right={<Sq icon="trip" onClick={()=>nav.go('trips')}/>}/>
      <Body>
        <SectionTitle action={<span onClick={()=>nav.go('trips')} style={{fontFamily:FM,fontSize:11.5,color:T.accent,cursor:'pointer'}}>всички →</span>}>Пътувания</SectionTitle>
        <div style={{ display:'flex', gap:10, overflowX:'auto', margin:'0 -16px', padding:'0 16px 4px' }}>
          {TRIPS.map((t,i)=>(
            <div key={t.id} onClick={()=>nav.go('trip',{id:t.id})} style={{ width:170, flexShrink:0, cursor:'pointer' }}>
              <PhotoTile date={t.from+' — '+t.to.split(' ').slice(0,2).join(' ')} hue={[40,220,150][i%3]} ratio="4/3" label={'★ '+t.overall}/>
              <div style={{ fontFamily:FS, fontSize:13.5, fontWeight:600, marginTop:7, color:T.text }}>{t.title}</div>
              <div style={{ fontFamily:FM, fontSize:11, color:T.textDim }}>{t.dest}</div>
            </div>
          ))}
        </div>
        <SectionTitle>Визуален дневник</SectionTitle>
        <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr 1fr', gap:7 }}>
          {DIARY_DAYS.map((d,i)=>(
            <div key={i} onClick={()=>nav.go('daily')} style={{ cursor:'pointer' }}>
              <PhotoTile date={fmtDate(d)} hue={(i*47)%360}/>
            </div>
          ))}
        </div>
      </Body>
    </>
  );
}

// ── More menu ─────────────────────────────────────────────────────
function More() {
  const nav = useNav();
  const groups = [
    { title:'Логване', items:[
      ['food','Храна','food',T.amber], ['activities','Активности','run',T.green],
      ['daily','Дневен отчет','sun',T.accent], ['steps','Крачки','steps',T.purple],
    ]},
    { title:'Пари', items:[
      ['finance','Финанси · разходи и приходи','expense',T.red],
    ]},
    { title:'Здраве', items:[
      ['health','Здраве · кръвно, добавки, изследвания','heart',T.pink],
    ]},
    { title:'Живот', items:[
      ['bucket','Bucket List','star',T.amber], ['trips','Пътувания','trip',T.accent],
      ['memories','Визуален дневник','camera',T.purple],
    ]},
    { title:'Данни', items:[
      ['export','Експорт за AI анализ','export',T.green], ['backup','Backup & Restore','income',T.accent], ['search','Търсене','search',T.textDim],
    ]},
  ];
  return (
    <>
      <TopBar title="Всички модули"/>
      <Body>
        {groups.map(g=>(
          <div key={g.title}>
            <Eyebrow style={{ margin:'8px 2px 9px' }}>{g.title}</Eyebrow>
            <div style={{ display:'flex', flexDirection:'column', gap:8, marginBottom:8 }}>
              {g.items.map(([id,label,icon,color])=>(
                <Row key={id} icon={icon} color={color} title={label} onClick={()=>nav.go(id)}
                  right={<Icon name="chevR" size={17} color={T.textFaint}/>}/>
              ))}
            </div>
          </div>
        ))}
        <div style={{ textAlign:'center', padding:'18px 0 4px', fontFamily:FM, fontSize:11, color:T.textFaint }}>LifeMaxxing · V1</div>
      </Body>
    </>
  );
}

Object.assign(window.SCREENS, { home:Home, stats:Stats, memories:Memories, more:More });
})();
