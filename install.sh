#!/bin/bash
  # Copying files

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/themes"
else
  DEST_DIR="$HOME/.themes"
fi

REO_DIR=$(cd $(dirname $0) && pwd)
SRC_DIR=${REO_DIR}/src

THEME_NAME=Matcha
COLOR_VARIANTS=('' '-light' '-dark')
THEME_VARIANTS=('-aliz' '-azul' '-sea')

usage() {
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-n, --name NAME" "Specify theme name (Default: ${THEME_NAME})"
  printf "  %-25s%s\n" "-c, --color VARIANTS" "Specify theme color variant(s) [standard|dark] (Default: All variants)"
  printf "  %-25s%s\n" "-t, --theme VARIANTS" "Specify hue theme variant(s) [aliz|azul|sea] (Default: All variants)"
  printf "  %-25s%s\n" "-g, --gdm" "Install GDM theme, this option need root user authority! please run this with sudo"
  printf "  %-25s%s\n" "-r, --revert" "revert GDM theme, this option need root user authority! please run this with sudo"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

# Copying files
install() {
  local dest=${1}
  local name=${2}
  local color=${3}
  local theme=${4}

  local themedir=${dest}/${name}${color}${theme}

  [[ ${color} == '-dark' ]] && local ELSE_DARK=${color}
  [[ ${color} == '-light' ]] && local ELSE_LIGHT=${color}

  [[ -d ${themedir} ]] && rm -rf ${themedir}

  echo "Installing '${themedir}'..."
  mkdir -p                                                                            ${themedir}

  # Install index.theme
  echo "[Desktop Entry]"                                                           >> ${themedir}/index.theme
  echo "Type=X-GNOME-Metatheme"                                                    >> ${themedir}/index.theme
  echo "Name=${name}${color}${theme}"                                              >> ${themedir}/index.theme
  echo "Comment=A dark modern design theme"                                        >> ${themedir}/index.theme
  echo "Encoding=UTF-8"                                                            >> ${themedir}/index.theme
  echo ""                                                                          >> ${themedir}/index.theme
  echo "[X-GNOME-Metatheme]"                                                       >> ${themedir}/index.theme
  echo "GtkTheme=${name}${color}${theme}"                                          >> ${themedir}/index.theme
  echo "MetacityTheme=${name}${color}${theme}"                                     >> ${themedir}/index.theme
  echo "IconTheme=Qogir-manjaro"                                                   >> ${themedir}/index.theme
  echo "CursorTheme=Qogir-manjaro"                                                 >> ${themedir}/index.theme
  echo "ButtonLayout=menu:minimize,maximize,close"                                 >> ${themedir}/index.theme

  # Install GNOME Shell Theme
  mkdir -p                                                                            ${themedir}/gnome-shell
  cd ${SRC_DIR}/gnome-shell
  cp -ur extensions                                                                   ${themedir}/gnome-shell
  cp -ur gnome-shell${ELSE_DARK}${theme}.css                                          ${themedir}/gnome-shell/gnome-shell.css
  cp -ur common-assets                                                                ${themedir}/gnome-shell/assets

  cd ${SRC_DIR}/gnome-shell/assets
  cp -ur no-events${ELSE_DARK}.svg                                                    ${themedir}/gnome-shell/assets/no-events.svg
  cp -ur no-notifications${ELSE_DARK}.svg                                             ${themedir}/gnome-shell/assets/no-notifications.svg
  cp -ur calendar-arrow-left${ELSE_DARK}.svg                                          ${themedir}/gnome-shell/assets/calendar-arrow-left.svg
  cp -ur calendar-arrow-right${ELSE_DARK}.svg                                         ${themedir}/gnome-shell/assets/calendar-arrow-right.svg
  cp -ur key-hide${ELSE_DARK}.svg                                                     ${themedir}/gnome-shell/assets/key-hide.svg
  cp -ur key-layout${ELSE_DARK}.svg                                                   ${themedir}/gnome-shell/assets/key-layout.svg
  cp -ur key-shift${ELSE_DARK}.svg                                                    ${themedir}/gnome-shell/assets/key-shift.svg
  [[ ${ELSE_DARK} == '' ]] && \
  cp -ur menu.svg                                                                     ${themedir}/gnome-shell/assets
  cp -ur submenu${ELSE_DARK}.svg                                                      ${themedir}/gnome-shell/assets/submenu.svg
  cp -ur submenu-open${ELSE_DARK}.svg                                                 ${themedir}/gnome-shell/assets/submenu-open.svg

  cd ${SRC_DIR}/gnome-shell/theme-assets
  cp -ur checkbox${theme}.svg                                                         ${themedir}/gnome-shell/assets/checkbox.svg
  [[ ${ELSE_DARK} == '-dark' ]] && \
  cp -ur menu${ELSE_DARK}${theme}.svg                                                 ${themedir}/gnome-shell/assets/menu.svg
  cp -ur menu-hover${theme}.svg                                                       ${themedir}/gnome-shell/assets/menu-hover.svg
  cp -ur more-results${theme}.svg                                                     ${themedir}/gnome-shell/assets/more-results.svg
  cp -ur toggle-on${theme}.svg                                                        ${themedir}/gnome-shell/assets/toggle-on.svg

  cd ${themedir}/gnome-shell
  ln -s assets/no-events.svg no-events.svg
  ln -s assets/process-working.svg process-working.svg
  ln -s assets/no-notifications.svg no-notifications.svg

  # Install GTK+ 2 Theme
  mkdir -p                                                                            ${themedir}/gtk-2.0
  cd ${SRC_DIR}/gtk-2.0
  cp -ur {apps.rc,main.rc,panel.rc,xfce-notify.rc}                                    ${themedir}/gtk-2.0
  cp -ur gtkrc${color}${theme}                                                        ${themedir}/gtk-2.0/gtkrc
  cp -ur assets${ELSE_DARK}${theme}                                                   ${themedir}/gtk-2.0/assets
  cp -ur menubar-toolbar${ELSE_DARK}.rc                                               ${themedir}/gtk-2.0/menubar-toolbar.rc

  # Install GTK+ 3 Theme
  mkdir -p                                                                            ${themedir}/gtk-3.0
  cd ${SRC_DIR}/gtk-3.0
  cp -ur assets${theme}                                                               ${themedir}/gtk-3.0/assets
  cp -ur gtk${color}${theme}.css                                                      ${themedir}/gtk-3.0/gtk.css
  cp -ur gtk-dark${theme}.css                                                         ${themedir}/gtk-3.0/gtk-dark.css

  cp -ur thumbnail${ELSE_DARK}${theme}.png                                            ${themedir}/gtk-3.0/thumbnail.png

  # Install CINNAMON Theme
  mkdir -p                                                                            ${themedir}/cinnamon
  cd ${SRC_DIR}/cinnamon
  cp -ur cinnamon${ELSE_DARK}${theme}.css                                             ${themedir}/cinnamon/cinnamon.css
  cp -ur thumbnail${ELSE_DARK}${theme}.png                                            ${themedir}/cinnamon/thumbnail.png

  cd ${SRC_DIR}/cinnamon/assets${theme}
  cp -ur common-assets                                                                ${themedir}/cinnamon
  cp -ur assets${ELSE_DARK}                                                           ${themedir}/cinnamon/assets

  # Install Metacity Theme
  mkdir -p                                                                            ${themedir}/metacity-1
  cd ${SRC_DIR}/metacity-1
  cp -ur {thumbnail.png,*.svg,metacity-theme-3.xml}                                   ${themedir}/metacity-1
  cp -ur metacity-theme-1${theme}.xml                                                 ${themedir}/metacity-1/metacity-theme-1.xml

  cd ${themedir}/metacity-1
  ln -s metacity-theme-1.xml metacity-theme-2.xml

  # Install xfwm4 Theme
  mkdir -p                                                                            ${themedir}/xfwm4
  cd ${SRC_DIR}/xfwm4
  cp -ur assets${color}${theme}/*.png                                                 ${themedir}/xfwm4

  if [[ ${color} == '-light' ]] ; then
    cp -ur themerc${color}                                                            ${themedir}/xfwm4/themerc
  else
    cp -ur themerc${theme}                                                            ${themedir}/xfwm4/themerc
  fi

  # Install openbox Theme
  mkdir -p                                                                            ${themedir}/openbox-3
  cd ${SRC_DIR}/openbox-3
  cp -ur *.xbm                                                                        ${themedir}/openbox-3
  cp -ur themerc${ELSE_DARK}${theme}                                                  ${themedir}/openbox-3/themerc

  # Install Unity Theme
  mkdir -p                                                                            ${themedir}/unity
  cd ${SRC_DIR}
  cp -ur unity                                                                        ${themedir}

  # Install Plank Theme
  mkdir -p                                                                            ${themedir}/plank
  cd ${SRC_DIR}
  cp -ur plank                                                                        ${themedir}
}

# Backup and install files related to GDM theme

GS_THEME_FILE="/usr/share/gnome-shell/gnome-shell-theme.gresource"
SHELL_THEME_FOLDER="/usr/share/gnome-shell/theme"
ETC_THEME_FOLDER="/etc/alternatives"
ETC_THEME_FILE="/etc/alternatives/gdm3.css"
UBUNTU_THEME_FILE="/usr/share/gnome-shell/theme/ubuntu.css"
UBUNTU_NEW_THEME_FILE="/usr/share/gnome-shell/theme/gnome-shell.css"

install_gdm() {
  local GDM_THEME_DIR="${1}/${2}${3}${4}"

  echo
  echo "Installing ${2}${3}${4} gdm theme..."

  if [[ -f "$GS_THEME_FILE" ]] && command -v glib-compile-resources >/dev/null ; then
    echo "Installing '$GS_THEME_FILE'..."
    cp -an "$GS_THEME_FILE" "$GS_THEME_FILE.bak"
    glib-compile-resources \
      --sourcedir="$GDM_THEME_DIR/gnome-shell" \
      --target="$GS_THEME_FILE" \
      "${SRC_DIR}/gnome-shell/gnome-shell-theme.gresource.xml"
  fi

  if [[ -f "$UBUNTU_THEME_FILE" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing '$UBUNTU_THEME_FILE'..."
    cp -an "$UBUNTU_THEME_FILE" "$UBUNTU_THEME_FILE.bak"
    # rm -rf "$GS_THEME_FILE"
    # mv "$GS_THEME_FILE.bak" "$GS_THEME_FILE"
    cp -af "$GDM_THEME_DIR/gnome-shell/gnome-shell.css" "$UBUNTU_THEME_FILE"
  fi

  if [[ -f "$UBUNTU_NEW_THEME_FILE" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing '$UBUNTU_NEW_THEME_FILE'..."
    cp -an "$UBUNTU_NEW_THEME_FILE" "$UBUNTU_NEW_THEME_FILE.bak"
    cp -af "$GDM_THEME_DIR"/gnome-shell/* "$SHELL_THEME_FOLDER"
  fi

  if [[ -f "$ETC_THEME_FILE" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing Ubuntu gnome-shell theme..."
    cp -an "$ETC_THEME_FILE" "$ETC_THEME_FILE.bak"
    # rm -rf "$ETC_THEME_FILE" "$GS_THEME_FILE"
    # mv "$GS_THEME_FILE.bak" "$GS_THEME_FILE"
    [[ -d $SHELL_THEME_FOLDER/Matcha ]] && rm -rf $SHELL_THEME_FOLDER/Matcha
    cp -ur "$GDM_THEME_DIR/gnome-shell" "$SHELL_THEME_FOLDER/Matcha"
    cd "$ETC_THEME_FOLDER"
    ln -s "$SHELL_THEME_FOLDER/Matcha-dark-sea/gnome-shell.css" gdm3.css
  fi
}

revert_gdm() {
  if [[ -f "$GS_THEME_FILE.bak" ]]; then
    echo "reverting '$GS_THEME_FILE'..."
    rm -rf "$GS_THEME_FILE"
    mv "$GS_THEME_FILE.bak" "$GS_THEME_FILE"
  fi

  if [[ -f "$UBUNTU_THEME_FILE.bak" ]]; then
    echo "reverting '$UBUNTU_THEME_FILE'..."
    rm -rf "$UBUNTU_THEME_FILE"
    mv "$UBUNTU_THEME_FILE.bak" "$UBUNTU_THEME_FILE"
  fi

  if [[ -f "$UBUNTU_NEW_THEME_FILE.bak" ]]; then
    echo "reverting '$UBUNTU_NEW_THEME_FILE'..."
    rm -rf "$UBUNTU_NEW_THEME_FILE" "$SHELL_THEME_FOLDER"/{assets,no-events.svg,process-working.svg,no-notifications.svg}
    mv "$UBUNTU_NEW_THEME_FILE.bak" "$UBUNTU_NEW_THEME_FILE"
  fi

  if [[ -f "$ETC_THEME_FILE.bak" ]]; then
    echo "reverting Ubuntu gnome-shell theme..."
    rm -rf "$ETC_THEME_FILE"
    mv "$ETC_THEME_FILE.bak" "$ETC_THEME_FILE"
    [[ -d $SHELL_THEME_FOLDER/Matcha ]] && rm -rf $SHELL_THEME_FOLDER/Matcha
  fi
}

#  Install theme
install_theme() {
for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
    install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${color}" "${theme}"
  done
done
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      dest="$(realpath "${2}")"
      if [[ ! -d "${dest}" ]]; then
        echo "ERROR: Destination directory does not exist."
        exit 1
      fi
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -g|--gdm)
      gdm='true'
      shift 1
      ;;
    -r|--revert)
      revert='true'
      shift 1
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          aliz)
            themes+=("${THEME_VARIANTS[0]}")
            shift 1
            ;;
          azul)
            themes+=("${THEME_VARIANTS[1]}")
            shift 1
            ;;
          sea)
            themes+=("${THEME_VARIANTS[2]}")
            shift 1
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized thin variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -c|--color)
      shift
      for color in "${@}"; do
        case "${color}" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            shift 1
            ;;
          light)
            colors+=("${COLOR_VARIANTS[1]}")
            shift 1
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[2]}")
            shift 1
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized color variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${gdm:-}" != 'true' && "${revert:-}" != 'true' ]]; then
  install_theme
fi

if [[ "${gdm:-}" == 'true' && "${revert:-}" != 'true' && "$UID" -eq "$ROOT_UID" ]]; then
  install_theme && install_gdm "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${color}" "${theme}"
fi

if [[ "${gdm:-}" != 'true' && "${revert:-}" == 'true' && "$UID" -eq "$ROOT_UID" ]]; then
  revert_gdm
fi

echo "Finished!..."
