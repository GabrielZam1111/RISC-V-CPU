`timescale 1ns / 1ps

module EX_MEM_pipe(
    input logic clk,
    input logic reset,
    input logic [31:0] instruction_in,
    input logic [31:0] PC_in,
    input logic [31:0] alu_result_in,
    input logic [31:0] immediate_in,
    input logic [31:0] D_in_in,
    input logic [3:0] read_write_in,
    input logic [1:0] wb_sel_in,
    input logic reg_write_en_in,
    input logic data_sel_MEM_in,
    input logic busywait,

    output logic [31:0] instruction_out,
    output logic [31:0] PC_out,
    output logic [31:0] alu_result_out,
    output logic [31:0] immediate_out,
    output logic [31:0] D_in_out,
    output logic data_sel_MEM_out,
    output logic [3:0] read_write_out,
    output logic [1:0] wb_sel_out,
    output logic reg_write_en_out
);
    typedef struct packed{
        logic [31:0] instruction;
        logic [31:0] PC;
        logic [31:0] alu_result;
        logic [31:0] immediate;
        logic [31:0] D_in;
        logic [3:0] read_write;
        logic [1:0] wb_sel;
        logic reg_write_en;
        logic data_sel_MEM;
    }pipe_reg_t;

    pipe_reg_t pipe_reg, pipe_reg_next; 

    always_comb begin
        pipe_reg_next = pipe_reg;
        if (reset) begin
            pipe_reg_next = '0;
        end else if (!busywait) begin
            pipe_reg_next.instruction = instruction_in;
            pipe_reg_next.PC = PC_in;
            pipe_reg_next.alu_result = alu_result_in;
            pipe_reg_next.immediate = immediate_in;
            pipe_reg_next.D_in = D_in_in;
            pipe_reg_next.read_write = read_write_in;
            pipe_reg_next.wb_sel = wb_sel_in;
            pipe_reg_next.reg_write_en = reg_write_en_in;
            pipe_reg_next.data_sel_MEM = data_sel_MEM_in;
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pipe_reg <= '0;
        end else begin
            pipe_reg <= pipe_reg_next;
        end
    end

    assign instruction_out = pipe_reg.instruction;
    assign PCout = pipe_reg.PC;
    assign alu_result_out = pipe_reg.alu_result;
    assign immediate_out = pipe_reg.immediate;
    assign D_in_out = pipe_reg.D_in;
    assign read_write_out = pipe_reg.read_write;
    assign wb_sel_out = pipe_reg.wb_sel;
    assign reg_write_en_out = pipe_reg.reg_write_en;
    assign data_sel_MEM_out = pipe_reg.data_sel_MEM;


endmodule