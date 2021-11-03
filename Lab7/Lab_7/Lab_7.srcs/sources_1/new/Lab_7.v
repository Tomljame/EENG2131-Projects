`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2021 11:42:11 AM
// Design Name: 
// Module Name: Lab_7
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


module adder4bit(
    input[3:0] x,
    input[3:0] y,
    input ci,
    output [3:0] s,
    output co
    
    );
    
    assign {co,s} = x + y + ci;
    
endmodule

module adder4bit_tb();
    reg [3:0] x;
    reg [3:0] y;
    reg ci;
    wire [3:0] s;
    wire co;
    
    adder4bit dut(x, y, ci, s, co);
    
    reg clk;
    integer vectornum, errors;
    reg [13:0] testvectors [999:0];
    reg expected_co;
    reg [3:0] expected_s;

    //set up testbench clock
    always begin
        clk = 0; #10; clk = 1; #10;
    end    
    
    
    //load test vectors
    initial begin
        $readmemb("C:/Users/tomjamf/Lab_7/Lab_7.srcs/sources_1/imports/Downloads/testvectors.txt", testvectors);
        vectornum = 0;
        errors = 0;
    end
    
    //apply next test vector at clock negedge
    always @(negedge clk) begin
        {x, y, ci, expected_co, expected_s} = testvectors[vectornum];
    end
    
    //check output
    always @(posedge clk) begin
    
        //check output
        if ({co, s} !== {expected_co, expected_s}) begin
            $display("Error! %d + %d + %d -> %d, expecting %d",
                x, y, ci, {co, s}, {expected_co, expected_s});
            errors = errors + 1; 
        end
      
        
        //increment vectornum
        vectornum = vectornum + 1;
        //check for end condition
        if (testvectors[vectornum] === 14'bx) begin
            $display("Done! %d tests completed with %d errors.",
            vectornum, errors);
            $finish;
        end
    end    
        
    
    
endmodule