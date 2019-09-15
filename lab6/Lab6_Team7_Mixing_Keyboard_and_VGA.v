
module KeyboardDecoder(
	output reg [511 :0] key_down,
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

`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: vga
/////////////////////////////////////////////////////////////////

module vga_controller 
  (
    input wire pclk,reset,
    output wire hsync,vsync,valid,
    output wire [9:0]h_cnt,
    output wire [9:0]v_cnt
    );
    
    reg [9:0]pixel_cnt;
    reg [9:0]line_cnt;
    reg hsync_i,vsync_i;
    wire hsync_default, vsync_default;
    wire [9:0] HD, HF, HS, HB, HT, VD, VF, VS, VB, VT;

   
    assign HD = 640;
    assign HF = 16;
    assign HS = 96;
    assign HB = 48;
    assign HT = 800; 
    assign VD = 480;
    assign VF = 10;
    assign VS = 2;
    assign VB = 33;
    assign VT = 525;
    assign hsync_default = 1'b1;
    assign vsync_default = 1'b1;
     
    always@(posedge pclk)
        if(reset)
            pixel_cnt <= 0;
        else if(pixel_cnt < (HT - 1))
                pixel_cnt <= pixel_cnt + 1;
             else
                pixel_cnt <= 0;

    always@(posedge pclk)
        if(reset)
            hsync_i <= hsync_default;
        else if((pixel_cnt >= (HD + HF - 1))&&(pixel_cnt < (HD + HF + HS - 1)))
                hsync_i <= ~hsync_default;
            else
                hsync_i <= hsync_default; 
    
    always@(posedge pclk)
        if(reset)
            line_cnt <= 0;
        else if(pixel_cnt == (HT -1))
                if(line_cnt < (VT - 1))
                    line_cnt <= line_cnt + 1;
                else
                    line_cnt <= 0;
                    
    always@(posedge pclk)
        if(reset)
            vsync_i <= vsync_default; 
        else if((line_cnt >= (VD + VF - 1))&&(line_cnt < (VD + VF + VS - 1)))
            vsync_i <= ~vsync_default; 
        else
            vsync_i <= vsync_default; 
                    
    assign hsync = hsync_i;
    assign vsync = vsync_i;
    assign valid = ((pixel_cnt < HD) && (line_cnt < VD));
    
    assign h_cnt = (pixel_cnt < HD) ? pixel_cnt:10'd0;
    assign v_cnt = (line_cnt < VD) ? line_cnt:10'd0;
           
endmodule


module mem_addr_gen(
   input clk,
   input rst,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   input up, down, left, right,
   input flag_pause_start,
   input flip_h,  //  0-> no flip horizontal
   input flip_v,  //0 -> no flip vertical
   output [16:0] pixel_addr
   );


   reg [16:0] pixel_addrp;
   reg [9:0] nowX, nowY;
 
   
    always@(posedge clk or posedge rst) begin
       if(rst) begin
           nowX <= 10'b0;
           nowY <= 10'b0;
       end
       
       else if(up) begin
           if(flag_pause_start) //pause
               nowY <= nowY;
           else                 //move
               nowY <= (nowY +10'd1) %239;
       end
       
       else if (down) begin
           if(flag_pause_start)  //pause
               nowY <= nowY;
           else                 //move
               nowY <= (nowY +10'd238) %239;
       end
       else if (right) begin
           if(flag_pause_start)   //pause
               nowX <= nowX;
           else                  //move
               nowX <= (nowX +10'd318) %319;
       end
       
       else if (left) begin
           if(flag_pause_start)    //pause
               nowX <= nowX;
           else                    //move
               nowX <= (nowX +10'd1) %319;
       end
       else begin
           nowX <= nowX;
           nowY <= nowY;
       end
           

    end
    always@(*) begin
         if(!flip_h) begin  
             if(!flip_v) begin   //both no flip
                 pixel_addrp = ((h_cnt>>1) + nowX + 320*(v_cnt>>1) + 320*nowY)% 76800;  //640*480 --> 320*240 
             end
             else begin          // v flip 
                 pixel_addrp = ((h_cnt>>1) + nowX +    320*240+320*238      -320*(v_cnt>>1) - 320*nowY)% 76800;  //640*480 --> 320*240 
             end
         end
         else begin
             if(!flip_v) begin  //h flip            
                 pixel_addrp = (320+318-   (h_cnt>>1) - nowX +320*(v_cnt>>1) + 320*nowY)% 76800;  //640*480 --> 320*240 
             end
             else begin
                 pixel_addrp = (320+318-   (h_cnt>>1) - nowX +    320*240+320*238      -320*(v_cnt>>1) - 320*nowY)% 76800;  //640*480 --> 320*240 
             end
         end
         
    end

assign pixel_addr = pixel_addrp;
endmodule


module clock_divisor(clk1, clk, clk22);
input clk;
output clk1;
output clk22;


reg [21:0] num;
wire [21:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end

assign next_num = num + 1'b1;
assign clk1 = num[1]; // divide 4
assign clk22 = num[21];

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

module TOP (
    input clk, // intrinsic clock
    input reset,
    input btn_rst,
    
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync
);

    wire debounced_btn_rst;
    wire onepulse_btn_rst;
 
    
    debounce deb_reset(
        .pb_debounced(debounced_btn_rst),
        .pb(btn_rst),
        .clk(clk)
    );
    OnePulse op (
        .signal_single_pulse(onepulse_btn_rst),
        .signal(debounced_btn_rst),
        .clock(clk)
    );

//==================================================================================================
//===================================VGA===========================================================
//==================================================================================================
    wire [11:0] data;
    wire clk_25MHz;
    wire clk_22;
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
    
    reg up;
    reg down;
    reg left;
    reg right;
    reg flag_pause_start;
    reg flag_reset;  //  =1 when just reseted,   =0 when P is pressed after reseted
    reg flip_v;
    reg flip_h;
    
  assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel:12'h0;

     clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk1(clk_25MHz),
      .clk22(clk_22)
    );

    mem_addr_gen mem_addr_gen_inst(
    .clk(clk_22),
    .rst(btn_rst),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .pixel_addr(pixel_addr),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .flag_pause_start(flag_pause_start),
    .flip_v(flip_v),
    .flip_h(flip_h)
    );
     
 
    blk_mem_gen_0 blk_mem_gen_0_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel)
    ); 

    vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(reset),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
   
//=========================================================================================================
//===================================Keyboard===============================================================
//=========================================================================================================
    parameter [8:0] KEY_CODES [0:27] = {
    9'b0_0100_0101,    // 0 => 45
    9'b0_0001_0110,    // 1 => 16
    9'b0_0001_1110,    // 2 => 1E
    9'b0_0010_0110,    // 3 => 26
    9'b0_0010_0101,    // 4 => 25
    9'b0_0010_1110,    // 5 => 2E
    9'b0_0011_0110,    // 6 => 36
    9'b0_0011_1101,    // 7 => 3D
    9'b0_0011_1110,    // 8 => 3E
    9'b0_0100_0110,    // 9 => 46
    
    9'b0_0111_0000, // right_0 => 70
    9'b0_0110_1001, // right_1 => 69
    9'b0_0111_0010, // right_2 => 72
    9'b0_0111_1010, // right_3 => 7A
    9'b0_0110_1011, // right_4 => 6B
    9'b0_0111_0011, // right_5 => 73
    9'b0_0111_0100, // right_6 => 74
    9'b0_0110_1100, // right_7 => 6C
    9'b0_0111_0101, // right_8 => 75
    9'b0_0111_1101, // right_9 => 7D
    9'b0_0101_1010, // enter 
    9'b0_0100_1101,  // P
    9'b0_0010_1010,  // V
    9'b0_0011_0011,  // H
    9'b0_0001_1101,  //W
    9'b0_0001_1100,  //A
    9'b0_0001_1011,  //S
    9'b0_0010_0011   //D
};

    reg [15:0] nums;
    reg [3:0] key_num;
    reg [9:0] last_key;
    
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
    
    wire scroll_up;
    wire scroll_down;
    wire scroll_left;
    wire scroll_right;
    wire keyboard_P;
    wire keyboard_V;
    wire keyboard_H;
    

    
    assign  scroll_up         = (key_down[KEY_CODES[24]] == 1'b1) ? 1'b1 : 1'b0;
    assign  scroll_down       = (key_down[KEY_CODES[26]] == 1'b1) ? 1'b1 : 1'b0;
    assign  scroll_left       = (key_down[KEY_CODES[25]] == 1'b1) ? 1'b1 : 1'b0;
    assign  scroll_right      = (key_down[KEY_CODES[27]] == 1'b1) ? 1'b1 : 1'b0;
    assign  keyboard_P        = (key_down[KEY_CODES[21]] == 1'b1) ? 1'b1 : 1'b0;
    assign  keyboard_V        = (key_down[KEY_CODES[22]] == 1'b1) ? 1'b1 : 1'b0;
    assign  keyboard_H        = (key_down[KEY_CODES[23]] == 1'b1) ? 1'b1 : 1'b0;
    
    
    KeyboardDecoder key_de (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(reset),
        .clk(clk)
    );
    
    always@(posedge clk or posedge onepulse_btn_rst) begin 
        if(onepulse_btn_rst) begin
            up<=1'b0;
            down <= 1'b0;
            left <= 1'b0;
            right<= 1'b0;
            flag_pause_start <= 1'b1;      // 0 -> moving , 1 -> pause
            flag_reset <=1'b1;             //  1-> when just reseted ,  0-> when P is pressed after reseted
            flip_v <= 1'b0;
            flip_h <= 1'b0;
        end
        else begin
            if(been_ready && key_down[last_change] == 1'b1) begin
                
                // button 8  (up) pressed
                if(scroll_up == 1'b1) begin
                    if(!flag_reset) begin
                        up   <= 1'b1;
                        down <= 1'b0;
                        left <= 1'b0;
                        right<= 1'b0;
                    end
                end
                
                //button 2  (down)  pressed
                if(scroll_down == 1'b1) begin
                    if(!flag_reset) begin
                        up   <= 1'b0;
                        down <= 1'b1;
                        left <= 1'b0;
                        right<= 1'b0;
                    end
                end
                
                //button 4  (left)  pressed
                if(scroll_left == 1'b1) begin
                    if(!flag_reset) begin
                        up   <=1'b0;
                        down <=1'b0;
                        left <=1'b1;
                        right<=1'b0; 
                    end                  
                end
                
                //button 6  (right)  pressed
                if(scroll_right == 1'b1) begin
                    if(!flag_reset) begin
                        up   <=1'b0;
                        down <=1'b0;
                        left <=1'b0;
                        right<=1'b1;
                    end
                end 
                
                // keybaord_P  (pause / start) pressed
                if(keyboard_P == 1'b1) begin
                    if(flag_pause_start == 1'b1) begin
                        if(!up && !down && !left && !right) begin   // in this case,  the reset is just pressed and about to press P
                            up   <=1'b1;
                            down <=1'b0;
                            left <=1'b0;
                            right<=1'b0;      
                            flag_reset <= 1'b0;    
                            flag_pause_start <= 1'b0;     
                        end
                        else 
                            flag_pause_start <= 1'b0;
                    end    
                    else
                        flag_pause_start <= 1'b1;
                end
                
                // keyboard_V  (flip vertically)  pressed
                if(keyboard_V == 1'b1)begin
                    if(flip_v == 1'b0) flip_v <= 1'b1;
                    else flip_v <= 1'b0;

                end
                
                // keyboard_H  (flip horizontally)  pressed
                if(keyboard_H == 1'b1)begin
                    if(flip_h == 1'b0) flip_h <= 1'b1;
                    else flip_h <= 1'b0;

                end                
            end       
        end
    end
endmodule