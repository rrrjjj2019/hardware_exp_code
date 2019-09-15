`timescale 1ns/1ps

module mux_1bit(a, b, sel, f);
    input a, b;
    input sel;
    output f;
    
    wire wire_not_sel;
    wire wire_a, wire_b;
    
    not not1(wire_not_sel, sel);
    
    and and0(wire_a, a, sel);
    and and00(wire_b, b, wire_not_sel);
    or or0(f, wire_a, wire_b);
    
endmodule

module Mux_8bits (a, b, sel, f);
    input [8-1:0] a, b;
    input sel;
    output [8-1:0] f;
    
    mux_1bit mux0(a[0], b[0], sel, f[0]);
    mux_1bit mux1(a[1], b[1], sel, f[1]);
    mux_1bit mux2(a[2], b[2], sel, f[2]);
    mux_1bit mux3(a[3], b[3], sel, f[3]);
    mux_1bit mux4(a[4], b[4], sel, f[4]);
    mux_1bit mux5(a[5], b[5], sel, f[5]);
    mux_1bit mux6(a[6], b[6], sel, f[6]);
    mux_1bit mux7(a[7], b[7], sel, f[7]);


endmodule