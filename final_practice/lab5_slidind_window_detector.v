`timescale 1ns/1ps

module Sliding_Window_Detector (clk, rst_n, in, dec1, dec2);
    input clk, rst_n;
    input in;
    output dec1, dec2;

    reg [2:0] state1, state2, next_state1, next_state2;
    reg [1:0] counter, next_counter;
    reg dec1, dec2;
    reg has_111;

    parameter [3:0] _S0 = 4'd0;
    parameter [3:0] _S1 = 4'd1;
    parameter [3:0] _S2 = 4'd2;

    parameter [3:0] S0 = 4'd3;
    parameter [3:0] S1 = 4'd4;
    parameter [3:0] S2 = 4'd5;
    parameter [3:0] S3 = 4'd6;
    parameter [3:0] S4 = 4'd7;
    
    always@(posedge clk)begin
        if(!rst_n)begin
            state1 <= _S0;
            state2 <= S0;
            counter <= 1;
        end
        else begin
            state1 <= next_state1;
            state2 <= next_state2;
            counter <= next_counter;
        end
    end

    always@(*)begin
        case(state1)
            _S0:begin
                if(in == 0)begin
                    next_state1 = _S0;
                    next_counter = 0;
                    dec1 = 0;
                end
                else begin
                    next_state1 = _S1;
                    dec1 = 0;
                    next_counter = counter + 1;
                    if(counter == 2'd3)begin
                        has_111 = 1;
                    end
                end
            end
            _S1:begin
                if(in == 0)begin
                    next_state1 = _S2;
                    next_counter = 0;
                    dec1 = 0;
                end
                else begin
                    next_state1 = _S1;
                    dec1 = 0;
                    next_counter = counter + 1;
                    if(counter == 2'd3)begin
                        has_111 = 1;
                    end
                end
            end
            _S2:begin
                if(in == 0)begin
                    next_state1 = _S0;
                    next_counter = 0;
                    dec1 = 0;
                end
                else begin
                    next_state1 = _S1;
                    next_counter = counter + 1;

                    if(counter == 2'd3)begin
                        has_111 = 1;
                    end

                    if(has_111)begin
                        dec1 = 0;
                    end
                    else begin
                        dec1 = 1;
                    end
                end
            end
        endcase
    end

    always@(*)begin
        case(state2)
            S0:begin
                if(in == 0)begin
                    next_state2 = S1;
                    dec2 = 0;
                end
                else begin
                    next_state2 = S0;
                    dec2 = 0;
                end
            end
            S1:begin
                if(in == 0)begin
                    next_state2 = S1;
                    dec2 = 0;
                end
                else begin  
                    next_state2 = S2;
                    dec2 = 0;
                end
            end
            S2:begin
                if(in == 0)begin
                    next_state2 = S1;
                    dec2 = 0;
                end
                else begin
                    next_state2 = S3;
                    dec2 = 0;
                end
            end
            S3:begin
                if(in == 0)begin
                    next_state2 = S4;
                    dec2 = 1;
                end
                else begin
                    next_state2 = S0;
                    dec2 = 0;
                end
            end
            S4:begin
                if(in == 0)begin
                    next_state2 = S1;
                    dec2 = 0;
                end
                else begin
                    next_state2 = S2;
                    dec2 = 0;
                end
            end
        endcase
    end

endmodule