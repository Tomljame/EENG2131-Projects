`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2021 12:15:56 PM
// Design Name: 
// Module Name: Lab3_1
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


module Lab3_1(
    input clk,
    output led0
    
    );
    
reg [24:0] count = 0;
 
assign led0 = count[24];

always @ (posedge(clk)) count <= count + 1;
    


endmodule
