`include "uart_tx_8n1.v"
`include "baud_clk_generator.v"

// Description: (Task 2b (continuous))
// Continuously send the state of the switches via uart (last 4 bits).


// Remember: switches are active low (pressed = 0, released = 1) -> inverted with "!"

module task2b_continuous (
    input wire clk,
    output wire uart_tx,
    input wire switch1,
    input wire switch2,
    input wire switch3,
    input wire switch4
    );
    
    reg bclk_en = 1;
    wire baud_clk;
    
    reg send_enable = 1;
    
    // Data contains the current state of the switches
    wire [7:0] send_data = {4'b0000, !switch1, !switch2, !switch3, !switch4};
    
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
