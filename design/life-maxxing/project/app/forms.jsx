// app/forms.jsx — quick-log sheets, quick chooser, Export screen
window.SCREENS = window.SCREENS || {};
window.SHEETS = window.SHEETS || {};
(function(){
const { useState } = React;

function Save({ children = 'Запази', onClick }) {
  const nav = useNav();
  return <Btn full onClick={onClick || (()=>{ nav.closeSheet(); nav.showToast('Записано успешно'); })}>{children}</Btn>;
}

// ── Quick chooser ─────────────────────────────────────────────────
function QuickSheet() {
  const nav = useNav();
  return (
    <Sheet title="Бързо логване" sub="избери какво да добавиш" onClose={nav.closeSheet} maxH="auto">
      <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:10, paddingBottom:6 }}>
        {QUICK.map(q=>(
          <div key={q.id} onClick={()=>nav.openSheet(q.id)} style={{ background:T.card, border:`1px solid ${T.border}`,
            borderRadius:15, padding:'15px 14px', display:'flex', alignItems:'center', gap:12, cursor:'pointer' }}>
            <div style={{ width:42, height:42, borderRadius:13, background:'rgba(255,255,255,0.05)',
              display:'flex', alignItems:'center', justifyContent:'center' }}><Icon name={q.icon} size={22} color={q.color}/></div>
            <span style={{ fontFamily:FS, fontSize:14.5, fontWeight:600, color:T.text }}>{q.label}</span>
          </div>
        ))}
      </div>
    </Sheet>
  );
}

// ── Food ──────────────────────────────────────────────────────────
function FoodSheet() {
  const nav = useNav();
  const [type, setType] = useState('Обяд');
  const [name, setName] = useState('');
  return (
    <Sheet title="Ново хранене" sub="дата и име са задължителни" onClose={nav.closeSheet} footer={<Save/>}>
      <Field label="Тип хранене" required><Segmented options={['Закуска','Обяд','Вечеря','Snack','Друго']} value={type} onChange={setType}/></Field>
      <Field label="Име / описание" required><Input value={name} onChange={e=>setName(e.target.value)} placeholder="напр. Пилешко с ориз"/></Field>
      <div style={{ display:'flex', gap:10 }}>
        <div style={{ flex:1 }}><Field label="Час"><Input defaultValue="13:25"/></Field></div>
        <div style={{ flex:1 }}><Field label="Калории" hint="kcal"><Input type="number" placeholder="680"/></Field></div>
      </div>
      <div style={{ display:'flex', gap:10 }}>
        <div style={{ flex:1 }}><Field label="Протеин"><Input type="number" placeholder="г"/></Field></div>
        <div style={{ flex:1 }}><Field label="Въглехид."><Input type="number" placeholder="г"/></Field></div>
        <div style={{ flex:1 }}><Field label="Мазнини"><Input type="number" placeholder="г"/></Field></div>
      </div>
      <Field label="Бележка"><TextArea placeholder="незадължително"/></Field>
    </Sheet>
  );
}

// ── Expense ───────────────────────────────────────────────────────
const EXP_CATS = ['Храна','Забавления','Социални','Транспорт','Образование','Абонаменти','Автомобил','Дрехи и обувки','Здраве и добавки','Спорт','Външен вид','Вейп','Друго'];
function ExpenseSheet() {
  const nav = useNav();
  const [cat, setCat] = useState('Храна');
  return (
    <Sheet title="Нов разход" sub="сума, валута, категория, описание" onClose={nav.closeSheet} footer={<Save/>}>
      <div style={{ display:'flex', gap:10 }}>
        <div style={{ flex:2 }}><Field label="Сума" required><Input type="number" placeholder="0.00" style={{ fontFamily:FM, fontSize:22, fontWeight:600 }}/></Field></div>
        <div style={{ flex:1 }}><Field label="Валута" required><Segmented options={['лв.','€','$']} value="лв." onChange={()=>{}}/></Field></div>
      </div>
      <Field label="Категория" required>
        <div style={{ display:'flex', gap:7, flexWrap:'wrap' }}>
          {EXP_CATS.map(c=>(
            <button key={c} onClick={()=>setCat(c)} style={{ fontFamily:FS, fontSize:13, padding:'8px 12px', borderRadius:100,
              cursor:'pointer', border:`1px solid ${cat===c?T.red:T.border}`, background:cat===c?T.redSoft:T.card, color:cat===c?T.red:T.textDim }}>{c}</button>
          ))}
        </div>
      </Field>
      <Field label="Описание" required><Input placeholder="напр. Зареждане OMV"/></Field>
      <Field label="Начин на плащане"><Segmented options={['Карта','В брой','Друго']} value="Карта" onChange={()=>{}}/></Field>
      <Field label="Бележка"><TextArea placeholder="незадължително"/></Field>
    </Sheet>
  );
}

