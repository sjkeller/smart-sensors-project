module baud_clk_generator
	#(parameter CLK_PER_BIT=1250) (
	    input wire clk,
	    input wire enable,
	    output reg baud_clk);

    reg [30:0] cnt = 0;
    
	initial baud_clk = 0;

    always @(posedge clk)
    begin

		if(enable == 1'b1) 
        		cnt = cnt + 1;
		else  
			cnt = 0;
		
		if(cnt >= CLK_PER_BIT)
		begin
			cnt = 0;
			baud_clk = ~baud_clk;
		end	
    end
    

endmodule

 
