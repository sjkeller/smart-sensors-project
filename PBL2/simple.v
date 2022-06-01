// Task 1 and 2


// SW 1 or SW 4 -> Green LED
// SW 2 -> Blue LED inverted

// Remember: switches are active low (pressed = 0, released = 1) -> inverted with "!"

/* module */
module simple (

    input switch1,
    input switch2,
    input switch4,
    output led_green,
    output led_blue
);

    /* reg */
    reg led_green;
    reg led_blue;
    
    
    always @ (switch1, switch2, switch4) begin
        led_green <= !switch1 || !switch4;
        led_blue <= switch2;
    end


endmodule