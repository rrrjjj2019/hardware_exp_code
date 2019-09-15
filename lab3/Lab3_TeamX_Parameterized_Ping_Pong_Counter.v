`timescale 1ns/1ps 

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
        if(enable)begin
            if (max > min && num <= max && num >= min) begin
                    if(!flip)begin
                        if(dir == 1'b0)begin
                            if(num == max)begin
                                next_num = num - 4'd1;
                                next_dir = ~dir;
                            end
                            else begin
                                next_num = num + 4'd1;
                                next_dir = dir;
                            end
                        end
                        else begin
                            if (num == min) begin
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
                        next_dir = ~dir;
                        if(dir == 1'b0)begin
                            next_num = num - 4'd1;
                        end
                        else begin
                            next_num = num + 4'd1;
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
