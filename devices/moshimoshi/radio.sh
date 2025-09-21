#!/usr/bin/env bash
ffmpeg -i http://listener3.mp3.tb-group.fm:80/hb.mp3 -ar 8000 -ac 1 -f mulaw - | cat
