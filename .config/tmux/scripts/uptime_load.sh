#!/usr/bin/env bash
uptime | rev | cut -f 1-3 -d" " | sed 's/,//g' | rev
