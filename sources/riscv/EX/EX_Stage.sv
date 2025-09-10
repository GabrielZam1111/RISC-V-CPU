`timescale 1ns / 1ps

module EX_Stage(
        input logic [31:0]data1,
        input logic [31:0]data2,
        input logic [31:0]PC_in,
        input logic [31:0]immediate_in,
        input logic [31:0]alu_result_MEM,
        input logic [31:0]write_data_WB,

        input logic [4:0]alu_op,
        input logic [2:0]branch_jump,


        input logic [1:0]data1_sel_ALU,
        input logic [1:0]data2_sel_ALU,
        input logic [1:0]data1_sel_BJ,
        input logic [1:0]data2_sel_BJ,


        output logic [31:0]alu_result,

        output logic [31:0]mux5_output,
        output logic pc_select
);
logic [31:0] mux1_output;
logic [31:0] mux2_output;
logic [31:0] mux3_output;
logic [31:0] mux4_output;

ALU ALU_UNIT(
    .data1      (mux1_output),
    .data2      (mux2_output),
    .alu_op     (alu_op),
    .alu_result (alu_result)
);

BranchLogic BRANCHL_LOGIC(
    .data1      (mux3_output),
    .data2      (mux4_output),
    .branch_jump(branch_jump),
    .pc_select  (pc_select)
);

mux4to1 mux1(
    .in0(data1),
    .in1(PCin),
    .in2(write_data_WB),
    .in3(alu_result_MEM),
    .sel(data1_sel_ALU),
    .out(mux1_output)
);
mux4to1 mux2(
    .in0(data2),
    .in1(immediate_in),
    .in2(write_data_WB),
    .in3(alu_result_MEM),
    .sel(data2_sel_ALU),
    .out(mux2_output)
);
mux4to1 mux3(
    .in0(data1),
    .in1(data1),
    .in2(write_data_WB),
    .in3(alu_result_MEM),
    .sel(data1_sel_BJ),
    .out(mux3_output)
);
mux4to1 mux4(
    .in0(data2),
    .in1(data2),
    .in2(write_data_WB),
    .in3(alu_result_MEM),
    .sel(data2_sel_BJ),
    .out(mux4_output)
);
mux4to1 mux5(
    .in0(data2),
    .in1(data2),
    .in2(write_data_WB),
    .in3(alu_result_MEM),
    .sel(data2_sel_BJ),
    .out(mux5_output)
);
endmodule