`timescale 1ns / 1ps
module MEM_Stage(
    input logic clk, reset,
    input logic [31:0] PC_in,
    input logic [31:0] address,
    input logic [31:0] D_in,
    input logic [31:0] write_data_WB,
    input logic data_sel_MEM,
    input logic [3:0] read_write,
    output logic [31:0] D_out,
    output logic [31:0] PCadd4,
    output logic [14:0] led
);
    logic [31:0] mux_out;
    assign PCadd4 = PC_in + 32'd4;
    
    assign mux_out = data_sel_MEM ? write_data_WB : D_in;
    
    DataMemory data_memory(
        .clk(clk),
        .address(address),
        .D_in(mux_out),
        .read_write_en(read_write),
        .D_out(D_out),
        .led(led)
    );
endmodule