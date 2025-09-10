`timescale 1ns / 1ps

module DataMemory(
    input logic clk,
    input logic [31:0] address,
    input logic [31:0] D_in,
    input logic [3:0] read_write_en,
    output logic [31:0] D_out,
    output logic [15:0] led
);

    logic [31:0] memory [0:255];  
    

    logic read_en, write_en;
    logic [1:0] byte_offset;
    logic [7:0] word_addr;

    assign word_addr = address[9:2];    
    assign byte_offset = address[1:0];  
    assign read_en = read_write_en[3];  
    assign write_en = |read_write_en[2:0]; 
    
    
    logic [31:0] D_out_reg;
    
    
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'h00000000;
        end
    end
    
    
    always_comb begin
        if (read_en) begin
            case (read_write_en[2:0])
                3'b000: begin
                    case (byte_offset)
                        2'b00: D_out = {{24{memory[word_addr][7]}}, memory[word_addr][7:0]};
                        2'b01: D_out = {{24{memory[word_addr][15]}}, memory[word_addr][15:8]};
                        2'b10: D_out = {{24{memory[word_addr][23]}}, memory[word_addr][23:16]};
                        2'b11: D_out = {{24{memory[word_addr][31]}}, memory[word_addr][31:24]};
                    endcase
                end

                3'b001: begin
                    case (byte_offset)
                        2'b00: D_out = {24'h000000, memory[word_addr][7:0]};
                        2'b01: D_out = {24'h000000, memory[word_addr][15:8]};
                        2'b10: D_out = {24'h000000, memory[word_addr][23:16]};
                        2'b11: D_out = {24'h000000, memory[word_addr][31:24]};
                    endcase
                end

                3'b010: begin
                    case (byte_offset[1])
                        1'b0: D_out = {{16{memory[word_addr][15]}}, memory[word_addr][15:0]};
                        1'b1: D_out = {{16{memory[word_addr][31]}}, memory[word_addr][31:16]};
                    endcase
                end
 
                3'b011: begin
                    case (byte_offset[1])
                        1'b0: D_out = {16'h0000, memory[word_addr][15:0]};
                        1'b1: D_out = {16'h0000, memory[word_addr][31:16]};
                    endcase
                end
 
                3'b100: D_out = memory[word_addr];
                
                default: D_out = 32'h00000000;
            endcase
        end else begin
            D_out = 32'h00000000;
        end
    end
    

    always_ff @(posedge clk) begin
        if (write_en) begin
            case (read_write_en[2:0])

                3'b101: begin
                    case (byte_offset)
                        2'b00: memory[word_addr][7:0]   <= D_in[7:0];
                        2'b01: memory[word_addr][15:8]  <= D_in[7:0];
                        2'b10: memory[word_addr][23:16] <= D_in[7:0];
                        2'b11: memory[word_addr][31:24] <= D_in[7:0];
                    endcase
                end

                3'b110: begin
                    case (byte_offset[1])
                        1'b0: memory[word_addr][15:0]  <= D_in[15:0];
                        1'b1: memory[word_addr][31:16] <= D_in[15:0];
                    endcase
                end

                3'b111: begin
                    memory[word_addr] <= D_in;
                end
            endcase
        end
    end
    

    assign led = memory[word_addr][15:0];
    
endmodule