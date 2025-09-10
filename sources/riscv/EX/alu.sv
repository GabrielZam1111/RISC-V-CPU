`timescale 1ns / 1ps

module ALU(
    input logic [31:0] data1,
    input logic [31:0] data2,
    input logic [4:0] alu_op,
    output logic [31:0] alu_result
);
    logic signed [31:0] signed_data1;
    logic signed [31:0] signed_data2;
    logic signed [63:0] mul_signed;
    logic [63:0] mul_unsigned;

    always_comb begin
            signed_data1 = data1;
            signed_data2 = data2;
            case(alu_op)
                5'b00000: alu_result = data1 + data2;       // ADD
                5'b00010: alu_result = data1 - data2;       // SUB
                5'b00100: alu_result = data1 << data2[4:0]; // SLL
                5'b01000: alu_result = ($signed(data1) < $signed(data2)) ? 32'd1 : 32'd0; // SLT
                5'b01100: alu_result = (data1 < data2) ? 32'd1 : 32'd0; // SLTU
                5'b10000: alu_result = data1 ^ data2;       // XOR
                5'b10100: alu_result = data1 >> data2[4:0]; // SRL
                5'b10110: alu_result = $signed(data1) >>> data2[4:0]; // SRA
                5'b11000: alu_result = data1 | data2;       // OR
                5'b11100: alu_result = data1 & data2;       // AND

                5'b00001: begin // MUL
                    mul_signed = signed_data1 * signed_data2;
                    alu_result = mul_signed[31:0];
                end
                5'b00101: begin // MULH
                    mul_signed = signed_data1 * signed_data2;
                    alu_result = mul_signed[63:32];
                end
                5'b01001: begin // MULHU
                    mul_unsigned = data1 * data2;
                    alu_result = mul_unsigned[63:32];
                end
                5'b01101: begin // MULHSU
                    mul_signed = signed_data1 * data2;
                    alu_result = mul_signed[63:32];
                end
                5'b10001: begin // DIV
                    alu_result = (data2 == 0) ? 32'hFFFFFFFF : signed_data1 / signed_data2;
                end
                5'b10101: begin // DIVU
                    alu_result = (data2 == 0) ? 32'hFFFFFFFF : data1 / data2;
                end
                5'b11001: begin // REM
                    alu_result = (data2 == 0) ? data1 : signed_data1 % signed_data2;
                end
                5'b11101: begin // REMU
                    alu_result = (data2 == 0) ? data1 : data1 % data2;
                end
                default: alu_result = 32'b0;
            endcase

        end
endmodule