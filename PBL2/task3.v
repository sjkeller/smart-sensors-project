// Task 3

// SW 1 or SW 4 -> Green LED
// SW 2 -> Blue LED inverted

// Remember: switches are active low (pressed = 0, released = 1) -> inverted with "!"

/* module */
module simple_task3 (

    input switch1,
    input switch2,
    input switch3,
    input switch4,
    output led_green,
    output led_blue
);

    /* reg */
    reg led_green;
    reg led_blue;

    wire [3:0] state = {!switch1, !switch2, !switch3, !switch4};
    
    
    always @ (state) begin
        case (state)

        4'b1111:   begin
                    led_blue <= 1;
                    led_green <= 0;
                 end
        
        4'b1001:   begin
                    led_blue <= 1;
                    led_green <= 0;
                 end
        4'b1010:   begin
                    led_blue <= 1;
                    led_green <= 0;
                 end
        4'b0011: begin
                    led_blue <= 1;
                    led_green <= 0;
                 end
        4'b1100: begin
                    led_blue <= 0;
                    led_green <= 1;
                 end
        4'b0101: begin
                    led_blue <= 0;
                    led_green <= 1;
                 end
        4'b0110: begin
                    led_blue <= 0;
                    led_green <= 1;
                 end
        4'b0111: begin
                    led_blue <= 0;
                    led_green <= 1;
                 end
        
        default: begin
                    led_blue <= 0;
                    led_green <= 0;
                 end
        endcase
    end



endmodule