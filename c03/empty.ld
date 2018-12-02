SECTIONS
{
	. = 0x0;
	._text :
	{
		KEEP(*(.startup))
		*(.text)
	}
}

