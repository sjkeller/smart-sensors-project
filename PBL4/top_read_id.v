`include "uart_tx_8n1.v"
//`include "clk_generator.v"
`include "SPI.v"

module top_read_id (
    input clk,
    input spi_miso,
    output uart_tx,
    output spi_clk,
    output spi_cs,
    output spi_mosi
);

    wire clk;
    wire spi_miso;

    // UART Section ---------------------------------------------------

    reg uart_baud_clk_enable = 1;
    wire baud_clk;
    
    reg uart_send_enable = 1;
    reg [7:0] uart_send_data = 0;
    
    wire uart_busy; 
    wire uart_tx;

    // Instanciate Baud Clock Generator
    clk_generator #( .CLK_PER_BIT(625) ) uart_baud_clk_generator(clk, uart_baud_clk_enable, baud_clk);
    
    // Instanciate UART
    uart_tx_8n1 uart(  baud_clk,
		    uart_send_enable,
		    uart_send_data,
		    uart_busy,
		    uart_tx       );

    
    // SPI/Sensor Section ----------------------------------------------

    
    parameter SENSOR_ADDRESS_ID = 6'h00; // Expected Id = 11100101

    reg [0:7] set_spi_data = 8'b00000000;
    wire [0:7] spi_data = (spi_rw) ? 8'bzzzzzzzz : set_spi_data;
    reg spi_enable = 0;
    reg spi_rw = 1; // 1 = read
    wire spi_busy;
    wire spi_clk;
    wire spi_cs;
    wire spi_mosi;
    reg [0:5] spi_address = 0;

    // instanciate SPI acc sensor
    SPI spi_sensor(
        .clk( clk ),
        .spi_miso (spi_miso),
        .en (spi_enable),
        .rw (spi_rw),
        .data (spi_data),
        .address (spi_address),
        .busy (spi_busy),
        .spi_clk (spi_clk),
        .spi_cs (spi_cs),
        .spi_mosi (spi_mosi)
    );


    // LOGIC -----------------------------------------------------------

    reg[20:0] wait_cnt = 0; //wait short time
    

    parameter STATE_IDLE = 0;
    parameter STATE_START_READ_SPI = 1;
    parameter STATE_WAIT_READ_SPI = 2;
    parameter STATE_START_SEND_UART = 3;
    parameter STATE_WAIT_SEND_UART = 4;


    
    reg [7:0] state = STATE_IDLE;


    always @(posedge clk)
    begin
        case(state)
            STATE_IDLE : begin                        
                wait_cnt <= wait_cnt + 1;
                if(wait_cnt == 0) begin
                    state <= STATE_START_READ_SPI;
                end
            end

            STATE_START_READ_SPI : begin                        
                if(spi_busy == 0 && spi_enable == 0)
                begin
                    spi_rw <= 1;
                    set_spi_data <= 0;
                    spi_address <= SENSOR_ADDRESS_ID;
                    spi_enable <= 1;
                end
                else if(spi_busy == 1 && spi_enable == 1)
                begin
                    spi_enable <= 0;
                    state <= STATE_WAIT_READ_SPI;
                end
            end

            STATE_WAIT_READ_SPI : begin                        
                if(spi_busy == 0)
                begin
                    uart_send_data <= spi_data;
                    state <= STATE_START_SEND_UART;
                end
            end

            STATE_START_SEND_UART : begin                        
                if(uart_busy == 0 && uart_send_enable == 0)
                begin
                    uart_send_enable <= 1;
                end
                else if(uart_busy == 1 && uart_send_enable == 1)
                begin
                    uart_send_enable <= 0;
                    state <= STATE_WAIT_SEND_UART;
                end
            end

            STATE_WAIT_SEND_UART : begin                        
                if(uart_busy == 0)
                begin
                    state <= STATE_IDLE;
                end
            end

            default : begin

            end
        endcase
      
           
    end


    

endmodule
