// app/backup.jsx — Backup & Restore (full ZIP backup, distinct from AI export)
window.SCREENS = window.SCREENS || {};
(function(){
const { useState } = React;

const INCLUDES = [
  'Храна и активности', 'Разходи и приходи', 'Кръвно, пулс и добавки', 'Здравни събития',
  'Изследвания', 'Daily Quick Logs', 'Крачки', 'Bucket List + преживявания',
  'Пътувания', 'Всички снимки', 'Прикачени файлове', 'Metadata + schema версия',
];

const CHECKS = [
  'ZIP файлът е валиден',
  'manifest.json намерен',
  'data.json намерен',
  'schemaVersion 1 · поддържана',
  '86 снимки · съвпадат с data.json',
  '160 записа · валидна структура',
];

const TREE = `lifemaxxing-backup-2026-05-31.zip
├── manifest.json
├── data.json
└── attachments/
    ├── meals/ · activities/
    ├── health-events/ · lab-results/
    ├── daily-photos/ · bucket-list/
    ├── bucket-list-experiences/
    └── trips/`;

const MANIFEST = `{
  "appName": "LifeMaxxing",
  "backupType": "full",
  "createdAt": "2026-05-31T20:30:00",
  "schemaVersion": 1,
  "appVersion": "1.0.0",
  "dataFile": "data.json",
  "attachmentsFolder": "attachments"
}`;

function Backup() {
  const nav = useNav();
  const [created, setCreated] = useState(false);
  const [picked, setPicked] = useState(false);

  return (
    <>
      <TopBar title="Backup & Restore" sub="запази и възстанови цялото приложение"/>
      <Body>
        {/* Distinction note */}
        <div style={{ background:T.accentSoft, border:'1px solid rgba(106,168,255,0.25)', borderRadius:13,
          padding:'11px 13px', display:'flex', gap:10, marginBottom:18 }}>
          <Icon name="bolt" size={17} color={T.accent} style={{ marginTop:1 }}/>
          <div style={{ fontSize:12.5, color:T.text, lineHeight:1.5 }}>
            За анализ от AI ползвай <b style={{color:T.accent}}>Експорт</b> (JSON/Markdown).
            Тук е пълен архив за възстановяване след преинсталация.
          </div>
        </div>

        {/* ── Full backup ── */}
        <SectionTitle>Пълен backup · ZIP</SectionTitle>
        <Card>
          <div style={{ display:'flex', alignItems:'center', gap:12, marginBottom:14 }}>
            <div style={{ width:42, height:42, borderRadius:13, background:T.greenSoft, display:'flex', alignItems:'center', justifyContent:'center' }}>
              <Icon name="export" size={21} color={T.green}/></div>
            <div>
              <div style={{ fontFamily:FS, fontSize:14.5, fontWeight:700, color:T.text }}>Архивирай всичко</div>
              <div style={{ fontFamily:FM, fontSize:11, color:T.textFaint }}>structured данни + снимки + файлове</div>
            </div>
          </div>
          <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:'8px 12px' }}>
            {INCLUDES.map(it=>(
              <div key={it} style={{ display:'flex', alignItems:'center', gap:7 }}>
                <Icon name="check" size={13} color={T.green} sw={2.6}/>
                <span style={{ fontSize:11.5, color:T.textDim }}>{it}</span>
              </div>
            ))}
          </div>
        </Card>

        <div style={{ display:'flex', alignItems:'center', gap:8, margin:'12px 2px', fontFamily:FM, fontSize:11.5, color:T.textFaint }}>
          <Icon name="clock" size={14} color={T.textFaint}/>
          Последен backup · 28 май 2026, 21:14 · <span style={{color:T.green}}>валиден</span>
        </div>

        <Btn full icon="export" onClick={()=>{ setCreated(true); nav.showToast('Backup създаден · 2.4 MB'); }}>Създай Full Backup (ZIP)</Btn>

        {created && (
          <div style={{ marginTop:12 }}>
            <Card>
              <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:10 }}>
                <Eyebrow>Готов архив</Eyebrow>
                <span onClick={()=>nav.showToast('Споделяне…')} style={{ display:'flex', alignItems:'center', gap:5,
                  fontFamily:FM, fontSize:11.5, color:T.accent, cursor:'pointer' }}><Icon name="export" size={13} color={T.accent}/> Сподели</span>
              </div>
              <pre style={{ fontFamily:FM, fontSize:11, color:T.textDim, margin:0, whiteSpace:'pre', overflowX:'auto', lineHeight:1.65 }}>{TREE}</pre>
              <Eyebrow style={{ margin:'14px 0 8px' }}>manifest.json</Eyebrow>
              <pre style={{ fontFamily:FM, fontSize:10.5, color:T.textDim, margin:0, whiteSpace:'pre-wrap',
                background:T.bg, border:`1px solid ${T.border}`, borderRadius:11, padding:'11px 12px', lineHeight:1.6 }}>{MANIFEST}</pre>
            </Card>
          </div>
        )}

        {/* ── Restore ── */}
        <SectionTitle>Възстановяване от backup</SectionTitle>
        {!picked ? (
          <div onClick={()=>setPicked(true)} style={{ border:`1.5px dashed ${T.borderHi}`, borderRadius:14, padding:'24px',
            display:'flex', flexDirection:'column', alignItems:'center', gap:9, cursor:'pointer', background:'rgba(255,255,255,0.02)' }}>
            <Icon name="income" size={26} color={T.textDim}/>
            <span style={{ fontFamily:FS, fontSize:13.5, color:T.text, fontWeight:600 }}>Избери ZIP backup файл</span>
            <span style={{ fontFamily:FM, fontSize:11, color:T.textFaint }}>.zip · от устройството</span>
          </div>
        ) : (
          <>
            <Row icon="export" color={T.accent} title="lifemaxxing-backup-2026-05-31.zip" sub="2.4 MB · избран"
              right={<span onClick={()=>setPicked(false)} style={{ cursor:'pointer' }}><Icon name="close" size={18} color={T.textFaint}/></span>}/>
            <Card style={{ marginTop:10 }}>
              <Eyebrow style={{ marginBottom:11 }}>Валидация</Eyebrow>
              <div style={{ display:'flex', flexDirection:'column', gap:9 }}>
                {CHECKS.map(c=>(
                  <div key={c} style={{ display:'flex', alignItems:'center', gap:9 }}>
                    <div style={{ width:18, height:18, borderRadius:'50%', background:T.greenSoft, display:'flex', alignItems:'center', justifyContent:'center', flexShrink:0 }}>
                      <Icon name="check" size={11} color={T.green} sw={3}/></div>
                    <span style={{ fontSize:12.5, color:T.textDim }}>{c}</span>
                  </div>
                ))}
              </div>
            </Card>
            <div style={{ marginTop:12, background:T.amberSoft, border:'1px solid rgba(245,195,107,0.3)', borderRadius:14, padding:'13px 15px' }}>
              <div style={{ display:'flex', gap:10 }}>
                <Icon name="bolt" size={18} color={T.amber} style={{ marginTop:1 }}/>
                <div style={{ fontSize:12.5, color:T.text, lineHeight:1.5 }}>
                  В приложението вече има данни. Restore ще <b>замени</b> текущите данни с тези от backup файла.
                </div>
              </div>
            </div>
            <div style={{ display:'flex', gap:10, marginTop:12 }}>
              <Btn variant="ghost" style={{ flex:1 }} onClick={()=>setPicked(false)}>Откажи</Btn>
              <Btn variant="danger" style={{ flex:1.4 }} icon="income" onClick={()=>{ setPicked(false); nav.showToast('Възстановяването завършено'); }}>Замени и възстанови</Btn>
            </div>
          </>
        )}
      </Body>
    </>
  );
}

Object.assign(window.SCREENS, { backup:Backup });
})();
