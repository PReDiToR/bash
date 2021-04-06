#!/bin/bash
## Autorotation script for Lenovo Miix 320
#  PReDiToR
#  13/11/20
s="DSI1"
t="FTSC1000:00 2808:1015"
killall monitor-sensor; rm -f /dev/shm/autorotate.log; monitor-sensor > /dev/shm/autorotate.log 2>&1 &
sleep 3
loop() {
  case $r in
    *normal*)
      m="1 0 0 0 1 0 0 0 1"; d=normal;;
    *left-up*)
      m="0 -1 1 1 0 0 0 0 1"; d=left;;
    *right-up*)
      m="0 1 0 -1 0 1 0 0 1"; d=right;;
    *bottom-up*)
      m="-1 0 1 0 -1 1 0 0 1"; d=inverted;;
    *)
      r=$(tail /dev/shm/autorotate.log | grep 'orientation' | tail -1); loop; return;;
  esac
  xinput set-prop "$t" 'Coordinate Transformation Matrix' $m; xrandr --output $s --rotate $d
}
loop "$r"
while inotifywait -e modify /dev/shm/autorotate.log; do
  r=$(tail -1 /dev/shm/autorotate.log)
  loop "$r"
done
