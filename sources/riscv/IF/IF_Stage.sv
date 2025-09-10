`timescale 1ns/1ps
package riscv_pkg;
    typedef enum logic [6:0] {
        RTYPE  = 7'b0110011,
        ITYPE  = 7'b0010011,
        LOAD   = 7'b0000011,
        STORE  = 7'b0100011,
        BRANCH = 7'b1100011,
        JALR   = 7'b1100111,
        JAL    = 7'b1101111,
        LUI    = 7'b0110111,
        AUIPC  = 7'b0010111
    } opcode_e;


    typedef enum logic [5:0] {
        null_reg,
        x0,  x1,  x2,  x3,  x4,  x5,  x6,  x7,
        x8,  x9,  x10, x11, x12, x13, x14, x15,
        x16, x17, x18, x19, x20, x21, x22, x23,
        x24, x25, x26, x27, x28, x29, x30, x31
    } reg_x_e;

    typedef enum logic [5:0] {
        null_abi,
        zero,  ra,   sp,   gp,   tp,   t0,   t1,   t2,
        s0,    s1,   a0,   a1,   a2,   a3,   a4,   a5,
        a6,    a7,   s2,   s3,   s4,   s5,   s6,   s7,
        s8,    s9,   s10,  s11,  t3,   t4,   t5,   t6
    } reg_abi_e;

endpackage

module IF_Stage(
    input logic clk, reset,
    input logic pc_select,
    input logic [31:0] alu_result_EX,
    output logic [31:0]PC_IF,
    output logic [31:0]instruction_IF
);
    import riscv_pkg::*;

    opcode_e   instr_opcode;
    reg_x_e    rs1_x, rs2_x, rd_x;
    reg_abi_e  rs1_abi, rs2_abi, rd_abi;


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

    always_comb begin
        // Default to null
        rs1_x   = null_reg;
        rs2_x   = null_reg;
        rd_x    = null_reg;

        rs1_abi = null_abi;
        rs2_abi = null_abi;
        rd_abi  = null_abi;

        unique case (instr_opcode)
            RTYPE, BRANCH: begin
                rs1_x   = reg_x_e'(instruction_IF[19:15]);
                rs2_x   = reg_x_e'(instruction_IF[24:20]);
                rd_x    = reg_x_e'(instruction_IF[11:7]);

                rs1_abi = reg_abi_e'(instruction_IF[19:15]);
                rs2_abi = reg_abi_e'(instruction_IF[24:20]);
                rd_abi  = reg_abi_e'(instruction_IF[11:7]);
            end

            ITYPE, LOAD, JALR: begin
                rs1_x   = reg_x_e'(instruction_IF[19:15]);
                rd_x    = reg_x_e'(instruction_IF[11:7]);

                rs1_abi = reg_abi_e'(instruction_IF[19:15]);
                rd_abi  = reg_abi_e'(instruction_IF[11:7]);
            end

            STORE: begin
                rs1_x   = reg_x_e'(instruction_IF[19:15]);
                rs2_x   = reg_x_e'(instruction_IF[24:20]);

                rs1_abi = reg_abi_e'(instruction_IF[19:15]);
                rs2_abi = reg_abi_e'(instruction_IF[24:20]);
            end

            JAL, LUI, AUIPC: begin
                rd_x    = reg_x_e'(instruction_IF[11:7]);
                rd_abi  = reg_abi_e'(instruction_IF[11:7]);
            end

            default: ; // keep null
        endcase
    end

    assign instr_opcode = opcode_e'(instruction_IF[6:0]);
endmodule