`timescale 1ns / 1ps

module DataMemory(
    input  logic        clk,
    input  logic [31:0] address,
    input  logic [31:0] D_in,
    input  logic [3:0]  read_write_en,
    output logic [31:0] D_out,
    output logic [14:0] led
);
    
    // Memory array - Basys 3 optimized size (2KB = perfect for 1 BRAM36)
    (* ram_style = "block" *) logic [31:0] memory [0:1023];
    
    // Address decoding
    logic [9:0] word_addr;
    logic [1:0] byte_offset;
    assign word_addr = address[11:2];    // 9 bits for 512 words
    assign byte_offset = address[1:0];
    
    // Control signal decoding
    logic read_en, write_en;
    logic [2:0] mem_op;
    assign read_en = read_write_en[3];
    assign write_en = |read_write_en[2:0];
    assign mem_op = read_write_en[2:0];
    
    // Memory initialization
    initial begin
        for (int i = 0; i < 512; i++) begin
            memory[i] = i;
        end
    end
    
    // Single synchronous memory access - BRAM friendly pattern
    logic [31:0] mem_read_data;
    
    always_ff @(posedge clk) begin
        // Write operation with byte enables
        if (write_en) begin
            case (mem_op)
                3'b101: begin // Byte write
                    case (byte_offset)
                        2'b00: memory[word_addr][7:0]   <= D_in[7:0];
                        2'b01: memory[word_addr][15:8]  <= D_in[7:0];
                        2'b10: memory[word_addr][23:16] <= D_in[7:0];
                        2'b11: memory[word_addr][31:24] <= D_in[7:0];
                    endcase
                end
                3'b110: begin // Half-word write
                    case (byte_offset[1])
                        1'b0: memory[word_addr][15:0]  <= D_in[15:0];
                        1'b1: memory[word_addr][31:16] <= D_in[15:0];
                    endcase
                end
                3'b111: begin // Word write
                    memory[word_addr] <= D_in;
                end
            endcase
        end
        
        // Always read for output (write-first mode)
        mem_read_data <= memory[word_addr];
    end
    
    // Output formatting (combinational from registered data)
    always_comb begin
        if (read_en) begin
            case (mem_op)
                3'b000: begin // Load byte (signed)
                    case (byte_offset)
                        2'b00: D_out = {{24{mem_read_data[7]}},  mem_read_data[7:0]};
                        2'b01: D_out = {{24{mem_read_data[15]}}, mem_read_data[15:8]};
                        2'b10: D_out = {{24{mem_read_data[23]}}, mem_read_data[23:16]};
                        2'b11: D_out = {{24{mem_read_data[31]}}, mem_read_data[31:24]};
                    endcase
                end
                3'b001: begin // Load byte (unsigned)
                    case (byte_offset)
                        2'b00: D_out = {24'h000000, mem_read_data[7:0]};
                        2'b01: D_out = {24'h000000, mem_read_data[15:8]};
                        2'b10: D_out = {24'h000000, mem_read_data[23:16]};
                        2'b11: D_out = {24'h000000, mem_read_data[31:24]};
                    endcase
                end
                3'b010: begin // Load half-word (signed)
                    case (byte_offset[1])
                        1'b0: D_out = {{16{mem_read_data[15]}}, mem_read_data[15:0]};
                        1'b1: D_out = {{16{mem_read_data[31]}}, mem_read_data[31:16]};
                    endcase
                end
                3'b011: begin // Load half-word (unsigned)
                    case (byte_offset[1])
                        1'b0: D_out = {16'h0000, mem_read_data[15:0]};
                        1'b1: D_out = {16'h0000, mem_read_data[31:16]};
                    endcase
                end
                3'b100: begin // Load word
                    D_out = mem_read_data;
                end
                default: D_out = 32'h00000000;
            endcase
        end else begin
            D_out = 32'h00000000;
        end
    end
    
    // LED output from fixed address - use the same read data when accessing LED address
    assign led = memory[64][14:0]; 
    
endmodule