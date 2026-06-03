"""Music bed for video #2 (~18.2s): calm morning pad, kick enters when the phone
appears (~3s), builds, uplift at the charts payoff (~12s), impacts on brand/CTA."""
import numpy as np, wave, os
SR=44100; DUR=19.9; N=int(SR*DUR); t=np.arange(N)/SR
L=np.zeros(N); R=np.zeros(N)
def idx(x): return int(x*SR)
def note(f,d,det=0.0):
    n=int(d*SR); tt=np.arange(n)/SR; f=f*2**(det/1200)
    return np.sin(2*np.pi*f*tt)+0.28*np.sin(2*np.pi*2*f*tt)+0.12*np.sin(2*np.pi*3*f*tt)
def env(n,a,r):
    e=np.ones(n); ai=int(a*SR); ri=int(r*SR)
    if ai:e[:ai]=np.linspace(0,1,ai)
    if ri:e[-ri:]=np.linspace(1,0,ri)
    return e
# Pad: Am - F - C - G (evolving), crossfaded
chords=[(0.0,5.7,[110,261.63,329.63,440]),(5.2,11.0,[87.31,220,261.63,349.23]),
        (10.4,15.8,[130.81,329.63,392,523.25]),(15.2,19.9,[98,246.94,293.66,392])]
for st,en,ns in chords:
    d=en-st; n=int(d*SR); e=env(n,0.7,0.7); sig=np.zeros(n)
    for f in ns: sig+=note(f,d,-4)+note(f,d,4)
    sig=sig/(len(ns)*2)*e*0.16; s=idx(st); ee=min(s+len(sig),N)
    L[s:ee]+=sig[:ee-s]; R[s:ee]+=sig[:ee-s]
rng=np.random.default_rng(11)
def kick(a):
    d=0.22;n=int(d*SR);tt=np.arange(n)/SR;f=48+80*np.exp(-tt*38)
    ph=2*np.pi*np.cumsum(f)/SR; return np.sin(ph)*np.exp(-tt*20)*a
# kick from phone-reveal (3s) to end of payoff (~15s), 4-on-floor
tt=3.0
while tt<16.8:
    a=0.9 if abs(tt-round(tt))<1e-6 else 0.5
    k=kick(a); s=idx(tt); ee=min(s+len(k),N); L[s:ee]+=k[:ee-s]; R[s:ee]+=k[:ee-s]; tt+=0.5
def hat(a):
    d=0.05;n=int(d*SR);no=rng.standard_normal(n); no=no-np.convolve(no,np.ones(8)/8,'same')
    return no*np.exp(-np.arange(n)/SR*120)*a
tt=3.25
while tt<16.8:
    h=hat(0.09); s=idx(tt); ee=min(s+len(h),N); L[s:ee]+=h[:ee-s]*0.85; R[s:ee]+=h[:ee-s]*1.15; tt+=0.5
# riser into phone reveal at 3.0
rn=idx(3.0); rt=np.arange(rn)/SR
sweep=np.sin(2*np.pi*np.cumsum(150+1000*(rt/3.0))/SR); ramp=(rt/3.0)**2
no=rng.standard_normal(rn); no=no-np.convolve(no,np.ones(12)/12,'same')
ris=(sweep*0.5+no*0.5)*ramp*0.22; L[:rn]+=ris; R[:rn]+=ris
def impact(a):
    d=0.7;n=int(d*SR);tt=np.arange(n)/SR
    boom=np.sin(2*np.pi*55*tt)*np.exp(-tt*7)
    cr=rng.standard_normal(n); cr=cr-np.convolve(cr,np.ones(6)/6,'same'); cr*=np.exp(-tt*5)
    return (boom*0.8+cr*0.4)*a
for tt in (3.0,13.4,16.83,18.33):
    im=impact(0.55); s=idx(tt); ee=min(s+len(im),N); L[s:ee]+=im[:ee-s]; R[s:ee]+=im[:ee-s]
fo=idx(19.2); fade=np.ones(N); fade[fo:]=np.linspace(1,0,N-fo); L*=fade; R*=fade
pk=max(abs(L).max(),abs(R).max(),1e-9); L=np.tanh(L/pk*1.1)*0.9; R=np.tanh(R/pk*1.1)*0.9
out="promo/v2/work/music_v2.wav"
with wave.open(out,'w') as w:
    w.setnchannels(2); w.setsampwidth(2); w.setframerate(SR)
    inter=np.empty(N*2); inter[0::2]=L; inter[1::2]=R
    w.writeframes((inter*32767).astype('<i2').tobytes())
print("wrote",out)
