// app/lists.jsx — Daily Quick Log, Bucket List, Trips, Trip detail, Search
window.SCREENS = window.SCREENS || {};
(function(){
const { useState } = React;

// ── Daily Quick Log ───────────────────────────────────────────────
function YNChip({ label, value, color }) {
  const yes = value;
  return (
    <div style={{ flex:1, background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:'12px 13px' }}>
      <div style={{ fontFamily:FS, fontSize:12, color:T.textDim, marginBottom:7 }}>{label}</div>
      <Pill color={yes?(color||T.green):T.textFaint} bg={yes?(color?undefined:T.greenSoft):'rgba(255,255,255,0.04)'}
        style={yes&&color?{background:`${color}22`}:{}}>{yes?'Да':'Не'}</Pill>
    </div>
  );
}
function Daily() {
  const nav = useNav();
  const D = DAILY;
  return (
    <>
      <TopBar title="Дневен отчет" sub="събота · 31 май 2026"
        right={<div onClick={()=>nav.openSheet('daily')} style={{ width:38, height:38, borderRadius:12, background:T.card,
          border:`1px solid ${T.border}`, display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}>
          <Icon name="edit" size={18} color={T.accent}/></div>}/>
      <Body>
        {/* mood hero */}
        <div style={{ background:'linear-gradient(135deg,#1a2435,#14161d)', border:'1px solid rgba(106,168,255,0.25)',
          borderRadius:18, padding:18, marginBottom:12, display:'flex', alignItems:'center', gap:18 }}>
          <Ring value={D.mood} max={10} color={T.accent} size={96}>
            <span style={{ fontFamily:FM, fontSize:30, fontWeight:600, color:T.text }}>{D.mood}</span>
            <span style={{ fontSize:10, color:T.textFaint }}>/ 10</span>
          </Ring>
          <div>
            <Eyebrow style={{ color:T.accent }}>Настроение</Eyebrow>
            <div style={{ fontFamily:FS, fontSize:17, fontWeight:700, color:T.text, marginTop:5 }}>Силен ден</div>
            <div style={{ fontSize:12.5, color:T.textDim, marginTop:3 }}>над средното (7.2)</div>
          </div>
        </div>

        {/* photo */}
        <div style={{ marginBottom:12 }}><PhotoTile date="31 май 2026" hue={210} ratio="16/9"/></div>

        {/* yes/no grid */}
        <div style={{ display:'flex', gap:10, marginBottom:10 }}>
          <YNChip label="Горд от себе си" value={D.proud}/>
          <YNChip label="Тренировка" value={D.workout} color={T.green}/>
        </div>
        <div style={{ display:'flex', gap:10, marginBottom:12 }}>
          <YNChip label="Неудобно нещо" value={D.uncomfortable} color={T.accent}/>
          <YNChip label="Алкохол" value={D.alcohol} color={T.red}/>
        </div>

        {D.uncomfortableWhat && (
          <Card style={{ marginBottom:10 }}>
            <Eyebrow style={{ color:T.accent }}>Неудобното нещо</Eyebrow>
            <div style={{ fontSize:13.5, color:T.text, marginTop:7, lineHeight:1.5 }}>{D.uncomfortableWhat}</div>
          </Card>
        )}

        <div style={{ display:'flex', gap:10, marginBottom:12 }}>
          <Card style={{ flex:1 }}><Stat label="Screen time" value="4ч 30м" color={T.amber}/></Card>
          <Card style={{ flex:1, display:'flex', justifyContent:'space-between', alignItems:'flex-start' }}>
            <Stat label="Крачки" value="9 420" color={T.purple}/>
            <Pill color={T.textFaint}>заключено</Pill>
          </Card>
        </div>

        <Card style={{ marginBottom:14 }}>
          <Eyebrow>Бележки</Eyebrow>
          <div style={{ fontSize:13.5, color:T.text, marginTop:8, lineHeight:1.55 }}>{D.note}</div>
        </Card>

        <Eyebrow style={{ margin:'4px 2px 10px' }}>Настроение · последните 30 дни</Eyebrow>
        <Card>
          <MiniBars data={DAYS30.map(d=>d.mood)} w={344} h={70} color={T.accent} gap={2} highlight={29}/>
          <div style={{ display:'flex', justifyContent:'space-between', marginTop:8, fontFamily:FM, fontSize:11, color:T.textFaint }}>
            <span>Попълнени: 24 дни</span><span>Ср. 7.2 · Горд: 18д</span>
          </div>
        </Card>
      </Body>
    </>
  );
}

// ── Bucket List ───────────────────────────────────────────────────
const STATUS_COLOR = { Idea:T.textDim, Planned:T.accent, Completed:T.green, Abandoned:T.textFaint };
const STATUS_BG = { Idea:'rgba(255,255,255,0.05)', Planned:T.accentSoft, Completed:T.greenSoft, Abandoned:'rgba(255,255,255,0.04)' };
const STATUS_BG_LABEL = { Idea:'Идея', Planned:'Планирано', Completed:'Завършено', Abandoned:'Изоставено' };
const PRIO_COLOR = { High:T.red, Medium:T.amber, Low:T.textDim };
function Bucket() {
  const nav = useNav();
  const [filter, setFilter] = useState('Всички');
  const filters = ['Всички','Idea','Planned','Completed'];
  const list = BUCKET.filter(b => filter==='Всички' || b.status===filter);
  return (
    <>
      <TopBar title="Bucket List" sub="желания и преживявания"
        right={<div onClick={()=>nav.openSheet('bucket')} style={{ width:38, height:38, borderRadius:12, background:T.accent,
          display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}><Icon name="plus" size={20} color="#0C0D11" sw={2.3}/></div>}/>
      <Body>
        <div style={{ display:'flex', gap:8, marginBottom:14 }}>
          <Card style={{ flex:1, textAlign:'center' }}><Stat label="Всичко" value="18"/></Card>
          <Card style={{ flex:1, textAlign:'center' }}><Stat label="Планирани" value="5" color={T.accent}/></Card>
          <Card style={{ flex:1, textAlign:'center' }}><Stat label="Завършени" value="4" color={T.green}/></Card>
        </div>
        <div style={{ display:'flex', gap:7, overflowX:'auto', marginBottom:14 }}>
          {filters.map(f=>(
            <button key={f} onClick={()=>setFilter(f)} style={{ flexShrink:0, fontFamily:FM, fontSize:12, padding:'7px 13px',
              borderRadius:100, cursor:'pointer', border:`1px solid ${filter===f?T.accent:T.border}`,
              background:filter===f?T.accentSoft:'transparent', color:filter===f?T.accent:T.textDim }}>
              {f==='Всички'?f:STATUS_BG_LABEL[f]}</button>
          ))}
        </div>
        <div style={{ display:'flex', flexDirection:'column', gap:10 }}>
          {list.map(b=>(
            <div key={b.id} onClick={()=>nav.go('bucketItem',{id:b.id})} style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:16, padding:15,
              cursor:'pointer', opacity:b.status==='Abandoned'?0.6:1 }}>
              <div style={{ display:'flex', justifyContent:'space-between', alignItems:'flex-start', gap:10 }}>
                <div style={{ fontFamily:FS, fontSize:15.5, fontWeight:700, color:T.text, flex:1,
                  textDecoration:b.status==='Abandoned'?'line-through':'none' }}>{b.title}</div>
                <Pill color={STATUS_COLOR[b.status]} bg={STATUS_BG[b.status]}>{STATUS_BG_LABEL[b.status]}</Pill>
              </div>
              {b.why && <div style={{ fontSize:13, color:T.textDim, marginTop:7, lineHeight:1.5, display:'-webkit-box',
                WebkitLineClamp:2, WebkitBoxOrient:'vertical', overflow:'hidden' }}>
                <span style={{ color:T.textFaint, fontFamily:FM, fontSize:11 }}>защо · </span>{b.why}</div>}
              <div style={{ display:'flex', alignItems:'center', gap:10, marginTop:11 }}>
                <Pill color={PRIO_COLOR[b.prio]}>● {b.prio}</Pill>
                {b.done && <span style={{ fontFamily:FM, fontSize:11, color:T.green }}>✓ {b.done}</span>}
                <div style={{ marginLeft:'auto' }}><Icon name="chevR" size={16} color={T.textFaint}/></div>
              </div>
            </div>
          ))}
        </div>
      </Body>
    </>
  );
}

// ── Bucket item detail ────────────────────────────────────────────
function BucketItem() {
  const nav = useNav();
  const b = BUCKET.find(x=>x.id===nav.params.id) || BUCKET[0];
  const done = b.status==='Completed';
  return (
    <>
      <TopBar title="Желание" sub="Bucket List"
        right={<div onClick={()=>nav.openSheet('bucket')} style={{ width:38, height:38, borderRadius:12, background:T.card,
          border:`1px solid ${T.border}`, display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}>
          <Icon name="edit" size={18} color={T.textDim}/></div>}/>
      <Body>
        <div style={{ display:'flex', gap:8, marginBottom:12 }}>
          <Pill color={STATUS_COLOR[b.status]} bg={STATUS_BG[b.status]}>{STATUS_BG_LABEL[b.status]}</Pill>
          <Pill color={PRIO_COLOR[b.prio]}>● {b.prio} приоритет</Pill>
        </div>
        <div style={{ fontFamily:FS, fontSize:27, fontWeight:700, letterSpacing:-0.5, lineHeight:1.15, color:T.text,
          textDecoration:b.status==='Abandoned'?'line-through':'none' }}>{b.title}</div>

        {b.why && (
          <Card style={{ marginTop:16 }}>
            <Eyebrow>Защо го искам</Eyebrow>
            <div style={{ fontSize:14, color:T.text, marginTop:8, lineHeight:1.55 }}>{b.why}</div>
          </Card>
        )}

        {done ? (
          <>
            <Eyebrow style={{ margin:'20px 2px 10px' }}>Преживяване</Eyebrow>
            <Card style={{ background:'linear-gradient(135deg,#15241c,#14161d)', borderColor:'rgba(95,208,138,0.25)' }}>
              {b.feeling && (
                <div style={{ display:'flex', alignItems:'center', gap:14, marginBottom:14 }}>
                  <span style={{ fontFamily:FM, fontSize:38, fontWeight:600, lineHeight:1, color:moodColor(b.feeling) }}>{b.feeling}</span>
                  <div>
                    <div style={{ fontFamily:FS, fontSize:15, fontWeight:700, color:moodColor(b.feeling) }}>{moodLabel(b.feeling)}</div>
                    <div style={{ fontFamily:FM, fontSize:11, color:T.textFaint, marginTop:2 }}>как се почувствах</div>
                  </div>
                </div>
              )}
              <div style={{ display:'flex', gap:10, flexWrap:'wrap', marginBottom:b.reflection?14:0 }}>
                {b.done && <Pill color={T.green} bg={T.greenSoft}>✓ {b.done}</Pill>}
                {b.worth && <Pill color={b.worth==='да'?T.green:T.red} bg={b.worth==='да'?T.greenSoft:T.redSoft}>
                  {b.worth==='да'?'Струваше си':'Не си струваше'}</Pill>}
              </div>
              {b.reflection && <div style={{ fontSize:13.5, color:T.text, lineHeight:1.6 }}>{b.reflection}</div>}
            </Card>
            {b.photos && (
              <>
                <Eyebrow style={{ margin:'18px 2px 10px' }}>Снимки · {b.photos}</Eyebrow>
                <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr 1fr', gap:7 }}>
                  {Array.from({length:Math.min(6,b.photos)}).map((_,i)=><PhotoTile key={i} hue={(i*43+120)%360}/>)}
                </div>
              </>
            )}
          </>
        ) : (
          <>
            <Card style={{ marginTop:16, display:'flex', alignItems:'center', gap:13 }}>
              <div style={{ width:42, height:42, borderRadius:13, background:T.greenSoft, display:'flex', alignItems:'center', justifyContent:'center' }}>
                <Icon name="flag" size={21} color={T.green}/></div>
              <div style={{ flex:1, fontSize:13, color:T.textDim, lineHeight:1.5 }}>Изживя ли го вече? Запиши преживяването си.</div>
            </Card>
            <div style={{ marginTop:14 }}>
              <Btn full icon="check" variant="primary" onClick={()=>nav.openSheet('bucketComplete')}>Маркирай като завършено</Btn>
            </div>
          </>
        )}
      </Body>
    </>
  );
}

// ── Trips ─────────────────────────────────────────────────────────
function Trips() {
  const nav = useNav();
  return (
    <>
      <TopBar title="Пътувания" sub="лична история на пътуванията"
        right={<div onClick={()=>nav.openSheet('trip')} style={{ width:38, height:38, borderRadius:12, background:T.accent,
          display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer' }}><Icon name="plus" size={20} color="#0C0D11" sw={2.3}/></div>}/>
      <Body>
        <div style={{ display:'flex', gap:8, marginBottom:14 }}>
          <Card style={{ flex:1, textAlign:'center' }}><Stat label="Пътувания" value="7"/></Card>
          <Card style={{ flex:1, textAlign:'center' }}><Stat label="Ср. оценка" value="8.4" color={T.amber}/></Card>
          <Card style={{ flex:1, textAlign:'center' }}><Stat label="Бих повторил" value="6" color={T.green}/></Card>
        </div>
        <div style={{ display:'flex', flexDirection:'column', gap:14 }}>
          {TRIPS.map((t,i)=>(
            <div key={t.id} onClick={()=>nav.go('trip',{id:t.id})} style={{ cursor:'pointer' }}>
              <div style={{ position:'relative' }}>
                <PhotoTile hue={[40,220,150][i%3]} ratio="16/9" date={`${t.from} — ${t.to}`}/>
                <div style={{ position:'absolute', top:10, right:10, background:'rgba(12,13,17,0.8)', backdropFilter:'blur(6px)',
                  borderRadius:11, padding:'5px 10px', fontFamily:FM, fontSize:14, fontWeight:600, color:T.amber }}>★ {t.overall}</div>
              </div>
              <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginTop:9 }}>
                <div>
                  <div style={{ fontFamily:FS, fontSize:16, fontWeight:700, color:T.text }}>{t.title}</div>
                  <div style={{ fontFamily:FM, fontSize:12, color:T.textDim, marginTop:1 }}>{t.dest}</div>
                </div>
                {t.repeat && <Pill color={T.green} bg={T.greenSoft}>би повторил</Pill>}
              </div>
            </div>
          ))}
        </div>
      </Body>
    </>
  );
}
function RatingBar({ label, v, color = T.amber }) {
  return (
    <div style={{ display:'flex', alignItems:'center', gap:12 }}>
      <span style={{ fontFamily:FS, fontSize:13, color:T.textDim, width:110 }}>{label}</span>
      <div style={{ flex:1, height:7, borderRadius:4, background:'rgba(255,255,255,0.07)', overflow:'hidden' }}>
        <div style={{ width:`${v*10}%`, height:'100%', background:color }}/>
      </div>
      <span style={{ fontFamily:FM, fontSize:13, fontWeight:600, color:T.text, width:28, textAlign:'right' }}>{v}</span>
    </div>
  );
}
function Trip() {
  const nav = useNav();
  const t = TRIPS.find(x=>x.id===nav.params.id) || TRIPS[0];
  const hue = { t1:40, t2:220, t3:150 }[t.id] || 220;
  return (
    <>
      <TopBar title={t.title} sub={t.dest}/>
      <Body style={{ padding:0 }}>
        <div style={{ position:'relative' }}>
          <PhotoTile hue={hue} ratio="3/2" style={{ borderRadius:0, border:'none' }}/>
          <div style={{ position:'absolute', bottom:0, left:0, right:0, padding:'30px 16px 14px',
            background:'linear-gradient(transparent,rgba(12,13,17,0.9))' }}>
            <div style={{ display:'flex', alignItems:'center', gap:10 }}>
              <span style={{ fontFamily:FM, fontSize:30, fontWeight:600, color:T.amber }}>★ {t.overall}</span>
              {t.repeat && <Pill color={T.green} bg={T.greenSoft}>би повторил</Pill>}
            </div>
            <div style={{ fontFamily:FM, fontSize:12.5, color:T.textDim, marginTop:4 }}>{t.from} — {t.to}</div>
          </div>
        </div>
        <div style={{ padding:'16px 16px 22px' }}>
          <Card style={{ marginBottom:12 }}>
            <Eyebrow style={{ marginBottom:14 }}>Оценки</Eyebrow>
            <div style={{ display:'flex', flexDirection:'column', gap:12 }}>
              <RatingBar label="Забавление" v={t.fun}/>
              <RatingBar label="Храна" v={t.food} color={T.green}/>
              <RatingBar label="Места / гледки" v={t.sights} color={T.accent}/>
              <RatingBar label="Цена / преживяване" v={t.value} color={T.purple}/>
            </div>
          </Card>
          <Card style={{ marginBottom:12 }}>
            <Eyebrow>Коментар</Eyebrow>
            <div style={{ fontSize:14, color:T.text, marginTop:8, lineHeight:1.55 }}>{t.comment}</div>
          </Card>
          <Eyebrow style={{ margin:'4px 2px 10px' }}>Галерия · {t.photos} снимки</Eyebrow>
          <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr 1fr', gap:7 }}>
            {Array.from({length:6}).map((_,i)=><PhotoTile key={i} hue={hue+i*12}/>)}
          </div>
        </div>
      </Body>
    </>
  );
}

// ── Search ────────────────────────────────────────────────────────
function Search() {
  const [q, setQ] = useState('');
  const nav = useNav();
  const results = [
    { icon:'food', color:T.amber, t:'Сьомга на скара', s:'Храна · вечеря · 31 май', to:'food' },
    { icon:'expense', color:T.red, t:'Гориво OMV', s:'Разход · 120 лв. · 31 май', to:'finance' },
    { icon:'labs', color:T.accent, t:'Цибалаб · хормони', s:'Изследване · 12 май', to:'health' },
    { icon:'trip', color:T.green, t:'Уикенд в Рим', s:'Пътуване · окт 2025', to:'trips' },
    { icon:'star', color:T.amber, t:'Скок с парашут', s:'Bucket List · планирано', to:'bucket' },
  ];
  return (
    <>
      <TopBar title="Търсене"/>
      <Body>
        <div style={{ display:'flex', alignItems:'center', gap:10, background:T.card, border:`1px solid ${T.border}`,
          borderRadius:14, padding:'0 14px', marginBottom:16 }}>
          <Icon name="search" size={19} color={T.textDim}/>
          <input value={q} onChange={e=>setQ(e.target.value)} placeholder="Търси във всичко…" autoFocus
            style={{ flex:1, background:'none', border:'none', outline:'none', color:T.text, fontFamily:FS, fontSize:15, padding:'13px 0' }}/>
        </div>
        <Eyebrow style={{ marginBottom:10 }}>{q?'Резултати':'Скорошни'}</Eyebrow>
        <div style={{ display:'flex', flexDirection:'column', gap:8 }}>
          {results.filter(r=>!q || r.t.toLowerCase().includes(q.toLowerCase())).map((r,i)=>(
            <Row key={i} icon={r.icon} color={r.color} title={r.t} sub={r.s} onClick={()=>nav.go(r.to)}
              right={<Icon name="chevR" size={16} color={T.textFaint}/>}/>
          ))}
        </div>
      </Body>
    </>
  );
}

Object.assign(window.SCREENS, { daily:Daily, bucket:Bucket, bucketItem:BucketItem, trips:Trips, trip:Trip, search:Search });
})();
