module TOP(Clk ,Rst_n, Rx , Tx, RxData, rx_test, rx_test_x, RxDone_test, debug1, debug2, debug3);

/////////////////////////////////////////////////////////////////////////////////////////
input           Clk             ; // Clock
input           Rst_n           ; // Reset
input           Rx              ; // RS232 RX line.
output          Tx              ; // RS232 TX line.
output [7:0]    RxData          ; // Received data
output          rx_test;
output          rx_test_x;
output          RxDone_test;
output debug1, debug2, debug3;
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
assign 		BaudRate = 16'd325; 	//baud rate set to 9600 for the HC-06 bluetooth module. Why 325? (Read comment in baud rate generator file)
assign 		NBits = 4'b1000	;	//We send/receive 8 bits
/////////////////////////////////////////////////////////////////////////////////////////

reg rx_test;
reg rx_test_x;
reg RxDone_test = 0;
wire o_clk;
wire debug1, debug2, debug3;

clock_divider c(
        .clk(Clk),
        .o_clk(o_clk)
 );

//Make connections between Rx module and TOP inputs and outputs and the other modules
UART_rs232_rx I_RS232RX(
    	.Clk(o_clk)             	,
   	.Rst_n(Rst_n)         	,
    	.RxEn(RxEn)           	,
    	.RxData(RxData)       	,
    	.RxDone(RxDone)       	,
    	.Rx(!Rx)               	,
    	.Tick(tick)           	,
    	.NBits(NBits),
       .debug1(debug1), 
       .debug2(debug2),
       .debug3(debug3)
    );

//Make connections between Tx module and TOP inputs and outputs and the other modules
UART_rs232_tx I_RS232TX(
   	.Clk(o_clk)            	,
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
    	.Clk(o_clk)               ,
    	.Rst_n(Rst_n)           ,
    	.Tick(tick)             ,
    	.BaudRate(BaudRate)
    );
    
 
    
 always@(*)begin
    if(Rx == 1)begin
        rx_test = 1;
        rx_test_x = 1;
    end
    else if(Rx == 0)begin
        rx_test = 1;
        rx_test_x = 0;
    end
    else begin
        rx_test = 0;
        rx_test_x = 1;
    end
    
    if(RxDone == 1)begin
        RxDone_test = 1;
    end
 end



endmodule