// ── Finance chooser (expense vs income) ───────────────────────────
function FinanceSheet() {
  const nav = useNav();
  const opts = [
    { id:'expense', label:'Разход', icon:'expense', color:T.red, sub:'пари навън' },
    { id:'income',  label:'Приход', icon:'income',  color:T.green, sub:'пари навътре' },
  ];
  return (
    <Sheet title="Нов запис" sub="разход или приход?" onClose={nav.closeSheet} maxH="auto">
      <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:10, paddingBottom:6 }}>
        {opts.map(o=>(
          <div key={o.id} onClick={()=>nav.openSheet(o.id)} style={{ background:T.card, border:`1px solid ${T.border}`,
            borderRadius:16, padding:'18px 16px', display:'flex', flexDirection:'column', gap:16, cursor:'pointer' }}>
            <div style={{ width:46, height:46, borderRadius:14, background:'rgba(255,255,255,0.05)',
              display:'flex', alignItems:'center', justifyContent:'center' }}><Icon name={o.icon} size={24} color={o.color}/></div>
            <div>
              <div style={{ fontFamily:FS, fontSize:16, fontWeight:700, color:T.text }}>{o.label}</div>
              <div style={{ fontFamily:FM, fontSize:11, color:T.textFaint, marginTop:2 }}>{o.sub}</div>
            </div>
          </div>
        ))}
      </div>
    </Sheet>
  );
}

// ── Income ────────────────────────────────────────────────────────
const INC_CATS = ['Заплата','Overtime','Лихви','Друго'];
function IncomeSheet() {
  const nav = useNav();
  const [cat, setCat] = useState('Заплата');
  return (
    <Sheet title="Нов приход" sub="сума, валута и източник са задължителни" onClose={nav.closeSheet} footer={<Save/>}>
      <div style={{ display:'flex', gap:10 }}>
        <div style={{ flex:2 }}><Field label="Сума" required><Input type="number" placeholder="0.00" style={{ fontFamily:FM, fontSize:22, fontWeight:600 }}/></Field></div>
        <div style={{ flex:1 }}><Field label="Валута" required><Segmented options={['лв.','€','$']} value="лв." onChange={()=>{}}/></Field></div>
      </div>
      <Field label="Източник" required><Input placeholder="напр. Заплата — Klevret"/></Field>
      <Field label="Категория" required>
        <div style={{ display:'flex', gap:7, flexWrap:'wrap' }}>
          {INC_CATS.map(c=>(
            <button key={c} onClick={()=>setCat(c)} style={{ fontFamily:FS, fontSize:13, padding:'8px 12px', borderRadius:100,
              cursor:'pointer', border:`1px solid ${cat===c?T.green:T.border}`, background:cat===c?T.greenSoft:T.card, color:cat===c?T.green:T.textDim }}>{c}</button>
          ))}
        </div>
      </Field>
      {cat==='Друго' && <Field label="Опиши източника"><Input placeholder="напр. дивидент, наем, подарък…"/></Field>}
      <Field label="Дата"><Input defaultValue="31.05.2026"/></Field>
      <Field label="Бележка"><TextArea placeholder="незадължително"/></Field>
    </Sheet>
  );
}

// ── Blood pressure ────────────────────────────────────────────────
function BpSheet() {
  const nav = useNav();
  const [sys, setSys] = useState(124), [dia, setDia] = useState(78), [pulse, setPulse] = useState(71);
  const bad = sys <= dia;
  return (
    <Sheet title="Кръвно и пулс" sub="дата, час и трите стойности са задължителни" onClose={nav.closeSheet}
      footer={<Save/>}>
      <div style={{ display:'flex', gap:10 }}>
        <div style={{ flex:1 }}><Field label="Дата"><Input defaultValue="31.05.2026"/></Field></div>
        <div style={{ flex:1 }}><Field label="Час"><Input defaultValue="08:20"/></Field></div>
      </div>
      <Field label="Систолично" required><Stepper value={sys} onChange={setSys} suffix="mmHg"/></Field>
      <Field label="Диастолично" required><Stepper value={dia} onChange={setDia} suffix="mmHg"/></Field>
      {bad && <div style={{ color:T.red, fontFamily:FM, fontSize:11.5, marginTop:-8, marginBottom:12 }}>Систоличното трябва да е по-голямо от диастоличното</div>}
      <Field label="Пулс" required><Stepper value={pulse} onChange={setPulse} suffix="bpm"/></Field>
      <Field label="Бележка"><Segmented options={['Сутрин','Вечер','В покой','След кафе','След тренировка']} value="Сутрин" onChange={()=>{}}/></Field>
    </Sheet>
  );
}

