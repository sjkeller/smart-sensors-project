`include "uart_tx_8n1.v"


`timescale 1ns / 1ps




module uart_tb ();

    // instanciate design under test
    uart_tx_8n1 dut(
        .baud_clk( clk ),
        .en (enable),
        .data (data),
        .busy (busy),
        .uart_tx (tx)
    );

    reg clk;
    reg enable;
    reg [7:0] data = 8'b01010101;

    wire busy;
    wire tx;



    // generate the clock
    initial begin

    $dumpfile("test_uart_tb.vcd");
        $dumpvars(0, uart_tb);
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    // Generate the reset
    initial begin
        enable = 1'b0;
        #10
        enable = 1'b1;
        forever #15 enable = ~enable;
    end





    initial begin
        // Use the monitor task to display the FPGA IO
        $monitor("time=%3d, clk=%b, enable=%b, busy=%b, data=%8b, tx=%b \n", 
                $time, clk, enable, busy, data, tx);



        # 200 $finish;
    end


endmodule // uart_tb