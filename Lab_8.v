`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 11:52:23 AM
// Design Name: 
// Module Name: Lab_8
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

module VGA_FPGA(
input clk,
output Hsync,
output Vsync,
output [3:0] vgaRed,
output [3:0] vgaGreen,
output [3:0] vgaBlue
);
wire pixelClk;
wire [9:0] Hcount;
wire [9:0] Vcount;
wire DE;

PixelClock dut(clk, pixelClk);
SyncSignals iut(pixelClk, 1, Hcount, Vcount, Hsync, Vsync, DE);

//assign vgaRed = (DE)? (4'b1010): (0);
//assign vgaBlue = (DE)? (4'b1010): (0);
//assign vgaGreen = (DE)? (4'b1010): (0);
assign vgaRed = (DE)? (sw


endmodule

module PixelClock(
input clk,
output reg pixelClk

    );
    
reg [27:0] counter = 28'd0;
parameter DIVISOR = 28'd4;
    
    always @(posedge clk)
    begin
    counter <= counter + 28'd1;
    if(counter >= (DIVISOR-1))
    counter <= 28'd0;
    pixelClk <= (counter<DIVISOR/2)?1'b1:1'b0;
 
end
endmodule

module PixelClock_tb;
reg clk;
wire pixelClk;

    PixelClock dut(
    .clk(clk),
    .pixelClk(pixelClk)
    
    );
    
        initial
        begin
        clk = 0;
        forever #10 clk <= ~clk;
        
        end
endmodule




module SyncSignals(
    input wire pixelClk,
    input wire rst,
    output reg [9:0] Hcount,
    output reg [9:0] Vcount,
    output reg HSYNC,
    output reg VSYNC,
    output reg DE
    );
    
    // horizontal timings
    parameter HA_END = 639;           // end of active pixels
    parameter HS_STA = HA_END + 16;   // sync starts after front porch
    parameter HS_END = HS_STA + 96;   // sync ends
    parameter LINE   = 799;           // last pixel on line (after back porch)

    // vertical timings
    parameter VA_END = 479;           // end of active pixels
    parameter VS_STA = VA_END + 10;   // sync starts after front porch
    parameter VS_END = VS_STA + 2;    // sync ends
    parameter SCREEN = 524;           // last line on screen (after back porch)

    initial begin
        HSYNC = ~(Hcount >= HS_STA && Hcount < HS_END);  // invert: negative polarity
        VSYNC = ~(Vcount >= VS_STA && Vcount < VS_END);  // invert: negative polarity
        DE = (Hcount <= HA_END && Vcount <= VA_END);
    end

    // calculate horizontal and vertical screen position
    always @(posedge pixelClk) begin
        if (Hcount == LINE) begin  // last pixel on line?
            Hcount <= 0;
            Vcount <= (Vcount == SCREEN) ? 0 : Vcount + 1;  // last line on screen?
        end else begin
            Hcount <= Hcount + 1;
        end
        if (rst) begin
            Hcount <= 0;
            Vcount <= 0;
        end
    end
endmodule

    





