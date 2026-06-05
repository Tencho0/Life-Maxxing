import numpy as np, wave

# Video #6 "Connect the Dots" music bed: cold/minor -> warm build -> brief pull-back ->
# bright major resolve on the reveal -> sustained warm outro. Section times track the beats
# (s01 0.0 / s02 3.4 / s03 5.4 / s04 8.8 / s05 reveal 11.3 / s06 15.6 / end 19.8).
sr = 44100
DUR = 20.0                      # slightly longer than the ~19.8s video; mux trims to length
N = int(sr * DUR)
mix = np.zeros(N)

def note(freq, t0, t1, gain=0.2, attack=0.4, release=0.6):
    s = np.zeros(N)
    i0, i1 = int(t0*sr), int(t1*sr)
    if i1 <= i0 or i0 >= N: return s
    i1 = min(i1, N); n = i1 - i0
    tt = np.arange(n)/sr
    w = (np.sin(2*np.pi*freq*tt)
         + 0.5*np.sin(2*np.pi*freq*1.001*tt)   # gentle detune for width
         + 0.25*np.sin(2*np.pi*freq*2*tt))     # octave for warmth
    env = np.ones(n)
    a = int(min(attack, n/sr/2)*sr); r = int(min(release, n/sr/2)*sr)
    if a > 0: env[:a] = np.linspace(0, 1, a)
    if r > 0: env[-r:] = np.linspace(1, 0, r)
    s[i0:i1] = w * env * gain
    return s

def chord(freqs, t0, t1, gain=0.10, **kw):
    s = np.zeros(N)
    for f in freqs: s += note(f, t0, t1, gain=gain, **kw)
    return s

# pitches (Hz)
A2,C3,E3,F3,G3,A3,C4,E4,G4,D4 = 110,130.81,164.81,174.61,196,220,261.63,329.63,392,293.66

# emotional arc
mix += chord([A2, E3],            0.0, 3.6, gain=0.05, attack=1.0, release=1.1)   # b1 ordinary: low minor, cold
mix += chord([C3, G3, C4],        3.4, 5.6, gain=0.07, attack=0.9, release=0.7)   # b2 movement: warm builds
mix += chord([F3, A3, C4, F3*2],  5.4, 8.9, gain=0.08, attack=0.8, release=0.7)   # b3 joy: brighter
mix += chord([A3, D4],            8.8, 11.3, gain=0.045, attack=0.5, release=0.6) # b4 doubt: pull back, suspended
mix += chord([C3,E3,G3,C4,E4,G4], 11.1, 15.7, gain=0.09, attack=0.25, release=1.1) # b5 reveal: bright major resolve
mix += chord([C3, G3, C4, E4],    15.6, 20.0, gain=0.07, attack=0.4, release=1.8)  # b6 endcard: sustained warm major

# soft 4-on-the-floor kick from movement through the reveal
def kick(tc, gain=0.32):
    s = np.zeros(N); i0 = int(tc*sr); n = int(0.18*sr)
    if i0+n > N: n = N-i0
    if n <= 0: return s
    tt = np.arange(n)/sr
    freq = 110*np.exp(-tt*30) + 45
    s[i0:i0+n] = np.sin(2*np.pi*np.cumsum(freq)/sr) * np.exp(-tt*16) * gain
    return s
spb = 60/100.0                  # 100 bpm
tk = 3.4
while tk < 11.3:
    mix += kick(tk); tk += spb

# noise riser into the reveal (9.8 -> 11.3)
i0, i1 = int(9.8*sr), int(11.3*sr); n = i1-i0
tt = np.arange(n)/sr
mix[i0:i1] += np.random.randn(n) * 0.05 * (np.linspace(0,1,n)**2)

# bell impact on the resolve (11.3)
mix += note(C4, 11.3, 12.7, gain=0.16, attack=0.004, release=1.3)
mix += note(G4, 11.3, 12.7, gain=0.11, attack=0.004, release=1.3)

# master: normalize, global fade in/out
mix /= (np.max(np.abs(mix)) + 1e-9); mix *= 0.85
fi, fo = int(0.3*sr), int(0.9*sr)
mix[:fi] *= np.linspace(0,1,fi); mix[-fo:] *= np.linspace(1,0,fo)

data = (mix*32767).astype(np.int16)
stereo = np.column_stack([data, data]).flatten()
w = wave.open("promo/v6/work/music_v6.wav", "w")
w.setnchannels(2); w.setsampwidth(2); w.setframerate(sr)
w.writeframes(stereo.tobytes()); w.close()
print("wrote promo/v6/work/music_v6.wav", DUR, "s")
