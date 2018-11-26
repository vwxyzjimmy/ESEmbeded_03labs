.syntax unified

.global _start

.type _start, %function

	.word 0x20000100
	.word _start

_start:
	b	mymain
