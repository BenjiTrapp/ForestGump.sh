#!/bin/bash
cat /opt/scripts/entrypoint.sh
exec bash --rcfile /opt/scripts/bashrc_custom
