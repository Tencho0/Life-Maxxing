"""Synthesize a minimal 15s music bed for the LifeMaxxing promo.
Soft pad (Am-F-C-G), 120 BPM kick on the cuts, subtle hats, a riser into the
2s drop, and impacts on the brand/CTA cards. Tasteful + low — sits under the VO.
Output: promo/work/music.wav (stereo, 44.1k, 16-bit).
"""
import numpy as np, wave, struct, os

SR = 44100
DUR = 15.0
N = int(SR * DUR)
t = np.arange(N) / SR
L = np.zeros(N); R = np.zeros(N)

def idx(tt): return int(tt * SR)

def add(buf, start, sig, paninfo=0.0):
    s = idx(start); e = min(s + len(sig), N)
    if s >= N: return
    seg = sig[:e - s]
    gl = 0.5 * (1 - paninfo); gr = 0.5 * (1 + paninfo)
    L[s:e] += seg * gl * 2; R[s:e] += seg * gr * 2

def note(freq, dur, detune=0.0):
    n = int(dur * SR); tt = np.arange(n) / SR
    f = freq * (2 ** (detune / 1200.0))
    return np.sin(2*np.pi*f*tt) + 0.28*np.sin(2*np.pi*2*f*tt) + 0.12*np.sin(2*np.pi*3*f*tt)

def env(n, a, r):
    e = np.ones(n)
    ai = int(a*SR); ri = int(r*SR)
    if ai: e[:ai] = np.linspace(0,1,ai)
    if ri: e[-ri:] = np.linspace(1,0,ri)
    return e

# ── Pad: Am - F - C - G, each ~ a few seconds, crossfaded ──────────────
chords = [
    (0.0, 4.3, [110.00, 261.63, 329.63, 440.00]),   # Am
    (4.0, 8.3, [ 87.31, 220.00, 261.63, 349.23]),   # F
    (8.0, 12.3,[130.81, 329.63, 392.00, 523.25]),   # C
    (12.0,15.0,[ 98.00, 246.94, 293.66, 392.00]),   # G
]
for (st, en, ns) in chords:
    dur = en - st
    n = int(dur*SR)
    e = env(n, 0.5, 0.5)
    sig = np.zeros(n)
    for f in ns:
        sig += note(f, dur, detune=-4) + note(f, dur, detune=+4)
    sig = sig / (len(ns)*2) * e * 0.16
    add(L if False else L, st, sig)  # center pad
    s = idx(st); ee = min(s+len(sig), N)
    R[s:ee] += sig[:ee-s]

# ── Kick: 120 BPM (every 0.5s) through the main section ────────────────
def kick(amp):
    d = 0.22; n = int(d*SR); tt = np.arange(n)/SR
    f = 48 + 80*np.exp(-tt*38)
    ph = 2*np.pi*np.cumsum(f)/SR
    e = np.exp(-tt*20)
    return np.sin(ph)*e*amp

beat = 0.5
tt = 2.0
while tt < 12.0:
    downbeat = abs(tt - round(tt)) < 1e-6
    k = kick(0.95 if downbeat else 0.55)
    s = idx(tt); ee = min(s+len(k), N); L[s:ee]+=k[:ee-s]; R[s:ee]+=k[:ee-s]
    tt += beat
# a final punch on the CTA
for tt in (13.5,):
    k = kick(0.9); s=idx(tt); ee=min(s+len(k),N); L[s:ee]+=k[:ee-s]; R[s:ee]+=k[:ee-s]

# ── Hats: short noisy ticks on the off-beats ───────────────────────────
rng = np.random.default_rng(7)
def hat(amp):
    d=0.05; n=int(d*SR); noise=rng.standard_normal(n)
    noise = noise - np.convolve(noise, np.ones(8)/8, mode='same')  # crude highpass
    return noise*np.exp(-np.arange(n)/SR*120)*amp
tt = 2.25
while tt < 12.0:
    h = hat(0.10); s=idx(tt); ee=min(s+len(h),N)
    pan = 0.15
    L[s:ee]+=h[:ee-s]*(1-pan); R[s:ee]+=h[:ee-s]*(1+pan)
    tt += beat

# ── Riser into the 2.0s drop ───────────────────────────────────────────
rn = idx(2.0); rt = np.arange(rn)/SR
sweep = np.sin(2*np.pi*np.cumsum(150+1200*(rt/2.0))/SR)
ramp = (rt/2.0)**2
noise = rng.standard_normal(rn); noise = noise-np.convolve(noise,np.ones(12)/12,mode='same')
riser = (sweep*0.5 + noise*0.5)*ramp*0.25
L[:rn]+=riser; R[:rn]+=riser

# ── Impacts on drop / brand / CTA ──────────────────────────────────────
def impact(amp):
    d=0.7; n=int(d*SR); tt2=np.arange(n)/SR
    boom = np.sin(2*np.pi*55*tt2)*np.exp(-tt2*7)
    crash = (rng.standard_normal(n)); crash = crash-np.convolve(crash,np.ones(6)/6,mode='same')
    crash *= np.exp(-tt2*5)
    return (boom*0.8 + crash*0.4)*amp
for tt in (2.0, 12.0, 13.5):
    im = impact(0.6); s=idx(tt); ee=min(s+len(im),N); L[s:ee]+=im[:ee-s]; R[s:ee]+=im[:ee-s]

# ── Master: gentle fade out, normalize, soft clip ──────────────────────
fo = idx(14.4)
fade = np.ones(N); fade[fo:] = np.linspace(1,0,N-fo)
L*=fade; R*=fade
peak = max(np.abs(L).max(), np.abs(R).max(), 1e-9)
L = np.tanh(L/peak*1.1)*0.9; R = np.tanh(R/peak*1.1)*0.9

out = os.path.join('promo','work','music.wav')
with wave.open(out,'w') as w:
    w.setnchannels(2); w.setsampwidth(2); w.setframerate(SR)
    inter = np.empty(N*2); inter[0::2]=L; inter[1::2]=R
    w.writeframes((inter*32767).astype('<i2').tobytes())
print('wrote', out, round(os.path.getsize(out)/1024), 'KB')
