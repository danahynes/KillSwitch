#! /usr/bin/env bash

gpio -g mode 3 out
gpio -g write 3 0
sleep 1
gpio -g write 3 1

# -)
