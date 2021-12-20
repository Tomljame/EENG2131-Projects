`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2021 07:58:49 AM
// Design Name: 
// Module Name: Pong
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

//Main control for pong game
module main(
    input logic clk,
    input logic start,   
    input logic reset,
    input logic bottom_button_l,
    input logic bottom_button_r,
    input logic top_button_l,
    input logic top_button_r,
    input logic start_ball,
    output logic[2:0] rgb, 
    output logic horizontal_sync,
    output logic vertical_sync,
    output a, b, c, d, e, f, g, dp,
                     output [3:0] an  ); 

reg score_checker1;
reg score_checker2;
reg [3:0] player1_score;
reg [3:0] player2_score;
//Setting scores to 0
initial 
                        begin : process_0
                        player1_score = 'b0000;   
                        player2_score = 'b0000;
                        score_checker1 = 0;
                        score_checker2 = 0;
                        end

reg[9:0] x_control;
reg[9:0] y_control;

reg video_on;

reg clk_50;

//50 MHz clock
clk_wiz_0(clk_50, reset, clk);

//Animation module
anim_gen(clk_50, reset, x_control,start_ball, bottom_button_l, bottom_button_r,top_button_l,top_button_r, y_control, video_on, rgb, score_checker1, score_checker2);

//Sync for VGA
sync_mod(clk_50, reset, start, y_control, x_control, horizontal_sync, vertical_sync, video_on);

//Score checker for player 1
always_ff @(posedge clk_50, posedge reset)
begin
    if (player1_score == 9 || reset == 1)
        player1_score <= 0;
    else if (score_checker1 == 1)
        player1_score++;
end

//Score checker for player 2
always_ff @(posedge clk_50, posedge reset)
begin
    if (player2_score == 9 || reset == 1)
        player2_score <= 0;
    else if (score_checker2 == 1)
        player2_score++;
end

//Score module
SevenSegment(clk_50,player1_score,'b0000,'b0000,player2_score,a, b, c, d, e, f, g, dp,an);

endmodule



module anim_gen (
   clk,
   reset,
   x_control,
   stop_ball,
   bottom_button_l,
   bottom_button_r,
   top_button_l,
   top_button_r,
   y_control,
   video_on,
   rgb,
   score1,
   score2);
 

input clk; 
input reset; 
input[9:0] x_control; 
input stop_ball; 
input bottom_button_l; 
input bottom_button_r; 
input top_button_l; 
input top_button_r; 
input[9:0] y_control; 
input video_on; 
output[2:0] rgb; 
output score1; 
output score2; 

reg[2:0] rgb; 
reg score1; 
reg score2; 
reg scoreChecker1; 
reg scoreChecker2; 
reg scorer; 
reg scorerNext; 

// Player 1 Bar
integer topbar_l; 
integer topbar_l_next; 
parameter topbar_t = 20; 
parameter topbar_thickness = 10;
parameter topbar_w = 120;
parameter topbar_v = 10; 
wire display_topbar; 
wire[2:0] rgb_topbar; 

// Player 2 Bar
integer bottombar_l;  
integer bottombar_l_next; 
parameter bottombar_t = 460; 
parameter bottombar_thickness = 10;
parameter bottombar_w = 120; 
parameter bottombar_v = 10; 
wire display_bottombar; 
wire[2:0] rgb_bottombar;

// Pong Ball
integer ball_c_l;
integer ball_c_l_next;
integer ball_c_t; 
integer ball_c_t_next; 
parameter ball_default_c_t = 300; 
parameter ball_default_c_l = 300; 
parameter ball_r = 8;
parameter horizontal_velocity = 3; 
parameter vertical_velocity = 3;
wire display_ball; 
wire[2:0] rgb_ball;

// refresh
integer refresh_reg; 
integer refresh_next; 
parameter refresh_constant = 830000;  
wire refresh_rate; 

// Animating ball
integer horizontal_velocity_reg; 
integer horizontal_velocity_next; 
integer vertical_velocity_reg; 
 
integer vertical_velocity_next; 
wire[9:0] x; 
wire[8:0] y; 

wire[3:0] output_mux; 

reg[2:0] rgb_reg; 

wire[2:0] rgb_next; 

initial
    begin
    vertical_velocity_next = 0;
    vertical_velocity_reg = 0;
    horizontal_velocity_reg = 0;
    ball_c_t_next = 300;
    ball_c_t = 300;
    ball_c_l_next = 300;  
    ball_c_l = 300; 
    bottombar_l_next = 260;
    bottombar_l = 260;
    topbar_l_next = 260;
    topbar_l = 260;
   end
assign x = x_control; 
assign y = y_control; 

// refresh screen

always @(posedge clk)
   begin //: process_1
   refresh_reg <= refresh_next;   
   end

//Refresh operations
assign refresh_next = refresh_reg === refresh_constant ? 0 : 
	refresh_reg + 1; 
assign refresh_rate = refresh_reg === 0 ? 1'b 1 : 
	1'b 0; 

//Reset
always @(posedge clk or posedge reset)
   begin 
   if (reset === 1'b 1) // to reset the game.
      begin
      ball_c_l <= ball_default_c_l;   
      ball_c_t <= ball_default_c_t;   
      bottombar_l <= 260;   
      topbar_l <= 260;   
      horizontal_velocity_reg <= 0;   
      vertical_velocity_reg <= 0;   
      end
   else 
      begin
      horizontal_velocity_reg <= horizontal_velocity_next; 
      vertical_velocity_reg <= vertical_velocity_next; 
      if (stop_ball === 1'b 1) 
         begin
         if (scorer === 1'b 0) 
            begin
            horizontal_velocity_reg <= 3;   
            vertical_velocity_reg <= 3;   
            end
         else 
            begin
            horizontal_velocity_reg <= -3;   
            vertical_velocity_reg <= -3;   
            end
         end
      ball_c_l <= ball_c_l_next; 
      ball_c_t <= ball_c_t_next; 
      bottombar_l <= bottombar_l_next;  
      topbar_l <= topbar_l_next;  
      scorer <= scorerNext;
      end
   end

// Animation for bottom bar
always @(bottombar_l or refresh_rate or bottom_button_r or bottom_button_l)
   begin 
   bottombar_l_next <= bottombar_l;  
   if (refresh_rate === 1'b 1) 
      begin
      if (bottom_button_l === 1'b 1 & bottombar_l > bottombar_v) 
         begin                                                  
         bottombar_l_next <= bottombar_l - bottombar_v;
         end
      else if (bottom_button_r === 1'b 1 & bottombar_l < 639 - bottombar_v - bottombar_w ) 
         begin                                                                             
         bottombar_l_next <= bottombar_l + bottombar_v;  
         end
      else
         begin
         bottombar_l_next <= bottombar_l;   
         end
      end
   end

// Animation for top bar
always @(topbar_l or refresh_rate or top_button_r or top_button_l)
   begin 
   topbar_l_next <= topbar_l;   
   if (refresh_rate === 1'b 1) 
      begin
      if (top_button_l === 1'b 1 & topbar_l > topbar_v)
          begin                                        
         topbar_l_next <= topbar_l - topbar_v;   
         end
      else if (top_button_r === 1'b 1 & topbar_l < 639 - topbar_v - topbar_w ) 
        begin                                                                  
         topbar_l_next <= topbar_l + topbar_v;  
         end
      else
         begin
         topbar_l_next <= topbar_l;   
         end
      end
   end

// Animation for ball
always @(refresh_rate or ball_c_l or ball_c_t or horizontal_velocity_reg or vertical_velocity_reg)
   begin 
   ball_c_l_next <= ball_c_l;   
   ball_c_t_next <= ball_c_t;   
   scorerNext <= scorer;   
   horizontal_velocity_next <= horizontal_velocity_reg;   
   vertical_velocity_next <= vertical_velocity_reg;   
   scoreChecker1 <= 1'b 0; 
   scoreChecker2 <= 1'b 0; 
   if (refresh_rate === 1'b 1) 
      begin
      if (ball_c_l >= bottombar_l & ball_c_l <= bottombar_l +120 & ball_c_t >= bottombar_t - 3 & ball_c_t <= bottombar_t + 5) 
         begin
         vertical_velocity_next <= -vertical_velocity; 
         end
      else if (ball_c_l >= topbar_l & ball_c_l <= topbar_l + 120 & ball_c_t >= topbar_t + 2 & ball_c_t <= topbar_t + 12 ) 
         begin
         vertical_velocity_next <= vertical_velocity;
         end
      if (ball_c_l < 0)
         begin
         horizontal_velocity_next <= horizontal_velocity; 
         end
      else if (ball_c_l > 620 ) 
         begin
         horizontal_velocity_next <= -horizontal_velocity;
         end
      ball_c_l_next <= ball_c_l + horizontal_velocity_reg;
      ball_c_t_next <= ball_c_t + vertical_velocity_reg; 
      if (ball_c_t === 477) 
         begin
         ball_c_l_next <= ball_default_c_l;  
         ball_c_t_next <= ball_default_c_t;  
         horizontal_velocity_next <= 0; 
         vertical_velocity_next <= 0; 
         scorerNext <= 1'b 0;   
         scoreChecker1 <= 1'b 1; 
         end
      else
         begin
         scoreChecker1 <= 1'b 0;   
         end
      if (ball_c_t === 3)
         begin
         ball_c_l_next <= ball_default_c_l; 
         ball_c_t_next <= ball_default_c_t; 
         horizontal_velocity_next <= 0; 
         vertical_velocity_next <= 0; 
         scorerNext <= 1'b 1;   
         scoreChecker2 <= 1'b 1;  
         end
      else
         begin
         scoreChecker2 <= 1'b 0;   
         end
      end
   end

// Bottom bar display
assign display_bottombar = x > bottombar_l & x < bottombar_l + bottombar_w & y > bottombar_t & 
    y < bottombar_t + bottombar_thickness ? 1'b 1 : 
	1'b 0; 
assign rgb_bottombar = 3'b 010; 

// Top bar display
assign display_topbar = x > topbar_l & x < topbar_l + topbar_w & y > topbar_t &
    y < topbar_t + topbar_thickness ? 1'b 1 : 
	1'b 0; 
assign rgb_topbar = 3'b 010; 

// Ball display
assign display_ball = (x - ball_c_l) * (x - ball_c_l) + (y - ball_c_t) * (y - ball_c_t) <= ball_r * ball_r ? 
    1'b 1 : 
	1'b 0; 
assign rgb_ball = 3'b 110;


always @(posedge clk)
   begin 
   rgb_reg <= rgb_next;   
   end

// multiplexer
assign output_mux = {video_on, display_topbar, display_bottombar, display_ball}; 

assign rgb_next = output_mux === 4'b 1000 ? 3'b 000 : 
	output_mux === 4'b 1100 ? rgb_bottombar : 
	output_mux === 4'b 1101 ? rgb_bottombar : 
	output_mux === 4'b 1010 ? rgb_topbar : 
	output_mux === 4'b 1011 ? rgb_topbar : 
	output_mux === 4'b 1001 ? rgb_ball : 
	3'b 000; 
	

// output
assign rgb = rgb_reg; 
assign score1 = scoreChecker1; 
assign score2 = scoreChecker2; 

endmodule 



module sync_mod (
   clk,
   reset,
   start,
   y_control,
   x_control,
   horizontal_scan,
   vertical_scan,
   video_on);
   
   input clk; 
   input reset; 
   input start; 
   output[9:0] y_control; 
   output[9:0] x_control; 
   output horizontal_scan; 
   output vertical_scan; 
   output video_on; 
   
   parameter HR = 640; 
   parameter HFP = 16; 
   parameter HBP = 48; 
   parameter HT = 96;
   parameter VR = 480; 
   parameter VFP = 10; 
   parameter VBP = 33; 


reg[9:0] y_control; 
reg[9:0] x_control; 
reg horizontal_scan; 
reg vertical_scan; 
reg video_on; 
reg[9:0] counter_h; 
reg[9:0] counter_h_next; 
reg[9:0] counter_v; 

reg[9:0] counter_v_next; 
reg counter_mod2; 

//States
reg counter_mod2_next; 
reg horizontal_end; 

// Output buffer
reg vertical_end; 
reg horizontal_scanning_buffer; 
reg horizontal_scanning_buffer_next; 
reg vertical_scanning_buffer; 

// Pixel counter
reg vertical_scanning_buffer_next; 
reg[9:0] x_counter; 
reg[9:0] x_counter_next; 
reg[9:0] y_counter; 

reg[9:0] y_counter_next; 
reg video; 


initial
begin: process_0
   vertical_scanning_buffer_next = 1'b 0;   
   vertical_scanning_buffer = 1'b 0;   
   horizontal_scanning_buffer_next = 1'b 0;   
   horizontal_scanning_buffer = 1'b 0;   
   vertical_end = 1'b 0;   
   horizontal_end = 1'b 0;   
   counter_mod2_next = 1'b 0;   
   counter_mod2 = 1'b 0;   
end


always @(posedge clk or posedge reset)
   begin : process_1
   if (reset === 1'b 1)
      begin
      counter_h <= 0;   
      counter_v <= 0;   
      horizontal_scanning_buffer <= 1'b 0;   
      horizontal_scanning_buffer <= 1'b 0;   
      counter_mod2 <= 1'b 0;   
      end
   else
      begin
      if (start === 1'b 1)
         begin
         counter_h <= counter_h_next;   
         counter_v <= counter_v_next;   
         x_counter <= x_counter_next;   
         y_counter <= y_counter_next;   
         horizontal_scanning_buffer <= horizontal_scanning_buffer_next;   
         vertical_scanning_buffer <= vertical_scanning_buffer_next;   
         counter_mod2 <= counter_mod2_next;   
         end
      end
   end

	//On/Off
	assign video = counter_v >= VBP & counter_v < VBP + 
          VR & counter_h >= HBP & counter_h < 
          HBP + HR ? 1'b 1 : 
        1'b 0; 
    
    always @( counter_mod2 ) 
    counter_mod2_next = ~counter_mod2; 
    
    // Horizontal scanning end
    
    always @( counter_h ) 
    horizontal_end = counter_h === 799 ? 1'b 1 : 
        1'b 0; 
    
    // Vertical scanning end
    
    always @( counter_v ) 
    vertical_end = counter_v === 523 ? 1'b 1 : 
        1'b 0; 
    
    //  Horizontal counter
    
    always @(counter_h or counter_mod2 or horizontal_end)
       begin : process_2
       counter_h_next <= counter_h;   
       if (counter_mod2 === 1'b 1)
          begin
          if (horizontal_end === 1'b 1)
             begin
             counter_h_next <= 0;   
             end
          else
             begin
             counter_h_next <= counter_h + 1;   
             end
          end
       end

always @(counter_v or counter_mod2 or horizontal_end or vertical_end)
   begin : process_3
   counter_v_next <= counter_v;   
   if (counter_mod2 === 1'b 1 & horizontal_end === 1'b 1)
      begin
      if (vertical_end === 1'b 1)
         begin
         counter_v_next <= 0;   
         end
      else
         begin
         counter_v_next <= counter_v + 1;   
         end
      end
   end


always @(x_counter or counter_mod2 or horizontal_end or video)
   begin : process_4
   x_counter_next <= x_counter;   
   if (video === 1'b 1)
      begin
      if (counter_mod2 === 1'b 1)
         begin
         if (x_counter === 639)
            begin
            x_counter_next <= 0;   
            end
         else
            begin
            x_counter_next <= x_counter + 1;   
            end
         end
      end
   else
      begin
      x_counter_next <= 0;   
      end
   end

always @(y_counter or counter_mod2 or horizontal_end or counter_v)
   begin : process_5
   y_counter_next <= y_counter;   
   if (counter_mod2 === 1'b 1 & horizontal_end === 1'b 1)
      begin
      if (counter_v > 32 & counter_v < 512)
         begin
         y_counter_next <= y_counter + 1;   
         end
      else
         begin
         y_counter_next <= 0;   
         end
      end
   end

// Buffer

always @( counter_h ) 
horizontal_scanning_buffer_next = counter_h < 704 ? 1'b 1 : 
	1'b 0; 

always @( counter_v ) 
vertical_scanning_buffer_next = counter_v < 523 ? 1'b 1 : 
	1'b 0; 
 
// outputs
assign y_control = y_counter; 
assign x_control = x_counter; 
assign horizontal_scan = horizontal_scanning_buffer; 
assign vertical_scan = vertical_scanning_buffer; 
assign video_on = video; 
endmodule 



module SevenSegment( input clk,
                 input [3:0] in0, in1, in2, in3,
                 output a, b, c, d, e, f, g, dp, 
                 output [3:0] an   
 );
 
   
    localparam N = 18;
    logic [N-1:0] count = {N{1'b0}}; 
    always@ (posedge clk)
	   count <= count + 1;

    
    logic [3:0]digit_val; 
    logic [3:0]digit_en;  
 
always_comb
     begin
     digit_en = 4'b1111; 
     digit_val = in0; 
 
     case(count[N-1:N-2]) 
    
     2'b00 :  
     begin
         digit_val = in0;
         digit_en = 4'b1110;
     end
    
     2'b01:  
     begin
         digit_val = in1;
         digit_en = 4'b1101;
     end
    
     2'b10:  
     begin
        digit_val = in2;
        digit_en = 4'b1011;
     end
     
     2'b11:  
     begin
         digit_val = in3;
         digit_en = 4'b0111;
     end
  endcase
 end
 


logic [6:0] sseg_LEDs; 
always_comb
 begin 
  sseg_LEDs = 7'b1111111; 
  case(digit_val)
    4'd0 : sseg_LEDs = 7'b1000000; 
    4'd1 : sseg_LEDs = 7'b1111001;
    4'd2 : sseg_LEDs = 7'b0100100;
    4'd3 : sseg_LEDs = 7'b0110000;
    4'd4 : sseg_LEDs = 7'b0011001;
    4'd5 : sseg_LEDs = 7'b0010010; 
    4'd6 : sseg_LEDs = 7'b0000010; 
    4'd7 : sseg_LEDs = 7'b1111000; 
    4'd8 : sseg_LEDs = 7'b0000000; 
    4'd9 : sseg_LEDs = 7'b0010000; 
   default : sseg_LEDs = 7'b0111111; 
  endcase
 end
 
assign an = digit_en; 
assign {g, f, e, d, c, b, a} = sseg_LEDs; 
assign dp = 1'b1; 
 
 
endmodule