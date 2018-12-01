SECTIONS
{
	. = 0x0;
	.mytext :
	{
		KEEP(*(.isr_vectors))
		*(.text)
	}
}
