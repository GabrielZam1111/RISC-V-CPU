`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2025 04:07:47 PM
// Design Name: 
// Module Name: CPU_TB
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


module CPU_TB(
    );
    reg clk;
    reg reset;
    cpu uut(
        .clk(clk),
        .reset(reset)
    );
    
    always #5 clk = !clk;
    
    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, uut); // Dumps all signals in the cpu instance
        clk = 0;
        #10;
        reset = 1;
        #1;
        reset = 0;
        #100
        ;
        $finish;
    end 
endmodule
