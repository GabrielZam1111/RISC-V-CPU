`timescale 1ns / 1ps

module ID_EX_pipe (
    input  logic                  clk,
    input  logic                  reset,
    input  logic                  busywait,
    input  logic                  NOP_sel,

    input  logic [31:0]      instruction_in,
    input  logic [31:0]      PC_in,
    input  logic [31:0]      data1_in,
    input  logic [31:0]      data2_in,
    input  logic [31:0]      immediate_in,

    input  logic [1:0]            data1_sel_ALU_in,
    input  logic [1:0]            data2_sel_ALU_in,
    input  logic [1:0]            data1_sel_BJ_in,
    input  logic [1:0]            data2_sel_BJ_in,
    input  logic                  data_sel_MEM_in,

    input  logic [4:0]            alu_op_in,
    input  logic [2:0]            branch_jump_in,
    input  logic [3:0]            read_write_in,
    input  logic [1:0]            wb_sel_in,
    input  logic                  reg_write_en_in,

    output logic [31:0]      instruction_out,
    output logic [31:0]      PC_out,
    output logic [31:0]      data1_out,
    output logic [31:0]      data2_out,
    output logic [31:0]      immediate_out,

    output logic [1:0]            data1_sel_ALU_out,
    output logic [1:0]            data2_sel_ALU_out,
    output logic [1:0]            data1_sel_BJ_out,
    output logic [1:0]            data2_sel_BJ_out,
    output logic                  data_sel_MEM_out,

    output logic [4:0]            alu_op_out,
    output logic [2:0]            branch_jump_out,
    output logic [3:0]            read_write_out,
    output logic [1:0]            wb_sel_out,
    output logic                  reg_write_en_out
);

    typedef struct packed {
        logic [31:0] instruction;
        logic [31:0] PC;
        logic [31:0] data1;
        logic [31:0] data2;
        logic [31:0] immediate;
        logic [1:0]       data1_sel_ALU;
        logic [1:0]       data2_sel_ALU;
        logic [1:0]       data1_sel_BJ;
        logic [1:0]       data2_sel_BJ;
        logic             data_sel_MEM;
        logic [4:0]       alu_op;
        logic [2:0]       branch_jump;
        logic [3:0]       read_write;
        logic [1:0]       wb_sel;
        logic             reg_write_en;
    } pipe_reg_t;

    pipe_reg_t pipe_reg, pipe_reg_next;

    always_comb begin
        pipe_reg_next = pipe_reg;
        if (reset) begin
            pipe_reg_next = '0;
        end else if (!busywait) begin
                 if (NOP_sel) begin
                pipe_reg_next.instruction    = 32'h00000013;
                pipe_reg_next.PC             = PC_in;
                pipe_reg_next.data1          = data1_in;
                pipe_reg_next.data2          = data2_in;
                pipe_reg_next.immediate      = immediate_in;
                pipe_reg_next.data1_sel_ALU  = 2'b00;
                pipe_reg_next.data2_sel_ALU  = 2'b00;
                pipe_reg_next.data1_sel_BJ   = 2'b00;
                pipe_reg_next.data2_sel_BJ   = 2'b00;
                pipe_reg_next.data_sel_MEM   = 1'b0;
                pipe_reg_next.alu_op         = 5'b00000;
                pipe_reg_next.branch_jump    = 3'b010; 
                pipe_reg_next.read_write     = 4'b0000;      
                pipe_reg_next.wb_sel         = 2'b00;        
                pipe_reg_next.reg_write_en   = 1'b0;         
            end else begin
                pipe_reg_next.instruction    = instruction_in;
                pipe_reg_next.PC             = PC_in;
                pipe_reg_next.data1          = data1_in;
                pipe_reg_next.data2          = data2_in;
                pipe_reg_next.immediate      = immediate_in;
                pipe_reg_next.data1_sel_ALU  = data1_sel_ALU_in;
                pipe_reg_next.data2_sel_ALU  = data2_sel_ALU_in;
                pipe_reg_next.data1_sel_BJ   = data1_sel_BJ_in;
                pipe_reg_next.data2_sel_BJ   = data2_sel_BJ_in;
                pipe_reg_next.data_sel_MEM   = data_sel_MEM_in;
                pipe_reg_next.alu_op         = alu_op_in;
                pipe_reg_next.branch_jump    = branch_jump_in;
                pipe_reg_next.read_write     = read_write_in;
                pipe_reg_next.wb_sel         = wb_sel_in;
                pipe_reg_next.reg_write_en   = reg_write_en_in;
            end
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pipe_reg <= '0;
        else
            pipe_reg <= pipe_reg_next;
    end

    // Output assignments
    assign instruction_out    = pipe_reg.instruction;
    assign PC_out              = pipe_reg.PC;
    assign data1_out          = pipe_reg.data1;
    assign data2_out          = pipe_reg.data2;
    assign immediate_out      = pipe_reg.immediate;
    assign data1_sel_ALU_out  = pipe_reg.data1_sel_ALU;
    assign data2_sel_ALU_out  = pipe_reg.data2_sel_ALU;
    assign data1_sel_BJ_out   = pipe_reg.data1_sel_BJ;
    assign data2_sel_BJ_out   = pipe_reg.data2_sel_BJ;
    assign data_sel_MEM_out   = pipe_reg.data_sel_MEM;
    assign alu_op_out         = pipe_reg.alu_op;
    assign branch_jump_out    = pipe_reg.branch_jump;
    assign read_write_out     = pipe_reg.read_write;
    assign wb_sel_out         = pipe_reg.wb_sel;
    assign reg_write_en_out   = pipe_reg.reg_write_en;

endmodule
