// *******************************
// lab_SPEAKER_TOP
//
// ********************************

module TOP (
	input clk,
	input reset,
	output pmod_1,
	output pmod_2,
	output pmod_4,
	inout wire PS2_DATA,//added
	inout wire PS2_CLK
);
//reg BEAT_FREQ_05 = 32'd2;	//one beat=0.5sec
//reg BEAT_FREQ_1 = 32'd1;	//one beat=1sec
reg [31:0] BEAT_FREQ;
parameter DUTY_BEST = 10'd512;	//duty cycle=50%

wire [31:0] freq;
wire [7:0] ibeatNum;
wire beatFreq;

assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on


reg dir;



/////by my self////////////////////////////////////////////////////////////////////////////////

    parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;

	parameter [8:0] ENTER_CODES = 9'b0_0101_1010;
	
	parameter [8:0] KEY_CODES [0:19] = {
		9'b0_0100_0101,	// 0 => 45
		9'b0_0001_0110,	// 1 => 16
		9'b0_0001_1110,	// 2 => 1E
		9'b0_0010_0110,	// 3 => 26
		9'b0_0010_0101,	// 4 => 25
		9'b0_0010_1110,	// 5 => 2E
		9'b0_0011_0110,	// 6 => 36
		9'b0_0011_1101,	// 7 => 3D
		9'b0_0011_1110,	// 8 => 3E
		9'b0_0100_0110,	// 9 => 46
		
		9'b0_0111_0000, // right_0 => 70
		9'b0_0110_1001, // right_1 => 69
		9'b0_0111_0010, // right_2 => 72
		9'b0_0111_1010, // right_3 => 7A
		9'b0_0110_1011, // right_4 => 6B
		9'b0_0111_0011, // right_5 => 73
		9'b0_0111_0100, // right_6 => 74
		9'b0_0110_1100, // right_7 => 6C
		9'b0_0111_0101, // right_8 => 75
		9'b0_0111_1101  // right_9 => 7D
	};
	
	reg [15:0] nums;
	reg [3:0] key_num;
	reg [9:0] last_key;
	
	wire shift_down;
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;

	wire button_enter, button_zero, button_one, button_two;
	assign button_enter = (key_down[ENTER_CODES] == 1'b1) ? 1'b1 : 1'b0;
	assign button_zero = (key_down[KEY_CODES[00]] || key_down[KEY_CODES[10]]) ? 1'b1 : 1'b0;
	assign button_one = (key_down[KEY_CODES[01]] || key_down[KEY_CODES[11]]) ? 1'b1 : 1'b0;
	assign button_two = (key_down[KEY_CODES[02]] || key_down[KEY_CODES[12]]) ? 1'b1 : 1'b0;

	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(reset),
		.clk(clk)
	);

	always @ (posedge clk, posedge reset) begin //reset
		if (reset) begin
			BEAT_FREQ <= 32'd2;
			dir <= 1'b0;
		end 
		else begin
			if (been_ready && key_down[last_change] == 1'b1) begin
					if(button_enter == 1'b1)begin
						BEAT_FREQ <= 32'd2;
						dir <= 1'b0;
					end

					if(button_two == 1'b1)begin
						if(BEAT_FREQ == 32'd2)begin
							BEAT_FREQ <= 32'd1;
						end
						else if(BEAT_FREQ == 32'd1) begin
							BEAT_FREQ <= 32'd2;
						end
					end
					
					
					if(button_one == 1'b1)begin
						if(ibeatNum == 8'd14)begin
							dir <= 1'b1;
						end
					end

					if(button_zero == 1'b1)begin
						if(ibeatNum == 8'd0)begin
							dir <= 1'b0;
						end
					end
			end
		end
	end
	
	always @ (*) begin
		case (last_change)
			KEY_CODES[00] : key_num = 4'b0000;
			KEY_CODES[01] : key_num = 4'b0001;
			KEY_CODES[02] : key_num = 4'b0010;
			KEY_CODES[03] : key_num = 4'b0011;
			KEY_CODES[04] : key_num = 4'b0100;
			KEY_CODES[05] : key_num = 4'b0101;
			KEY_CODES[06] : key_num = 4'b0110;
			KEY_CODES[07] : key_num = 4'b0111;
			KEY_CODES[08] : key_num = 4'b1000;
			KEY_CODES[09] : key_num = 4'b1001;
			KEY_CODES[10] : key_num = 4'b0000;
			KEY_CODES[11] : key_num = 4'b0001;
			KEY_CODES[12] : key_num = 4'b0010;
			KEY_CODES[13] : key_num = 4'b0011;
			KEY_CODES[14] : key_num = 4'b0100;
			KEY_CODES[15] : key_num = 4'b0101;
			KEY_CODES[16] : key_num = 4'b0110;
			KEY_CODES[17] : key_num = 4'b0111;
			KEY_CODES[18] : key_num = 4'b1000;
			KEY_CODES[19] : key_num = 4'b1001;
			default		  : key_num = 4'b1111;
		endcase
	end



////////////////////by my self///////////////////////////////////////////////////////////////////////////////////////////////////


//Generate beat speed
PWM_gen btSpeedGen ( .clk(clk), 
					 .reset(reset),
					 .freq(BEAT_FREQ),
					 .duty(DUTY_BEST), 
					 .PWM(beatFreq)
);
	
//manipulate beat
PlayerCtrl playerCtrl_00 ( .clk(beatFreq),
						   .reset(button_enter), //orginal reset
						   .dir(dir),
						   .ibeat(ibeatNum)
);	
	
//Generate variant freq. of tones
Music music00 ( .ibeatNum(ibeatNum),
				.tone(freq)
);

// Generate particular freq. signal
PWM_gen toneGen ( .clk(clk), 
				  .reset(reset), 
				  .freq(freq),
				  .duty(DUTY_BEST), 
				  .PWM(pmod_1)
);


endmodule


module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);

wire [31:0] count_max = 100_000_000 / freq;
wire [31:0] count_duty = count_max * duty / 1024;
reg [31:0] count;
    
always @(posedge clk, posedge reset) begin
    if (reset) begin
        count <= 0;
        PWM <= 0;
    end else if (count < count_max) begin
        count <= count + 1;
		if(count < count_duty)
            PWM <= 1;
        else
            PWM <= 0;
    end else begin
        count <= 0;
        PWM <= 0;
    end
end

endmodule


module PlayerCtrl (
	input clk,
	input reset,
	input dir,
	output reg [7:0] ibeat
);
parameter BEATLEAGTH = 14; //original 63

always @(posedge clk/*, posedge reset*/) begin
	if (reset) begin
		ibeat <= 8'd0;
	end
	else if (dir == 8'd0) begin //ascend
		if(ibeat < BEATLEAGTH)begin
			ibeat <= ibeat + 1;
		end
		else begin
			ibeat <= 8'd14; //original 0
		end
	end
	else begin  //decend
		if(ibeat > 0)begin
			ibeat <= ibeat - 1;
		end
		else begin
			ibeat <= 0;
		end
	end
end

endmodule

module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
	);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
endmodule


//
//
//
//

`define NM1 32'd466 //bB_freq
`define NM2 32'd523 //C_freq
`define NM3 32'd587 //D_freq
`define NM4 32'd622 //bE_freq
`define NM5 32'd698 //F_freq
`define NM6 32'd784 //G_freq
`define NM7 32'd880 //A_freq
`define NM0 32'd20000 //slience (over freq.)

module Music (
	input [7:0] ibeatNum,	
	output reg [31:0] tone
);

always @(*) begin
	case (ibeatNum)		// 1 beat
		8'd0 : tone = 32'd262;	//3
		8'd1 : tone = 32'd294;
		8'd2 : tone = 32'd330;
		8'd3 : tone = 32'd349;
		8'd4 : tone = 32'd392;	//1
		8'd5 : tone = 32'd440;
		8'd6 : tone = 32'd494;
		8'd7 : tone = 32'd262 << 1;
		8'd8 : tone = 32'd294 << 1;
		8'd9 : tone = 32'd330 << 1;
		8'd10 : tone = 32'd349 << 1;
		8'd11 : tone = 32'd392 << 1;
		8'd12 : tone = 32'd440 << 1;
		8'd13 : tone = 32'd494 << 1;
		8'd14 : tone = 32'd262 << 2;
		//8'd15 : tone = 32'd294 << 2;
	endcase
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
	
	OnePulse op (
		.signal_single_pulse(pulse_been_ready),
		.signal(been_ready),
		.clock(clk)
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
