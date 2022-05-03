`include "blinking.v"

`timescale 1ns / 1ps


module blinking_tb ();

blinking dut(

	.CLOCK (clk),
	.LED( LED )
    );

reg clk;
wire LED;

// generate the clock
initial begin

$dumpfile("blinking_tb.vcd");
    $dumpvars(0, blinking_tb);
	clk = 1'b0;
	forever #1 clk = ~clk;
end

// Generate the reset
// initial begin
// end



initial begin
    // Use the monitor task to display the FPGA IO
    $monitor("time=%3d, LED=%b, clk=%b \n", 
              $time, LED, clk);
    
  end


endmodule // blinking_tb