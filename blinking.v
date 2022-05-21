// SW 1 or SW 4 -> Green LED
// SW 2 -> Blue LED inverted

// Remember: switches are active low (pressed = 0, released = 1) -> inverted with "!"

/* module */
`include "Blink.v"

module blinking (
	
	input CLOCK,
    input switch1,
    input switch2,
    input switch4,
    output wire led_green,
    output wire led_blue
);


    
    top led_1 (CLOCK, !switch1, led_green);
    top led_2 (CLOCK, !switch2, led_blue);
    
    
    /*always @ (switch1, switch2, switch4) begin
        led_green <= !switch1 || !switch4;
        led_blue <= switch2;
    end*/

endmodule