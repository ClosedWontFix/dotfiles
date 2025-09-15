#!/usr/bin/env bash
# -*- bash -*-
# vim: ft=bash
#
# File: .config/tmux/scripts/window_name.sh
# Author: Dan Borkowski
#

uptime | rev | cut -f 1-3 -d" " | sed 's/,//g' | rev
