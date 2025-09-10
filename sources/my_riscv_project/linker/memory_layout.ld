MEMORY
{
    /* Instruction Memory - 4KB */
    IMEM : ORIGIN = 0x00000000, LENGTH = 4K
    
    /* Data Memory - 1KB, separate address space */
    DMEM : ORIGIN = 0x00001000, LENGTH = 1K
}

ENTRY(_start)

SECTIONS
{
    /* Instructions and constants in instruction memory */
    .text : {
        *(.text.init)
        *(.text)
        *(.text.*)
    } > IMEM

    .rodata : {
        *(.rodata)
        *(.rodata.*)
    } > IMEM

    /* Initialized data - loaded from IMEM, runs from DMEM */
    .data : {
        __data_start = .;
        *(.data)
        *(.data.*)
        __data_end = .;
    } > DMEM AT > IMEM

    /* Uninitialized data in DMEM */
    .bss : {
        __bss_start = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        __bss_end = .;
    } > DMEM

    /* Stack at top of data memory */
    . = ALIGN(4);
    __stack_top = ORIGIN(DMEM) + LENGTH(DMEM) - 4;
    
    /* Store data load addresses for startup code */
    __data_load_start = LOADADDR(.data);
    __data_load_end = LOADADDR(.data) + SIZEOF(.data);
}