AS=m68k-unknown-linux-as
LD=m68k-unknown-linux-ld
SOURCES=5bf10fd1.a
all: 5bf10fd1.bin

clean: 
	rm -f *.bin *.o

.a.o:
	$(AS) -g -o $@ $<

.o.bin:
	$(LD) 

#!/bin/sh
#m68k-unknown-linux-as -g --statistics -o 5bf10fd1.o 5bf10fd1.a || exit
#m68k-unknown-linux-ld --stats --oformat=binary -Ttext=0x40800000 -e 0x40800000 -o 5bf10fd1.bin 5bf10fd1.o || exit
#cmp ROM-077D.DAT 5bf10fd1.bin || exit
#sha1sum -c 5bf10fd1.sha1 || exit
#echo oink
#csplit -s -n 3 -f 077d. tmp9 "/SPLIT HERE/" "{*}"
#git diff
#git add 077d.???
#git commit -a -m "$(date)"
#git commit -a -m "$(date) $(./complete.sh)"
#rm 077d.[0-9]??
