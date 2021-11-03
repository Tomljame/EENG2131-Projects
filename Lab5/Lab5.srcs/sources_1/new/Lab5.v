`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2021 09:46:40 AM
// Design Name: 
// Module Name: Lab5
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

module SevenSegmentFourDigits(clk, bcd0, bcd1, bcd2, bcd3, AN, segN);
  input clk; // Standard 100 MHz clock
  input [3:0] bcd0; // right-most digit
  input [3:0] bcd1;
  input [3:0] bcd2;
  input [3:0] bcd3; // left-most digit
  output [3:0] AN; // digit enable, active low
  output [6:0] segN; // segment enable, active low
  
  reg [3:0] bcd;
  
  DigitController(
        
        .AN(AN),
        .clk(clk)
        
    );
    
  BCDtoSevenSegN(
        
        .bcd(bcd),
        .segN(segN)
        
  );
        
    always @(AN)
        begin
            if (AN == 4'b1110)
            bcd = bcd0;
            else if (AN == 4'b1101)
            bcd = bcd1;
            else if (AN == 4'b1011)
            bcd = bcd2;
            else
            bcd = bcd3;
            
        end
   
endmodule


module SevenSegmentFourDigits_FPGA (clk, sw, an, seg);
    input clk;
    input [15:0] sw;
    output [3:0] an;
    output [6:0] seg;
    
    
    SevenSegmentFourDigits(
            .clk(clk),
            .bcd0(sw[3:0]),
            .bcd1(sw[7:4]),
            .bcd2(sw[11:8]),
            .bcd3(sw[15:12]),
            .AN(an[3:0]),
            .segN(seg[6:0])
            
    );
            
 endmodule            
   
    
            

module BCDtoSevenSegN(bcd,segN);

input [3:0] bcd;
output reg [6:0] segN;

always @(bcd)
 begin
  case (bcd)
   4'b0000 : begin segN = 7'b1000000; end
   4'b0001 : begin segN = 7'b1111001; end
   4'b0010 : begin segN = 7'b0100100; end
   4'b0011 : begin segN = 7'b0110000; end
   4'b0100 : begin segN = 7'b0011001; end
   4'b0101 : begin segN = 7'b0010010; end
   4'b0110 : begin segN = 7'b0000010; end
   4'b0111 : begin segN = 7'b1111000; end
   4'b1000 : begin segN = 7'b0000000; end
   4'b1001 : begin segN = 7'b0010000; end
   default : begin segN = 7'b0000110; end
  endcase
 end
endmodule

module BCDtoSevenSegNTest;

    reg [3:0] bcd;
    wire [6:0] segN;
    
    BCDtoSevenSegN dut (
        .bcd(bcd),
        .segN(segN)
        
    );
    
    initial begin
        
        #20 bcd = 0;
        #20 bcd = 1;
        #20 bcd = 2;
        #20 bcd = 3;
        #20 bcd = 4;
        #20 bcd = 5;
        #20 bcd = 6;
        #20 bcd = 7;
        #20 bcd = 8;
        #20 bcd = 9;
        #20 bcd = 15;
        #40;
    end
    
    initial begin
		 $monitor("bcd=%h,segN=%7b",bcd,segN);
		 end
  
 endmodule       
        
module DigitController(clk, AN);
    parameter numDigits = 4;
    parameter refreshRate_ms = 10;
    input clk; // 100 MHz
    output [numDigits-1:0] AN; // Active low!
    reg [25:0] counter = 0;
    reg [numDigits-1:0] AN = 4'b1110;
    
    always @ (posedge clk) 
    begin
        if (counter > refreshRate_ms/4 * 100000)
        begin
            counter <= 0;
            if (AN == 4'b1110)
            AN <= 4'b1101;
            else if (AN == 4'b1101)
            AN <= 4'b1011;
            else if (AN == 4'b1011)
            AN <= 4'b0111;
            else if (AN == 4'b0111)
            AN <= 4'b1110;
        end
        else
        begin
            counter <= counter + 1;
        end
    end

endmodule

module DigitControllerTest;
    reg clk = 0;
    wire [3:0] AN;
    integer i;
    
    DigitController dut(
        
        .AN(AN),
        .clk(clk)
        
    );
    
    initial begin
        for (i = 0; i<100000000; i = i+1)
            begin
                clk = ~clk;
                #10;
        end
        
    
    
    end
    endmodule
   





