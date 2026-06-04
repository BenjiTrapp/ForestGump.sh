#!/bin/bash
# Record an RDP session as a GIF
# Usage: record-rdp.sh <target> <user> <pass> [duration_seconds] [output.gif]

set -e

TARGET="${1:?Usage: record-rdp.sh <target> <user> <pass> [duration] [output.gif]}"
USER="${2:?}"
PASS="${3:?}"
DURATION="${4:-10}"
OUTPUT="${5:-/data/rdp-demo.gif}"

DISPLAY_NUM=42
RESOLUTION="1024x768"
FPS=5

echo "[*] Starting Xvfb on :${DISPLAY_NUM} (${RESOLUTION})..."
Xvfb :${DISPLAY_NUM} -screen 0 ${RESOLUTION}x24 &
XVFB_PID=$!
sleep 1

export DISPLAY=:${DISPLAY_NUM}

echo "[*] Launching xfreerdp to ${TARGET}..."
xfreerdp /v:"${TARGET}" /u:"${USER}" /p:"${PASS}" \
    /cert:ignore +clipboard /size:${RESOLUTION} /bpp:24 &
RDP_PID=$!
sleep 4  # Let session establish and desktop render

# Simulate right-click to open openbox menu, then open xterm
echo "[*] Opening terminal on remote desktop..."
if command -v xdotool &>/dev/null; then
    xdotool mousemove 512 384 click 3 sleep 0.5 key Down Return
    sleep 2
fi

echo "[*] Recording for ${DURATION}s at ${FPS}fps..."
ffmpeg -y -f x11grab -video_size ${RESOLUTION} -framerate ${FPS} \
    -i :${DISPLAY_NUM} -t ${DURATION} \
    -vf "fps=${FPS},scale=800:-1" \
    "${OUTPUT}" 2>/dev/null

echo "[*] Cleaning up..."
kill ${RDP_PID} 2>/dev/null || true
kill ${XVFB_PID} 2>/dev/null || true

echo "[+] Done! GIF saved to: ${OUTPUT}"
ls -lh "${OUTPUT}"
