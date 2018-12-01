SECTIONS
{
	. = 0X0;
	._text :
	{
		KEEP(*(.startup))
		*(.text)
	}
}

