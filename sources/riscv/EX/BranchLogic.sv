`timescale 1ns / 1ps

module BranchLogic(
        input logic [31:0] data1,
        input logic [31:0] data2,
        input logic [2:0] branch_jump,
        output logic pc_select
);
        logic equal;
        logic u_less_than;
        logic s_less_than;

        assign equal = (data1 ==  data2);

        assign u_less_than = (data1 < data2);
        assign s_less_than = ($signed(data1) < $signed(data2));

        always_comb begin
            case(branch_jump)
                3'b000:pc_select = equal; //BEQ
                3'b001:pc_select = !equal;//BNE
                3'b010:pc_select = 0;     //NO
                3'b011:pc_select = 1;     //J
                3'b100:pc_select = s_less_than; //BLT
                3'b101:pc_select = ~s_less_than; // data1 >= data2 (signed) //BGE
                3'b110:pc_select = ~u_less_than;
                3'b111:pc_select = (equal || !u_less_than);
                default: pc_select = 0;   
         endcase 
        end
        

endmodule