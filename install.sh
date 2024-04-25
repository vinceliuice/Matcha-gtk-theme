#! /usr/bin/env bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/themes"
  GTKSV_DIR="/usr/share/gtksourceview-3.0/styles"
else
  DEST_DIR="$HOME/.themes"
  GTKSV_DIR="$HOME/.local/share/gtksourceview-3.0/styles"
fi

REO_DIR="$(cd $(dirname "$0") && pwd)"
SRC_DIR="${REO_DIR}/src"

THEME_NAME=Matcha
COLOR_VARIANTS=('' '-light' '-dark')
THEME_VARIANTS=('-sea' '-aliz' '-azul' '-pueril')

GS_VERSION=""

usage() {
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-n, --name NAME" "Specify theme name (Default: ${THEME_NAME})"
  printf "  %-25s%s\n" "-c, --color VARIANTS" "Specify theme color variant(s) [standard|dark] (Default: All variants)"
  printf "  %-25s%s\n" "-t, --theme VARIANTS" "Specify hue theme variant(s) [sea|aliz|azul|pueril] (Default: All variants)"
  printf "  %-25s%s\n" "-s, --gnome-shell" "Set gnome-shell flavor, where new is version 44.0 or later, [38|40|42|44] (Default: Auto detect)"
  printf "  %-25s%s\n" "-l, --libadwaita" "Force all libadwaita app use linked gtk-4.0 theme"
  printf "  %-25s%s\n" "-g, --gdm" "Install GDM theme, this option need root user authority! please run this with sudo"
  printf "  %-25s%s\n" "-r, --remove" "Remove(Uninstall) themes/GDM/libadwaita"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

# Copying files
install() {
  local dest="${1}"
  local name="${2}"
  local color="${3}"
  local theme="${4}"

  local themedir="${dest}/${name}${color}${theme}"

  [[ ${color} == '-dark' ]] && local ELSE_DARK="${color}"
  [[ ${color} == '-light' ]] && local ELSE_LIGHT="${color}"

  [[ -d "${themedir}" ]] && rm -rf "${themedir}"

  echo "Installing '${themedir}'..."
  mkdir -p                                                                            "${themedir}"

  # Install index.theme
  echo "[Desktop Entry]"                                                           >> "${themedir}/index.theme"
  echo "Type=X-GNOME-Metatheme"                                                    >> "${themedir}/index.theme"
  echo "Name=${name}${color}${theme}"                                              >> "${themedir}/index.theme"
  echo "Comment=A dark modern design theme"                                        >> "${themedir}/index.theme"
  echo "Encoding=UTF-8"                                                            >> "${themedir}/index.theme"
  echo ""                                                                          >> "${themedir}/index.theme"
  echo "[X-GNOME-Metatheme]"                                                       >> "${themedir}/index.theme"
  echo "GtkTheme=${name}${color}${theme}"                                          >> "${themedir}/index.theme"
  echo "MetacityTheme=${name}${color}${theme}"                                     >> "${themedir}/index.theme"
  echo "IconTheme=Qogir-manjaro"                                                   >> "${themedir}/index.theme"
  echo "CursorTheme=Qogir-manjaro"                                                 >> "${themedir}/index.theme"
  echo "ButtonLayout=menu:minimize,maximize,close"                                 >> "${themedir}/index.theme"

  # Install GNOME Shell Theme
  mkdir -p                                                                            "${themedir}/gnome-shell"
  cd "${SRC_DIR}/gnome-shell"
  cp -r pad-osd.css                                                                   "${themedir}/gnome-shell"
  cp -r icons                                                                         "${themedir}/gnome-shell"
  cp -r common-assets                                                                 "${themedir}/gnome-shell/assets"
  cp -r "${GS_VERSION}/gnome-shell${ELSE_DARK}${theme}.css"                           "${themedir}/gnome-shell/gnome-shell.css"

  cd "${SRC_DIR}/gnome-shell/assets"
  cp -r "calendar-arrow-left${ELSE_DARK}.svg"                                         "${themedir}/gnome-shell/assets/calendar-arrow-left.svg"
  cp -r "calendar-arrow-right${ELSE_DARK}.svg"                                        "${themedir}/gnome-shell/assets/calendar-arrow-right.svg"
  cp -r "checkbox-off${ELSE_DARK}.svg"                                                "${themedir}/gnome-shell/assets/checkbox-off.svg"
  cp -r "calendar-today${ELSE_DARK}.svg"                                              "${themedir}/gnome-shell/assets/calendar-today.svg"
  cp -r "checkbox${theme}.svg"                                                        "${themedir}/gnome-shell/assets/checkbox.svg"
  cp -r "more-results${theme}.svg"                                                    "${themedir}/gnome-shell/assets/more-results.svg"
  cp -r "toggle-on${theme}.svg"                                                       "${themedir}/gnome-shell/assets/toggle-on.svg"

  cd "${themedir}/gnome-shell"
  mv -f assets/no-events.svg no-events.svg
  mv -f assets/process-working.svg process-working.svg
  mv -f assets/no-notifications.svg no-notifications.svg

  # Install GTK+ 2.0 Theme
  mkdir -p                                                                            "${themedir}/gtk-2.0"
  cd "${SRC_DIR}/gtk-2.0"
  cp -r {apps.rc,main.rc,panel.rc,xfce-notify.rc}                                     "${themedir}/gtk-2.0"
  cp -r "gtkrc${color}${theme}"                                                       "${themedir}/gtk-2.0/gtkrc"
  cp -r assets${ELSE_DARK}${theme}                                                    "${themedir}/gtk-2.0/assets"
  cp -r "menubar-toolbar${ELSE_DARK}.rc"                                              "${themedir}/gtk-2.0/menubar-toolbar.rc"

  # Install GTK+ 3.0 Theme
  mkdir -p                                                                            "${themedir}/gtk-3.0"
  cd "${SRC_DIR}/gtk"
  cp -r "assets${theme}"                                                              "${themedir}/gtk-3.0/assets"
  cp -r "gtk-3.0/gtk${color}${theme}.css"                                             "${themedir}/gtk-3.0/gtk.css"
  cp -r "gtk-3.0/gtk-dark${theme}.css"                                                "${themedir}/gtk-3.0/gtk-dark.css"

  cp -r "thumbnail${ELSE_DARK}${theme}.png"                                           "${themedir}/gtk-3.0/thumbnail.png"

  # Install GTK+ 4.0 Theme
  mkdir -p                                                                            "${themedir}/gtk-4.0"
  cp -r "gtk-4.0/gtk${color}${theme}.css"                                             "${themedir}/gtk-4.0/gtk.css"
  cp -r "gtk-4.0/gtk-dark${theme}.css"                                                "${themedir}/gtk-4.0/gtk-dark.css"
  cd "${themedir}/gtk-4.0"
  ln -sf ../gtk-3.0/assets  assets
  ln -sf ../gtk-3.0/thumbnail.png thumbnail.png

  # Install CINNAMON Theme
  mkdir -p                                                                            "${themedir}/cinnamon"
  cd "${SRC_DIR}/cinnamon"
  cp -r "cinnamon${ELSE_DARK}${theme}.css"                                            "${themedir}/cinnamon/cinnamon.css"
  cp -r "thumbnail${ELSE_DARK}${theme}.png"                                           "${themedir}/cinnamon/thumbnail.png"

  cd "${SRC_DIR}/cinnamon/assets${theme}"
  cp -r common-assets                                                                 "${themedir}/cinnamon"
  cp -r "assets${ELSE_DARK}"                                                          "${themedir}/cinnamon/assets"

  # Install Metacity Theme
  mkdir -p                                                                            "${themedir}/metacity-1"
  cd "${SRC_DIR}/metacity-1"
  cp -r {thumbnail.png,*.svg,metacity-theme-3.xml}                                    "${themedir}/metacity-1"
  cp -r "metacity-theme-1${theme}.xml"                                                "${themedir}/metacity-1/metacity-theme-1.xml"

  cd "${themedir}/metacity-1"
  ln -s metacity-theme-1.xml metacity-theme-2.xml

  # Install xfwm4 Theme
  mkdir -p                                                                            "${themedir}/xfwm4"
  cd "${SRC_DIR}/xfwm4"
  cp -r "assets${color}${theme}"/*.png                                                "${themedir}/xfwm4"

  if [[ "${color}" == '-light' ]] ; then
    cp -r "themerc${color}"                                                           "${themedir}/xfwm4/themerc"
  else
    cp -r "themerc${theme}"                                                           "${themedir}/xfwm4/themerc"
  fi

  # Install xfwm4 hdpi Theme
  mkdir -p                                                                            "${themedir}-hdpi/xfwm4"
  cp -r "assets${color}${theme}-hdpi"/*.png                                           "${themedir}-hdpi/xfwm4"

  if [[ "${color}" == '-light' ]] ; then
    cp -r "themerc${color}"                                                           "${themedir}-hdpi/xfwm4/themerc"
  else
    cp -r "themerc${theme}"                                                           "${themedir}-hdpi/xfwm4/themerc"
  fi

  # Install xfwm4 xhdpi Theme
  mkdir -p                                                                            "${themedir}-xhdpi/xfwm4"
  cp -r "assets${color}${theme}-xhdpi"/*.png                                          "${themedir}-xhdpi/xfwm4"

  if [[ "${color}" == '-light' ]] ; then
    cp -r "themerc${color}"                                                           "${themedir}-xhdpi/xfwm4/themerc"
  else
    cp -r "themerc${theme}"                                                           "${themedir}-xhdpi/xfwm4/themerc"
  fi

  # Install openbox Theme
  mkdir -p                                                                            "${themedir}/openbox-3"
  cd "${SRC_DIR}/openbox-3"
  cp -r *.xbm                                                                         "${themedir}/openbox-3"
  cp -r "themerc${ELSE_DARK}${theme}"                                                 "${themedir}/openbox-3/themerc"

  # Install Unity Theme
  mkdir -p                                                                            "${themedir}/unity"
  cd "${SRC_DIR}"
  cp -r unity                                                                         "${themedir}"

  # Install Plank Theme
  mkdir -p                                                                            "${themedir}/plank"
  cd "${SRC_DIR}"
  cp -r plank                                                                         "${themedir}"

  # Install GTKSourceView-3.0 Theme (for gtk+ text editors)
  mkdir -p                                                                            "${GTKSV_DIR}/"
  cd "${SRC_DIR}/extra/gtksourceview"
  cp -r *.xml                                                                         "${GTKSV_DIR}/"
}

# Backup and install files related to GDM theme
GS_THEME_FILE="/usr/share/gnome-shell/gnome-shell-theme.gresource"
SHELL_THEME_FOLDER="/usr/share/gnome-shell/theme"
ETC_THEME_FOLDER="/etc/alternatives"
ETC_THEME_FILE="/etc/alternatives/gdm3.css"
ETC_NEW_THEME_FILE="/etc/alternatives/gdm3-theme.gresource"
UBUNTU_THEME_FILE="/usr/share/gnome-shell/theme/ubuntu.css"
UBUNTU_NEW_THEME_FILE="/usr/share/gnome-shell/theme/gnome-shell.css"
UBUNTU_YARU_THEME_FILE="/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource"

install_gdm() {
  local dest="${1}"
  local name="${2}"
  local gcolor="${3}"
  local theme="${4}"

  local GDM_THEME_DIR="${1}/${2}${3}${4}"
  local YARU_GDM_THEME_DIR="$SHELL_THEME_FOLDER/Yaru/${2}${3}${4}"

  [[ "${gcolor}" == '-dark' ]] && local ELSE_DARK="${gcolor}"
  [[ "${gcolor}" == '-light' ]] && local ELSE_LIGHT="${gcolor}"

  echo
  echo "Installing ${2}${3}${4} gdm theme..."

  if ! command -v glib-compile-resources >/dev/null ; then
    echo "glib-compile-resources not found! Exit."
    exit 1
  fi

  if [[ -f "$GS_THEME_FILE" ]] ; then
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
    cp -af "$GDM_THEME_DIR/gnome-shell/gnome-shell.css" "$UBUNTU_THEME_FILE"
  fi

  if [[ -f "$UBUNTU_NEW_THEME_FILE" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing '$UBUNTU_NEW_THEME_FILE'..."
    cp -an "$UBUNTU_NEW_THEME_FILE" "$UBUNTU_NEW_THEME_FILE.bak"
    cp -af "$GDM_THEME_DIR"/gnome-shell/* "$SHELL_THEME_FOLDER"
  fi

  # > Ubuntu 18.04
  if [[ -f "$ETC_THEME_FILE" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing Ubuntu GDM theme..."
    cp -an "$ETC_THEME_FILE" "$ETC_THEME_FILE.bak"
    [[ -d "$SHELL_THEME_FOLDER/$THEME_NAME" ]] && rm -rf "$SHELL_THEME_FOLDER/$THEME_NAME"
    cp -r "$GDM_THEME_DIR/gnome-shell" "$SHELL_THEME_FOLDER/$THEME_NAME"
    cd "$ETC_THEME_FOLDER"
    [[ -f "$ETC_THEME_FILE.bak" ]] && ln -sf "$SHELL_THEME_FOLDER/$THEME_NAME/gnome-shell.css" gdm3.css
  fi

  # > Ubuntu 20.04
  if [[ -d "$SHELL_THEME_FOLDER/Yaru" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing Ubuntu GDM theme..."
    cp -an "$UBUNTU_YARU_THEME_FILE" "$UBUNTU_YARU_THEME_FILE.bak"
    rm -rf "$UBUNTU_YARU_THEME_FILE"
    rm -rf "$YARU_GDM_THEME_DIR" && mkdir -p "$YARU_GDM_THEME_DIR"

    mkdir -p                                                                           "$YARU_GDM_THEME_DIR"/gnome-shell
    mkdir -p                                                                           "$YARU_GDM_THEME_DIR"/gnome-shell/Yaru
    cp -r "$SRC_DIR"/gnome-shell/{icons,pad-osd.css}                                   "$YARU_GDM_THEME_DIR"/gnome-shell
    cp -r "$SRC_DIR"/gnome-shell/gnome-shell"${ELSE_DARK}${theme}".css                 "$YARU_GDM_THEME_DIR"/gnome-shell/gdm3.css
    cp -r "$SRC_DIR"/gnome-shell/gnome-shell"${ELSE_DARK}${theme}".css                 "$YARU_GDM_THEME_DIR"/gnome-shell/Yaru/gnome-shell.css
    cp -r "$SRC_DIR"/gnome-shell/common-assets                                         "$YARU_GDM_THEME_DIR"/gnome-shell/assets
    cp -r "$SRC_DIR"/gnome-shell/assets/calendar-arrow-left"${ELSE_DARK}".svg          "$YARU_GDM_THEME_DIR"/gnome-shell/assets/calendar-arrow-left.svg
    cp -r "$SRC_DIR"/gnome-shell/assets/calendar-arrow-right"${ELSE_DARK}".svg         "$YARU_GDM_THEME_DIR"/gnome-shell/assets/calendar-arrow-right.svg
    cp -r "$SRC_DIR"/gnome-shell/assets/checkbox-off"${ELSE_DARK}".svg                 "$YARU_GDM_THEME_DIR"/gnome-shell/assets/checkbox-off.svg
    cp -r "$SRC_DIR"/gnome-shell/assets/calendar-today"${ELSE_DARK}".svg               "$YARU_GDM_THEME_DIR"/gnome-shell/assets/calendar-today.svg
    cp -r "$SRC_DIR"/gnome-shell/assets/checkbox"${theme}".svg                         "$YARU_GDM_THEME_DIR"/gnome-shell/assets/checkbox.svg
    cp -r "$SRC_DIR"/gnome-shell/assets/more-results"${theme}".svg                     "$YARU_GDM_THEME_DIR"/gnome-shell/assets/more-results.svg
    cp -r "$SRC_DIR"/gnome-shell/assets/toggle-on"${theme}".svg                        "$YARU_GDM_THEME_DIR"/gnome-shell/assets/toggle-on.svg

    cd "$YARU_GDM_THEME_DIR"/gnome-shell
    mv -f assets/no-events.svg no-events.svg
    mv -f assets/process-working.svg process-working.svg
    mv -f assets/no-notifications.svg no-notifications.svg

    glib-compile-resources \
      --sourcedir="$YARU_GDM_THEME_DIR"/gnome-shell \
      --target="$UBUNTU_YARU_THEME_FILE" \
      "$SRC_DIR"/gnome-shell/gdm-theme.gresource.xml

    rm -rf "$YARU_GDM_THEME_DIR"
  fi
}

revert_gdm() {
  if [[ -f "$GS_THEME_FILE.bak" ]]; then
    echo "Reverting '$GS_THEME_FILE'..."
    rm -rf "$GS_THEME_FILE"
    mv "$GS_THEME_FILE.bak" "$GS_THEME_FILE"
  fi

  if [[ -f "$UBUNTU_THEME_FILE.bak" ]]; then
    echo "Reverting '$UBUNTU_THEME_FILE'..."
    rm -rf "$UBUNTU_THEME_FILE"
    mv "$UBUNTU_THEME_FILE.bak" "$UBUNTU_THEME_FILE"
  fi

  if [[ -f "$UBUNTU_NEW_THEME_FILE.bak" ]]; then
    echo "Reverting '$UBUNTU_NEW_THEME_FILE'..."
    rm -rf "$UBUNTU_NEW_THEME_FILE" "$SHELL_THEME_FOLDER"/{assets,no-events.svg,process-working.svg,no-notifications.svg}
    mv "$UBUNTU_NEW_THEME_FILE.bak" "$UBUNTU_NEW_THEME_FILE"
  fi

  # > Ubuntu 18.04
  if [[ -f "$ETC_THEME_FILE.bak" ]]; then

    echo "reverting Ubuntu GDM theme..."

    rm -rf "$ETC_THEME_FILE"
    mv "$ETC_THEME_FILE.bak" "$ETC_THEME_FILE"
    [[ -d "$SHELL_THEME_FOLDER/$THEME_NAME" ]] && rm -rf "$SHELL_THEME_FOLDER/$THEME_NAME"
  fi

  # > Ubuntu 20.04
  if [[ -f "$UBUNTU_YARU_THEME_FILE.bak" ]]; then
    echo "reverting Ubuntu GDM theme..."
    rm -rf "$UBUNTU_YARU_THEME_FILE"
    mv "$UBUNTU_YARU_THEME_FILE.bak" "$UBUNTU_YARU_THEME_FILE"
  fi
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
    -l|--libadwaita)
      libadwaita='true'
      shift
      ;;
    -r|--remove|-u|--uninstall)
      remove='true'
      shift
      ;;
    -s|--gnome-shell)
      case "${2}" in
        38)
          GS_VERSION=3.28
          shift 2
          ;;
        40)
          GS_VERSION=40.0
          shift 2
          ;;
        42)
          GS_VERSION=42.0
          shift 2
          ;;
        44)
          GS_VERSION=44.0
          shift 2
          ;;
        -*|--*)
          shift 1
          break
          ;;
        *)
          echo "ERROR: Unrecognized gnome-shell version '$1'."
          echo "Try '$0 --help' for more information."
          exit 1
          ;;
        esac
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          sea)
            themes+=("${THEME_VARIANTS[0]}")
            shift 1
            ;;
          aliz)
            themes+=("${THEME_VARIANTS[1]}")
            shift 1
            ;;
          azul)
            themes+=("${THEME_VARIANTS[2]}")
            shift 1
            ;;
          pueril)
            themes+=("${THEME_VARIANTS[3]}")
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
            lcolors+=("${COLOR_VARIANTS[0]}")
            gcolors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          light)
            colors+=("${COLOR_VARIANTS[1]}")
            lcolors+=("${COLOR_VARIANTS[1]}")
            gcolors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[2]}")
            lcolors+=("${COLOR_VARIANTS[2]}")
            gcolors+=("${COLOR_VARIANTS[2]}")
            shift
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

if [[ -z "$GS_VERSION" ]]; then
  if [[ "$(command -v gnome-shell)" ]]; then
    gnome-shell --version
    SHELL_VERSION="$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f -1)"
    if [[ "${SHELL_VERSION:-}" -ge "46" ]]; then
      GS_VERSION="46.0"
    elif [[ "${SHELL_VERSION:-}" -ge "44" ]]; then
      GS_VERSION="44.0"
    elif [[ "${SHELL_VERSION:-}" -ge "42" ]]; then
      GS_VERSION="42.0"
    elif [[ "${SHELL_VERSION:-}" -ge "40" ]]; then
      GS_VERSION="40.0"
    else
      GS_VERSION="3.28"
    fi
  else
    echo "'gnome-shell' not found, using styles for last gnome-shell version available."
    GS_VERSION="46.0"
  fi
fi

uninstall() {
  local dest="${1}"
  local name="${2}"
  local color="${3}"
  local theme="${4}"

  local THEME_DIR="${1}/${2}${3}${4}"

  [[ -d "$THEME_DIR" ]] && rm -rf "$THEME_DIR" && echo -e "Uninstalling "$THEME_DIR" ..."
}

link_libadwaita() {
  local dest="${1}"
  local name="${2}"
  local lcolor="${3}"
  local theme="${4}"

  local THEME_DIR="${1}/${2}${3}${4}"

  echo -e "\nLink '$THEME_DIR/gtk-4.0' to '${HOME}/.config/gtk-4.0' for libadwaita..."

  mkdir -p                                                                      "${HOME}/.config/gtk-4.0"
  ln -sf "${THEME_DIR}/gtk-4.0/assets"                                          "${HOME}/.config/gtk-4.0/assets"
  ln -sf "${THEME_DIR}/gtk-4.0/gtk.css"                                         "${HOME}/.config/gtk-4.0/gtk.css"
  ln -sf "${THEME_DIR}/gtk-4.0/gtk-dark.css"                                    "${HOME}/.config/gtk-4.0/gtk-dark.css"
}

uninstall_link() {
  rm -rf "${HOME}/.config/gtk-4.0"/{assets,gtk.css,gtk-dark.css}
}

link_theme() {
  for lcolor in "${lcolors[@]-${COLOR_VARIANTS[2]}}"; do
    for theme in "${themes[@]-${THEME_VARIANTS[0]}}"; do
      link_libadwaita "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "${lcolor}" "${theme}"
    done
  done
}

install_theme() {
  for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
    for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
      install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${color}" "${theme}"
    done
  done
}

uninstall_theme() {
  for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
    for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
      uninstall "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "${color}" "${theme}"
    done
  done
}

if [[ "${gdm:-}" != 'true' ]]; then
  if [[ "${remove:-}" != 'true' ]]; then
    install_theme

    if [[ "$libadwaita" == 'true' ]]; then
      uninstall_link && link_theme
    fi
  else
    if [[ "$libadwaita" == 'true' ]]; then
      uninstall_link
      echo -e 'Remove libadwaita links...'
    else
      uninstall_theme
    fi
  fi
fi

if [[ "${gdm:-}" == 'true' && "${remove:-}" != 'true' && "$UID" -eq "$ROOT_UID" ]]; then
  if [[ "${#gcolors[@]}" -gt 1 ]]; then
    echo -e 'Error: To install a gdm theme you can only select one color'
    exit 1
  fi

  if [[ "${#themes[@]}" -gt 1 ]]; then
    echo -e 'Error: To install a gdm theme you can only select one theme'
    exit 1
  fi

  echo -e "\nNOTICE: Only GDM theme will installed..."

  for gcolor in "${gcolors[@]-${COLOR_VARIANTS[2]}}"; do
    for theme in "${themes[@]-${THEME_VARIANTS[0]}}"; do
      install_gdm "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${gcolor}" "${theme}"
    done
  done
fi

if [[ "${gdm:-}" == 'true' && "${remove:-}" == 'true' && "$UID" -eq "$ROOT_UID" ]]; then
  revert_gdm
fi

echo "Finished!..."
