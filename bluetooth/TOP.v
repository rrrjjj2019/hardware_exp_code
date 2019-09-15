module TOP(Clk ,Rst_n, Rx , Tx, /*RxData,*/ count_Rx, debug, motor_signal_out, motor_signal_out2);

/////////////////////////////////////////////////////////////////////////////////////////
input           Clk             ; // Clock
input           Rst_n           ; // Reset
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

reg rx_test;
reg rx_test_x;
wire debug;
wire [7:0]    RxData;
reg motor_dir;
reg motor_en;

reg motor_dir2;

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
    
 always@(*)begin
    if(count_Rx == 8'd3)begin //up
        motor_en = 1;
        motor_dir = 0;
        motor_dir2 = 0;
    end
    else if(count_Rx == 8'd4)begin //down
        motor_en = 1;
        motor_dir = 1;
        motor_dir2 = 1;
    end
    else if(count_Rx == 8'd5)begin //stop
        motor_en = 0;
        motor_dir = 1;
        motor_dir2 = 1;
    end
    else if(count_Rx == 8'd7)begin // left
        motor_en = 1;
        motor_dir = 1;
        motor_dir2 = 0;
    end
    else if(count_Rx == 8'd9)begin // right
            motor_en = 1;
            motor_dir = 0;
            motor_dir2 = 1;
    end
 end



endmodule
