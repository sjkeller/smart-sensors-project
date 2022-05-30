// SW 1 or SW 4 -> Green LED
// SW 2 -> Blue LED inverted

// Remember: switches are active low (pressed = 0, released = 1) -> inverted with "!"

/* module */
module uart_tx_8n1 (

    
    input wire CLOCK,
    input wire en,
    input data,
    output wire busy,
    output uart_tx,
);

    /* reg */
   	reg [7:0] data;
    reg uart_tx;
    
    
    always @ (CLOCK, en) begin
		// Date rec and transmit 
    end


endmodule