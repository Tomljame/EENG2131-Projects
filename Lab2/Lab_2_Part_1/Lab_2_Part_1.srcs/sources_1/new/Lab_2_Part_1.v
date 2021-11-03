`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2021 11:55:54 AM
// Design Name: 
// Module Name: Lab_2_Part_1
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


module lab_2_part_1(
    input A,
    input B,
    input C,
    input D,
    output F
    );
    wire X,Y;
    and(X, A, B);
    and(Y, C, D);
    or(F, X, Y);
endmodule

module lab_2_part_1_testbench;

    wire F;
    reg A, B, C, D;
    
    lab_2_part_1   dut(A, B, C, D, F);
    //Lab_2_Part_1   dut2(A, B, C, D, F);
    
    initial begin
        A = 1'b0; B = 1'b0; C = 1'b0; D = 1'b0;
        #10;
        A = 1'b0; B = 1'b0; C = 1'b0; D = 1'b1;
        #10;
        A = 1'b0; B = 1'b0; C = 1'b1; D = 1'b0;
        #10;
        A = 1'b0; B = 1'b0; C = 1'b1; D = 1'b1;
        #10;
        A = 1'b0; B = 1'b1; C = 1'b0; D = 1'b0;
        #10;
        A = 1'b0; B = 1'b1; C = 1'b0; D = 1'b1;
        #10;
        A = 1'b0; B = 1'b1; C = 1'b1; D = 1'b0;
        #10;
        A = 1'b0; B = 1'b1; C = 1'b1; D = 1'b1;
        #10;
        A = 1'b1; B = 1'b0; C = 1'b0; D = 1'b0;
        #10;
        A = 1'b1; B = 1'b0; C = 1'b0; D = 1'b1;
        #10;
        A = 1'b1; B = 1'b0; C = 1'b1; D = 1'b0;
        #10;
        A = 1'b1; B = 1'b0; C = 1'b1; D = 1'b1;
        #10;
        A = 1'b1; B = 1'b1; C = 1'b0; D = 1'b0;
        #10;
        A = 1'b1; B = 1'b1; C = 1'b0; D = 1'b1;
        #10
        A = 1'b1; B = 1'b1; C = 1'b1; D = 1'b0;
        #10
        A = 1'b1; B = 1'b1; C = 1'b1; D = 1'b1;
        
end
endmodule