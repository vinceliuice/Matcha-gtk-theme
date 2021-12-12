#! /usr/bin/env bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

INDEX="assets.txt"

for variant in '' '-light' '-dark'; do
  for color in '-sea' '-aliz' '-azul' '-pueril'; do

    ASSETS_DIR="assets${variant}${color}"
    HD_ASSETS_DIR="assets${variant}${color}-hdpi"
    XHD_ASSETS_DIR="assets${variant}${color}-xhdpi"
    SRC_FILE="assets${variant}${color}.svg"

    # normal
    install -d $ASSETS_DIR

    for i in `cat $INDEX`
    do
    if [ -f $ASSETS_DIR/$i.png ]; then
        echo $ASSETS_DIR/$i.png exists.
    else
        echo
        echo Rendering $ASSETS_DIR/$i.png
        $INKSCAPE --export-id=$i \
                  --export-id-only \
                  --export-png=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
        && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png
    fi
    done

    # hdpi
    install -d $HD_ASSETS_DIR

    for i in `cat $INDEX`
    do
    if [ -f $HD_ASSETS_DIR/$i.png ]; then
        echo $HD_ASSETS_DIR/$i.png exists.
    else
        echo
        echo Rendering $HD_ASSETS_DIR/$i.png
        $INKSCAPE --export-id=$i \
                  --export-id-only \
                  --export-dpi=144 \
                  --export-png=$HD_ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
        && $OPTIPNG -o7 --quiet $HD_ASSETS_DIR/$i.png
    fi
    done

    # xhdpi
    install -d $XHD_ASSETS_DIR

    for i in `cat $INDEX`
    do
    if [ -f $XHD_ASSETS_DIR/$i.png ]; then
        echo $XHD_ASSETS_DIR/$i.png exists.
    else
        echo
        echo Rendering $XHD_ASSETS_DIR/$i.png
        $INKSCAPE --export-id=$i \
                  --export-id-only \
                  --export-dpi=192 \
                  --export-png=$XHD_ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
        && $OPTIPNG -o7 --quiet $XHD_ASSETS_DIR/$i.png
    fi
    done
  done
done

exit 0
