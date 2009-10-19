#!/bin/sh
m68k-unknown-linux-as --statistics tmp9 -o tmp9.o
m68k-unknown-linux-ld --oformat=binary -Ttext=0x40800000 -e 0x40800000 -o bork tmp9.o || exit
cmp ROM-077D.DAT bork || exit
echo oink
csplit -s -n 3 -f 077d. tmp9 "/SPLIT HERE/" "{*}"
git diff
git add 077d.???
git commit -m "$(date)"
rm 077d.[0123]??
