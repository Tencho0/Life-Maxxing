// app/app.jsx — root: nav state, sheet, toast, scale-to-fit stage. Loaded last.
const { useState, useEffect, useCallback } = React;

function Root() {
  const [history, setHistory] = useState([{ screen:'home', params:{} }]);
  const [sheet, setSheet] = useState(null);
  const [toast, setToast] = useState(null);
  const cur = history[history.length - 1];

  const go = useCallback((screen, params = {}) => setHistory(h => [...h, { screen, params }]), []);
  const tab = useCallback((screen) => setHistory([{ screen, params:{} }]), []);
  const back = useCallback(() => setHistory(h => h.length > 1 ? h.slice(0, -1) : h), []);
  const openSheet = useCallback((type) => setSheet(type), []);
  const closeSheet = useCallback(() => setSheet(null), []);
  const showToast = useCallback((msg) => {
    setToast(msg);
    clearTimeout(window.__tt); window.__tt = setTimeout(() => setToast(null), 2200);
  }, []);

  const nav = {
    screen: cur.screen, params: cur.params, canBack: history.length > 1,
    go, tab, back, openSheet, closeSheet, sheet, showToast,
  };

  const ScreenComp = (window.SCREENS && window.SCREENS[cur.screen]) || window.SCREENS.home;
  const SheetComp = sheet && window.SHEETS && window.SHEETS[sheet];

  return (
    <NavCtx.Provider value={nav}>
      <div style={{ position:'relative', height:'100%', display:'flex', flexDirection:'column',
        background:T.bg, fontFamily:FS, color:T.text, overflow:'hidden' }}>
        <ScreenComp key={cur.screen + JSON.stringify(cur.params)} />
        <BottomNav/>
        {SheetComp && <SheetComp/>}
        <Toast msg={toast}/>
      </div>
    </NavCtx.Provider>
  );
}

// ── Scale-to-fit stage ────────────────────────────────────────────
function Stage() {
  const FW = 430, FH = 912; // device footprint incl. bezel
  const [scale, setScale] = useState(1);
  useEffect(() => {
    const fit = () => setScale(Math.min(1, (window.innerWidth - 16) / FW, (window.innerHeight - 16) / FH));
    fit(); window.addEventListener('resize', fit);
    return () => window.removeEventListener('resize', fit);
  }, []);
  return (
    <div style={{ position:'fixed', inset:0, background:'#070809', display:'flex',
      alignItems:'center', justifyContent:'center', overflow:'hidden' }}>
      <div style={{ zoom: scale }}>
        <AndroidDevice dark width={412} height={892}>
          <Root/>
        </AndroidDevice>
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<Stage/>);
