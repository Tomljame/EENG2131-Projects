`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2021 09:47:48 PM
// Design Name: 
// Module Name: Lab3_3
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
module full_adder(
    output S,Co,
    input A,B,Cin
    );
assign {S,Co} = A + B + Cin ;

endmodule

module ripple_adder_4bit(

input Cin,
input [8:0] sw,
output [15:11] led,
output Co,
output [3:0] S



    );
         
wire [3:0] A, B;
wire c1,c2,c3;


assign Cin = sw[0];
assign A = sw[4:1];
assign B = sw[8:5];
assign Co = led[15];
assign S = led[14:11];

full_adder FA1(S[0],c1,A[0],B[0],Cin);
full_adder FA2(S[1],c2,A[1],B[1],c1);
full_adder FA3(S[2],c3,A[2],B[2],c2);
full_adder FA4(S[3],Co,A[3],B[3],c3);

endmodule