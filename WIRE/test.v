`include "a.v"
`include "b.v"

module test;

    wire CLK, CLK2;
    a module_a (CLK);
    b module_b (CLK, CLK2);

    always @(CLK)
        $display("1st main clock");
    
    always @(CLK2)
        $display("2nd main clock");

    initial begin
        #100;
        $finish;
    end

endmodule