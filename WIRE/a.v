module a(
    output reg CLOCK_A
    );

    always begin
        // clock of period 20 time units
        CLOCK_A = 0;
        #10;
        CLOCK_A = 1;
        #10;
    end
endmodule