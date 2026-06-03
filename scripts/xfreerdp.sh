#!/bin/bash
# Wrapper for xfreerdp that uses xvfb when no X display is available
# This allows RDP from the headless ttyd web terminal

FREERDP_BIN=$(command -v xfreerdp)

if [ -n "$DISPLAY" ]; then
    exec "$FREERDP_BIN" "$@"
else
    exec xvfb-run "$FREERDP_BIN" "$@"
fi