// ── Daily quick log ───────────────────────────────────────────────
function DailySheet() {
  const nav = useNav();
  const [mood, setMood] = useState(8);
  const [proud, setProud] = useState('да');
  const [unc, setUnc] = useState('да');
  const [workout, setWorkout] = useState('да');
  const [alc, setAlc] = useState('не');
  return (
    <Sheet title="Дневен отчет" sub="събота · 31 май 2026" onClose={nav.closeSheet} footer={<Save>Запази отчета</Save>}>
      <Field label="Настроение" required><MoodPicker value={mood} onChange={setMood}/></Field>
      <Field label="Горд ли си от себе си?" required><YesNo value={proud} onChange={setProud}/></Field>
      <Field label="Направи ли 1 неудобно нещо?" required><YesNo value={unc} onChange={setUnc}/></Field>
      {unc==='да' && <Field label="Какво неудобно нещо?"><TextArea placeholder="незадължително" defaultValue="Обадих се на клиент, който отлагах"/></Field>}
      <Field label="Тренировка?" required><YesNo value={workout} onChange={setWorkout}/></Field>
      <Field label="Пил ли си алкохол?" required><YesNo value={alc} onChange={setAlc}/></Field>
      {alc==='да' && <Field label="Какво пи?"><Input placeholder="напр. 2 бири"/></Field>}
      <div style={{ display:'flex', gap:10 }}>
        <div style={{ flex:1 }}><Field label="Screen time"><Input defaultValue="4h 30m"/></Field></div>
        <div style={{ flex:1 }}><Field label="Крачки" hint="заключено"><Input defaultValue="9 420" disabled style={{ color:T.textDim }}/></Field></div>
      </div>
      <Field label="Бележки"><TextArea placeholder="как мина денят?"/></Field>
      <Field label="Снимка на деня"><PhotoAdd/></Field>
    </Sheet>
  );
}

// ── Activity ──────────────────────────────────────────────────────
const ACT_CATS = ['Фитнес','BJJ','Бокс','Кикбокс','ММА','Тенис','Разходка в планината','Народни танци','Колоездене','Плуване','Ски','Друго'];
function ActivitySheet() {
  const nav = useNav();
  const [cat, setCat] = useState('Фитнес');
  return (
    <Sheet title="Нова активност" sub="дата, име и категория са задължителни" onClose={nav.closeSheet} footer={<Save/>}>
      <Field label="Категория" required>
        <div style={{ display:'flex', gap:7, flexWrap:'wrap' }}>
          {ACT_CATS.map(c=>(
            <button key={c} onClick={()=>setCat(c)} style={{ fontFamily:FS, fontSize:13, padding:'8px 12px', borderRadius:100,
              cursor:'pointer', border:`1px solid ${cat===c?T.green:T.border}`, background:cat===c?T.greenSoft:T.card, color:cat===c?T.green:T.textDim }}>{c}</button>
          ))}
        </div>
      </Field>
      <Field label="Име / описание" required><Input placeholder="напр. Гръб и бицепс"/></Field>
      <div style={{ display:'flex', gap:10 }}>
        <div style={{ flex:1 }}><Field label="Начало"><Input defaultValue="18:30"/></Field></div>
        <div style={{ flex:1 }}><Field label="Край"><Input defaultValue="19:35"/></Field></div>
        <div style={{ flex:1 }}><Field label="Мин."><Input defaultValue="65"/></Field></div>
      </div>
      <Field label="Интензивност"><Segmented options={['Ниска','Средна','Висока']} value="Висока" onChange={()=>{}}/></Field>
      <Field label="Продуктивност / настроение след"><Scale10 value={8} onChange={()=>{}} color={T.green}/></Field>
      <Field label="Бележка"><TextArea placeholder="незадължително"/></Field>
    </Sheet>
  );
}

// ── Steps ─────────────────────────────────────────────────────────
function StepsSheet() {
  const nav = useNav();
  return (
    <Sheet title="Крачки" sub="една стойност на ден" onClose={nav.closeSheet} footer={<Save/>}>
      <Field label="Дата"><Input defaultValue="31.05.2026"/></Field>
      <Field label="Брой крачки" required><Input type="number" placeholder="9420" style={{ fontFamily:FM, fontSize:22, fontWeight:600 }}/></Field>
      <Field label="Бележка"><TextArea placeholder="незадължително"/></Field>
    </Sheet>
  );
}

