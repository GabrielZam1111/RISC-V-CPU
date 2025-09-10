`timescale 1ns / 1ps

module RegisterFile(
    input logic clk, reset,
    input logic [31:0] write_data,
    input logic [4:0] write_addr,
    input logic [4:0] data1_addr,
    input logic [4:0] data2_addr,
    input logic reg_write_en,
    output logic [31:0] data1,
    output logic [31:0] data2
);
    logic [31:0] register [31:0];

    always_comb begin
        data1 = (data1_addr == 5'b00000) ? 32'h0000_0000 : register[data1_addr];
        data2 = (data2_addr == 5'b00000) ? 32'h0000_0000 : register[data2_addr];
    end

    integer i;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                register[i] <= 32'h0000_0000;
            end
        end else if (reg_write_en && write_addr != 5'b00000) begin
            register[write_addr] <= write_data;
        end
    end

endmodule