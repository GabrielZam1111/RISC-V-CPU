`timescale 1ns / 1ps

module ImmediateGenerator(
        input logic [24:0] instruction,
        input logic [2:0] imm_sel,
        output logic [31:0] immediate
    );
    always_comb begin
        case (imm_sel)
            3'b000: immediate = {instruction[24:5],12'b0}; // U
            3'b001: immediate = {{10{instruction[24]}},instruction[12:5],instruction[13],instruction[23:14], 2'b00}; //J
            3'b010: immediate = {{20{instruction[24]}},instruction[23:18],instruction[4:0]};   //S
            3'b011: immediate = {{20{instruction[24]}},instruction[0],instruction[23:18],instruction[4:1], 1'b0}; //B
            3'b100: immediate = {{20{instruction[24]}},instruction[24:13]}; //I
            3'b101: immediate = {{27{instruction[24]}},instruction[17:13]}; //I shift
            3'b110: immediate = {{20{0}},instruction[24:13]};               //IU 
            default: immediate = 32'b0;
        endcase
        end
endmodule