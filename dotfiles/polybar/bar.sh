#!/usr/bin/env bash
killall -q polybar

while pgrep -x polybar > /dev/null; do sleep 1; done

# polybar -r top # -r top is the name of the bar you should display
polybar
