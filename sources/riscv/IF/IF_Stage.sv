`timescale 1ns/1ps

module IF_Stage(
    input logic clk, reset,
    input logic pc_select,
    input logic [31:0] alu_result_EX,
    output logic [31:0]PC_IF,
    output logic [31:0]instruction_IF
);

    logic [31:0] PC_IFadd4;
    logic [31:0] mux_out;
    assign PC_IFadd4 = PC_IF + 4;
    assign mux_out = pc_select ? alu_result_EX : PC_IFadd4;

    InstructionMemory IMEM(
        .clk(clk),
        .address(PC_IF),
        .instruction(instruction_IF)
    );

    always_ff @(posedge clk or posedge reset) begin
        if(reset)
            PC_IF <= 32'h0000_0000;
        else
            PC_IF <= mux_out;
    end

endmodule