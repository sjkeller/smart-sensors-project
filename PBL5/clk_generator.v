module clk_generator
	#(parameter CLK_PER_BIT=200) ( 
	    input wire clk,
	    input wire enable,
	    output reg out_clk);

    reg [30:0] cnt = 0;
    
	initial out_clk = 0;

    always @(posedge clk)
    begin

		if(enable == 1'b1) 
        		cnt = cnt + 1;
		else  
			cnt = 0;
		
		if(cnt >= CLK_PER_BIT)
		begin
			cnt = 0;
			out_clk = ~out_clk;
		end

    end    

endmodule

 
