CROSS-COMPILER = arm-none-eabi-
QEMU = ./gnu-mcu-eclipse-qemu/bin/qemu-system-gnuarmeclipse

all: sections.bin

sections.bin: sections.c
	$(CROSS-COMPILER)gcc -mcpu=cortex-m4 -nostartfiles -T empty.ld sections.c startup.s -o sections.elf
	$(CROSS-COMPILER)objcopy -O binary sections.elf sections.bin
	$(CROSS-COMPILER)objdump -D sections.elf

qemu:
	@echo
	@echo "Press Ctrl+A and then press X to exit QEMU"
	@echo
	$(QEMU) -M STM32F4-Discovery -nographic -gdb tcp::1234 -S -kernel sections.bin

clean:
	rm -rf *.o *.elf *.bin

