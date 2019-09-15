`timescale 1ns/1ps

module Binary_to_Grey (din, dout);
    input [4-1:0] din;
    output [4-1:0] dout;

    wire not_a, not_b, not_c, not_d;

    //dout[0]
    wire and_0_1, and_0_2;
    //dout[1]
    wire and_1_1, and_1_2;
    //dout[2]
    wire and_2_1, and_2_2;
    //dour[3]
    

    not not1(not_a, din[3]);
    not not2(not_b, din[2]);
    not not3(not_c, din[1]);
    not not4(not_d, din[0]);

    and and01(and_0_1, not_c, din[0]);
    and and02(and_0_2, din[1], not_d);
    or or01(dout[0], and_0_1, and_0_2);

    and and11(and_1_1, din[2], not_c);
    and and12(and_1_2, not_b, din[1]);
    or or11(dout[1], and_1_1, and_1_2);

    and and21(and_2_1, not_a, din[2]);
    and and22(and_2_2, din[3], not_b);
    or or21(dout[2], and_2_1, and_2_2);
    
    not not31(dout[3], not_a);

endmodule
