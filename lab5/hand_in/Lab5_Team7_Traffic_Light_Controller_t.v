`timescale 1ns / 1ps
`define CYC 4

module Traffic_Light_controller_t;
    reg clk=1'b1;
    reg rst_n=1'b1;
    reg lr_has_car=1'b0;
    wire [2:0]hw_light, lr_light;
    
    Traffic_Light_Controller t0(clk, rst_n, lr_has_car, hw_light, lr_light);
    
    always #(`CYC/2) clk=~clk;
    //===================test1===================================
    /*
    initial begin
        @(negedge clk) rst_n=1'b0;
        @(negedge clk) rst_n=1'b1;
        @(negedge clk)
        @(negedge clk) lr_has_car=1'b1;
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)        
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)                
        @(negedge clk)$finish;
        */
        //==========================test2=======================================
       initial begin
                @(negedge clk) rst_n=1'b0;
                @(negedge clk) rst_n=1'b1;
                @(negedge clk)
                @(negedge clk) 
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk) 
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)lr_has_car=1'b1;
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)        
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)//lr_has_car=1'b0;
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)   
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)                
                @(negedge clk)$finish;
        
    end
endmodule

module count_num_cycle_t;
    reg clk=1'b1;
    reg rst_n=1'b1;
    parameter num_cycle=5'd5;
    wire done;
    
    count_num_cycle c1(clk, rst_n, num_cycle, done);
    always #(`CYC/2) clk=~clk;
    
    initial begin
        @(negedge clk) rst_n=1'b0;
        @(negedge clk) rst_n=1'b1;
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk) $finish;
         
    end

endmodule
