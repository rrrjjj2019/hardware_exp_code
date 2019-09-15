`timescale 1ns/1ps


module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
    input clk, rst_n;
    input lr_has_car;
    output [3-1:0] hw_light;
    output [3-1:0] lr_light;
    
    reg [2:0]state, next_state;
    reg [3-1:0] hw_light;
    reg [3-1:0] lr_light;
    reg [4:0]num_cycle;
    reg restart_count;
    wire done;
    
    parameter S0=3'b000;
    parameter S1=3'b001;
    parameter S2=3'b010;
    parameter S3=3'b011;
    parameter S4=3'b100;
    parameter S5=3'b101;
    
    parameter RED=3'b100;
    parameter YEL=3'b010;
    parameter GRE=3'b001;
    // instantiate count_num_cycle
    count_num_cycle c0(clk, rst_n, restart_count, num_cycle, done);
    
    always@(posedge clk) begin
        if(!rst_n) state<=S0;
        else       state<=next_state;
    end
    
    always@(*) begin
        case(state)
            S0: {hw_light, lr_light, num_cycle, next_state, restart_count}=
                {GRE, RED, 5'd25, (done==1'b1&&lr_has_car==1'b1)? S1:S0, (done==1'b1&&lr_has_car==1'b1)? 1'b1:1'b0};
            S1: {hw_light, lr_light, num_cycle, next_state, restart_count}=
                {YEL, RED, 5'd5, (done==1'b1)? S2:S1, (done==1'b1)? 1'b1:1'b0};
            S2: {hw_light, lr_light, num_cycle, next_state, restart_count}=
                {RED, RED, 5'b1, (done==1'b1)? S3:S2, (done==1'b1)? 1'b1:1'b0};
            S3: {hw_light, lr_light, num_cycle, next_state, restart_count}=
                {RED, GRE, 5'd25, (done==1'b1)? S4:S3, (done==1'b1)? 1'b1:1'b0};
            S4: {hw_light, lr_light, num_cycle, next_state, restart_count}=
                {RED, YEL, 5'd5, (done==1'b1)? S5:S4, (done==1'b1)? 1'b1:1'b0};
            S5: {hw_light, lr_light, num_cycle, next_state, restart_count}=
                {RED, RED, 5'd1, (done==1'b1)? S0:S5, (done==1'b1)? 1'b1:1'b0};
        endcase
    end
endmodule


module count_num_cycle(clk, rst_n, restart_count, num_cycle, done);
    input clk;
    input rst_n;
    input [4:0]num_cycle;
    input restart_count;
    output done;
    
    reg done;
    reg [4:0]count, next_count;
    
    always@(posedge clk) begin
        if(!rst_n||restart_count)  count<=5'b1;
        else                       count<=next_count;
    end
    
    always@(*) begin
        next_count=(count==num_cycle)? count:count+5'b1;
        done=(count==num_cycle)? 1'b1:1'b0;
    end
    
endmodule
