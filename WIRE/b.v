module b(
    input wire CLOCK_B,
    output reg CLOCK_B2
    );

    always begin
        CLOCK_B2 = 0;
        @(CLOCK_B); // wait 2 clock cycles, can also be implementes with iterator
        @(CLOCK_B);
        CLOCK_B2 = 1;
        @(CLOCK_B);
        @(CLOCK_B);
    end
endmodule