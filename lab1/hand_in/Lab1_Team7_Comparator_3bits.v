`timescale 1ns/1ps

module fanout (a, b, fanout_lt, fanout_gt, fanout_eq);
    input  [2:0]a, b;
    output [2:0] fanout_lt, fanout_gt;
    output [9:0] fanout_eq;
    wire a_lt_b, a_gt_b, a_eq_b;
    wire not_a_lt_b, not_a_gt_b, not_a_eq_b;
    
    Comparator_3bits c(a, b, a_lt_b, a_gt_b, a_eq_b);
    
    not not6(not_a_lt_b, a_lt_b);
    not not7(not_a_gt_b, a_gt_b);
    not not8(not_a_eq_b, a_eq_b);
    not not9(fanout_lt[2], fanout_lt[1], fanout_lt[0], not_a_lt_b);
    not not10(fanout_gt[2], fanout_gt[1], fanout_gt[0], not_a_gt_b);
    not not11(fanout_eq[9], fanout_eq[8], fanout_eq[7], fanout_eq[6], fanout_eq[5], 
                  fanout_eq[4], fanout_eq[3], fanout_eq[2], fanout_eq[1], fanout_eq[0], not_a_eq_b);
    

endmodule


module Comparator_3bits (a, b, a_lt_b, a_gt_b, a_eq_b);
    input [3-1:0] a, b;
    output a_lt_b, a_gt_b, a_eq_b;
    
    
     wire not_a2, not_a1, not_a0, not_b2, not_b1, not_b0;
     wire b2_g_a2, b1_g_a1, b0_g_a0;
     wire a2_g_b2, a1_g_b1, a0_g_b0;
     wire nor2, nor1, nor0;
     wire a1_g_b1p, a0_g_b0p;
     wire b1_g_a1p, b0_g_a0p;
     
    
      not not0(not_a2, a[2]);
      not not1(not_a1, a[1]);
      not not2(not_a0, a[0]);
      not not3(not_b2, b[2]);
      not not4(not_b1, b[1]);
      not not5(not_b0, b[0]);
      
      and and0(b2_g_a2, not_a2, b[2]);//0
      and and1(a2_g_b2, not_b2, a[2]);//1
      and and2(b1_g_a1, not_a1, b[1]);//0
      and and3(a1_g_b1, not_b1, a[1]);//1
      and and4(b0_g_a0, not_a0, b[0]);//1
      and and5(a0_g_b0, not_b0, a[0]);//0
      
      nor nor3(nor2, b2_g_a2, a2_g_b2);
      nor nor4(nor1, b1_g_a1, a1_g_b1);
      nor nor5(nor0, b0_g_a0, a0_g_b0);
      
      and and6(a1_g_b1p, a1_g_b1, nor2);
      and and7(a0_g_b0p, nor2, nor1, a0_g_b0);
      and and8(b1_g_a1p, nor2, b1_g_a1);
      and and9(b0_g_a0p, nor2, nor1, b0_g_a0);
      
      or or0(a_lt_b, b2_g_a2, b1_g_a1p, b0_g_a0p);
      or or1(a_gt_b, a2_g_b2, a1_g_b1p, a0_g_b0p);
      
      and and10(a_eq_b, nor2, nor1, nor0);

endmodule
