`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
	input clk, rst_n;
	input enable;
	output direction;
	output [4-1:0] out;

	reg [3:0] result;
	reg [3:0] expression;
	reg dir;

	parameter max_value = 4'b1111;
	parameter min_value = 4'b0000;

	assign out = result;
	always@(*) begin
		if(dir==0)begin
			if(result == 4'd15)begin
				expression = 4'd14;
			end
			else begin
				expression = result+1'b1;
			end
		end
		else begin
			if(result == 4'd0) begin
				expression = 4'd1;
			end
			else begin
				expression = result - 1'b1;
			end
		end
	end
	//assign expression = (!dir) ? (result + 1'b1) : (result - 1'b1);
    assign direction = dir;
	always@(posedge clk ) begin
		if(rst_n != 1'b0)begin
			if(enable)begin
				result <= expression;
				if(result == max_value ) begin
					dir <= 1'b1;
				end
				else if(result == min_value )begin
					dir <= 1'b0;
				end
			end
		end
		else begin
			result <= 4'b0000;
			dir <= 1'b0;
		end
	end 

    
endmodule