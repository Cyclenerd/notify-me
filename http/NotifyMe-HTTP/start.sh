#!/bin/sh
plackup -E "production" -s "Starman" -p "$PORT" -a bin/app.psgi