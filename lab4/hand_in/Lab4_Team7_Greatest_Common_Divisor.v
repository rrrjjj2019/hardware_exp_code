`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
    input clk, rst_n;
    input start;
    input [8-1:0] a;
    input [8-1:0] b;
    output done;
    output [8-1:0] gcd;

    parameter WAIT = 2'b00;
    parameter CAL = 2'b01;
    parameter FINISH = 2'b10;

	reg [8-1:0] _a, next_a;
	reg [8-1:0] _b, next_b;
	reg [1:0] state, next_state;
	reg done, next_done;
	reg [8-1:0] gcd, next_gcd;
	
	always@(posedge clk) begin
	    if(rst_n==1'b0) begin
		    //_a<=a;
			//_b<=b;
			state<=WAIT;
			done<=1'b0;
			gcd<=8'b0;
		end
		else begin
		    _a<=next_a;
			_b<=next_b;
			state<=next_state;
			done<=next_done;
			gcd<=next_gcd;
		end
	end
	
	always@(*) begin
	    case(state) 
		    
			WAIT: begin
			    
				next_done=done;
				next_gcd=gcd;
				
			    if(start==1'b1) begin
				    next_a=a;
					next_b=b;
					next_state=CAL;
				end
				else begin
				    next_a=_a;
				    next_b=_b;
				    next_state=WAIT;
				end
			end
			
			CAL: begin
			
			    if(_a==8'b0) begin
				    next_gcd=_b;
                    next_done=1'b1;
					next_state=FINISH;
					next_a=_a;
					next_b=_b;
				end
				
				else begin
				    
					if(_b!=8'b0) begin
					    next_done=done;
						next_gcd=gcd;
						next_state=CAL;
	
					    if(_a>_b) begin
						    next_a=_a-_b;
							next_b=_b;	
						end
						else begin
						    next_b=_b-_a;
						    next_a=_a;
						end
					end
					else begin
					    next_gcd=_a;
						next_done=1'b1;
						next_state=FINISH;
						next_a=_a;
						next_b=_b;
					end
				end
			end
			
			FINISH: begin
			    next_gcd=8'b0;
				next_done=1'b0;
				next_state=WAIT;
				next_a=_a;
				next_b=_b;
			end
			
			/*default: begin
			    next_gcd=8'b0;
				next_done=1'b0;
				next_state=WAIT;
				next_a=_a;
				next_b=_b;
			end*/
		endcase
	end
	
	
endmodule
