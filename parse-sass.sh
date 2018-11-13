#! /bin/bash

if [ ! "$(which sassc 2> /dev/null)" ]; then
   echo sassc needs to be installed to generate the css.
   exit 1
fi

SASSC_OPT="-M -t expanded"

_COLOR_VARIANTS=('' '-dark')
if [ ! -z "${COLOR_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

_THEME_VARIANTS=('-sea' '-aliz' '-azul')
if [ ! -z "${THEME_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _THEME_VARIANTS <<< "${THEME_VARIANTS:-}"
fi

for color in "${_COLOR_VARIANTS[@]}"; do
  for theme in "${_THEME_VARIANTS[@]}"; do
  sassc $SASSC_OPT src/gtk-3.0/gtk${color}${theme}.{scss,css}
  echo "==> Generating the gtk${color}${theme}.css..."
  done
done

for color in "${_COLOR_VARIANTS[@]}"; do
  for theme in "${_THEME_VARIANTS[@]}"; do
  sassc $SASSC_OPT src/gnome-shell/gnome-shell${color}${theme}.{scss,css}
  echo "==> Generating the gnome-shell${color}${theme}.css..."
  done
done

for color in "${_COLOR_VARIANTS[@]}"; do
  for theme in "${_THEME_VARIANTS[@]}"; do
  sassc $SASSC_OPT src/cinnamon/cinnamon${color}${theme}.{scss,css}
  echo "==> Generating the cinnamon${color}${theme}.css..."
  done
done
