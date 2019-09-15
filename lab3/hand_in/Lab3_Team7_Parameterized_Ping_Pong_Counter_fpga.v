`timescale 1ns/1ps 

module topModule_SwBo7(clk, rst_n, enable, flip, max, min, an, seg7);

    input clk;
	input rst_n;
	input enable;
	input flip;
	input [3 : 0]max;
	input [3 : 0]min;
	
	output [3 : 0]an; 
	output [7 : 1]seg7;

	wire dir;
	wire [4 - 1 : 0]out;
	reg [7 : 1]seg7;
	reg [3 : 0]an;
	
	parameter an3=2'b11;
	parameter an2=2'b10;
	parameter an1=2'b01;
	parameter an0=2'b00;
	
	reg [2 - 1 : 0]an_state;
	reg [2 - 1 : 0]an_next_state;
	
	//clk for numbers to count up and down
	//set to 0.3sec/clk cycle
	wire clk_count;
	
	//clk for the four numbers to display in order
	//set to 1ms/clk cycle
	wire clk_display;
	
	//clk for debounce module 
	//set to 4ms/cycle
	wire clk_onepulse;
	
	wire flip_debounce;
	wire rst_debounce;
	
	wire onepulse_flip;
	wire onepulse_rst;
	
	//set differnet clk
	clk_divider _clk_count(clk/*, rst_n*/,2**24, clk_count);
	clk_divider _clk_display(clk/*, rst_n*/, 2**15, clk_display);
	clk_divider _clk_onepulse(clk/*, rst_n*/, 2**24, clk_onepulse);
	
	//set debounce
	debounce _flip_debounce(flip, clk, flip_debounce);
	debounce _rst_debounce(rst_n, clk, rst_debounce);
	
	//set one pulse
	onepulse _onepulse_flip(flip_debounce, clk_onepulse, onepulse_flip);
	onepulse _onepulse_rst(rst_debounce, clk_onepulse, onepulse_rst);
	
	
	Parameterized_Ping_Pong_Counter p(clk_count, !onepulse_rst, enable, onepulse_flip, max, min, dir, out);
	
	
	always@(posedge clk_display) begin
	    if(onepulse_rst) 
	        an_state <= an3;
	    else
	        an_state<=an_next_state;
	end
	
	always@(*) begin
	    case(an_state) 
		    
			an3: begin
			    if(dir==0) begin
				    seg7[2]=1'b0;
					seg7[1]=1'b0;
					seg7[3]=1'b0;
					seg7[4]=1'b1;
					seg7[5]=1'b1;
					seg7[6]=1'b1;
					seg7[7]=1'b1;
				end
				else begin
				    seg7[2]=1'b1;
					seg7[1]=1'b1;
					seg7[3]=1'b1;
					seg7[4]=1'b1;
					seg7[5]=1'b0;
					seg7[6]=1'b0;
					seg7[7]=1'b0;
				end
				
				an=4'b0111;
				an_next_state=an2;
			end
			
			an2: begin
			    if(dir==0) begin
				    seg7[2]=1'b0;
					seg7[1]=1'b0;
					seg7[3]=1'b0;
					seg7[4]=1'b1;
					seg7[5]=1'b1;
					seg7[6]=1'b1;
					seg7[7]=1'b1;
				end
				else begin
				    seg7[2]=1'b1;
					seg7[1]=1'b1;
					seg7[3]=1'b1;
					seg7[4]=1'b1;
					seg7[5]=1'b0;
					seg7[6]=1'b0;
					seg7[7]=1'b0;
				end
				
				an=4'b1011;
			    an_next_state=an1;
			end
			
			an1: begin
			    if(out==4'd15||out==4'd14||out==4'd13||out==4'd12||
				   out==4'd11||out==4'd10) begin
				    seg7[3]=1'b0;
					seg7[6]=1'b0;
					seg7[1]=1'b1;
					seg7[2]=1'b1;
					seg7[4]=1'b1;
					seg7[5]=1'b1;
					seg7[7]=1'b1;
				end
				else begin
				    seg7[3]=1'b0;
					seg7[6]=1'b0;
					seg7[1]=1'b0;
					seg7[2]=1'b0;
					seg7[4]=1'b1;
					seg7[5]=1'b0;
					seg7[7]=1'b0;
				end
				
				an=4'b1101;
			    an_next_state=an0;
			end
			
			an0: begin
			    if(out==4'd0||out==4'd10) begin
				    seg7[1]=1'b0;
					seg7[2]=1'b0;
					seg7[5]=1'b0;
					seg7[7]=1'b0;
					seg7[6]=1'b0;
					seg7[3]=1'b0;
					seg7[4]=1'b1;
				end
				else if(out==4'd1||out==4'd11) begin
				    seg7[3]=1'b0;
					seg7[6]=1'b0;
					seg7[1]=1'b1;
					seg7[2]=1'b1;
					seg7[4]=1'b1;
					seg7[5]=1'b1;
					seg7[7]=1'b1;
				end
				else if(out==4'd2||out==4'd12) begin
				    seg7[1]=1'b0;
					seg7[3]=1'b0;
					seg7[4]=1'b0;
					seg7[5]=1'b0;
					seg7[7]=1'b0;
					seg7[3]=1'b0;
					seg7[2]=1'b1;
					seg7[6]=1'b1;
				end
				else if(out==4'd3||out==4'd13) begin
				    seg7[1]=1'b0;
					seg7[3]=1'b0;
					seg7[4]=1'b0;
					seg7[6]=1'b0;
					seg7[7]=1'b0;
					seg7[2]=1'b1;
					seg7[5]=1'b1;
				end
				else if(out==4'd4||out==4'd14) begin
				    seg7[2]=1'b0;
					seg7[3]=1'b0;
					seg7[4]=1'b0;
					seg7[6]=1'b0;
					seg7[1]=1'b1;
					seg7[5]=1'b1;
					seg7[7]=1'b1;
				end
				else if(out==4'd5||out==4'd15) begin
				    seg7[1]=1'b0;
					seg7[2]=1'b0;
					seg7[4]=1'b0;
					seg7[6]=1'b0;
					seg7[7]=1'b0;
					seg7[3]=1'b1;
					seg7[5]=1'b1;
				end
				else if(out==4'd6) begin
				    seg7[1]=1'b0;
					seg7[2]=1'b0;
					seg7[4]=1'b0;
					seg7[5]=1'b0;
					seg7[6]=1'b0;
					seg7[7]=1'b0;
					seg7[3]=1'b1;
				end
				else if(out==4'd7) begin
				    seg7[1]=1'b0;
					seg7[2]=1'b0;
					seg7[3]=1'b0;
					seg7[6]=1'b0;
					seg7[4]=1'b1;
					seg7[5]=1'b1;
					seg7[7]=1'b1;
				end
				else if(out==4'd8) begin
				    seg7[1]=1'b0;
					seg7[2]=1'b0;
					seg7[3]=1'b0;
					seg7[4]=1'b0;
					seg7[5]=1'b0;
					seg7[6]=1'b0;
					seg7[7]=1'b0;
				end
				else if(out==4'd9) begin
				    seg7[1]=1'b0;
					seg7[2]=1'b0;
					seg7[3]=1'b0;
					seg7[4]=1'b0;
					seg7[6]=1'b0;
					seg7[5]=1'b1;
					seg7[7]=1'b1;
				end
				
				an=4'b1110;
		        an_next_state=an3;
			end
		endcase
	end
endmodule


module clk_divider(clk_in/*, rst_n*/, divide_by, clk_out);
    
	input clk_in;
	//input rst_n;
	input [28 - 1 : 0]divide_by;  
	output clk_out;
	
	reg clk_out;
	reg clk_out_next;
	reg [28 - 1 : 0]count;
	reg [28 - 1 : 0]count_next;
	

	always@(posedge clk_in) begin
	   /* if(rst_n) begin
		    clk_out<=1'b0;
			count<=28'b0;
		end
		else begin*/
		    clk_out<=clk_out_next;
		    count<=count_next;
		//end
	end
	
	always@(*) begin
	    if(count==divide_by) begin
		    clk_out_next = !clk_out;
			count_next = 28'b0;
		end
		else begin
		    clk_out_next = clk_out;
		    count_next = count + 1'b1;
		end
	end
	
endmodule


module debounce(pb, clk, pb_debounce);
    input pb;
	input clk;
	output pb_debounce;
	
	reg [3:0]DFF;
	
	
	always@(posedge clk) begin
	    DFF[0] <= pb;
		DFF[3 : 1] <= DFF[2 : 0];
	end
	
	assign pb_debounce = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
	
endmodule


module onepulse(pb, clk, pb_one_pulse);
    input pb;
	input clk;
	output pb_one_pulse;
	

	reg pb_delay;
	reg pb_one_pulse;

	always@(posedge clk) begin
	    pb_delay <= pb;
		pb_one_pulse <= pb & (!pb_delay);
	end
	
	
endmodule


module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
    input clk, rst_n;
    input enable;
    input flip;
    input [4-1:0] max;
    input [4-1:0] min;
    output direction;
    output [4-1:0] out;

    reg [4-1:0] num, next_num;
    reg dir, next_dir;
	


    always@(posedge clk) begin
        if(!rst_n)begin
            num <= min;
            dir <= 1'b0;
        end
        else begin
            num <= next_num;
            dir <= next_dir;
        end
    end

    always @(*)begin
        /*if(flip)begin
            if(num <= max)begin
                if(num >= min)begin
                    next_dir = ~dir;
                end
                else begin
                    next_dir = dir;
                end
            end
            else begin
			
                next_dir = dir;
            end
        end
        else begin
            next_dir = dir;
        end*/

        if(enable)begin
            if (max > min && num <= max && num >= min) begin
				if(!flip)begin
					if(dir == 1'b0)begin
						if (num == max) begin
							next_num = num - 4'd1;
							next_dir = ~dir;
						end
						else begin
							next_num = num + 4'd1;
							next_dir = dir;
						end
					end
					else begin
						if(num == min)begin
							next_num = num + 4'd1;
							next_dir = ~dir;
						end
						else begin
							next_num = num - 4'd1;
							next_dir = dir;
						end
					end
				end
                else begin
					if(dir == 1'b0)begin
						next_num = num - 4'b1;
						next_dir = ~dir;
					end
					else begin
						next_num = num + 4'b1;
						next_dir = ~dir;
					end
				end
            end
            else begin
                next_num = num;
				next_dir = dir;
            end
        end
        else begin
            next_num = num;
			next_dir = dir;
        end
    end

    assign out = num;
    assign direction = dir;

endmodule
