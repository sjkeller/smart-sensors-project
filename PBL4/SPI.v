`include "clk_generator.v"


/* module */
module SPI (
    input wire clk,    
    input wire spi_miso,
    input wire en,
    input wire rw,
    inout [0:7] data,
    input wire [0:5] address,
    output reg busy,
    output wire spi_clk,
    output reg spi_cs,
    output reg spi_mosi
);

    clk_generator spi_clk_generator(
	.clk( clk ),
	.enable (spi_clk_enable),
	.out_clk (spi_clk_gen)
    );


    wire spi_clk_gen;

    assign spi_clk = spi_cs || spi_clk_gen || ~internal_busy; //clock should be high when cs high (chip not selected)


    parameter SPI_HIGH = 1'b1;
    parameter SPI_LOW = 1'b0;

    parameter STATE_IDLE = 0;
    parameter STATE_SENDADDRESS = 1; 
    parameter STATE_SENDDATA = 2;
    parameter STATE_READDATA = 3;

    initial busy = 0; // is currently sending data = 1
    reg internal_busy = 0;

    initial spi_cs = 1; //chip not selected = 1


    reg spi_clk_enable = 1;
    
    wire [0:7] send_address = {rw, SPI_LOW, address[0],address[1],address[2],address[3],address[4],address[5]};
    //reg [0:7] send_address = 8'b10010011;

    reg [0:7] read_data = 0;

    assign data = (rw) ? read_data: 8'bzzzzzzzz;
    
    reg [4:0] counter = 0;

    reg [2:0] state = 0;

    //reg [0:7] testwrite = 8'b10101010;

        
    always @ (posedge spi_clk_gen) begin
        if (internal_busy==1) begin        

            
            if(state == STATE_READDATA) begin
                    read_data[counter] <= spi_miso;
            end   

            if (counter==7) begin

                case (state)
                    STATE_SENDADDRESS : begin                        
                        state <= (rw==0)? STATE_SENDDATA : STATE_READDATA;                        
                        counter <= 0;
                    end
                    default : begin
                        
                        state <= STATE_IDLE;
                        internal_busy <= 0;
                    end
                endcase

            end
            else begin
                counter <= counter + 1;
            end
            
        end else begin            
            counter <= 0;
            
            if(state == STATE_IDLE) begin
                spi_cs <= 1;
                state <= STATE_SENDADDRESS;
            end
            else begin
                state <= STATE_SENDADDRESS;
                busy <= en;
                spi_cs <= ~en;            
                internal_busy <= en;
            end
            //read_data <= 0;
        end
    end

    always @ (negedge spi_clk_gen) begin
        if (internal_busy==1) begin    
            case (state)
                STATE_SENDADDRESS : begin
                    spi_mosi <= send_address[counter];
                end
                STATE_SENDDATA : begin
                    spi_mosi <= data[counter];
                end
                STATE_READDATA : begin
                    spi_mosi <= 0;
                end
            endcase
        end
    end

endmodule
