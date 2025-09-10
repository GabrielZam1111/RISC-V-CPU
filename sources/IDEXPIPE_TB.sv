`timescale 1ns / 1ps


module IDEXPIPE_TB(

    );

    
endmodule


module IDtoEX(
    input clk,
    input reset,
    




);
    ID_Stage ID_TEST(
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
endmodule