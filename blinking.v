// blinking a LED

/* module */
module blinking (

    input CLOCK,
    output LED
    
);

    /* reg */
    reg [31:0] counter = 31'b0;
    reg state;
    
    initial state = 1'b0;

    /* assign */
    assign LED = state;
    
    /* always */
    always @ (posedge CLOCK) begin
        counter <= counter + 1;
        state <= counter[5]; // <------ data to change
    end

endmodule