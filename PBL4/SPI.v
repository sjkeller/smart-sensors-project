/* module */
module SPI (
    input wire clk,
    input wire en,
    input wire rw,
    inout wire [7:0] data,
    input wire [5:0] address,
    output reg busy,
    output reg SPI_CLK,
    output reg SPI_CS,
    output reg SPI_MOSI,
    input wire SPI_MISO,
    //parameter CPOL
    
);


    parameter SPI_HIGH = 1'b1;
    parameter SPI_LOW = 1'b0;
    parameter CPOL = 0;

    initial busy = 0; // is currently sending data
    
    wire [0:7] send_address = {rw, SPI_LOW, address};
    
    reg [4:0] counter = 0; 
        
    always @ (posedge clk) begin    
    
    end

    always @ (negedge clk) begin    
    
    end

endmodule
