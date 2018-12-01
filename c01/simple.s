	.cpu cortex-m4
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"simple.c"
	.text
	.align	1
	.global	mymain
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	mymain, %function
mymain:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
.L2:
	b	.L2
	.size	mymain, .-mymain
	.ident	"GCC: (15:6.3.1+svn253039-1build1) 6.3.1 20170620"
