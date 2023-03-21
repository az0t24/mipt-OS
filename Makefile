SHELL := /bin/bash

AS=/home/az0t24/OS/gcc-11.1.0-nolibc/x86_64-linux/bin/x86_64-linux-gcc
CC=/home/az0t24/OS/gcc-11.1.0-nolibc/x86_64-linux/bin/x86_64-linux-gcc
LD=/home/az0t24/OS/gcc-11.1.0-nolibc/x86_64-linux/bin/x86_64-linux-gcc
OBJCOPY=/home/az0t24/OS/gcc-11.1.0-nolibc/x86_64-linux/bin/x86_64-linux-objcopy

SED=sed
GRUB_MKRESCUE=grub-mkrescue

ROOT=$(shell pwd)
ASFLAGS=-g -I$(ROOT)
CCFLAGS=-I$(ROOT) -mno-mmx -mno-sse -mno-sse2 -maddress-mode=long -mcmodel=kernel -g -m64 -mno-red-zone -std=c11 -ffreestanding -nostdlib -fno-common #-Wall -Werror -Wextra -Wno-unused-function
LDFLAGS=-nostdlib #--no-dynamic-linker --warn-constructors --warn-common --no-eh-frame-hdr --fatal-warnings
export

kernel.iso: kernel.bin
	mkdir -p isodir/boot/grub
	cp grub.cfg isodir/boot/grub
	cp kernel.bin isodir/boot
	$(GRUB_MKRESCUE) -o kernel.iso isodir
	rm -rf isodir

kernel.bin:
	$(MAKE) -C arch/x86
	$(MAKE) -C boot/
	$(MAKE) -C drivers/
	$(MAKE) -C kernel/
	$(MAKE) -C mm/
	$(MAKE) -C sched/
	$(LD) $(LDFLAGS) -T <(cpp -P -E linker.ld) `find $(ROOT) -name '*.o'` -o kernel.bin
	$(OBJCOPY) --only-keep-debug kernel.bin kernel.sym
	$(OBJCOPY) --strip-debug kernel.bin

clean:
	$(MAKE) -C arch/x86 clean
	$(MAKE) -C boot/ clean
	$(MAKE) -C drivers/ clean
	$(MAKE) -C kernel/ clean
	$(MAKE) -C mm/ clean
	$(MAKE) -C sched/ clean
	rm -f kernel.bin
	rm -f kernel.sym
	rm -f kernel.iso

.PHONY: kernel.bin clean
