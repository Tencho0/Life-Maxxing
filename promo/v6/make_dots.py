import os
from PIL import Image, ImageDraw

# Connect-the-dots overlay for the reveal beat: a scrim panel fades in over the phone, a
# line draws left->right across 7 day-points, the "happy" days (training days) pop green
# with a glow + a dumbbell glyph. Honest data viz of his own numbers (not fake app UI).
W, H = 1080, 1920
FPS = 30
DOT_DUR = 4.3                       # MUST equal beat s05 duration (retimed in Task 4)
NF = int(FPS * DOT_DUR)
OUT = "promo/v6/work/dots"; os.makedirs(OUT, exist_ok=True)

# 7 days across a band over the phone's mid-region
N = 7
X0, X1 = 220, 860
BAND_TOP, BAND_BOT = 1140, 1430
xs = [int(X0 + (X1-X0)*i/(N-1)) for i in range(N)]
mood     = [0.35, 0.85, 0.42, 0.92, 0.45, 0.88, 0.50]   # higher = happier
training = [False, True, False, True, False, True, False] # peaks = training days
ys = [int(BAND_BOT - (BAND_BOT-BAND_TOP)*m) for m in mood]
GREEN = (95, 208, 138)             # 0x5FD08A
GREY  = (165, 174, 190)
GLYPH_Y = BAND_BOT + 78

def clamp(v, a=0.0, b=1.0): return max(a, min(b, v))

for i in range(NF):
    t = i / FPS
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))

    # scrim panel fades in 0.6 -> 1.0
    sc = clamp((t - 0.6) / 0.4)
    if sc > 0:
        scrim = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        ImageDraw.Draw(scrim).rounded_rectangle(
            [100, BAND_TOP-120, 980, GLYPH_Y+46], radius=40,
            fill=(8, 10, 16, int(165*sc)))
        img = Image.alpha_composite(img, scrim)

    d = ImageDraw.Draw(img)
    # connecting line draws 0.9 -> 2.1
    p = clamp((t - 0.9) / 1.2)
    drawn_x = X0 + (X1 - X0) * p
    pts = [(xs[k], ys[k]) for k in range(N) if xs[k] <= drawn_x]
    if len(pts) >= 2:
        d.line(pts, fill=(205, 214, 228, 235), width=7, joint="curve")

    # dots + (for training days) glow and a dumbbell glyph
    for k in range(N):
        if xs[k] <= drawn_x + 2:
            if training[k]:
                glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
                ImageDraw.Draw(glow).ellipse(
                    [xs[k]-42, ys[k]-42, xs[k]+42, ys[k]+42], fill=(95, 208, 138, 75))
                img = Image.alpha_composite(img, glow); d = ImageDraw.Draw(img)
                r = 25
                d.ellipse([xs[k]-r, ys[k]-r, xs[k]+r, ys[k]+r], fill=GREEN+(255,))
                gx, gy = xs[k], GLYPH_Y
                d.rounded_rectangle([gx-26, gy-6, gx+26, gy+6], radius=4, fill=(255,255,255,235))
                d.rounded_rectangle([gx-32, gy-17, gx-20, gy+17], radius=4, fill=(255,255,255,235))
                d.rounded_rectangle([gx+20, gy-17, gx+32, gy+17], radius=4, fill=(255,255,255,235))
            else:
                r = 15
                d.ellipse([xs[k]-r, ys[k]-r, xs[k]+r, ys[k]+r], fill=GREY+(255,))

    img.save(f"{OUT}/dots_{i:03d}.png")

print("wrote", NF, "frames to", OUT)