// ── Med ───────────────────────────────────────────────────────────
function MedSheet() {
  const nav = useNav();
  const [type, setType] = useState('Добавка');
  const [status, setStatus] = useState('Прието');
  return (
    <Sheet title="Медикамент / добавка" sub="дата, час, име, тип, статус" onClose={nav.closeSheet} footer={<Save/>}>
      <Field label="Име" required><Input placeholder="напр. Витамин D3"/></Field>
      <Field label="Тип" required><Segmented options={['Медикамент','Добавка','Витамин','Минерал','Спортна','Друго']} value={type} onChange={setType}/></Field>
      <div style={{ display:'flex', gap:10 }}>
        <div style={{ flex:1 }}><Field label="Час"><Input defaultValue="08:15"/></Field></div>
        <div style={{ flex:1 }}><Field label="Доза"><Input placeholder="4000 IU"/></Field></div>
      </div>
      <Field label="Статус" required><YesNo value={status==='Прието'?'да':'не'} onChange={v=>setStatus(v==='да'?'Прието':'Пропуснато')}/></Field>
      <div style={{ fontFamily:FM, fontSize:11, color:T.textFaint, marginTop:-8, marginBottom:12 }}>Да = Прието · Не = Пропуснато</div>
      <Field label="Бележка"><TextArea placeholder="незадължително"/></Field>
    </Sheet>
  );
}

// ── Bucket ────────────────────────────────────────────────────────
function BucketSheet() {
  const nav = useNav();
  const [prio, setPrio] = useState('Medium');
  const [status, setStatus] = useState('Idea');
  return (
    <Sheet title="Ново желание" sub="заглавие, приоритет и статус" onClose={nav.closeSheet} footer={<Save/>}>
      <Field label="Заглавие" required><Input placeholder="напр. Северно сияние в Исландия"/></Field>
      <Field label="Защо го искам"><TextArea placeholder="мотивацията зад желанието"/></Field>
      <Field label="Приоритет" required><Segmented options={['Low','Medium','High']} value={prio} onChange={setPrio} cols={3}/></Field>
      <Field label="Статус" required><Segmented options={['Idea','Planned','Completed','Abandoned']} value={status} onChange={setStatus}/></Field>
    </Sheet>
  );
}

// ── Bucket complete (experience) ──────────────────────────────────
function BucketCompleteSheet() {
  const nav = useNav();
  const [feel, setFeel] = useState(8);
  const [worth, setWorth] = useState('да');
  return (
    <Sheet title="Завърши желанието" sub="запиши преживяването си" onClose={nav.closeSheet}
      footer={<Save>Маркирай като завършено</Save>}>
      <Field label="Как се чувстваш?" required><MoodPicker value={feel} onChange={setFeel}/></Field>
      <Field label="Дата на изпълнение" required><Input defaultValue="31.05.2026"/></Field>
      <Field label="Струваше ли си?" required><YesNo value={worth} onChange={setWorth}/></Field>
      <Field label="Снимки"><PhotoAdd label="Добави снимки" multi/></Field>
      <Field label="Бележка / рефлексия"><TextArea placeholder="Как се почувства? Би ли го направил пак? Какво научи?"/></Field>
    </Sheet>
  );
}

// ── Trip ──────────────────────────────────────────────────────────
function TripSheet() {
  const nav = useNav();
  const [overall, setOverall] = useState(8);
  return (
    <Sheet title="Ново пътуване" sub="заглавие, дестинация, период, оценка" onClose={nav.closeSheet} footer={<Save/>}>
      <Field label="Заглавие" required><Input placeholder="напр. Уикенд в Рим"/></Field>
      <Field label="Дестинация" required><Input placeholder="напр. Рим, Италия"/></Field>
      <div style={{ display:'flex', gap:10 }}>
        <div style={{ flex:1 }}><Field label="От дата" required><Input defaultValue="10.10.2025"/></Field></div>
        <div style={{ flex:1 }}><Field label="До дата" required><Input defaultValue="13.10.2025"/></Field></div>
      </div>
      <Field label="Обща оценка" required hint={`${overall} / 10`}><Scale10 value={overall} onChange={setOverall} color={T.amber}/></Field>
      <Field label="Коментар"><TextArea placeholder="как беше?"/></Field>
      <Field label="Cover снимка"><PhotoAdd/></Field>
      <Field label="Галерия"><PhotoAdd label="Добави снимки" multi/></Field>
    </Sheet>
  );
}

