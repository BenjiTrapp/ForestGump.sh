#!/bin/bash
# rdp-browser - Browser-based RDP client via noVNC
# Usage: rdp-browser /v:target /u:user /p:pass [other xfreerdp args...]
# Then open http://localhost:6080/vnc.html in your browser

NOVNC_PORT=${NOVNC_PORT:-6080}
VNC_PORT=${VNC_PORT:-5900}
DISPLAY_NUM=${DISPLAY_NUM:-99}
SCREEN_SIZE=${SCREEN_SIZE:-1280x1024x24}
NOVNC_DIR=/usr/share/novnc

cleanup() {
    echo ""
    echo "Shutting down..."
    kill $WS_PID $X11VNC_PID $FREERDP_PID $XVFB_PID 2>/dev/null
    wait 2>/dev/null
    echo "Done."
}
trap cleanup EXIT INT TERM

if ! command -v Xvfb &>/dev/null; then
    echo "Error: Xvfb not found. Install xvfb package."
    exit 1
fi
if ! command -v x11vnc &>/dev/null; then
    echo "Error: x11vnc not found."
    exit 1
fi
if ! command -v websockify &>/dev/null; then
    echo "Error: websockify not found. Install python3-websockify."
    exit 1
fi
if [ ! -d "$NOVNC_DIR" ]; then
    echo "Error: noVNC not found at $NOVNC_DIR"
    exit 1
fi
if [ ! -f "$NOVNC_DIR/vnc.html" ]; then
    echo "Error: noVNC web files missing (vnc.html not found)"
    exit 1
fi

echo "Starting Xvfb on display :$DISPLAY_NUM ..."
Xvfb :$DISPLAY_NUM -screen 0 $SCREEN_SIZE &
XVFB_PID=$!
sleep 0.5

if ! kill -0 $XVFB_PID 2>/dev/null; then
    echo "Error: Xvfb failed to start"
    exit 1
fi

echo "Starting xfreerdp $@ ..."
DISPLAY=:$DISPLAY_NUM xfreerdp "$@" &
FREERDP_PID=$!

echo "Starting x11vnc on port $VNC_PORT ..."
x11vnc -display :$DISPLAY_NUM -rfbport $VNC_PORT -forever -shared -nopw -quiet &
X11VNC_PID=$!
sleep 0.5

if ! kill -0 $X11VNC_PID 2>/dev/null; then
    echo "Error: x11vnc failed to start"
    echo "Check that :$DISPLAY_NUM is a valid display."
    exit 1
fi

echo "Starting websockify (noVNC) on 0.0.0.0:$NOVNC_PORT ..."
websockify --web "$NOVNC_DIR" 0.0.0.0:$NOVNC_PORT localhost:$VNC_PORT &
WS_PID=$!
sleep 1

if ! kill -0 $WS_PID 2>/dev/null; then
    echo "Error: websockify failed to start"
    exit 1
fi

HOST="${HOST:-localhost}"
echo ""
echo "============================================"
echo "  RDP session active!"
echo ""
echo "  Open in your browser:"
echo "  http://$HOST:$NOVNC_PORT/vnc.html"
echo "  http://$HOST:$NOVNC_PORT/vnc_lite.html"
echo ""
echo "  Press Ctrl+C to stop."
echo "============================================"
echo ""

wait $FREERDP_PID 2>/dev/null
wait $WS_PID $X11VNC_PID $XVFB_PID 2>/dev/null
