`include "top.v"


`timescale 1ns / 1ps




module top1_tb ();

    // instanciate design under test
    top dut(
        clk,
        /*switch1,
        switch2,
        switch3,
        switch4,
        out1,
        out2,
        */
        tx

    );

    reg clk;

    reg switch1, switch2, switch3, switch4;
    wire out1, out2;

    wire tx;



    // generate the clock
    initial begin

    $dumpfile("test_top1_tb.vcd");
        $dumpvars(0, top1_tb);
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