// ── Export screen ─────────────────────────────────────────────────
const SAMPLE_JSON = `{
  "exportDate": "2026-05-31",
  "period": { "from": "2026-05-01", "to": "2026-05-31" },
  "summary": {
    "finance": { "totalIncome": 3280, "totalExpenses": 2090, "balance": 1190 },
    "health":  { "bpCount": 18, "avgSystolic": 126, "avgDiastolic": 79, "avgPulse": 73 }
  },
  "dailyQuickLogs": [ … 24 ],
  "meals": [ … ], "activities": [ … ],
  "expenses": [ … 47 ], "income": [ … 3 ],
  "trips": [ … 7 ], "bucketList": [ … 18 ]
}`;
function Export() {
  const nav = useNav();
  const [scope, setScope] = useState('Пълен');
  const [fmt, setFmt] = useState('JSON');
  const [period, setPeriod] = useState('30 дни');
  return (
    <>
      <TopBar title="Експорт за AI" sub="дай данните си на ChatGPT за анализ"/>
      <Body>
        <Field label="Обхват"><Segmented options={['Пълен','Период','Модул']} value={scope} onChange={setScope} cols={3}/></Field>
        {scope==='Период' && <Field label="Период"><PeriodChips value={period} onChange={setPeriod}/></Field>}
        {scope==='Модул' && <Field label="Модул">
          <div style={{ display:'flex', gap:7, flexWrap:'wrap' }}>
            {['Храна','Активности','Разходи','Приходи','Здраве','Крачки','Дневник','Bucket List','Пътувания'].map(m=>(
              <Pill key={m} color={T.textDim} style={{ padding:'7px 11px', fontSize:12, cursor:'pointer' }}>{m}</Pill>
            ))}
          </div>
        </Field>}
        <Field label="Формат"><Segmented options={['JSON','Markdown','CSV']} value={fmt} onChange={setFmt} cols={3}/></Field>

        <Eyebrow style={{ margin:'6px 2px 10px' }}>Преглед</Eyebrow>
        <div style={{ background:T.bg, border:`1px solid ${T.border}`, borderRadius:14, padding:14, marginBottom:14 }}>
          {fmt==='Markdown' ? (
            <pre style={{ fontFamily:FM, fontSize:11, color:T.textDim, margin:0, whiteSpace:'pre-wrap', lineHeight:1.6 }}>
{`# LifeMaxxing · 1–31 май 2026

## Резюме
- Баланс: +1 190 лв.
- Ср. настроение: 7.2 · Тренировки: 16
- Ср. кръвно: 126/79 · пулс 73

## Questions for AI
1. Анализирай последните 30 дни.
2. Намери модели в храна, пари, настроение, здраве.
3. Къде се подобрявам? Къде се саботирам?`}
            </pre>
          ) : (
            <pre style={{ fontFamily:FM, fontSize:11, color:T.textDim, margin:0, whiteSpace:'pre-wrap', lineHeight:1.55 }}>{SAMPLE_JSON}</pre>
          )}
        </div>

        <div style={{ display:'flex', gap:10, marginBottom:10 }}>
          <Card style={{ flex:1, textAlign:'center' }}><Stat label="Записи" value="160"/></Card>
          <Card style={{ flex:1, textAlign:'center' }}><Stat label="Снимки" value="86"/></Card>
          <Card style={{ flex:1, textAlign:'center' }}><Stat label="Размер" value="2.4" unit="MB"/></Card>
        </div>
        <Btn full icon="export" onClick={()=>nav.showToast('Експортът е готов · '+fmt)}>Експортирай {fmt}</Btn>
        <div style={{ textAlign:'center', fontFamily:FM, fontSize:11, color:T.textFaint, marginTop:12, lineHeight:1.6 }}>
          Markdown е готов за copy-paste в ChatGPT.<br/>За пълен архив със снимки → Backup & Restore.
        </div>
      </Body>
    </>
  );
}

Object.assign(window.SHEETS, {
  quick:QuickSheet, food:FoodSheet, expense:ExpenseSheet, income:IncomeSheet, finance:FinanceSheet, bp:BpSheet, daily:DailySheet,
  activity:ActivitySheet, steps:StepsSheet, med:MedSheet, bucket:BucketSheet, bucketComplete:BucketCompleteSheet, trip:TripSheet,
});
Object.assign(window.SCREENS, { export:Export });
})();
