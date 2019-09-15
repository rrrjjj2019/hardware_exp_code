`timescale 1ns/1ps

module NOT(a, out);
    input a;
    output out;
    nor nor_0(out, a, a);
endmodule

module AND(a, b, out);
    input a, b;
    output out;
    wire out1, out2;
    nor nor_0(out1, a, a);
    nor nor_1(out2, b, b);
    nor nor_2(out, out1, out2);
endmodule

module OR(a, b, out);
    input a, b;
    output out;
    wire out1;
    nor nor_0(out1, a, b);
    NOT not_0(out1, out);
endmodule

module XOR(a, b, out);
    input a, b;
    output out;
    wire out1, out2, out3, out4;

    nor nor_0(out1, a, a);
    nor nor_1(out2, b, b);
    nor nor_2(out3, out1, out2);
    nor nor_3(out4, a, b);
    nor nor_4(out, out3, out4);
endmodule

module XNOR(a, b, out);
    input a, b;
    output out;
    wire out1, out2, out3, out4, out5;

    nor nor_0(out1, a, a);
    nor nor_1(out2, b, b);
    nor nor_2(out3, out1, out2);
    nor nor_3(out4, a, b);
    nor nor_4(out5, out3, out4);
    nor nor_5(out, out5, out5);
endmodule

module NAND(a, b, out);
    input a, b;
    output out;
    wire out1, out2, out3;
    nor nor_0(out1, a, a);
    nor nor_1(out2, b, b);
    nor nor_2(out3, out1, out2);
    nor nor_3(out, out3, out3);
endmodule

module NOR_Implement (a, b, sel, out);
    input a, b;
    input [3-1:0] sel;
    output out;

    wire n_sel_0, n_sel_1, n_sel_2;
    wire not_o, nor_o, and_o, or_o, xor_o, xnor_o, nand_o;
    wire out1, out2, out3, out4, out5, out6, out7;

    NOT not_0(sel[0], n_sel_0);
    NOT not_1(sel[1], n_sel_1);
    NOT not_2(sel[2], n_sel_2);

    NOT not_3(a, not_o);
    nor nor_0(nor_o, a, b);
    AND and_0(a, b, and_o);
    OR or_0(a, b, or_o);
    XOR xor_0(a, b, xor_o);
    XNOR xnor_0(a, b, xnor_o);
    NAND nand_0(a, b, nand_o);

    and and_1(out1, n_sel_2, n_sel_1, n_sel_0, not_o);
    and and_2(out2, n_sel_2, n_sel_1, sel[0], nor_o);
    and and_3(out3, n_sel_2, sel[1], n_sel_0, and_o);
    and and_4(out4, n_sel_2, sel[1], sel[0], or_o);
    and and_5(out5, sel[2], n_sel_1, n_sel_0, xor_o);
    and and_6(out6, sel[2], n_sel_1, sel[0], xnor_o);
    and and_7(out7, sel[2], sel[1], nand_o);

    or or_1(out, out1, out2, out3, out4, out5, out6, out7);
    

endmodule
