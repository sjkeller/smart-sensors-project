`include "alu.v"

module test;

    reg [2:0] operation;
    reg [31:0] data_a;
    reg [31:0] data_b;

    wire [31:0] result;

    'define add 0;
    'define mul 1;
    'define exor 7;

    alu calculator (operation, data_a, data_b, result);

    initial begin
        $display ("Simulation started!");
        operation = 'add;
        A = 1;
        B = 2;
        $diplay("%d", calculator);
        $diplay("Simulation ended");

endmodule
