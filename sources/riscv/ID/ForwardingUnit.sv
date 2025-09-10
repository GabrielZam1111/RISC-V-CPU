module ForwardingUnit (
    input  logic [6:0] opcode,
    input  logic [4:0] addr1,
    input  logic [4:0] addr2,
    input  logic [4:0] ex_addr,
    input  logic [4:0] mem_addr,
    input  logic [4:0] wb_addr,
    input  logic       op1sel,
    input  logic       op2sel,
    output logic [1:0] data1_sel_ALU,
    output logic [1:0] data2_sel_ALU,
    output logic [1:0] data1_sel_BJ,
    output logic [1:0] data2_sel_BJ,
    output logic       data1_sel_ID,
    output logic       data2_sel_ID,
    output logic       data_sel_MEM
);

   
    logic JALR, LOAD, STORE, I_TYPE, R_TYPE, INST_MASK;
    assign JALR      = (opcode == 7'b1100111);
    assign LOAD      = (opcode == 7'b0000011);
    assign STORE     = (opcode == 7'b0100011);
    assign I_TYPE    = (opcode == 7'b0010011);
    assign R_TYPE    = (opcode == 7'b0110011);
    assign INST_MASK = JALR | LOAD | STORE | I_TYPE | R_TYPE;

    
    logic WB_EXE_BJ_DATA1, MEM_EXE_BJ_DATA1, WB_EXE_BJ_DATA2, MEM_EXE_BJ_DATA2, WB_ID_BJ_DATA1, WB_ID_BJ_DATA2;
    assign WB_EXE_BJ_DATA1  = (mem_addr == addr1);
    assign MEM_EXE_BJ_DATA1 = (ex_addr == addr1);
    assign WB_EXE_BJ_DATA2  = (mem_addr == addr2);
    assign MEM_EXE_BJ_DATA2 = (ex_addr == addr2);
    assign WB_ID_BJ_DATA1   = (wb_addr == addr1);
    assign WB_ID_BJ_DATA2   = (wb_addr == addr2);

    
    logic WB_EXE_ALU_DATA1, MEM_EXE_ALU_DATA1;
    assign WB_EXE_ALU_DATA1  = WB_EXE_BJ_DATA1  & INST_MASK;
    assign MEM_EXE_ALU_DATA1 = MEM_EXE_BJ_DATA1 & INST_MASK;
    assign data1_sel_ALU[1]  = WB_EXE_ALU_DATA1 | MEM_EXE_ALU_DATA1;
    assign data1_sel_ALU[0]  = (op1sel & ~WB_EXE_ALU_DATA1) | MEM_EXE_ALU_DATA1;

    
    assign data1_sel_BJ[1] = WB_EXE_BJ_DATA1 | MEM_EXE_BJ_DATA1;
    assign data1_sel_BJ[0] = (op1sel & ~WB_EXE_BJ_DATA1) | MEM_EXE_BJ_DATA1;

    
    logic WB_EXE_ALU_DATA2, MEM_EXE_ALU_DATA2;
    assign WB_EXE_ALU_DATA2  = WB_EXE_BJ_DATA2  & R_TYPE;
    assign MEM_EXE_ALU_DATA2 = MEM_EXE_BJ_DATA2 & R_TYPE;
    assign data2_sel_ALU[1]  = WB_EXE_ALU_DATA2 | MEM_EXE_ALU_DATA2;
    assign data2_sel_ALU[0]  = (op2sel & ~WB_EXE_ALU_DATA2) | MEM_EXE_ALU_DATA2;

    
    assign data2_sel_BJ[1] = WB_EXE_BJ_DATA2 | MEM_EXE_BJ_DATA2;
    assign data2_sel_BJ[0] = (op2sel & ~WB_EXE_BJ_DATA2) | MEM_EXE_BJ_DATA2;

    
    assign data1_sel_ID = WB_ID_BJ_DATA1;
    assign data2_sel_ID = WB_ID_BJ_DATA2;

    
    assign data_sel_MEM = MEM_EXE_BJ_DATA2;

endmodule
