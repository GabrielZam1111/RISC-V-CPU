# src/start.S
.section .text.init
.global _start

_start:
    # Set up stack pointer
    la sp, __stack_top
    
    # Copy initialized data from IMEM to DMEM
    la t0, __data_load_start    # Source in IMEM
    la t1, __data_start         # Destination in DMEM  
    la t2, __data_end           # End of data in DMEM
copy_data:
    beq t1, t2, clear_bss
    lw t3, 0(t0)               # Load from IMEM
    sw t3, 0(t1)               # Store to DMEM
    addi t0, t0, 4
    addi t1, t1, 4
    j copy_data
    
    # Clear BSS section
clear_bss:
    la t0, __bss_start
    la t1, __bss_end
clear_bss_loop:                # Fixed: consistent label name
    beq t0, t1, call_main
    sw zero, 0(t0)
    addi t0, t0, 4
    j clear_bss_loop           # Fixed: matches label above

call_main:
    # Call main function
    jal ra, main
    
    # Infinite loop after main returns
loop:
    j loop