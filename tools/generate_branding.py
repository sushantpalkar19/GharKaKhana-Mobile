#!/usr/bin/env python3
"""Generate production branding assets from the transparent SVG logo."""

from __future__ import annotations

import os
from io import BytesIO
from pathlib import Path

import cairosvg
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
BRANDING = ROOT / "assets" / "branding"
SOURCE = BRANDING / "logo.svg"

ORANGE = (245, 124, 0, 255)  # #F57C00
WHITE = (255, 255, 255, 255)
GREEN = (46, 125, 50, 255)  # #2E7D32


def load_source(size: int = 2048) -> Image.Image:
    png = cairosvg.svg2png(url=str(SOURCE), output_width=size, output_height=size)
    img = Image.open(BytesIO(png)).convert("RGBA")
    return trim_alpha(img)


def trim_alpha(img: Image.Image, padding: int = 16) -> Image.Image:
    bbox = img.split()[3].getbbox()
    if bbox is None:
        return img

    left = max(bbox[0] - padding, 0)
    top = max(bbox[1] - padding, 0)
    right = min(bbox[2] + padding, img.width)
    bottom = min(bbox[3] + padding, img.height)
    return img.crop((left, top, right, bottom))


def fit_on_canvas(
    img: Image.Image,
    canvas_size: int,
    content_ratio: float,
    padding_ratio: float = 0.0,
) -> Image.Image:
    canvas = Image.new("RGBA", (canvas_size, canvas_size), (0, 0, 0, 0))
    max_side = int(canvas_size * content_ratio * (1.0 - padding_ratio * 2))
    fitted = img.copy()
    fitted.thumbnail((max_side, max_side), Image.Resampling.LANCZOS)
    x = (canvas_size - fitted.width) // 2
    y = (canvas_size - fitted.height) // 2
    canvas.paste(fitted, (x, y), fitted)
    return canvas


def solid_background(size: int, color: tuple[int, int, int, int]) -> Image.Image:
    return Image.new("RGBA", (size, size), color)


def create_monochrome(img: Image.Image, size: int = 1024) -> Image.Image:
    """Single-color silhouette for Android 13 themed icon."""
    canvas = fit_on_canvas(img, size, content_ratio=0.72)
    alpha = canvas.split()[3]
    mono = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    # Use primary orange as monochrome fill
    fill = Image.new("RGBA", (size, size), ORANGE)
    mono.paste(fill, mask=alpha)
    return mono


def create_app_icon(logo: Image.Image, bg_color: tuple[int, int, int, int]) -> Image.Image:
    size = 1024
    bg = solid_background(size, bg_color)
    fg = fit_on_canvas(logo, size, content_ratio=0.78)
    bg.alpha_composite(fg)
    return bg


def create_favicon(logo: Image.Image) -> Image.Image:
    canvas = fit_on_canvas(logo, 64, content_ratio=0.82)
    return canvas.resize((32, 32), Image.Resampling.LANCZOS)


def main() -> None:
    BRANDING.mkdir(parents=True, exist_ok=True)

    source = load_source()

    logo = fit_on_canvas(source, 1024, content_ratio=0.82)
    logo.save(BRANDING / "logo.png", optimize=True)

    # Android adaptive safe zone: 66% diameter circle ≈ 72% of canvas width
    adaptive_fg = fit_on_canvas(source, 1024, content_ratio=0.66)
    adaptive_fg.save(BRANDING / "adaptive_foreground.png", optimize=True)

    solid_background(1024, WHITE).save(BRANDING / "adaptive_background.png")
    solid_background(1024, ORANGE).save(BRANDING / "adaptive_background_orange.png")

    create_app_icon(source, WHITE).save(BRANDING / "app_icon.png", optimize=True)
    create_app_icon(source, ORANGE).save(BRANDING / "app_icon_orange.png", optimize=True)

    create_monochrome(source).save(BRANDING / "monochrome.png", optimize=True)
    create_favicon(source).save(BRANDING / "favicon.png", optimize=True)

    print("Generated branding assets in", BRANDING)
    for name in sorted(os.listdir(BRANDING)):
        path = BRANDING / name
        if path.is_file():
            print(f"  {name}: {path.stat().st_size // 1024} KB")


if __name__ == "__main__":
    main()
