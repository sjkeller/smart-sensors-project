`include "uart_tx_8n1.v"
`include "baud_clk_generator.v"

module task2a_extra_count (
    input wire clk,
    output wire uart_tx
);
    
    reg bclk_en = 1;
    wire baud_clk;
    
    reg send_enable = 1;
    reg [7:0] send_data = 0;
    
    wire uart_busy;    

    reg[20:0] wait_cnt = 0; //wait short time between sending to uart
    
    // Instanciate Baud Clock Generator
    baud_clk_generator bclk(clk, bclk_en, baud_clk);
    
    // Instanciate UART
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
            wait_cnt = wait_cnt + 1;
            if(wait_cnt == 0) begin
                send_data = send_data + 1;
                send_enable = 1;
            end
            
        end
        else if(uart_busy == 1 && send_enable==1)
        begin
            send_enable = 0;
        end
    end


    

endmodule
