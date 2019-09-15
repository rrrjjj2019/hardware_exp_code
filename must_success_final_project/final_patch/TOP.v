module TOP(Clk ,Rst_n, _is_wall, Rx , Tx, /*RxData,*/ count_Rx, debug, motor_signal_out, motor_signal_out2);

/////////////////////////////////////////////////////////////////////////////////////////
input           Clk             ; // Clock
input           Rst_n           ; // Reset
input           _is_wall        ;
input           Rx              ; // RS232 RX line.
output          Tx              ; // RS232 TX line.
//output [7:0]    RxData          ; // Received data

output [7:0]    count_Rx;
output debug;
output [3:0] motor_signal_out;
output [3:0] motor_signal_out2;
/////////////////////////////////////////////////////////////////////////////////////////
wire [7:0]    	TxData     	; // Data to transmit.
wire          	RxDone          ; // Reception completed. Data is valid.
wire          	TxDone          ; // Trnasmission completed. Data sent.
wire            tick		; // Baud rate clock
wire          	TxEn            ;
wire 		    RxEn		;
wire [3:0]      NBits    	;
wire [15:0]    	BaudRate        ; //328; 162 etc... (Read comment in baud rate generator file)
/////////////////////////////////////////////////////////////////////////////////////////
assign 		RxEn = 1'b1	;
assign 		TxEn = 1'b1	;
assign 		BaudRate = 16'd650; 	//baud rate set to 9600 for the HC-06 bluetooth module. Why 325? (Read comment in baud rate generator file)
assign 		NBits = 4'b1000	;	//We send/receive 8 bits
/////////////////////////////////////////////////////////////////////////////////////////

reg [1:0] flag_mode = 1; // 0 ->default (no move) , 1->manual , 2->auto

reg rx_test;
reg rx_test_x;
wire debug;
wire [7:0]    RxData;
reg motor_dir;
reg motor_en;

reg motor_dir2;

wire is_wall;

pmod_step_interface motor(
    .clk(Clk),
    .rst(Rst_n),
    .direction(motor_dir),
    .en(motor_en),
    .signal_out(motor_signal_out)
    );
    
pmod_step_interface motor2(
        .clk(Clk),
        .rst(Rst_n),
        .direction(motor_dir2),
        .en(motor_en),
        .signal_out(motor_signal_out2)
        );

//Make connections between Rx module and TOP inputs and outputs and the other modules
UART_rs232_rx I_RS232RX(
    	.Clk(Clk)             	,
   	.Rst_n(Rst_n)         	,
    	.RxEn(RxEn)           	,
    	.RxData(RxData)       	,
    	.RxDone(RxDone)       	,
    	.Rx(Rx)               	,
    	.Tick(tick)           	,
    	.NBits(NBits), 
    	.count_Rx(count_Rx),
    	.debug(debug)
    );

//Make connections between Tx module and TOP inputs and outputs and the other modules
UART_rs232_tx I_RS232TX(
   	.Clk(Clk)            	,
    	.Rst_n(Rst_n)         	,
    	.TxEn(TxEn)           	,
    	.TxData(TxData)      	,
   	.TxDone(TxDone)      	,
   	.Tx(Tx)               	,
   	.Tick(tick)           	,
   	.NBits(NBits)
    );

//Make connections between tick generator module and TOP inputs and outputs and the other modules
UART_BaudRate_generator I_BAUDGEN(
    	.Clk(Clk)               ,
    	.Rst_n(Rst_n)           ,
    	.Tick(tick)             ,
    	.BaudRate(BaudRate)
    );
    
bi_chang b(_is_wall, is_wall);// if is_wall ==1, there is a wall


//**********************************************************************
reg [1:0] state, next_state;
parameter state_direct = 2'b00;
parameter state_back   = 2'b01;
parameter state_turn   = 2'b10; 
reg       [27:0] count_back = 28'b0;
reg       [27:0] count_turn = 28'b0;   
reg       [27:0] next_count_back;
reg       [27:0] next_count_turn;  

always@(posedge Clk) begin
    if(Rst_n) begin
         state <= state_direct;
         count_back <= 0;
         count_turn <= 0;
    end
    else begin
       state <= next_state;
       count_back <=  next_count_back;
       count_turn <=  next_count_turn;
    end    
end        
//**************************************************************************    
 always@(*) begin
    if(count_Rx == 8'd6) begin //AUTO
        case(state)
            state_direct: begin
                 motor_en = 1;
                 motor_dir = 0;
                 motor_dir2 = 1;
                 if(is_wall) next_state = state_back;
                 else        next_state = state_direct;
            end
            state_back: begin
                motor_en = 1;
                motor_dir = 1;
                motor_dir2 = 0;
                next_count_back = (count_back == 28'd10**9)? 0 : count_back+1;
                next_state      = (count_back == 28'd10**9)? state_turn : state_back;
            end
            state_turn: begin
                motor_en = 1;
                motor_dir = 0;
                motor_dir2 = 0;
                next_count_turn = (count_back == 28'd10**9)? 0 : count_turn+1;
                next_state      = (count_back == 28'd10**9)? state_direct : state_turn;
            end
            
            
            
        endcase
    end
    
    else if(count_Rx == 8'd3)begin //left
    
        motor_en = 1;
        motor_dir = 0;
        motor_dir2 = 0;

    end
    else if(count_Rx == 8'd4)begin //right
    
        motor_en = 1;
        motor_dir = 1;
        motor_dir2 = 1;
       
    end
    else if(count_Rx == 8'd5)begin //stop
        motor_en = 0;
        motor_dir = 1;
        motor_dir2 = 1;
    end
    else if(count_Rx == 8'd7)begin // down
    
        motor_en = 1;
        motor_dir = 1;
        motor_dir2 = 0;

    end
    else if(count_Rx == 8'd9)begin // up
   
        motor_en = 1;
        motor_dir = 0;
        motor_dir2 = 1;
  
    end
 end    
 
 

endmodule
