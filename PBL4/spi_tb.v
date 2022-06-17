`include "SPI.v"


`timescale 1ns / 1ps


module spi_tb ();

    // instanciate design under test
    SPI dut(
        .clk( clk ),
        .en (enable),
        .rw (rw),
        .data (data),
        .address (address),
        .busy (busy),
        .spi_clk (spi_clk),
        .spi_cs (spi_cs),
        .spi_mosi (spi_mosi),
        .spi_miso (spi_miso)
    );

    reg clk;
    reg enable;

    reg [7:0] set_data = 8'b10101010;
    wire [7:0] data = (rw) ? 8'bzzzzzzzz : set_data;

    wire busy;
    wire spi_clk;
    wire spi_cs;
    wire spi_mosi;
    reg spi_miso = 0;
    reg rw = 1;
    reg [5:0] address = 6'b111000;



    // generate the clock
    initial begin

    $dumpfile("test_spi_tb.vcd");
        $dumpvars(0, spi_tb);
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    // Generate the reset
    initial begin
        enable = 1'b0;
        #10
        enable = 1'b1;
        //forever #30 enable = ~enable;
    end

    always @ (negedge spi_clk)  spi_miso <= ~ spi_miso;




    initial begin
        // Use the monitor task to display the FPGA IO
        $monitor("time=%3d, clk=%b, enable=%b, busy=%b, data=%8b, cs = %b, spi_clk = %b, spi_mosi = %b, spi_miso = %b \n", 
                $time, clk, enable, busy, data, spi_cs, spi_clk, spi_mosi, spi_miso);



        # 1000 $finish;
    end


endmodule // uart_tb