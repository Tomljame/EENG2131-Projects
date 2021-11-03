`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2021 11:12:15 PM
// Design Name: 
// Module Name: Lab2_5
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

module MultibitAdder(a,b,cin,sum,cout);
input [3:0] a,b;
input cin;
output [3:0]sum;
output cout;
assign {cout,sum}=a+b+cin;
endmodule


module TestModule;
// Inputs
reg [3:0] a;
reg [3:0] b;
reg cin;

// Outputs
wire [3:0] sum;
wire cout;


// Instantiate the Unit Under Test (UUT)
MultibitAdder uut (
.a(a),
.b(b),
.cin(cin),
.sum(sum),
.cout(cout)
);

initial begin
// Initialize Inputs
a = 0;
b = 0;
cin = 0;

#100;

a = 4'b0010;
b = 4'b0001;
cin = 1;

#100;

end
endmodule
