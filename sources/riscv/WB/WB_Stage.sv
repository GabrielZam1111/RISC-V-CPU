`timescale  1ns /1ps
module WB_Stage(
        input logic [31:0] instruction,
        input logic [31:0] PCadd4,
        input logic [31:0] alu_result,
        input logic [31:0] immediate,
        input logic [31:0] D_out,
        input logic [1:0] wb_sel_out,
        output logic [4:0] write_addr_WB,
        output logic [31:0] write_data_WB
);
    assign write_addr_WB = instruction[11:7];

    mux4to1 wb_mux (
        .sel(wb_sel_out),
        .in0(alu_result),
        .in1(D_out),
        .in2(immediate),
        .in3(PCadd4),
        .out(write_data_WB)
    );
endmodule