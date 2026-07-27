#!/usr/bin/env python3
"""Convert a plain-text COBOL report into a greenbar-style PDF."""

from __future__ import annotations

import argparse
from pathlib import Path

from reportlab.lib.colors import Color, black, white
from reportlab.lib.pagesizes import letter, landscape
from reportlab.pdfgen import canvas


GREEN = Color(0.88, 0.96, 0.88)
EDGE = Color(0.70, 0.82, 0.70)
HOLE = Color(0.85, 0.88, 0.85)


def split_pages(text: str, lines_per_page: int) -> list[list[str]]:
    pages: list[list[str]] = []
    for form_page in text.split("\f"):
        lines = form_page.splitlines()
        if not lines:
            pages.append([])
            continue
        for start in range(0, len(lines), lines_per_page):
            pages.append(lines[start:start + lines_per_page])
    return pages or [[]]


def draw_greenbar_page(
    pdf: canvas.Canvas,
    lines: list[str],
    page_size: tuple[float, float],
    columns: int,
    lines_per_page: int,
    band_lines: int,
    title: str | None,
) -> None:
    width, height = page_size

    left_gutter = 30
    right_gutter = 30
    top_margin = 32
    bottom_margin = 32

    text_left = left_gutter + 18
    text_right = width - right_gutter - 18
    usable_width = text_right - text_left
    usable_height = height - top_margin - bottom_margin

    line_height = usable_height / lines_per_page
    font_size = min(10.0, usable_width / columns * 1.66)
    font_size = max(font_size, 6.0)

    # Greenbar bands
    for row in range(lines_per_page):
        y = height - top_margin - (row + 1) * line_height
        if (row // band_lines) % 2 == 0:
            pdf.setFillColor(GREEN)
        else:
            pdf.setFillColor(white)
        pdf.rect(left_gutter, y, width - left_gutter - right_gutter,
                 line_height, stroke=0, fill=1)

    # Border
    pdf.setStrokeColor(EDGE)
    pdf.rect(left_gutter, bottom_margin,
             width - left_gutter - right_gutter,
             usable_height, stroke=1, fill=0)

    # Tractor-feed holes
    hole_radius = 3.1
    hole_step = 18
    y = bottom_margin + 9
    while y < height - top_margin:
        pdf.setFillColor(HOLE)
        pdf.setStrokeColor(EDGE)
        pdf.circle(left_gutter / 2, y, hole_radius, stroke=1, fill=1)
        pdf.circle(width - right_gutter / 2, y, hole_radius,
                   stroke=1, fill=1)
        y += hole_step

    # Optional small title
    if title:
        pdf.setFillColor(black)
        pdf.setFont("Courier-Bold", 7)
        pdf.drawString(text_left, height - 18, title[:90])

    # Report text
    pdf.setFillColor(black)
    pdf.setFont("Courier", font_size)
    baseline_adjust = (line_height - font_size) / 2 + 1

    for row, raw_line in enumerate(lines[:lines_per_page]):
        line = raw_line.expandtabs(8)[:columns]
        y = height - top_margin - (row + 1) * line_height + baseline_adjust
        pdf.drawString(text_left, y, line)


def convert_text_to_greenbar(
    input_path: Path,
    output_path: Path,
    orientation: str,
    columns: int,
    lines_per_page: int,
    band_lines: int,
) -> None:
    text = input_path.read_text(encoding="utf-8", errors="replace")
    page_size = landscape(letter) if orientation == "landscape" else letter
    pages = split_pages(text, lines_per_page)

    pdf = canvas.Canvas(str(output_path), pagesize=page_size)
    pdf.setTitle(f"Greenbar report - {input_path.name}")

    for page_number, lines in enumerate(pages, start=1):
        draw_greenbar_page(
            pdf=pdf,
            lines=lines,
            page_size=page_size,
            columns=columns,
            lines_per_page=lines_per_page,
            band_lines=band_lines,
            title=f"{input_path.name}   PAGE {page_number}",
        )
        pdf.showPage()

    pdf.save()


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert a plain-text COBOL report to greenbar PDF."
    )
    parser.add_argument("input", type=Path, help="Input plain-text report")
    parser.add_argument("output", type=Path, help="Output PDF file")
    parser.add_argument(
        "--orientation",
        choices=("portrait", "landscape"),
        default="portrait",
    )
    parser.add_argument("--columns", type=int, default=80)
    parser.add_argument("--lines", type=int, default=60,
                        help="Lines per PDF page")
    parser.add_argument("--band-lines", type=int, default=3,
                        help="Lines in each alternating color band")
    args = parser.parse_args()

    if args.columns < 20:
        parser.error("--columns must be at least 20")
    if args.lines < 10:
        parser.error("--lines must be at least 10")
    if args.band_lines < 1:
        parser.error("--band-lines must be at least 1")
    if not args.input.is_file():
        parser.error(f"input file does not exist: {args.input}")

    convert_text_to_greenbar(
        input_path=args.input,
        output_path=args.output,
        orientation=args.orientation,
        columns=args.columns,
        lines_per_page=args.lines,
        band_lines=args.band_lines,
    )


if __name__ == "__main__":
    main()
