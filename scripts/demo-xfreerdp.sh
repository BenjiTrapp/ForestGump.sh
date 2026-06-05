#!/bin/bash
# Demo: Verify xfreerdp is functional in the headless ForestGump.sh container
# Usage: demo-xfreerdp.sh [target] [user] [password]
#
# Without arguments, runs a basic functionality check.
# With arguments, attempts an actual RDP connection.

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

banner() {
    echo -e "${CYAN}"
    echo "  ╔══════════════════════════════════════╗"
    echo "  ║   ForestGump.sh - xfreerdp Demo     ║"
    echo "  ╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

check_pass() { echo -e "  [${GREEN}✓${NC}] $1"; }
check_fail() { echo -e "  [${RED}✗${NC}] $1"; exit 1; }

banner

# --- Step 1: Verify xfreerdp binary exists ---
echo -e "${CYAN}[1/4] Checking xfreerdp binary...${NC}"
if command -v xfreerdp &>/dev/null; then
    check_pass "xfreerdp found at $(command -v xfreerdp)"
else
    check_fail "xfreerdp not found in PATH"
fi

# --- Step 2: Print version ---
echo -e "${CYAN}[2/4] xfreerdp version:${NC}"
VERSION_OUTPUT=$(xvfb-run --auto-servernum xfreerdp /version 2>&1 | head -5)
if [ -n "$VERSION_OUTPUT" ]; then
    echo "$VERSION_OUTPUT"
    check_pass "Version retrieved"
else
    check_fail "Failed to get version"
fi

# --- Step 3: Verify xvfb (headless X) ---
echo -e "${CYAN}[3/4] Checking xvfb-run (headless display)...${NC}"
if command -v xvfb-run &>/dev/null; then
    check_pass "xvfb-run available — headless RDP supported"
else
    check_fail "xvfb-run not found — headless RDP will not work"
fi

# --- Step 4: Attempt connection or dry-run ---
echo -e "${CYAN}[4/4] Connection test...${NC}"

TARGET="${1:-}"
USER="${2:-}"
PASS="${3:-}"

if [ -z "$TARGET" ]; then
    echo "      No target specified. Running xvfb dry-run to confirm X11 works..."
    # Run xfreerdp with /version through xvfb to prove the headless pipeline works
    if xvfb-run --auto-servernum xfreerdp /version > /dev/null 2>&1; then
        check_pass "xvfb-run + xfreerdp pipeline works (dry-run /version)"
    else
        # xfreerdp may return non-zero even on success; check if it ran at all
        OUTPUT=$(xvfb-run --auto-servernum xfreerdp /version 2>&1)
        if echo "$OUTPUT" | grep -q "FreeRDP"; then
            check_pass "xvfb-run + xfreerdp pipeline works (FreeRDP responded)"
        else
            check_fail "xvfb-run + xfreerdp pipeline failed"
        fi
    fi
    echo ""
    echo -e "  ${GREEN}All checks passed!${NC} xfreerdp is ready to use."
    echo ""
    echo "  To connect to a target:"
    echo "    demo-xfreerdp.sh <ip> <user> <password>"
    echo ""
    echo "  Example:"
    echo "    demo-xfreerdp.sh 192.168.1.10 administrator 'P@ssw0rd'"
    echo ""
else
    echo "      Connecting to $TARGET as $USER..."
    # Use timeout to kill after 8s. If xfreerdp connects successfully it stays
    # open (interactive session), so being killed by timeout = success.
    # Real failures (wrong host, auth error) return quickly with error messages.
    OUTPUT=$(timeout 8 xvfb-run --auto-servernum xfreerdp /v:"$TARGET" /u:"$USER" /p:"$PASS" \
        /cert:ignore +clipboard 2>&1) || EXIT_CODE=$?
    EXIT_CODE=${EXIT_CODE:-0}
    # exit code 124 = killed by timeout (connection was alive = success)
    # exit code 137 = SIGKILL timeout
    if [ $EXIT_CODE -eq 124 ] || [ $EXIT_CODE -eq 137 ]; then
        check_pass "RDP connection to $TARGET succeeded (session was active)"
    elif echo "$OUTPUT" | grep -qi "Caught signal\|Terminated"; then
        check_pass "RDP connection to $TARGET succeeded (session was active)"
    elif echo "$OUTPUT" | grep -qi "ERRCONNECT\|NEGO\|refused\|unreachable\|authentication failure"; then
        echo "$OUTPUT" | tail -5
        check_fail "RDP connection to $TARGET failed"
    else
        echo "$OUTPUT" | tail -5
        check_fail "RDP connection to $TARGET failed (unknown state)"
    fi
fi
