`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2025 03:22:53 PM
// Design Name: 
// Module Name: final
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu(
        input logic clk,
        input logic reset,
        input logic [3:0]btn,
        output logic [15:0]led 
    );
    logic reset;
    
     
    
    // Busywait signals (1 bit)
    logic busywait_IF_ID = 0;
    logic busywait_ID_EX = 0;
    logic busywait_EX_MEM = 0;
    logic busywait_MEM_WB = 0;
    
    // Addresses and instructions are 32-bit
    logic [31:0] write_addr_WB;
    logic [31:0] instruction_MEM;
    logic [31:0] instruction_EX;
 
    // Signals for IF stage outputs (guessing 32-bit for PC and instruction)
    logic [31:0] PC_IF;
    logic [31:0] instruction_IF;

    // Signals between IF_ID pipe
    logic [31:0] instruction_ID;
    logic [31:0] PC_ID;

    // Signals in ID stage
    logic [31:0] write_data_WB;

    logic reg_write_en_WB; // single bit

    logic [4:0] alu_op_ID;      // guessing 7 bits for ALU op (adjust if different)
    logic [2:0]branch_jump_ID;       // 1 bit
    logic [3:0]read_write_ID;        // 1 bit
    logic [1:0]wb_sel_ID;            // 1 bit
    logic reg_write_en_ID;      // 1 bit

    logic [1:0]data1_sel_ALU_ID;     // 1 bit
    logic [1:0]data2_sel_ALU_ID;     // 1 bit
    logic [1:0]data1_sel_BJ_ID;      // 1 bit
    logic [1:0]data2_sel_BJ_ID;      // 1 bit
    logic data_sel_MEM_ID;      // 1 bit

    logic [31:0] data1_muxout_ID;
    logic [31:0] data2_muxout_ID;

    logic [31:0] immediate_ID;

    // Signals between ID_EX pipe
    logic [31:0] PC_EX;
    logic [31:0] data1_EX;
    logic [31:0] data2_EX;
    logic [31:0] immediate_EX;

    logic [4:0] alu_op_EX;
    logic [2:0]branch_jump_EX;
    logic [3:0]read_write_EX;
    logic [1:0]wb_sel_EX;
    logic reg_write_en_EX;

    logic [1:0]data1_sel_ALU_EX;
    logic [1:0]data2_sel_ALU_EX;
    logic [1:0]data1_sel_BJ_EX;
    logic [1:0]data2_sel_BJ_EX;
    logic data_sel_MEM_EX;

    // EX Stage signals
    logic [31:0] alu_result_EX;
    logic [31:0] D_in_EX;
    logic pc_select;

    // Signals between EX_MEM pipe
    logic [31:0] PC_MEM;
    logic [31:0] alu_result_MEM;
    logic [31:0] immediate_MEM;

    logic [31:0] D_in_MEM;
    logic [3:0]read_write_MEM;
    logic [1:0]wb_sel_MEM;
    logic reg_write_en_MEM;

    logic data_sel_MEM_MEM;

    // MEM Stage signals
    logic [31:0] D_out_MEM;
    logic [31:0] PCadd4_MEM;

    // Signals between MEM_WB pipe
    logic [31:0] instruction_WB;
    logic [31:0] PCadd4_WB;
    logic [31:0] alu_result_WB;
    logic [31:0] immediate_WB;
    logic [31:0] D_out_WB;

    logic [1:0]wb_sel_WB;

    // WB Stage outputs
    

    IF_Stage IF(
        .clk(clk),
        .reset(reset),
        .pc_select(pc_select),
        .alu_result_EX(alu_result_EX),
        .PC_IF(PC_IF),
        .instruction_IF(instruction_IF)
    );

    IF_ID_pipe IF_ID(
        .clk(clk),
        .reset(reset),

        .instruction_in(instruction_IF),
        .PC_in(PC_IF),

        .busywait(busywait_IF_ID),

        .instruction_out(instruction_ID),
        .PC_out(PC_ID)
    );
    
    ID_Stage ID(
        .clk(clk),
        .reset(reset),

        .instruction(instruction_ID),
        .write_data_WB(write_data_WB),
        .write_addr_WB(write_addr_WB[11:7]),
        .reg_write_en_WB(reg_write_en_WB),

        .wb_addr_WB(write_addr_WB[11:7]),
        .mem_addr_MEM(instruction_MEM[11:7]),
        .ex_addr_EX(instruction_EX[11:7]),

        .mux1_output(data1_muxout_ID),
        .mux2_output(data2_muxout_ID),

        .immediate(immediate_ID),

        .alu_op(alu_op_ID),
        .branch_jump(branch_jump_ID),
        .read_write(read_write_ID),
        .wb_sel(wb_sel_ID),
        .reg_write_en(reg_write_en_ID),

        .data1_sel_ALU(data1_sel_ALU_ID),
        .data2_sel_ALU(data2_sel_ALU_ID),
        .data1_sel_BJ(data1_sel_BJ_ID),
        .data2_sel_BJ(data2_sel_BJ_ID),
        .data_sel_MEM(data_sel_MEM_ID)
    );  
    ID_EX_pipe ID_EX(
        .clk(clk),
        .reset(reset),

        .instruction_in(instruction_ID),
        .PC_in(PC_ID),
        .data1_in(data1_muxout_ID),
        .data2_in(data2_muxout_ID),
        .immediate_in(immediate_ID),

        .alu_op_in(alu_op_ID),
        .branch_jump_in(branch_jump_ID),
        .read_write_in(read_write_ID),
        .wb_sel_in(wb_sel_ID),
        .reg_write_en_in(reg_write_en_ID),

        .data1_sel_ALU_in(data1_sel_ALU_ID),
        .data2_sel_ALU_in(data2_sel_ALU_ID),
        .data1_sel_BJ_in(data1_sel_BJ_ID),
        .data2_sel_BJ_in(data2_sel_BJ_ID),
        .data_sel_MEM_in(data_sel_MEM_ID),

        .busywait(busywait_ID_EX),

        .instruction_out(instruction_EX),
        .PC_out(PC_EX),
        .data1_out(data1_EX),
        .data2_out(data2_EX),
        .immediate_out(immediate_EX),

        .alu_op_out(alu_op_EX),
        .branch_jump_out(branch_jump_EX),
        .read_write_out(read_write_EX),
        .wb_sel_out(wb_sel_EX),
        .reg_write_en_out(reg_write_en_EX),

        .data1_sel_ALU_out(data1_sel_ALU_EX),
        .data2_sel_ALU_out(data2_sel_ALU_EX),
        .data1_sel_BJ_out(data1_sel_BJ_EX),
        .data2_sel_BJ_out(data2_sel_BJ_EX),
        .data_sel_MEM_out(data_sel_MEM_EX)
    );

    EX_Stage EX(
        .data1(data1_EX),
        .data2(data2_EX),
        .PC_in(PC_EX),
        .immediate_in(immediate_EX),
        .alu_result_MEM(alu_result_MEM),
        .write_data_WB(write_data_WB),
        
        .alu_op(alu_op_EX),
        .branch_jump(branch_jump_EX),
        
        .data1_sel_ALU(data1_sel_ALU_EX),
        .data2_sel_ALU(data2_sel_ALU_EX),
        .data1_sel_BJ(data1_sel_BJ_EX),
        .data2_sel_BJ(data2_sel_BJ_EX),  // You have data2_sel_BJ(data1_sel_BJ_EX) - double check if typo
        
        .alu_result(alu_result_EX),
        .mux5_output(D_in_EX),
        
        .pc_select(pc_select)
    );

    EX_MEM_pipe EX_MEM(
        .clk(clk),
        .reset(reset),

        .instruction_in(instruction_EX),
        .PC_in(PC_EX),
        .alu_result_in(alu_result_EX),
        .immediate_in(immediate_EX),

        .D_in_in(D_in_EX),
        .read_write_in(read_write_EX),
        .wb_sel_in(wb_sel_EX),
        .reg_write_en_in(reg_write_en_EX),

        .data_sel_MEM_in(data_sel_MEM_EX),

        .busywait(busywait_EX_MEM),

        .data_sel_MEM_out(data_sel_MEM_MEM),

        .instruction_out(instruction_MEM),
        .PC_out(PC_MEM),
        .alu_result_out(alu_result_MEM),
        .immediate_out(immediate_MEM),
        
        .D_in_out(D_in_MEM),
        .read_write_out(read_write_MEM),
        .wb_sel_out(wb_sel_MEM),
        .reg_write_en_out(reg_write_en_MEM)
    );

    MEM_Stage MEM(
        .clk(clk),
        .reset(reset),
        .PC_in(PC_MEM),
        .address(alu_result_MEM),
        .D_in(D_in_MEM),
        .write_data_WB(write_data_WB),
        .data_sel_MEM(data_sel_MEM_MEM),
        .read_write(read_write_MEM),
        .D_out(D_out_MEM),
        .PCadd4(PCadd4_MEM),
        .led(led)
    );

    MEM_WB_pipe MEM_WB(
        .clk(clk),
        .reset(reset),
        .instruction_in(instruction_MEM),
        .PCadd4_in(PCadd4_MEM),
        .alu_result_in(alu_result_MEM),
        .immediate_in(immediate_MEM),
        .D_out_in(D_out_MEM),
        .wb_sel_in(wb_sel_MEM),
        .reg_write_en_in(reg_write_en_MEM),

        .busywait(busywait_MEM_WB),

        .instruction_out(instruction_WB),
        .PCadd4_out(PCadd4_WB),
        .alu_result_out(alu_result_WB),
        .immediate_out(immediate_WB),
        .D_out_out(D_out_WB),
        .wb_sel_out(wb_sel_WB),
        .reg_write_en_out(reg_write_en_WB)
    );

    WB_Stage WB(
        .instruction(instruction_WB),
        .PCadd4(PCadd4_WB),
        .alu_result(alu_result_WB),
        .immediate(immediate_WB),
        .D_out(D_out_WB),
        .wb_sel_out(wb_sel_WB),
        .write_addr_WB(write_addr_WB[11:7]),
        .write_data_WB(write_data_WB)
    );

endmodule
