LAB3
===
# Calling Convention
## 介紹
Calling Convention指的是caller 和 callee 函式間，參數或回傳值在傳遞過程中，在stack frame(activation record)中的存放順序、及stack frame結束時由caller或callee負責清除的規則。
[Procedure Call and Stack 码代码的陈同学 ](https://blog.csdn.net/myle69/article/details/80362634)


## [Calling convention Wiki](https://en.wikipedia.org/wiki/Calling_convention#ARM_(A64)) 
A calling convention is an implementation-level (low-level) scheme for how subroutines receive parameters from their caller and how they return a result。

## ARM (32-bit ARM calling convention)
The standard 32-bit ARM calling convention allocates the 15 general-purpose registers as:
* r14 is the link register. (The BL instruction, used in a subroutine call, stores the return address in this register).
* r13 is the stack pointer. (The Push/Pop instructions in "Thumb" operating mode use this register only).
* r12 is the Intra-Procedure-call scratch register.
* r4 to r11: used to hold local variables.
* r0 to r3: used to hold argument values passed to a subroutine, and also hold results returned from a subroutine.
* The 16th register, r15, is the program counter.

If the type of value returned is too large to fit in r0 to r3, or whose size cannot be determined statically at compile time, then the caller must allocate space for that value at run time, and pass a pointer to that space in r0.

**Subroutines must preserve the contents of r4 to r11 and the stack pointer.** (Perhaps by saving them to the stack in the function prologue, then using them as scratch space, then restoring them from the stack in the function epilogue). In particular, subroutines that call other subroutines **must save the return address in the link register r14 to the stack before calling those other subroutines.** However, such subroutines do not need to return that value to r14—they merely need to load that value into r15, the program counter, to return.


The ARM calling convention mandates using a **full-descending stack**.
This calling convention causes a "typical" ARM subroutine to
1. In the prologue, push r4 to r11 to the stack, and push the return address in r14, to the stack. (This can be done with a single STM instruction).
2. copy any passed arguments (in r0 to r3) to the local scratch registers (r4 to r11).
3. allocate other local variables to the remaining local scratch registers (r4 to r11).
4. do calculations and call other subroutines as necessary using BL, assuming r0 to r3, r12 and r14 will not be preserved.
5. put the result in r0
6. In the epilogue, pull r4 to r11 from the stack, and pull the return address to the program counter r15. (This can be done with a single LDM instruction).

## ATPCS（ARM-Thumb Procedure Call Standard）
ATPCS規定了一些子程式之間呼叫的基本規則.這些基本規則含括子程式呼叫過程中暫存器的使用規則,資料堆疊的使用規則,引數的傳遞規則.為適應一些特定的需要,對這些基本的呼叫規則進行一些修改得到幾種不同的子程式呼叫規則。
[ARM的規則ATPCS和AAPCS](https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/423687/#outline__5)
[ATPCS 1.簡介](http://b8807053.pixnet.net/blog/post/3612142)  (這篇寫得很仔細)
### ARM 傳遞參數
ARM架構下，函數參數是通過 r0~r3 registers 傳遞的，若是要傳遞的參數超過四個，就必須使用 stack 來傳遞。
1. Subroutine 藉由 r0~r3 registers 傳遞參數，Subroutine 在返回前不用回復 r0~r3 進入 Subroutine 的內容。
2. 在 Subroutine 中使用 r4~r11保存局部變量，在進入 Subroutine 前必須保存這些被使用到的 registers 的值於 stack 中，才能提供給 Subroutine 使用，當 Subroutine 要結束時，在返回前必須恢復這些 registers 的值，對於 Subroutine 沒有用到的 registers 就不用進行這些操作(因為沒用到)，在 Thumb 中，通常只使用 r4~r7 來保存局部變量。

## 作業:
改寫一下 c03 的範例
1. 根據 c02 之範例(寫個 .ld 檔)在 c03 建出能在 qemu 模擬並正常運作之 bin 檔案，並用 qemu 模擬及 gdb 觀察之
2. 在 sections.c 內加入會回傳之函數，以及傳入數個參數至必須使用到 stack 傳入，並比較其傳入差別，及如何傳回。
3. 比較哪些是存於 stack 之變數。
``` c
int init_global = 0x1111;
int uninit_global;

const int global_const = 0x2222;

char init_global_rw_str[] = "AAA"; // ASCII 'A' : 0x41
char uninit_global_rw_str[3];
char *global_ro_str = "BBB"; // ASCII 'B' : 0x42

static int init_static_global = 0x3333;
static int uninit_static_global;

int func(int pass);
void pass_five_para(int a, int b, int c, int d, int e);
void mymain(void)
{
	int init_local = 0x4444;
	int uninit_local;

	const int local_const = 0x5555;

	char init_local_rw_str[] = "CCC"; // ASCII 'C' : 0x43
	char uninit_local_rw_str[3];
	char *local_ro_str = "DDD"; // ASCII 'D' : 0x44

	static int init_static_local = 0x6666;
	static int uninit_static_local;

	uninit_local_rw_str[0] = uninit_local_rw_str[1] = uninit_local_rw_str[2] = 'E'; // ASCII 'D' : 0x45

	uninit_local = func(init_local);
	pass_five_para(1, 2, 3, 4, 5);
	while (1)
		;
}

int func(int pass)
{
	static int init_static_local = 0x7777;
	static int uninit_static_local;
	return (init_static_local + pass);
}

void pass_five_para(int a, int b, int c, int d, int e){
	int nothing = a+b+c+d+e;
}
```
```
Disassembly of section ._text:

00000000 <mymain-0x8>:
   0:	20000100 	andcs	r0, r0, r0, lsl #2
   4:	00000009 	andeq	r0, r0, r9

00000008 <mymain>:
   8:	b580      	push	{r7, lr}
   a:	b088      	sub	sp, #32
   c:	af02      	add	r7, sp, #8
   e:	f244 4344 	movw	r3, #17476	; 0x4444
  12:	617b      	str	r3, [r7, #20]
  14:	f245 5355 	movw	r3, #21845	; 0x5555
  18:	613b      	str	r3, [r7, #16]
  1a:	4b0b      	ldr	r3, [pc, #44]	; (48 <mymain+0x40>)
  1c:	607b      	str	r3, [r7, #4]
  1e:	4b0b      	ldr	r3, [pc, #44]	; (4c <mymain+0x44>)
  20:	60fb      	str	r3, [r7, #12]
  22:	2345      	movs	r3, #69	; 0x45
  24:	70bb      	strb	r3, [r7, #2]
  26:	78bb      	ldrb	r3, [r7, #2]
  28:	707b      	strb	r3, [r7, #1]
  2a:	787b      	ldrb	r3, [r7, #1]
  2c:	703b      	strb	r3, [r7, #0]
  2e:	6978      	ldr	r0, [r7, #20]
  30:	f000 f80e 	bl	50 <func>
  34:	60b8      	str	r0, [r7, #8]
  36:	2305      	movs	r3, #5
  38:	9300      	str	r3, [sp, #0]
  3a:	2304      	movs	r3, #4
  3c:	2203      	movs	r2, #3
  3e:	2102      	movs	r1, #2
  40:	2001      	movs	r0, #1
  42:	f000 f815 	bl	70 <pass_five_para>
  46:	e7fe      	b.n	46 <mymain+0x3e>
  48:	00434343 	subeq	r4, r3, r3, asr #6
  4c:	000000a4 	andeq	r0, r0, r4, lsr #1

00000050 <func>:
  50:	b480      	push	{r7}
  52:	b083      	sub	sp, #12
  54:	af00      	add	r7, sp, #0
  56:	6078      	str	r0, [r7, #4]
  58:	4b04      	ldr	r3, [pc, #16]	; (6c <func+0x1c>)
  5a:	681a      	ldr	r2, [r3, #0]
  5c:	687b      	ldr	r3, [r7, #4]
  5e:	4413      	add	r3, r2
  60:	4618      	mov	r0, r3
  62:	370c      	adds	r7, #12
  64:	46bd      	mov	sp, r7
  66:	bc80      	pop	{r7}
  68:	4770      	bx	lr
  6a:	bf00      	nop
  6c:	000000bc 	strheq	r0, [r0], -ip

00000070 <pass_five_para>:
  70:	b480      	push	{r7}
  72:	b087      	sub	sp, #28
  74:	af00      	add	r7, sp, #0
  76:	60f8      	str	r0, [r7, #12]
  78:	60b9      	str	r1, [r7, #8]
  7a:	607a      	str	r2, [r7, #4]
  7c:	603b      	str	r3, [r7, #0]
  7e:	68fa      	ldr	r2, [r7, #12]
  80:	68bb      	ldr	r3, [r7, #8]
  82:	441a      	add	r2, r3
  84:	687b      	ldr	r3, [r7, #4]
  86:	441a      	add	r2, r3
  88:	683b      	ldr	r3, [r7, #0]
  8a:	441a      	add	r2, r3
  8c:	6a3b      	ldr	r3, [r7, #32]
  8e:	4413      	add	r3, r2
  90:	617b      	str	r3, [r7, #20]
  92:	bf00      	nop
  94:	371c      	adds	r7, #28
  96:	46bd      	mov	sp, r7
  98:	bc80      	pop	{r7}
  9a:	4770      	bx	lr
```

* [LAB3 Github](https://github.com/vwxyzjimmy/ESEmbeded_03labs)

