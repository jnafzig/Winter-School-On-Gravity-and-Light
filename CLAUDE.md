# Winter School on Gravity and Light

LaTeX lecture notes for Dr. Frederic P. Schuller's WE-Heraeus International Winter School on Gravity and Light (2015).

## Build

Requires Docker. Uses a `texlive/texlive:latest` container.

```
make          # Build PDF to build/main.pdf
make clean    # Remove build artifacts
make shell    # Open bash shell in the TeX container
```

## Project structure

- `src/main.tex` - Main document, preamble, and package imports
- `src/Shortcuts.tex` - Custom LaTeX commands and shortcuts
- `src/sections/` - Lecture chapters (e.g., `01Topology.tex`, `04diffmfds.tex`)
- `src/sections/tutorials/` - Tutorial chapters
- `src/sections/solutions/` - Exercise solutions
- `src/images/` and `src/figures/` - Assets
- `build/main.pdf` - Built output
- `transcripts/` - Lecture transcripts from YouTube

## Conventions

- Chapters are numbered starting from 0 and labelled "Lecture" (not "Chapter")
- Custom shortcuts are defined in `Shortcuts.tex` (e.g., `\cM` for `\mathcal{M}`, `\R` for `\mathbb{R}`)
- `\flower` (open, `\ding{96}`) and `\flowerf` (filled, `\ding{95}`) are placeholder symbols used for generic properties (e.g., C^k-compatibility), matching Dr. Schuller's notation
- Exercises use `\bbox` / `\ebox` tcolorbox environments
- Theorem-like environments have shortcut macros: `\bd`/`\ed` (definition), `\bt`/`\et` (theorem), `\bl`/`\el` (lemma), `\br`/`\er` (remark), etc.
