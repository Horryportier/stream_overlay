#! /bin/bash

./rtmp_server/rtmp_server &
obs --startstreaming & 
./exports/linux/stream_overlay.sh &

