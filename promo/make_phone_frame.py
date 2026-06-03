"""Generate the clean phone mockup used by video #2/#3 (no hand):
- phone_body.png : 660x1304 rounded bezel (RGBA, transparent outside)
- screen_mask.png: 620x1264 rounded grayscale mask (for rounding the app screen)
The app screen is overlaid ON TOP of the body at (20,20); the body's rounded
corners let the background (gradient or blurred B-roll) show around it.
Output dir: promo/v2/work/ (referenced by render_v2.sh and render_v3.sh)."""
import os
from PIL import Image, ImageDraw

OUT = "promo/v2/work"
os.makedirs(OUT, exist_ok=True)

bw, bh, br = 660, 1304, 66          # body
sw, sh, sr = 620, 1264, 48          # screen (centered, ~20px bezel)

body = Image.new("RGBA", (bw, bh), (0, 0, 0, 0))
d = ImageDraw.Draw(body)
d.rounded_rectangle([0, 0, bw - 1, bh - 1], radius=br, fill=(17, 19, 25, 255), outline=(60, 68, 84, 255), width=3)
d.rounded_rectangle([3, 3, bw - 4, bh - 4], radius=br - 3, outline=(40, 46, 58, 140), width=2)
body.save(os.path.join(OUT, "phone_body.png"))

mask = Image.new("L", (sw, sh), 0)
ImageDraw.Draw(mask).rounded_rectangle([0, 0, sw - 1, sh - 1], radius=sr, fill=255)
mask.save(os.path.join(OUT, "screen_mask.png"))
print("wrote phone_body.png (660x1304) + screen_mask.png (620x1264) to", OUT)
