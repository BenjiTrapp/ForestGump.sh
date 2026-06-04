#!/bin/bash
# Record a full RDP demo as a GIF showing:
#   1. xfreerdp connecting to target (progress shown)
#   2. Remote desktop appears with xterm
#   3. "whoami" typed on the remote machine
#
# Usage: record-rdp.sh <target> <user> <pass> [output.gif]

set -e

TARGET="${1:?Usage: record-rdp.sh <target> <user> <pass> [output.gif]}"
USER="${2:?}"
PASS="${3:?}"
OUTPUT="${4:-/data/rdp-full-demo.gif}"

DISPLAY_NUM=42
RESOLUTION="1024x768"
FPS=5

cleanup() {
    kill $RDP_PID 2>/dev/null || true
    kill $FFMPEG_PID 2>/dev/null || true
    kill $XVFB_PID 2>/dev/null || true
}
trap cleanup EXIT

# --- Phase 1: Start virtual display ---
echo "[*] Starting Xvfb on :${DISPLAY_NUM}..."
pkill -f "Xvfb :${DISPLAY_NUM}" 2>/dev/null || true
sleep 1
Xvfb :${DISPLAY_NUM} -screen 0 ${RESOLUTION}x24 &
XVFB_PID=$!
sleep 1
export DISPLAY=:${DISPLAY_NUM}

# --- Phase 2: Start recording FIRST (captures the connection process) ---
echo "[*] Starting recording..."
ffmpeg -y -f x11grab -video_size ${RESOLUTION} -framerate ${FPS} \
    -i :${DISPLAY_NUM} -t 20 \
    -vf "fps=${FPS},scale=800:-1" \
    "${OUTPUT}" 2>/dev/null &
FFMPEG_PID=$!
sleep 1

# --- Phase 3: Connect via xfreerdp (viewer will see connection happening) ---
echo "[*] Connecting to ${TARGET} via xfreerdp..."
xfreerdp /v:"${TARGET}" /u:"${USER}" /p:"${PASS}" \
    /cert:ignore +clipboard /size:${RESOLUTION} /bpp:24 &
RDP_PID=$!

# Wait for RDP desktop to render (rdp-target auto-launches xterm via .xsession)
echo "[*] Waiting for RDP desktop..."
sleep 10

# --- Phase 4: Type whoami in the remote xterm ---
echo "[*] Typing 'whoami' on remote desktop..."
# Click inside the xterm window to ensure focus
xdotool mousemove 400 300 click 1
sleep 1

# Type whoami with realistic delay
xdotool type --delay 100 "whoami"
sleep 0.5
xdotool key Return
sleep 3

# Type one more command to show interactivity
xdotool type --delay 100 "hostname"
sleep 0.5
xdotool key Return
sleep 3

# --- Phase 5: Wait for recording to finish ---
echo "[*] Waiting for recording to complete..."
wait $FFMPEG_PID 2>/dev/null || true

echo "[+] Done! GIF saved to: ${OUTPUT}"
ls -lh "${OUTPUT}"
