# Ray Wang — Personal Website

Source for my personal website, built with [Quarto](https://quarto.org/).

The structure is adapted from the open-source Quarto site by [Silvia Canelón](https://github.com/spcanelon/silvia) — many thanks to her for sharing it.

## Local preview

```powershell
quarto preview
```

## Build

```powershell
quarto render
```

## Save Updates

```powershell
powershell -ExecutionPolicy Bypass -File render.ps1
```

```bash
git add .
git commit -m "update accent color"
git push
```


Output is written to `_site/`.
