`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
    input clk, rst_n;
    input start;
    input [8-1:0] a;
    input [8-1:0] b;
    output done;
    output [8-1:0] gcd;

    parameter [1:0] wait_state = 2'd0;
    parameter [1:0] calculate_state = 2'd1;
    parameter [1:0] finish_state = 2'd2;

    reg [1:0]state, next_state;
    reg [7:0]_a, next_a;
    reg [7:0]_b, next_b;
    reg [7:0]gcd, next_gcd;
    reg done, next_done;

    always@(posedge clk)begin
        if(!rst_n)begin
            state <= wait_state;
           gcd <= 8'd0;
            done <= 0;
            _a <= 0;
            _b <= 0;
        end
        else begin
            state <= next_state;
            gcd <= next_gcd;
            _a <= next_a;
            _b <= next_b;
            done <= next_done;
        end
    end

    always@(*)begin
        case (state)
            wait_state:begin
                if(start == 1'b1)begin
                    next_state = calculate_state;
                end
                else begin
                    next_state = wait_state;
                end
                next_gcd = 8'd0;
                next_a = a;
                next_b = b;
                next_done = 0;
            end
            calculate_state:begin
                if(_a == 0)begin
                    next_gcd = _b;
                    next_state = finish_state;
                    next_a = _a;
                    next_b = _b;
                    next_done = 1;
                end
                else begin
                    if(_b != 0)begin
                        next_done = 0;
                        next_state = calculate_state;
                        next_gcd = 0;
                        if(a > b)begin
                            next_a = _a - _b;
                            next_b = _b;
                        end
                        else begin
                            next_a = _a;
                            next_b = _b - _a;
                        end
                    end
                    else begin
                        next_gcd = _a;
                        next_state = finish_state;
                        next_a = _a;
                        next_b = _b;
                        next_done = 1;
                    end
                end
            end
            finish_state:begin
                next_done = 0;
                next_state = wait_state;
                next_a = _a;
                next_b = _b;
                next_gcd = 0;
            end
        endcase
    end

endmodule