/* module */
module uart_tx_8n1 (
    input wire baud_clk,
    input wire en,
    input wire [7:0] data,
    output reg busy,
    output reg uart_tx
);

    parameter UART_HIGH = 1'b1;
    parameter UART_LOW = 1'b0;

    initial busy = 0; // is currently sending data
    initial uart_tx = UART_HIGH; // idlestate = 1    
	 
    
    wire [0:9] send_data = {UART_LOW, data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7], UART_HIGH};    
    
    reg [4:0] counter = 0; // value: 0 startbit, 1-8 data bits index, 9 stop bit
        
    always @ (posedge baud_clk) begin    	
        if (busy==1) 
        begin
    		uart_tx <= send_data[counter];
    		counter <= counter + 1;
				
			if(counter==9) busy <= 0;	

        end else begin
			counter <= 0;				
    		busy <= en;
		end
    end
endmodule
