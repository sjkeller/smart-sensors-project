// blinking a LED

/* module */
module blinking (

    input CLOCK,
    output LED
    
);

    /* reg */
    reg [31:0] counter;
    reg state;
    
    /* assign */
    assign LED = state;
    
    /* always */
    always @ (posedge CLOCK) begin
        counter <= counter + 1;
        state <= counter[23]; // <------ data to change
    end

endmodule
