`timescale 1ns / 1ps

module InstructionMemory(
    input logic clk,                    
    input logic [31:0] address,
    output logic [31:0] instruction
);
    
    
    logic [31:0] memory [0:1023];       
    
    
    logic [9:0] word_addr;              
    assign word_addr = address[11:2];   
    
    
    initial begin
            for (int i = 0; i < 1024; i++) begin
        memory[i] = 32'h00000013;
    end
        $readmemh("program.mem", memory);
    end
    
    
    always_ff @(posedge clk) begin
        instruction <= memory[word_addr];
    end
    
endmodule