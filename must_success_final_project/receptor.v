module receptor(input clk, input reset, input rx, output reg [7:0] leds);
    reg [1:0]state, next_state;
    parameter start1 = 3'b000;
    parameter start0 = 3'b001;

    reg control = 0;
    reg done = 0;
    reg [8:0] tmp = 9'b000000000;

    reg [3:0] i = 4'b0000;
    reg [9:0] c = 10'b1111111111;
    reg delay = 0;
    reg [1:0] c2 = 2'b11;
    reg capture = 0;

    always@(posedge clk) begin
        if(c < 868)begin
            c = c + 1;
        end
        else begin
            c = 0;
            delay = ~delay;
        end
    end

    always@(posedge delay)begin
        if(c2 > 1)begin
            c2 = 0;
        end
        else begin
            c2 = c2 + 1;
        end
    end

    always@(c2)begin
        if(c2 == 1)begin
            capture = 1;
        end
        else begin
            capture = 0;
        end
    end

    always@(posedge capture, posedge reset)begin
        if(reset)begin
            state <= start1;
        end
        else begin
            state <= next_state;
        end
    end

    always@(*)begin
        case (state)
            start1:begin
                if(rx == 1 && done == 0)begin
                    control = 0;
                    next_state = start1;
                end
                else if(rx == 0 && done == 0)begin
                    control = 1;
                    next_state = start0;
                end
                else begin
                    control = 0;
                    next_state = start1;
                end
            end
            start0:begin
                if(done == 0)begin
                    control = 1;
                    next_state = start0;
                end
                else begin
                    control = 0;
                    next_state = start1;
                end
            end
            default
                next_state = start1;
        endcase
    end

    always@(posedge capture)begin
        if(control == 1 && done == 0)begin
            tmp <= {rx, tmp[8:1]};
        end
    end

    always@(posedge capture)begin
        if(control)begin 
            if(i >= 9)begin
                i = 0;
                done = 1;
                leds <= tmp[8:1];
            end
            else begin
                i = i + 1;
                done = 0;
            end
        end
        else begin
            done = 0;
        end
    end

endmodule