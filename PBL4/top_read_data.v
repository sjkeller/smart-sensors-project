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
    parameter SENSOR_ADDRESS_POWER_CTL = 6'b101101;//6'h2D;
    parameter SENSOR_ADDRESS_DATA_FORMAT = 6'b110001;//6'h31;
    parameter SENSOR_ADDRESS_DATAX0 = 6'b110010;//6'h32;//6'b010011; // X-axis data 0
    parameter SENSOR_ADDRESS_DATAX1 = 6'h33; // X-axis data 1

    parameter SENSOR_ADDRESS_DATAZ0 = 6'h36;
    
    parameter SENSOR_ADDRESS_BWRATE = 6'h2C;

    parameter DATA_FOR_POWER_CTRL = 8'b00001000; // 0x08
    parameter DATA_FOR_DATA_FORMAT = 8'b00000001; // 0x01

    reg [0:7] set_spi_data = 8'b10101010;
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
    
    parameter STATE_START_WAIT= 1;
    
    parameter STATE_INIT1_START= 2;
    parameter STATE_INIT1_WAIT= 3;
    parameter STATE_INIT2_START= 4;
    parameter STATE_INIT2_WAIT= 5;

    parameter STATE_START_READ_SPI = 6;
    parameter STATE_WAIT_READ_SPI = 7;
    
    parameter STATE_START_READ_SPI_2 = 8;
    parameter STATE_WAIT_READ_SPI_2 = 9;

    parameter STATE_START_SEND_UART = 10;
    parameter STATE_WAIT_SEND_UART = 11;
    
    parameter STATE_START_SEND_UART_2 = 12;
    parameter STATE_WAIT_SEND_UART_2 = 13;

    
    reg [7:0] data_x0 = 0;
    reg [7:0] data_x1 = 0;

    wire [15:0] data_x = {data_x1, data_x0};

    
    reg [7:0] state = STATE_START_WAIT;


    always @(posedge clk)
    begin
        case (state)
            STATE_START_WAIT : begin                        
                wait_cnt <= wait_cnt + 1;
                if(wait_cnt == 0) begin
                    state <= STATE_INIT1_START;
                end
            end

            // Init -----------------------
            STATE_INIT1_START : begin                        
                if(spi_busy == 0 && spi_enable == 0)
                begin
                    spi_rw <= 0;
                    set_spi_data <= DATA_FOR_DATA_FORMAT; 
                    spi_address <= SENSOR_ADDRESS_DATA_FORMAT;
                    spi_enable <= 1;
                end
                else if(spi_busy == 1 && spi_enable == 1)
                begin
                    spi_enable <= 0;
                    state <= STATE_INIT1_WAIT;
                end
            end

            STATE_INIT1_WAIT : begin                        
                if(spi_busy == 0)
                begin
                    wait_cnt <= wait_cnt + 1;
                    if(wait_cnt == 0) begin
                        state <= STATE_INIT2_START;
                    end
                end
            end

            STATE_INIT2_START : begin                        
                if(spi_busy == 0 && spi_enable == 0)
                begin
                    spi_rw <= 0;
                    set_spi_data <= DATA_FOR_POWER_CTRL; // 0x08
                    spi_address <= SENSOR_ADDRESS_POWER_CTL;
                    spi_enable <= 1;
                end
                else if(spi_busy == 1 && spi_enable == 1)
                begin
                    spi_enable <= 0;
                    state <= STATE_INIT2_WAIT;
                end
            end

            STATE_INIT2_WAIT : begin                        
                if(spi_busy == 0)
                begin
                    wait_cnt <= wait_cnt + 1;
                    if(wait_cnt == 0) begin
                        state <= STATE_IDLE;
                    end
                    
                end
            end


            // -----------------------------


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
                    spi_address <= SENSOR_ADDRESS_DATAX0;
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
                    data_x0 <= spi_data;
                    state <= STATE_START_READ_SPI_2;
                end
            end

            STATE_START_READ_SPI_2 : begin                        
                if(spi_busy == 0 && spi_enable == 0)
                begin
                    spi_rw <= 1;
                    set_spi_data <= 0;
                    spi_address <= SENSOR_ADDRESS_DATAX1;
                    spi_enable <= 1;
                end
                else if(spi_busy == 1 && spi_enable == 1)
                begin
                    spi_enable <= 0;
                    state <= STATE_WAIT_READ_SPI_2;
                end
            end

            STATE_WAIT_READ_SPI_2 : begin                        
                if(spi_busy == 0)
                begin
                    data_x1 <= spi_data;
                    state <= STATE_START_SEND_UART;
                end
            end

            STATE_START_SEND_UART : begin                        
                if(uart_busy == 0 && uart_send_enable == 0)
                begin
                    uart_send_data <= data_x1;
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
                    state <= STATE_START_SEND_UART_2;
                end
            end

            STATE_START_SEND_UART_2 : begin                        
                if(uart_busy == 0 && uart_send_enable == 0)
                begin
                    uart_send_data <= data_x0;
                    uart_send_enable <= 1;
                end
                else if(uart_busy == 1 && uart_send_enable == 1)
                begin
                    uart_send_enable <= 0;
                    state <= STATE_WAIT_SEND_UART_2;
                end
            end

            STATE_WAIT_SEND_UART_2 : begin                        
                if(uart_busy == 0)
                begin
                    state <= STATE_START_WAIT;
                end
            end

            default : begin

            end
        endcase
      
           
    end


    

endmodule
