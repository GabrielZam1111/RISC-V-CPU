module IF_ID_pipe(
    input logic clk, reset,
    input logic [31:0] instruction_in,
    input logic [31:0] PC_in,
    input logic busywait,
    output logic [31:0] instruction_out,
    output logic [31:0] PC_out
);


    typedef struct packed {
        logic [31:0] instruction;
        logic [31:0] PC;
    }pipe_reg_t;

    pipe_reg_t pipe_reg, pipe_reg_next;

    always_comb begin
        pipe_reg_next = pipe_reg;
        if (reset) begin
            pipe_reg_next = '0;
        end else if (!busywait) begin
            pipe_reg_next.instruction = instruction_in;
            pipe_reg_next.PC = PC_in;
        end
    end

    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            pipe_reg <= '0;
        end else begin
            pipe_reg <= pipe_reg_next;
        end

    
    assign instruction_out = pipe_reg.instruction;
    assign PC_out = pipe_reg.PC;

endmodule