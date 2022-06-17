`include "clk_generator.v"


/* module */
module SPI (
    input wire clk,
    input wire en,
    input wire rw,
    inout [7:0] data,
    input wire [5:0] address,
    output reg busy,
    output wire spi_clk,
    output reg spi_cs,
    output reg spi_mosi,
    input wire spi_miso
);

    clk_generator spi_clk_generator(
	.clk( clk ),
	.enable (spi_clk_enable),
	.out_clk (spi_clk_gen)
    );


    wire spi_clk_gen;

    assign spi_clk = spi_cs || spi_clk_gen; //clock should be high when cs high (chip not selected)


    parameter SPI_HIGH = 1'b1;
    parameter SPI_LOW = 1'b0;

    parameter STATE_IDLE = 0;
    parameter STATE_SENDADDRESS = 1; 
    parameter STATE_SENDDATA = 2;
    parameter STATE_READDATA = 3;

    initial busy = 0; // is currently sending data = 1

    initial spi_cs = 1; //chip not selected = 1

    reg spi_clk_enable = 1;
    
    wire [0:7] send_address = {rw, SPI_LOW, address};

    reg [7:0] read_data = 0;

    assign data = (rw) ? read_data: 8'bzzzzzzzz;
    
    reg [4:0] counter = 0;

    reg [2:0] state = 0;
        
    always @ (posedge spi_clk_gen) begin
        if (busy==1) begin           

            if (counter==7) begin
                counter <= 0;
                //busy <= 0;

                case (state)
                    STATE_SENDADDRESS : begin                        
                        state = (rw==0)? STATE_SENDDATA : STATE_READDATA;
                    end
                    default : begin
                        state = STATE_IDLE;
                        busy <= 0;
                        spi_cs = 1;
                    end
                endcase

            end else begin
                if(state == STATE_READDATA) 
                        read_data[counter] <= spi_miso;
                else
                    counter <= counter + 1;
            end
        end else begin
            counter <= 0;
            busy <= en;
            spi_cs = ~en;
            state <= STATE_SENDADDRESS;
        end
    end

    always @ (negedge spi_clk_gen) begin
        if (busy==1) begin    
            case (state)
                STATE_SENDADDRESS : begin
                    spi_mosi <= send_address[counter];
                end
                STATE_SENDDATA : begin
                    spi_mosi <= data[counter];
                end
                STATE_READDATA : begin
                    counter <= counter + 1;
                end
            endcase
        end
    end

endmodule
