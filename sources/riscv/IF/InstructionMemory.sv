`timescale 1ns / 1ps

module InstructionMemory(
    input  logic        clk,
    input  logic [31:0] address,
    output logic [31:0] instruction
);
    
    // Memory array - Basys 3 optimized (4KB = 1 RAMB36E1)
    (* ram_style = "block" *) logic [31:0] memory [0:1023];
    
    // Word address calculation
    logic [9:0] word_addr;
    assign word_addr = address[11:2];   // Byte to word address conversion
    
    // Memory initialization - synthesis friendly
    initial begin
        // Initialize with NOPs first (optional safety)
        for (int i = 0; i < 1024; i++) begin
            memory[i] = 32'h00000013;  // RISC-V NOP: addi x0, x0, 0
        end
        // Load program from file
        $readmemh("program.mem", memory);
    end
    
    // Simple synchronous read - guaranteed BRAM inference
    always_ff @(posedge clk) begin
        instruction <= memory[word_addr];
    end
    
endmodule