CROSS-COMPILER = arm-none-eabi-

all: simple.elf

simple.elf: simple.c isr_vectors.s
	$(CROSS-COMPILER)gcc -Wall -mcpu=cortex-m4 -mthumb -nostartfiles -T m4.ld simple.c isr_vectors.s -o simple.elf
	$(CROSS-COMPILER)objdump -D simple.elf

clean:
	rm -rf *.o *.elf

