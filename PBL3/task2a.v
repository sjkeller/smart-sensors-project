`include "uart_tx_8n1.v"
`include "baud_clk_generator.v"

module task2a (
    input wire clk,
    output wire uart_tx
);
    
    reg bclk_en = 1;
    wire baud_clk;
    
    reg send_enable = 1;
    reg [7:0] send_data = 42; //Data value to send
    
    wire uart_busy;
    

    // Instanciate Baud Clock Generator
    baud_clk_generator bclk(clk, bclk_en, baud_clk);
    
    
    // Instanciate UART
    uart_tx_8n1 uart(  baud_clk,
		    send_enable,
		    send_data,
		    uart_busy,
		    uart_tx       );
    

endmodule
