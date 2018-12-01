.syntax unified

.global _startup

.type _startup, %function

	.word 0x20000100
	.word _startup

_startup:
	b	mymain
