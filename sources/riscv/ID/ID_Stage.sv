`timescale 1ns / 1ps



module ID_Stage(
        input logic clk, reset,
        input logic [31:0] instruction,
        input logic [31:0] write_data_WB,
        input logic [4:0] write_addr_WB,
        input logic reg_write_en_WB,

        input logic [4:0]wb_addr_WB,
        input logic [4:0]mem_addr_MEM,
        input logic [4:0]ex_addr_EX,

        output logic [31:0]mux1_output,
        output logic [31:0]mux2_output,

        output logic [31:0] immediate,

        output logic [4:0]alu_op,
        output logic [2:0]branch_jump,
        output logic [3:0]read_write,
        output logic [1:0]wb_sel,
        output logic reg_write_en,

        output logic [1:0]data1_sel_ALU,
        output logic [1:0]data2_sel_ALU,
        output logic [1:0]data1_sel_BJ,
        output logic [1:0]data2_sel_BJ,
        output logic data_sel_MEM
);

    logic [31:0] data1, data2;
    logic op1sel, op2sel;
    logic [2:0] imm_sel;


    assign mux1_output = data1_sel_ID ? write_data_WB : data1;
    assign mux2_output = data2_sel_ID ? write_data_WB : data2;

    RegisterFile REG_FILE(
        .clk(clk),
        .reset(reset),
        .write_data(write_data_WB),
        .write_addr(write_addr_WB),
        .data1_addr(instruction[19:15]),
        .data2_addr(instruction[24:20]),
        .reg_write_en(reg_write_en_WB),
        .data1(data1),
        .data2(data2)
    );

    ImmediateGenerator IMMGEN(
        .instruction(instruction[31:7]),
        .imm_sel(imm_sel),
        .immediate(immediate)
    );

    ControlUnit CONTROL_UNIT(
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .imm_sel(imm_sel),
        .rd(instruction[11:7]),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .op1sel(op1sel),
        .op2sel(op2sel),
        .alu_op(alu_op),
        .branch_jump(branch_jump),
        .read_write(read_write),
        .wb_sel(wb_sel),
        .reg_write_en(reg_write_en)
    );

    ForwardingUnit FORWARDING_UNIT(
        .addr1(instruction[19:15]),
        .addr2(instruction[24:20]),
        .opcode(instruction[6:0]),
        .op1sel(op1sel),
        .op2sel(op2sel),
        .wb_addr(wb_addr_WB),
        .mem_addr(mem_addr_MEM),
        .ex_addr(ex_addr_EX),
        .data1_sel_ID(data1_sel_ID),
        .data2_sel_ID(data2_sel_ID),
        .data1_sel_ALU(data1_sel_ALU),
        .data2_sel_ALU(data2_sel_ALU),
        .data1_sel_BJ(data1_sel_BJ),
        .data2_sel_BJ(data2_sel_BJ),
        .data_sel_MEM(data_sel_MEM)
    );

endmodule
