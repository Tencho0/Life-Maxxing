"""Download AI chatbot logos (Wikimedia Commons, rasterized SVG->PNG via width)
and build white rounded 'chips' so dark/mono logos read on a dark background.
Outputs: promo/v4/logos/<name>.png and promo/v4/work/chip_<name>.png
Used by render_v4.sh (the AI logo row + the analysis card header).

Trademark note: these are third-party logos shown as nominative 'works with' use.
Fine for organic/personal posts; review brand guidelines for paid/scaled ads."""
import os, urllib.request
from PIL import Image, ImageDraw

os.makedirs("promo/v4/logos", exist_ok=True)
os.makedirs("promo/v4/work", exist_ok=True)
UA = {"User-Agent": "Mozilla/5.0"}
LOGOS = {
    "chatgpt": "ChatGPT-Logo.svg",
    "claude":  "Claude_AI_logo.svg",
    "gemini":  "Google_Gemini_logo.svg",
}
for name, wikifile in LOGOS.items():
    dst = f"promo/v4/logos/{name}.png"
    if not os.path.exists(dst):
        url = f"https://commons.wikimedia.org/wiki/Special:FilePath/{wikifile}?width=400"
        req = urllib.request.Request(url, headers=UA)
        with urllib.request.urlopen(req, timeout=30) as r, open(dst, "wb") as f:
            f.write(r.read())
        print("  downloaded", name)

CW, CH, R = 320, 200, 28
INNER_W, INNER_H = 250, 120
for name in LOGOS:
    logo = Image.open(f"promo/v4/logos/{name}.png").convert("RGBA")
    chip = Image.new("RGBA", (CW, CH), (0, 0, 0, 0))
    ImageDraw.Draw(chip).rounded_rectangle([0, 0, CW - 1, CH - 1], radius=R, fill=(247, 248, 250, 255))
    s = min(INNER_W / logo.width, INNER_H / logo.height)
    logo = logo.resize((int(logo.width * s), int(logo.height * s)), Image.LANCZOS)
    chip.alpha_composite(logo, ((CW - logo.width) // 2, (CH - logo.height) // 2))
    chip.save(f"promo/v4/work/chip_{name}.png")
    print("  chip", name)
print("done: 3 AI logo chips -> promo/v4/work/")
