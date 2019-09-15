`timescale 1ns/1ps

module fpga(clk, reset, NT5, NT10, NT50, cancel, PS2_DATA, PS2_CLK, coffee, coke, oolong, water, out, AN);
    input clk, reset, NT5, NT10, NT50, cancel;
    inout wire PS2_DATA;
    inout wire PS2_CLK;
    output coffee, coke, oolong, water;
    output [0:6] out;
    output [3:0] AN;

    wire coffee, coke, oolong, water;
    wire [6:0] balance;

    reg [3:0] AN;
    reg [0:6] out;
    reg sel, next_sel;

    wire divided_clk_vending_machine;
    wire divided_clk_display;
    wire divided_clk_onepulse;

    wire debounced_reset, debounced_NT5, debounced_NT10, debounced_NT50, debounced_cancel;
    wire /*onepulse_reset0,*/ onepulse_NT5, onepulse_NT10, onepulse_NT50, onepulse_cancel;
    wire onepulse_reset;

    clock_divider #(1)_clk_counter(clk, divided_clk_vending_machine);
    clock_divider #(1)_clk_onepulse(clk, divided_clk_onepulse);
    clock_divider #(2**15)_clk_display(clk, divided_clk_display);

    debounce deb_reset(
        .pb_debounced(debounced_reset),
        .pb(reset),
        .clk(clk)
    );

    debounce deb_NT5(
        .pb_debounced(debounced_NT5),
        .pb(NT5),
        .clk(clk)
    );

    debounce deb_NT10(
        .pb_debounced(debounced_NT10),
        .pb(NT10),
        .clk(clk)
    );

    debounce deb_NT50(
        .pb_debounced(debounced_NT50),
        .pb(NT50),
        .clk(clk)
    );

    debounce deb_cancel(
        .pb_debounced(debounced_cancel),
        .pb(cancel),
        .clk(clk)
    );

    onepulse one_reset(
        .pb_debounced(debounced_reset),
        .clk(divided_clk_onepulse),
        .pb_one_pluse(onepulse_reset)
    );

    //assign onepulse_reset = !onepulse_reset0;

    onepulse one_NT5(
        .pb_debounced(debounced_NT5),
        .clk(divided_clk_onepulse),
        .pb_one_pluse(onepulse_NT5)
    );

    onepulse one_NT10(
        .pb_debounced(debounced_NT10),
        .clk(divided_clk_onepulse),
        .pb_one_pluse(onepulse_NT10)
    );

    onepulse one_NT50(
        .pb_debounced(debounced_NT50),
        .clk(divided_clk_onepulse),
        .pb_one_pluse(onepulse_NT50)
    );

    onepulse one_cancel(
        .pb_debounced(debounced_cancel),
        .clk(divided_clk_onepulse),
        .pb_one_pluse(onepulse_cancel)
    );

    vending_machine V(
        .clk(divided_clk_vending_machine), 
        .reset(onepulse_reset), 
        .NT5(onepulse_NT5), 
        .NT10(onepulse_NT10), 
        .NT50(onepulse_NT50), 
        .cancel(onepulse_cancel), 
        .PS2_DATA(PS2_DATA), 
        .PS2_CLK(PS2_CLK), 
        .coffee(coffee), 
        .coke(coke),
        .oolong(oolong),
        .water(water), 
        .balance(balance)
    );


    always@(posedge divided_clk_display)begin
        sel <= next_sel;
    end

    always@(*)begin
        if(sel == 1'd0)begin
            next_sel = sel + 1;
            AN = 4'b1110;
            if(balance == 7'd0 || balance == 7'd10 || balance == 7'd20 || balance == 7'd30 || balance == 7'd40 || balance == 7'd50 || balance == 7'd60 || balance == 7'd70 || balance == 7'd80)begin
                out = 7'b0000001; //0
            end
            else if(balance == 7'd1 || balance == 7'd11 || balance == 7'd21 || balance == 7'd31 || balance == 7'd41 || balance == 7'd51 || balance == 7'd61 || balance == 7'd71)begin
                out = 7'b1001111; //1
            end
            else if(balance == 7'd2 || balance == 7'd12 || balance == 7'd22 || balance == 7'd32 || balance == 7'd42 || balance == 7'd52 || balance == 7'd62 || balance == 7'd72)begin
                out = 7'b0010010; //2
            end
            else if(balance == 7'd3 || balance == 7'd13 || balance == 7'd23 || balance == 7'd33 || balance == 7'd43 || balance == 7'd53 || balance == 7'd63 || balance == 7'd73)begin
                out = 7'b0000110; //3
            end
            else if(balance == 7'd4 || balance == 7'd14 || balance == 7'd24 || balance == 7'd34 || balance == 7'd44 || balance == 7'd54 || balance == 7'd64 || balance == 7'd74)begin
                out = 7'b1001100; //4
            end
            else if(balance == 7'd5 || balance == 7'd15 || balance == 7'd25 || balance == 7'd35 || balance == 7'd45 || balance == 7'd55 || balance == 7'd65 || balance == 7'd75)begin
                out = 7'b0100100; //5
            end
            else if(balance == 7'd6 || balance == 7'd16 || balance == 7'd26 || balance == 7'd36 || balance == 7'd46 || balance == 7'd56 || balance == 7'd66 || balance == 7'd76) begin
                out = 7'b0100000; //6
            end
            else if(balance == 7'd7 || balance == 7'd17 || balance == 7'd27 || balance == 7'd37 || balance == 7'd47 || balance == 7'd57 || balance == 7'd67 || balance == 7'd77)begin
                out = 7'b0001111; //7
            end
            else if(balance == 7'd8 || balance == 7'd18 || balance == 7'd28 || balance == 7'd38 || balance == 7'd48 || balance == 7'd58 || balance == 7'd68 || balance == 7'd78)begin
                out = 7'b00000000; //8
            end
            else if(balance == 7'd9 || balance == 7'd19 || balance == 7'd29 || balance == 7'd39 || balance == 7'd49 || balance == 7'd59 || balance == 7'd69 || balance == 7'd79)begin
                out = 7'b0000100; //9
            end
        end
        else begin
            next_sel = 1'd0;
            AN = 4'b1101;
            if(balance >= 7'd0 && balance <= 7'd9)begin
                out = 7'b0000001; //0
            end
            else if(balance >= 7'd10 && balance <= 7'd19)begin
                out = 7'b1001111; //1
            end
            else if(balance >= 7'd20 && balance <= 7'd29)begin
                out = 7'b0010010; //2
            end
            else if(balance >= 7'd30 && balance <= 7'd39)begin
                out = 7'b0000110; //3
            end
            else if(balance >= 7'd40 && balance <= 7'd49)begin
                out = 7'b1001100; //4
            end
            else if(balance >= 7'd50 && balance <= 7'd59)begin
                out = 7'b0100100; //5
            end
            else if(balance >= 7'd60 && balance <= 7'd69)begin
                out = 7'b0100000; //6
            end
            else if(balance >= 7'd70 && balance <= 7'd79)begin
                out = 7'b0001111; //7
            end
            else begin
                out = 7'b00000000; //8
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

module KeyboardDecoder(
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	onepulse op (
        .pb_debounced(been_ready),
		.clk(clk),
        .pb_one_pluse(pulse_been_ready)
	);
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end

endmodule


module vending_machine(clk, reset, NT5, NT10, NT50, cancel, PS2_DATA, PS2_CLK, coffee, coke, oolong, water, balance);
    input clk, reset, NT5, NT10, NT50, cancel;
    inout wire PS2_DATA;
    inout wire PS2_CLK;
    output coffee, coke, oolong, water;
    output [6:0] balance;
    wire [6:0] balance;

    reg [6:0] uncharged_coin;
    reg [6:0] charged_coin, next_charged_coin;

    reg coffee, coke, oolong, water;

    parameter [8:0] KEY_A_CODES = 9'b0_0001_1100;
    parameter [8:0] KEY_S_CODES = 9'b0_0001_1011;
    parameter [8:0] KEY_D_CODES = 9'b0_0010_0011;
    parameter [8:0] KEY_F_CODES = 9'b0_0010_1011;

    wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;

    wire key_a, key_s, key_d, key_f;
    assign key_a = (key_down[KEY_A_CODES] == 1'b1) ? 1'b1 : 1'b0;
    assign key_s = (key_down[KEY_S_CODES] == 1'b1) ? 1'b1 : 1'b0;
    assign key_d = (key_down[KEY_D_CODES] == 1'b1) ? 1'b1 : 1'b0;
    assign key_f = (key_down[KEY_F_CODES] == 1'b1) ? 1'b1 : 1'b0;

    parameter [1:0] reset_state = 2'b00;
    parameter [1:0] input_coin_state = 2'b01;
    parameter [1:0] charging_state = 2'b10;
    reg [1:0] state, next_state;
    reg [26:0] clk_counter, next_clk_counter;

    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(reset),
		.clk(clk)
	);

    always@(posedge clk)begin
        if(reset)begin
            state <= reset_state;
            charged_coin <= 7'd0;
        end
        else begin
            state <= next_state;
            charged_coin <= next_charged_coin;
            clk_counter <= next_clk_counter;
        end
    end

    always@(*)begin
        case(state)
            reset_state:begin
                next_state = input_coin_state;
                next_charged_coin = charged_coin;
                next_clk_counter = 27'd0;
            end
            input_coin_state:begin
                if(cancel == 1'b1)begin
                    next_state = charging_state;
                end
                else begin
                    if(NT5 == 1'b1)begin
                        if(charged_coin > 7'd75)begin
                            next_charged_coin = 7'd80;
                        end
                        else begin
                            next_charged_coin = charged_coin + 7'd5;
                        end
                    end
                    else begin
                        if(NT10 == 1'b1)begin
                            if(charged_coin > 7'd70)begin
                                next_charged_coin = 7'd80;
                            end
                            else begin
                                next_charged_coin = charged_coin + 7'd10;
                            end
                        end
                        else begin
                            if(NT50 == 1'b1)begin
                                if(charged_coin > 7'd30)begin
                                    next_charged_coin = 7'd80;
                                end
                                else begin
                                    next_charged_coin = charged_coin + 7'd50;
                                end
                            end
                            else begin
                                next_charged_coin = charged_coin;
                            end
                        end
                    end
                    
                    
                    



                    if(charged_coin < 7'd20)begin
                        coke = 0;
                        coffee = 0;
                        oolong = 0;
                        water = 0;
                    end
                    else if(charged_coin >= 7'd20 && charged_coin < 7'd25)begin
                        coke = 1;
                        coffee = 0;
                        oolong = 0;
                        water = 0;
                    end
                    else if (charged_coin >= 7'd25 && charged_coin < 7'd30) begin
                        coke = 1;
                        oolong = 1;
                        water = 0;
                        coffee = 0;
                    end
                    else if(charged_coin >= 7'd30 && charged_coin < 7'd55)begin
                        coke = 1;
                        oolong = 1;
                        water = 1;
                        coffee = 0;
                    end
                    else begin
                        coke = 1;
                        oolong = 1;
                        water = 1;
                        coffee = 1;
                    end
                


                    if (been_ready && key_down[last_change] == 1'b1)begin
                            if(key_s == 1'b1)begin
                                if(coke == 1'b1)begin
                                    next_charged_coin = charged_coin - 7'd20;
                                    next_state = charging_state;
                                end
                                else begin
                                    next_charged_coin = charged_coin;
                                    next_state = input_coin_state;
                                end
                            end

                            if(key_d == 1'b1)begin
                                if(oolong == 1'b1)begin
                                    next_charged_coin = charged_coin - 7'd25;
                                    next_state = charging_state;
                                end
                                else begin
                                    next_charged_coin = charged_coin;
                                    next_state = input_coin_state;
                                end
                            end

                            if(key_f == 1'b1)begin
                                if(water == 1'b1)begin
                                    next_charged_coin = charged_coin - 7'd30;
                                    next_state = charging_state;
                                end
                                else begin
                                    next_state = input_coin_state;
                                    next_charged_coin = charged_coin;
                                end
                            end

                            if(key_a == 1'b1)begin
                                if(coffee == 1'b1)begin
                                    next_charged_coin = charged_coin - 7'd55;
                                    next_state = charging_state;
                                end
                                else begin
                                    next_state = input_coin_state;
                                    next_charged_coin = charged_coin;
                                end
                            end
                    end
                end
            end

            //end
            charging_state:begin
                if(clk_counter == 10**8)begin
                    next_clk_counter = 27'd0;

                    if(charged_coin > 0)begin
                        next_charged_coin = charged_coin - 7'd5;
                        next_state = charging_state;
                    end
                    else begin
                        next_charged_coin = charged_coin;
                        next_state = reset_state;
                    end
                    
                end
                else begin
                    next_clk_counter = clk_counter + 1;
                    next_state = charging_state;
                    next_charged_coin = charged_coin;
                end


                if(charged_coin < 7'd20)begin
                    coke = 0;
                    coffee = 0;
                    oolong = 0;
                    water = 0;
                end
                else if(charged_coin >= 7'd20 && charged_coin < 7'd25)begin
                    coke = 1;
                    coffee = 0;
                    oolong = 0;
                    water = 0;
                end
                else if (charged_coin >= 7'd25 && charged_coin < 7'd30) begin
                    coke = 1;
                    oolong = 1;
                    water = 0;
                    coffee = 0;
                end
                else if(charged_coin >= 7'd30 && charged_coin < 7'd55)begin
                    coke = 1;
                    oolong = 1;
                    water = 1;
                    coffee = 0;
                end
                else begin
                    coke = 1;
                    oolong = 1;
                    water = 1;
                    coffee = 1;
                end
                
            end
        endcase
    end

    //assign balance = (state == reset_state || state == input_coin_state)? uncharged_coin : charged_coin;
    assign balance = charged_coin;

endmodule

