#!/bin/bash
# Build the firmware and publish it for over-the-air updates.
# Usage: bump "version:" in nodex-pir.yaml, then run ./release.sh, then commit + push.
set -e
# Build with this ESPHome version on purpose. Newer ESPHome (2026.x) stops sending entity
# object_ids, which breaks older Home Assistant installs (only one entity per type appears).
ESPHOME_VERSION=2025.8.1
if [ "$(esphome version | awk '{print $2}')" != "$ESPHOME_VERSION" ]; then
  echo "Need ESPHome $ESPHOME_VERSION for releases:  pip install esphome==$ESPHOME_VERSION"; exit 1
fi
YAML=nodex-pir.yaml
NAME=nodex-pir
OUT=docs/firmware

VERSION=$(grep -E '^\s*version:' "$YAML" | head -1 | sed -E 's/.*"(.*)".*/\1/')
echo "Building $NAME $VERSION ..."
esphome compile "$YAML"

BUILD=.esphome/build/$NAME/.pioenvs/$NAME
mkdir -p "$OUT"
cp "$BUILD/firmware.ota.bin"     "$OUT/$NAME.ota.bin"
cp "$BUILD/firmware.factory.bin" "$OUT/$NAME.factory.bin"
MD5=$(md5 -q "$OUT/$NAME.ota.bin" 2>/dev/null || md5sum "$OUT/$NAME.ota.bin" | cut -d' ' -f1)

cat > "$OUT/manifest.json" <<JSON
{
  "name": "Nodex PIR",
  "version": "$VERSION",
  "home_assistant_domain": "esphome",
  "new_install_prompt_erase": false,
  "builds": [
    {
      "chipFamily": "ESP8266",
      "parts": [ { "path": "$NAME.factory.bin", "offset": 0 } ],
      "ota": {
        "path": "$NAME.ota.bin",
        "md5": "$MD5",
        "summary": "Nodex PIR firmware $VERSION",
        "release_url": "https://github.com/TPS505/Nodex-PIR/releases"
      }
    }
  ]
}
JSON
echo "Done: $OUT/manifest.json -> version $VERSION. Now: git add docs && git commit -m 'Release $VERSION' && git push"
