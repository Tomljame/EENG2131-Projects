`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2021 01:40:13 PM
// Design Name: 
// Module Name: Lab2_3
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


module Lab2_3 (S, Cout, A, B, Cin);
output S;
output Cout;
input A;
input B;
input Cin;

wire X,Y,Z;
xor(X, A, B);
xor(S, X, Cin);
and(Y, Cin, X);
and(Z, A, B);
or(Cout, Y, Z);

endmodule

module Lab2_3_testbench;

    wire Cout,S;
    reg A,B,Cin;

    Lab2_3 dut(S, Cout, A, B, Cin);
    
    initial begin
    
    A = 1'b0; B = 1'b0; Cin = 1'b0;
    #10;
    A = 1'b0; B = 1'b0; Cin = 1'b1;
    #10;
    A = 1'b0; B = 1'b1; Cin = 1'b0;
    #10;
    A = 1'b0; B = 1'b1; Cin = 1'b1;
    #10;
    A = 1'b1; B = 1'b0; Cin = 1'b0;
    #10;
    A = 1'b1; B = 1'b0; Cin = 1'b1;
    #10
    A = 1'b1; B = 1'b1; Cin = 1'b0;
    #10
    A = 1'b1; B = 1'b1; Cin = 1'b1;
    
    
    
        
        
end
endmodule
