// lib/data.jsx — realistic Bulgarian sample data for LifeMaxxing
// Today is 31 май 2026. Currency BGN (лв.).

const MONTHS_BG = ['януари','февруари','март','април','май','юни','юли','август','септември','октомври','ноември','декември'];
const MONTHS_BG_SHORT = ['яну','фев','мар','апр','май','юни','юли','авг','сеп','окт','ное','дек'];
const DOW_BG = ['нд','пн','вт','ср','чт','пт','сб'];
const DOW_BG_FULL = ['неделя','понеделник','вторник','сряда','четвъртък','петък','събота'];

const TODAY = new Date(2026, 4, 31); // 31 May 2026

function fmtDate(d) { return `${d.getDate()} ${MONTHS_BG_SHORT[d.getMonth()]}`; }
function fmtDateFull(d) { return `${d.getDate()} ${MONTHS_BG[d.getMonth()]} ${d.getFullYear()}`; }
function fmtBGN(n) { return new Intl.NumberFormat('bg-BG', { maximumFractionDigits: 0 }).format(Math.round(n)) + ' лв.'; }
function fmtBGN2(n) { return new Intl.NumberFormat('bg-BG', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(n) + ' лв.'; }

// seeded pseudo-random for reproducible series
function mulberry(seed) { return function() {
  let t = seed += 0x6D2B79F5;
  t = Math.imul(t ^ (t >>> 15), t | 1);
  t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
  return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
}; }

// Build last N days of daily metrics
function buildDays(n) {
  const rnd = mulberry(77);
  const out = [];
  for (let i = n - 1; i >= 0; i--) {
    const d = new Date(TODAY); d.setDate(TODAY.getDate() - i);
    const dow = d.getDay();
    const weekend = dow === 0 || dow === 6;
    const steps = Math.round(4200 + rnd() * 7800 + (weekend ? 1500 : 0));
    const mood = Math.max(3, Math.min(10, Math.round(6.4 + Math.sin(i / 3) * 1.5 + (rnd() - 0.4) * 2)));
    const cals = Math.round(1850 + rnd() * 750 + (weekend ? 350 : 0));
    const sys = Math.round(118 + rnd() * 16 + (weekend ? 4 : 0));
    const dia = Math.round(74 + rnd() * 10);
    const pulse = Math.round(64 + rnd() * 16);
    const expense = Math.round(15 + rnd() * 130 + (weekend ? 60 : 0));
    const income = (i % 30 === 1) ? 2500 : (rnd() > 0.9 ? Math.round(rnd() * 400) : 0);
    const screen = +(2.5 + rnd() * 4).toFixed(1);
    const workout = rnd() > 0.55;
    const alcohol = weekend && rnd() > 0.4;
    out.push({ d, dow, steps, mood, cals, sys, dia, pulse, expense, income, screen, workout, alcohol });
  }
  return out;
}

const DAYS30 = buildDays(30);
const last7 = DAYS30.slice(-7);

// ── Today snapshot ────────────────────────────────────────────────
const TODAY_STATS = {
  mood: 8,
  steps: 9420, stepsGoal: 10000,
  cals: 2180, calsGoal: 2400, protein: 142, carbs: 198, fat: 71,
  expense: 86, income: 0,
  bp: { sys: 124, dia: 78, pulse: 71, time: '08:20' },
  workout: true, alcohol: false,
  screen: 4.5,
  mealsCount: 3, activitiesCount: 2, medsToday: 3,
};

// ── Quick log actions ─────────────────────────────────────────────
const QUICK = [
  { id: 'food',   label: 'Храна',    icon: 'food',    color: T.amber },
  { id: 'expense',label: 'Разход',   icon: 'expense', color: T.red },
  { id: 'bp',     label: 'Кръвно',   icon: 'pulse',   color: T.pink },
  { id: 'daily',  label: 'Дневник',  icon: 'sun',     color: T.accent },
  { id: 'activity',label:'Активност',icon: 'run',     color: T.green },
  { id: 'steps',  label: 'Крачки',   icon: 'steps',   color: T.purple },
  { id: 'med',    label: 'Добавка',  icon: 'pill',    color: T.accent },
];

// ── Meals (храна) ─────────────────────────────────────────────────
const MEALS = [
  { id:'m1', type:'Закуска', name:'Овесена каша с банан и фъстъчено масло', time:'08:10', cals:420, p:14, c:58, f:15 },
  { id:'m2', type:'Обяд', name:'Пилешко с ориз и салата', time:'13:25', cals:680, p:52, c:64, f:22 },
  { id:'m3', type:'Snack', name:'Протеинов шейк + ябълка', time:'17:00', cals:280, p:32, c:34, f:4 },
  { id:'m4', type:'Вечеря', name:'Сьомга на скара със зеленчуци', time:'20:15', cals:560, p:44, c:18, f:34, note:'Без хляб' },
];

// ── Activities (активности) ───────────────────────────────────────
const ACTIVITIES = [
  { id:'a1', cat:'Фитнес', name:'Гръб и бицепс', start:'18:30', dur:65, intensity:'Висока', mood:8, color:T.green },
  { id:'a2', cat:'BJJ', name:'Вечерна тренировка — gi', start:'20:00', dur:90, intensity:'Висока', mood:9, color:T.accent },
  { id:'a3', cat:'Колоездене', name:'Обиколка на Витоша', start:'08:30', dur:120, intensity:'Средна', mood:8, color:T.purple },
  { id:'a4', cat:'Плуване', name:'Сутрешно плуване — 1500м', start:'07:00', dur:45, intensity:'Средна', mood:7, color:T.pink },
];

// ── Expenses (разходи) ────────────────────────────────────────────
const EXPENSES = [
  { id:'e1', cat:'Храна', desc:'Обяд навън — Happy', amount:32, time:'13:40', pay:'Карта', color:T.amber },
  { id:'e2', cat:'Автомобил', desc:'Зареждане OMV', amount:120, time:'10:15', pay:'Карта', color:T.red },
  { id:'e3', cat:'Здраве и добавки', desc:'Креатин + витамин D', amount:54, time:'16:20', pay:'Карта', color:T.green },
  { id:'e4', cat:'Социални', desc:'Кафе с приятели', amount:18, time:'19:00', pay:'В брой', color:T.purple },
  { id:'e5', cat:'Абонаменти', desc:'Netflix + iCloud', amount:42, time:'—', pay:'Карта', color:T.accent },
];

const EXPENSE_CATS = [
  { cat:'Храна', value:640, color:T.amber },
  { cat:'Автомобил', value:420, color:T.red },
  { cat:'Здраве и добавки', value:300, color:T.pink },
  { cat:'Социални', value:230, color:T.purple },
  { cat:'Абонаменти', value:180, color:T.accent },
  { cat:'Друго', value:320, color:T.textDim },
];

const INCOME = [
  { id:'i1', source:'Заплата', cat:'Заплата', amount:2500, date:'1 май' },
  { id:'i2', source:'Overtime — нощни смени', cat:'Overtime', amount:600, date:'14 май' },
  { id:'i3', source:'Лихва по депозит', cat:'Лихви', amount:180, date:'22 май' },
];

const FIN = {
  income: 3280, expenses: 2090, get balance(){ return this.income - this.expenses; },
  topCat: 'Храна', avgDaily: 70, expCount: 47, incCount: 3,
};

// ── Health ────────────────────────────────────────────────────────
const HEALTH_EVENTS = [
  { id:'h1', type:'Зъболекар', sub:'Почистване', clinic:'Д-р Иванова', date:'18 май', price:80, next:'18 ное', what:'Профилактично почистване и преглед' },
  { id:'h2', type:'Лекар', clinic:'Д-р Петров — кардиолог', date:'4 май', price:120, what:'Профилактичен преглед, ЕКГ — норма' },
  { id:'h3', type:'Процедура', clinic:'Кинезис', date:'27 апр', price:50, what:'Физиотерапия — рамо' },
];

const LAB_TESTS = [
  { id:'l1', lab:'Цибалаб', reason:'Хормони', date:'12 май', photos:2,
    results:'Testosterone: 24.1 nmol/L\nTSH: 1.8 mIU/L\nVitamin D: 32 ng/ml\nGlucose: 5.1 mmol/L' },
  { id:'l2', lab:'Рамус', reason:'Профилактика', date:'2 апр', photos:1,
    results:'ALT: 28 U/L\nAST: 24 U/L\nХолестерол: 4.6 mmol/L\nКреатинин: 88 µmol/L' },
];

const BP_LOGS = [
  { id:'b1', date:'31 май', time:'08:20', sys:124, dia:78, pulse:71, note:'Сутрин след събуждане' },
  { id:'b2', date:'30 май', time:'22:10', sys:131, dia:82, pulse:76, note:'Вечер преди лягане' },
  { id:'b3', date:'30 май', time:'08:05', sys:122, dia:77, pulse:69, note:'В покой' },
  { id:'b4', date:'29 май', time:'08:30', sys:127, dia:80, pulse:73, note:'След кафе' },
];

const MEDS = [
  { id:'md1', name:'Витамин D3', type:'Витамин', dose:'4000 IU', time:'08:15', status:'Прието' },
  { id:'md2', name:'Омега-3', type:'Добавка', dose:'2 капс.', time:'08:15', status:'Прието' },
  { id:'md3', name:'Магнезий', type:'Минерал', dose:'400 mg', time:'22:00', status:'Прието' },
  { id:'md4', name:'Креатин', type:'Спортна добавка', dose:'5 g', time:'—', status:'Пропуснато' },
];

const HEALTH_STATS = {
  bpCount: 18, avgSys: 126, avgDia: 79, avgPulse: 73,
  lastBp: '124/78', lastPulse: 71,
  eventsCount: 3, labsCount: 2, medsCount: 84,
  lastDental: '18 май', lastLab: '12 май',
};

// ── Daily Quick Log ───────────────────────────────────────────────
const DAILY = {
  date: TODAY, mood: 8, proud: true, uncomfortable: true,
  uncomfortableWhat: 'Обадих се на клиент, който отлагах от седмица',
  workout: true, alcohol: false, screen: 4.5, steps: 9420,
  note: 'Силен ден. Тренировката беше тежка но качествена. Изядох малко повече въглехидрати следобед.',
  hasPhoto: true,
};

const DAILY_SUMMARY = {
  filled: 24, avgMood: 7.2, proudDays: 18, uncomfortableDays: 14,
  workoutDays: 16, alcoholDays: 6, noAlcoholDays: 24, avgScreen: 4.8,
};

// ── Steps ─────────────────────────────────────────────────────────
const STEPS_STATS = {
  total: 248400, avg: 8280, best: 16240, worst: 3120, daysLogged: 30, goal: 10000,
};

// ── Bucket List ───────────────────────────────────────────────────
const BUCKET = [
  { id:'bl1', title:'Скок с парашут', why:'Да победя страха си от височини веднъж завинаги', prio:'High', status:'Planned' },
  { id:'bl2', title:'Северно сияние в Исландия', why:'Откакто се помня искам да го видя на живо', prio:'High', status:'Idea' },
  { id:'bl3', title:'Маратон под 4 часа', why:'Дисциплина и доказателство към себе си', prio:'Medium', status:'Planned' },
  { id:'bl4', title:'Да науча да карам сноуборд', why:'', prio:'Low', status:'Completed', done:'фев 2026', feeling:9, worth:'да', photos:6,
    reflection:'Падах постоянно първите два дни, но на третия беше магия. Определено бих повторил.' },
  { id:'bl5', title:'Уикенд в Рим', why:'Архитектура и храна', prio:'Medium', status:'Completed', done:'окт 2025', feeling:8, worth:'да', photos:4,
    reflection:'Всяка пресечка беше като картина. По 20 000 крачки на ден, но всяка си заслужаваше.' },
  { id:'bl6', title:'Татуировка', why:'', prio:'Low', status:'Abandoned' },
];

const BUCKET_STATS = { total:18, ideas:7, planned:5, completed:4, abandoned:2, high:6 };

// ── Trips (пътувания) ─────────────────────────────────────────────
const TRIPS = [
  { id:'t1', title:'Уикенд в Рим', dest:'Рим, Италия', from:'10 окт', to:'13 окт 2025', year:2025,
    overall:9, fun:9, food:10, sights:9, value:7, repeat:true,
    comment:'Невероятна храна и история на всяка крачка. Малко скъпо но си заслужаваше.', photos:12, color:T.amber },
  { id:'t2', title:'Ски в Банско', dest:'Банско, България', from:'2 фев', to:'6 фев 2026', year:2026,
    overall:8, fun:9, food:7, sights:8, value:8, repeat:true,
    comment:'Чудесен сняг, научих сноуборд. Хотелът можеше да е по-добър.', photos:24, color:T.accent },
  { id:'t3', title:'Гръцко лято', dest:'Тасос, Гърция', from:'18 юли', to:'25 юли 2025', year:2025,
    overall:9, fun:8, food:8, sights:10, value:9, repeat:true,
    comment:'Кристална вода, спокойствие, най-добрата ни почивка от години.', photos:38, color:T.green },
];

const TRIPS_STATS = { count:7, avgOverall:8.4, best:'Уикенд в Рим', repeatCount:6,
  avgFun:8.3, avgFood:8.1, avgSights:9.0, avgValue:7.9 };

// ── Visual diary (photos) ─────────────────────────────────────────
// dates that have a daily photo (last ~20 days, subset)
const DIARY_DAYS = DAYS30.filter((_, i) => [29,28,26,24,23,21,19,17,15,12,10,8,5,3,1,0].includes(i))
  .map(x => x.d);

Object.assign(window, {
  MONTHS_BG, MONTHS_BG_SHORT, DOW_BG, DOW_BG_FULL, TODAY,
  fmtDate, fmtDateFull, fmtBGN, fmtBGN2,
  DAYS30, last7, TODAY_STATS, QUICK,
  MEALS, ACTIVITIES, EXPENSES, EXPENSE_CATS, INCOME, FIN,
  HEALTH_EVENTS, LAB_TESTS, BP_LOGS, MEDS, HEALTH_STATS,
  DAILY, DAILY_SUMMARY, STEPS_STATS, BUCKET, BUCKET_STATS,
  TRIPS, TRIPS_STATS, DIARY_DAYS,
});
