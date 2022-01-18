#!/bin/sh
plackup -E "production" -s "Starman" -o "0.0.0.0" -p "$PORT" -a bin/app.psgi