`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
	input clk, rst_n;
	input enable;
	output direction;
	output [4-1:0] out;

    reg [3:0] num;
    reg dir;
    reg [3:0] next_num;
    reg next_dir;

	always @(posedge clk) begin
        if(!rst_n)begin
            num <= 4'd0;
            dir <= 1'b0;
        end
        else begin
            num <= next_num;
            dir <= next_dir;
        end
    end

    always @(*) begin
        if (enable) begin
            //$display("##1##");
            if(dir == 1'b0)begin
                //$display("##2##");
                if (num < 4'd15) begin
                    next_num = num + 4'd1;
                end
                else if (num == 4'd15) begin
                    next_num = num - 4'd1;
                    next_dir = 1'b1;
                end
            end
            else if(dir == 1'b1)begin
                if (num > 4'd0)begin
                    next_num = num - 4'd1;
                end
                else if (num == 4'd0) begin
                    next_num = num + 4'd1;
                    next_dir = 1'b0;
                end
            end
        end
        else begin
            next_num = num;
            next_dir = dir;
        end
    end

    assign direction = dir;
    assign out = num;
    
endmodule