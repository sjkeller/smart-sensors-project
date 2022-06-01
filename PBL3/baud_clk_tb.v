`include "baud_clk_generator.v"

`timescale 1ns / 1ps


module baud_clk_tb ();

baud_clk_generator #( .CLK_PER_BIT(4) ) dut(
	.clk( clk ),
	.enable (enable),
	.baud_clk (out_baud_clk)
);

reg clk;
reg enable;
wire out_baud_clk;



// generate the clock
initial begin

$dumpfile("test_baud_clk.vcd");
    $dumpvars(0, baud_clk_tb);
	clk = 1'b0;
	forever #1 clk = ~clk;
end

// Generate the reset
initial begin
	enable = 1'b0;
	#10
	enable = 1'b1;
end



initial begin
    // Use the monitor task to display the FPGA IO
    $monitor("time=%3d, clk=%b, enable=%b, baud_clk=%2b \n", 
              $time, clk, enable, out_baud_clk);

    
  end


endmodule // baud_clk_tb