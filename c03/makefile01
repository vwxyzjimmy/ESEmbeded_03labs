CROSS-COMPILER = arm-none-eabi-
QEMU = ./gnu-mcu-eclipse-qemu/bin/qemu-system-gnuarmeclipse

all: asm02.bin

asm02.bin: asm02.s
	$(CROSS-COMPILER)gcc -Wall -mcpu=cortex-m4 -nostartfiles -Ttext=0x0 asm02.s -o asm02.elf
	$(CROSS-COMPILER)objcopy -O binary asm02.elf asm02.bin
	$(CROSS-COMPILER)objdump -D asm02.elf

qemu:
	@echo
	@echo "Press Ctrl+A and then press X to exit QEMU"
	@echo
	$(QEMU) -M STM32F4-Discovery -nographic -gdb tcp::1234 -S -kernel asm02.bin

clean:
	rm -rf *.o *.elf *.bin

