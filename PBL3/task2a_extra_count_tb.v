`include "task2a_extra_count.v"


`timescale 1ns / 1ps




module task2a_extra_count_tb ();

    // instanciate design under test
    task2a_extra_count dut(
        clk,
        tx
    );

    reg clk;

    reg switch1, switch2, switch3, switch4;
    wire out1, out2;

    wire tx;



    // generate the clock
    initial begin

    $dumpfile("task2a_extra_count_tb.vcd");
        $dumpvars(0, task2a_extra_count_tb);
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    // Generate the reset
    initial begin
    end





    initial begin
        // Use the monitor task to display the FPGA IO
        $monitor("time=%3d, clk=%b, tx=%b \n", 
                $time, clk,  tx);



        #3000 $finish;
    end


endmodule // uart_tb