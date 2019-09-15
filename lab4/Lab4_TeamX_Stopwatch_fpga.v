`timescale 1ns/1ps

module fpga(clk, reset, start, out, AN, dot);
    input clk, reset, start;
    output [0:6] out;
    output [3:0] AN;
    output dot;

    reg [3:0] AN;
    reg [0:6] out;
    reg [1:0] sel, next_sel;
    reg dot;

    wire divided_clk_counter;
    wire divided_clk_display;
    wire divided_clk_onepulse;

    wire debounced_reset, debounced_start;
    wire onepulse_reset0, onepulse_start;
    wire onepulse_reset;

    wire [3:0] minute, float_second;
    wire [5:0] second;

    clock_divider #(10**7)_clk_counter(clk, divided_clk_counter);
    clock_divider #(10**7)_clk_onepulse(clk, divided_clk_onepulse);
    clock_divider #(2**15)_clk_display(clk, divided_clk_display);

    debounce deb_reset(
        .pb_debounced(debounced_reset),
        .pb(reset),
        .clk(clk)
    );

    debounce deb_start(
        .pb_debounced(debounced_start),
        .pb(start),
        .clk(clk)
    );

    onepulse one_reset(
        .pb_debounced(debounced_reset),
        .clk(divided_clk_onepulse),
        .pb_one_pluse(onepulse_reset0)
    );

    assign onepulse_reset = !onepulse_reset0;

    onepulse one_start(
        .pb_debounced(debounced_start),
        .clk(divided_clk_onepulse),
        .pb_one_pluse(onepulse_start)
    );

    counter c(
        .clk(divided_clk_counter),
        .reset(onepulse_reset),
        .start(onepulse_start),
        .minute(minute),
        .second(second),
        .float_second(float_second)
    );

    always@(posedge divided_clk_display)begin
        /*if(!onepulse_reset)begin
            sel <= 2'd0;
        end
        else begin*/
            sel <= next_sel;
        //end
    end

    always@(*)begin
        if(sel == 2'd0)begin
            next_sel = sel + 1;
            AN = 4'b1110;
            dot = 1;
            if(float_second == 4'b0000)begin
                out = 7'b0000001; //0
            end
            else if(float_second == 4'b0001)begin
                out = 7'b1001111; //1
            end
            else if(float_second == 4'b0010)begin
                out = 7'b0010010; //2
            end
            else if(float_second == 4'b0011)begin
                out = 7'b0000110; //3
            end
            else if(float_second == 4'b0100)begin
                out = 7'b1001100; //4
            end
            else if(float_second == 4'b0101)begin
                out = 7'b0100100; //5
            end
            else if(float_second == 4'b0110) begin
                out = 7'b0100000; //6
            end
            else if(float_second == 4'b0111)begin
                out = 7'b0001111; //7
            end
            else if(float_second == 4'b1000)begin
                out = 7'b00000000; //8
            end
            else if(float_second == 4'b1001)begin
                out = 7'b0000100; //9
            end
        end
        else if(sel == 2'd1)begin
            next_sel = sel + 1;
            AN = 4'b1101;
            dot = 0;
            if(second == 6'd0 || second == 6'd10 || second == 6'd20 || second == 6'd30 || second == 6'd40 || second == 6'd50)begin
                out = 7'b0000001; //0
            end
            else if(second == 6'd1 || second == 6'd11 || second == 6'd21 || second == 6'd31 || second == 6'd41 || second == 6'd51)begin
                out = 7'b1001111; //1
            end
            else if(second == 6'd2 || second == 6'd12 || second == 6'd22 || second == 6'd32 || second == 6'd42 || second == 6'd52)begin
                out = 7'b0010010; //2
            end
            else if(second == 6'd3 || second == 6'd13 || second == 6'd23 || second == 6'd33 || second == 6'd43 || second == 6'd53)begin
                out = 7'b0000110; //3
            end
            else if(second == 6'd4 || second == 6'd14 || second == 6'd24 || second == 6'd34 || second == 6'd44 || second == 6'd54)begin
                out = 7'b1001100; //4
            end
            else if(second == 6'd5 || second == 6'd15 || second == 6'd25 || second == 6'd35 || second == 6'd45 || second == 6'd55)begin
                out = 7'b0100100; //5
            end
            else if(second == 6'd6 || second == 6'd16 || second == 6'd26 || second == 6'd36 || second == 6'd46 || second == 6'd56) begin
                out = 7'b0100000; //6
            end
            else if(second == 6'd7 || second == 6'd17 || second == 6'd27 || second == 6'd37 || second == 6'd47 || second == 6'd57)begin
                out = 7'b0001111; //7
            end
            else if(second == 6'd8 || second == 6'd18 || second == 6'd28 || second == 6'd38 || second == 6'd48 || second == 6'd58)begin
                out = 7'b00000000; //8
            end
            else if(second == 6'd9 || second == 6'd19 || second == 6'd29 || second == 6'd39 || second == 6'd49 || second == 6'd59)begin
                out = 7'b0000100; //9
            end
        end
        else if(sel == 2'd2)begin
            next_sel = sel + 1;
            AN = 4'b1011;
            dot = 1;
            if(second >= 6'd0 && second <= 6'd9)begin
                out = 7'b0000001; //0
            end
            else if(second >= 6'd10 && second <= 6'd19)begin
                out = 7'b1001111; //1
            end
            else if(second >= 6'd20 && second <= 6'd29)begin
                out = 7'b0010010; //2
            end
            else if(second >= 6'd30 && second <= 6'd39)begin
                out = 7'b0000110; //3
            end
            else if(second >= 6'd40 && second <= 6'd49)begin
                out = 7'b1001100; //4
            end
            else begin
                out = 7'b0100100; //5
            end
        end
        else begin
            next_sel = 0;
            AN = 4'b0111;
            dot = 1;
            if(minute == 4'b0000)begin
                out = 7'b0000001; //0
            end
            else if(minute == 4'b0001)begin
                out = 7'b1001111; //1
            end
            else if(minute == 4'b0010)begin
                out = 7'b0010010; //2
            end
            else if(minute == 4'b0011)begin
                out = 7'b0000110; //3
            end
            else if(minute == 4'b0100)begin
                out = 7'b1001100; //4
            end
            else if(minute == 4'b0101)begin
                out = 7'b0100100; //5
            end
            else if(minute == 4'b0110)begin
                out = 7'b0100000; //6
            end
            else if(minute == 4'b0111)begin
                out = 7'b0001111; //7
            end
            else if(minute == 4'b1000)begin
                out = 7'b00000000; //8
            end
            else if(minute == 4'b1001)begin
                out = 7'b0000100; //9
            end
        end
    end

endmodule


module debounce(pb_debounced, pb, clk);
    output pb_debounced;
    input pb, clk;

    reg [3:0] DFF;

    always@(posedge clk) begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end

    assign pb_debounced = (DFF == 4'b1111) ? 1'b1 : 1'b0;

endmodule

module onepulse (pb_debounced, clk, pb_one_pluse);
    input pb_debounced, clk;
    output pb_one_pluse;

    reg pb_one_pluse;
    reg pb_debounced_delay;

    always@(posedge clk)begin
        pb_debounced_delay <= pb_debounced;
        pb_one_pluse <= pb_debounced & (!pb_debounced_delay);
    end

endmodule

module clock_divider(clk, o_clk);
    input clk;
    output o_clk;

    parameter N = 8;

    reg clk_p, clk_n;
    reg [30:0] counter_p, counter_n;

    assign o_clk = (N == 1)? clk:
                   (N[0])?(clk_n | clk_p) : clk_p;

    //pos
    always@(posedge clk)begin
        if (counter_p == (N-1) ) begin
            counter_p <= 0;
        end
        else begin
            counter_p <= counter_p + 1;
        end
    end

    always @(posedge clk) begin
       if(counter_p < (N>>1))begin
            clk_p <= 1;
        end
        else begin
            clk_p <= 0;
        end
    end

    //neg
    always@(posedge clk)begin
        if (counter_n == 0 ) begin
            counter_n <= (N-1);
        end
        else begin
            counter_n <= counter_n - 1;
        end
    end

    always @(posedge clk) begin
        if(counter_n > (N>>1))begin
            clk_n <= 1'b1;
        end
        else begin
            clk_n <= 1'b0;
        end
    end

endmodule

module counter(clk, reset, start, minute, second, float_second);
    input clk, reset, start;
    output [3:0] minute, float_second;
    output [5:0] second;

    reg [3:0] minute, next_minute;
    reg [3:0] float_second, next_float_second;
    reg [5:0] second, next_second;
    reg [1:0] state, next_state;

    parameter [1:0] wait_state = 2'b00;
    parameter [1:0] reset_state = 2'b01;
    parameter [1:0] counting_state = 2'b10;


    always@(posedge clk)begin
        if(!reset)begin
            float_second <= 4'd0;
            second <= 6'd0;
            minute <= 4'd0;
            state <= reset_state;
        end
        else begin
            state <= next_state;
            minute <= next_minute;
            second <= next_second;
            float_second <= next_float_second;
        end
    end

    always@(*)begin
        case (state)
            reset_state:begin
                next_minute = minute;
                next_float_second = float_second;
                next_second = second;
                next_state = wait_state;
            end
            wait_state:begin
                if(start)begin
                    next_state = counting_state;
                end
                else begin
                    next_state = wait_state;
                end
                next_minute = minute;
                next_float_second = float_second;
                next_second = second;
            end
            counting_state:begin
                if(float_second == 4'd9)begin
                    next_float_second = 0;
                    if(second == 6'd59)begin
                        next_second = 0;
                        if(minute == 4'd9)begin
                            next_minute = 0;
                            next_state = wait_state;
                        end
                        else begin
                            next_minute = minute + 1;
                            next_state = counting_state;
                        end
                    end
                    else begin
                        next_second = second + 1;
                        next_minute = minute;
                        next_state = counting_state;
                    end
                end
                else begin
                    next_float_second = float_second + 1;
                    next_second = second;
                    next_minute = minute;
                    next_state = counting_state;
                end
            end
        endcase
    end

endmodule