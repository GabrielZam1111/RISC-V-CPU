`timescale 1ns / 1ps

module ControlUnit(
        input logic [6:0]opcode,
        input logic [2:0]funct3,
        input logic [6:0]funct7,
        input logic [4:0]rd,
        input logic [4:0]rs1,
        input logic [4:0]rs2,
        output logic [2:0]imm_sel,
        output logic op1sel,
        output logic op2sel,
        output logic [4:0]alu_op,
        output logic [2:0]branch_jump,
        output logic [3:0]read_write,
        output logic [1:0]wb_sel,
        output logic reg_write_en
);

        logic lui;
        logic auipc;
        logic jal;
        logic jalr;
        logic btype;
        logic itype;
        logic load;
        logic store;
        logic rtype;

        logic alu_op_type,bl;
        logic [2:0]imm_type;

        assign lui    = (opcode[6:2] == 5'b01101); // 0110111
        assign auipc  = (opcode[6:2] == 5'b00101); // 0010111
        assign jal    = (opcode[6:2] == 5'b11011); // 1101111
        assign jalr   = (opcode[6:2] == 5'b11001); // 1100111
        assign btype  = (opcode[6:2] == 5'b11000); // 1100011
        assign load   = (opcode[6:2] == 5'b00000); // 0000011
        assign store  = (opcode[6:2] == 5'b01000); // 0100011
        assign itype  = (opcode[6:2] == 5'b00100); // 0010011
        assign rtype  = (opcode[6:2] == 5'b01100); // 0110011

        assign op1sel = auipc | jal | btype;
        assign op2sel = lui | auipc | jal | jalr | btype | load | store | itype;
        assign reg_write_en = lui| auipc | jal | jalr | load | itype | rtype;
        assign wb_sel = {jal | lui, jal | load};
        assign alu_op_type = itype | rtype;
        assign bl = jal | jalr | btype;
        assign imm_type = {jalr | load | itype, btype | store, jal | btype};

       

        
        assign imm_sel = {imm_type[2],
                          (imm_type[2] & ~load & ~funct3[2] & funct3[1] & funct3[0]) | (~imm_type[2] & imm_type[1] & ~load),
                          (~imm_type[2] & imm_type[0] & ~load) | (imm_type[2] & funct3[0] & (~funct3[2] | ~funct3[1]) & ~load)};

        
        assign alu_op[4:2] = alu_op_type ? funct3[2:0] : 3'b000;
        assign alu_op[1] = alu_op_type & (((imm_sel == 3'b101) | rtype) & funct7[5]);
        assign alu_op[0] = alu_op_type & (((imm_sel == 3'b101) | rtype) & funct7[0]);

      
        assign branch_jump[2] = ~opcode[2] & bl & funct3[2];
        assign branch_jump[1] = opcode[2] | ~bl | funct3[1];
        assign branch_jump[0] = bl & (funct3[0] | opcode[2]);

      
        wire lw = load & ~store;
        wire sw = store & ~load;

        assign read_write[3] = store | load;
        assign read_write[2] = (lw & funct3[2] & ~funct3[1]) | (lw & funct3[2] & funct3[0]) | (sw & ~funct3[2] & ~funct3[1] & funct3[0]) | (sw & ~funct3[2] & funct3[1] & ~funct3[0]);
        assign read_write[1] = (lw & ~funct3[2] & funct3[1] & ~funct3[0]) | (sw & ~funct3[2] & ~funct3[1] & ~funct3[0]) | (sw & ~funct3[2] & ~funct3[1] & funct3[0]) | (sw & ~funct3[2] & funct3[1] & ~funct3[0]);
        assign read_write[0] = (lw & ~funct3[2] & ~funct3[1] & funct3[0]) | (lw & funct3[2] & ~funct3[1] & funct3[0]) | (sw & ~funct3[2] & ~funct3[1] & ~funct3[0]) | (sw & ~funct3[2] & funct3[1] & ~funct3[0]);

        

endmodule