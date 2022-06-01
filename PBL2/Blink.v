module top (input wire clk,
	    input wire enable,
	    output reg LED);

    reg [30:0] cnt;

    always @(posedge clk)
    begin

		if(enable == 1'b1) 
        	cnt = cnt + 1;
		else  
			cnt = 0;
		LED = cnt[24];		
    end

endmodule

 