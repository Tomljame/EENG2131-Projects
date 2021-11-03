`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2021 02:21:01 PM
// Design Name: 
// Module Name: Lab2_4
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


module Lab2_4 (S, Cout, A, B, Cin);
output S;
output Cout;
input A;
input B;
input Cin;

wire X,Y,Z;
xor #10 (X, A, B);
xor #10 (S, X, Cin);
and #10 (Y, Cin, X);
and #10 (Z, A, B);
or #10 (Cout, Y, Z);

endmodule

module Lab2_4_testbench;

    wire Cout,S;
    reg A,B,Cin;

    Lab2_4 dut(S, Cout, A, B, Cin);
    
    initial begin
    
    A = 1'b0; B = 1'b0; Cin = 1'b0;
    #100;
    A = 1'b0; B = 1'b0; Cin = 1'b1;
    #100;
    A = 1'b0; B = 1'b1; Cin = 1'b0;
    #100;
    A = 1'b0; B = 1'b1; Cin = 1'b1;
    #100;
    A = 1'b1; B = 1'b0; Cin = 1'b0;
    #100;
    A = 1'b1; B = 1'b0; Cin = 1'b1;
    #100
    A = 1'b1; B = 1'b1; Cin = 1'b0;
    #100
    A = 1'b1; B = 1'b1; Cin = 1'b1;
    
    
    
        
        
end
endmodule
