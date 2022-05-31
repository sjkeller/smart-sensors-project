`include "uart.v"
`include "baud_clk_generator.v"

module top (
    input wire clk,
    output wire uart_tx
);
    
    reg bclk_en = 1;
    
    reg send_enable = 0;
    reg [7:0] send_data = 0;
    
    wire uart_busy;
    
    wire baud_clk;

    reg[12:0] wait_cnt = 0;
    
    baud_clk_generator bclk(clk, bclk_en, baud_clk);
    
    uart_tx_8n1 uart(  baud_clk,
		    send_enable,
		    send_data,
		    uart_busy,
		    uart_tx       );


    // count
    always @(posedge clk)
    begin

        if(uart_busy == 0 && send_enable == 0)
        begin
            if(wait_cnt == 0) begin
                send_data = send_data + 1;
                send_enable = 1;
            end else begin
                wait_cnt = wait_cnt + 1;
            end
        end
        else if(uart_busy == 1 && send_enable==1)
        begin
            send_enable = 0;
        end
    end
    
    

endmodule
