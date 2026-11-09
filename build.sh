#!/bin/sh
# Packs module/ and the license into dist/force-skiavk-<version>.zip
set -e
cd "$(dirname "$0")"

VERSION=$(sed -n 's/^version=//p' module/module.prop)
rm -rf dist
mkdir -p dist/module
cp -R module/. dist/module/
cp LICENSE dist/module/LICENSE
(cd dist/module && zip -qr -X "../force-skiavk-$VERSION.zip" .)
rm -rf dist/module
echo "Built dist/force-skiavk-$VERSION.zip"
