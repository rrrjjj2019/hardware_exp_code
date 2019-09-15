`timescale 1ns/1ps 

module fpga(clk, max, min, enable, flip, reset, out, AN);
    input [3:0] max, min;
    input enable, flip, reset, clk;
    output [0:6] out;
    output [3:0] AN;
    /*output divided_clk;
    output onepluse_reset;
    output debounced_reset;*/

    wire divided_clk_count;
    wire divided_clk_display;
    wire divided_clk_onepluse;

    //debounce
    wire debounced_flip, debounced_reset;
    //reg flip;

    //onepluse
    wire onepluse_flip, onepluse_reset;
    
    //Parameterized_Ping_Pong_Counter
    //reg [3:0] max, min;
    //reg enable;
    wire [3:0] num;
    wire dir;

    //mux
    reg [1:0] sel, next_sel;
    reg [3:0] AN;
    reg [0:6] out;
    

    /*clock_divider cd(
        .clk(clk),
        .o_clk(divided_clk)
    );*/

    clock_divider #(2**25)_clk_count(clk, divided_clk_count);
    clock_divider #(2**25)_clk_onepluse(clk, divided_clk_onepluse);
    clock_divider #(2**15)_clk_display(clk, divided_clk_display);

    debounce deb_flip(
        .pb_debounced(debounced_flip),
        .pb(flip),
        .clk(clk)
    );

    debounce deb_reset(
        .pb_debounced(debounced_reset),
        .pb(reset),
        .clk(clk)
    );

    onepulse one_flip(
        .pb_debounced(debounced_flip),
        .clk(divided_clk_onepluse),
        .pb_one_pluse(onepluse_flip)
    );

    onepulse one_reset(
        .pb_debounced(debounced_reset),
        .clk(divided_clk_onepluse),
        .pb_one_pluse(onepluse_reset)
    );

    Parameterized_Ping_Pong_Counter pppc(
        .clk(divided_clk_count),
        .rst_n(!onepluse_reset),
        .enable(enable),
        .flip(onepluse_flip),  //?
        .max(max),
        .min(min),
        .direction(dir),
        .out(num)
    );

    always@(posedge divided_clk_display)begin
        if(onepluse_reset)begin  //!
            //$display("sel = 0");
            sel <= 2'd0;
        end
        else begin
            //$display("sel <= next_sel, sel = %d", sel);
            sel <= next_sel;
        end
    end

    always @(*) begin
        if(sel == 2'd0)begin
            next_sel = sel + 4'd1;
            AN = 4'b1110;
            if(num == 4'b0000 || num == 4'b1010)begin
                out = 7'b0000001; //0
            end
            else if(num == 4'b0001 || num == 4'b1011)begin
                out = 7'b1001111; //1
            end
            else if(num == 4'b0010 || num == 4'b1100)begin
                out = 7'b0010010; //2
            end
            else if(num == 4'b0011 || num == 4'b1101)begin
                out = 7'b0000110; //3
            end
            else if(num == 4'b0100 || num == 4'b1110)begin
                out = 7'b1001100; //4
            end
            else if(num == 4'b0101 || num == 4'b1111)begin
                out = 7'b0100100; //5
            end
            else if(num == 4'b0110) begin
                out = 7'b0100000; //6
            end
            else if(num == 4'b0111)begin
                out = 7'b0001111; //7
            end
            else if(num == 4'b1000)begin
                out = 7'b00000000; //8
            end
            else if(num == 4'b1001)begin
                out = 7'b0000100; //9
            end
        end
        else if (sel == 2'd1) begin
            next_sel = sel + 4'd1;
            AN = 4'b1101;
            if(num <= 4'b1001)begin
                out = 7'b0000001;
            end
            else begin
                out = 7'b1001111;
            end
        end
        else if (sel == 2'd2) begin
            next_sel = sel + 4'd1;
            AN = 4'b1011;
            if(dir == 1'b0)begin
                out = 7'b0011101;
            end
            else begin
                out = 7'b1100011;
            end
        end
        else if (sel == 2'd3) begin
            next_sel = 4'd0;
            AN = 4'b0111;
            if(dir == 1'b0)begin
                out = 7'b0011101;
            end
            else begin
                out = 7'b1100011;
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
            //$display("counter_p = %d", counter_p);
        end
    end

    always @(posedge clk) begin
       if(counter_p < (N>>1))begin
            //$display("clk_p <= 1");
            clk_p <= 1;
        end
        else begin
            //$display("clk_p <= 0");
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
