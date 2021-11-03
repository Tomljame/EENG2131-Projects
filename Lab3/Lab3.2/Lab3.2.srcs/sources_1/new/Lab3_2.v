`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 09:40:49 PM
// Design Name: 
// Module Name: Lab3_2
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


module Lab3_2(
    input clk,
    output led0,
    output led1,
    output led2,
    output led3
    );

reg [31:0] counter;
reg LED_status0;
reg LED_status1;
reg LED_status2;
reg LED_status3;

initial begin
counter <= 32'b0;
LED_status0 <= 1'b0;
LED_status1 <= 1'b0;
LED_status2 <= 1'b0;
LED_status3 <= 1'b0;

end

always @ (posedge clk) 
begin
counter <= counter + 1'b1;
if (counter > 100000000)
begin
LED_status0 <= !LED_status0;
counter <= 32'b0;

if (counter > 25000000)
begin
LED_status1 <= !LED_status1;
counter <= 32'b0;

if (counter > 20000000)
begin
LED_status2 <= !LED_status2;
counter <= 32'b0;

if (counter > 3703703)
begin
LED_status3 <= !LED_status3;
counter <= 32'b0;
end
end
end
end
end

assign led0 = LED_status0;
assign led1 = LED_status1;
assign led2 = LED_status2;
assign led3 = LED_status3;

endmodule


