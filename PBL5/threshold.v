module threshold
	#(parameter THRESHOLD=35) (
    input update_clk,
    input [15:0] data_x,
    output is_over_threshold
);

reg is_over_threshold = 0;

always @(posedge update_clk)
begin
      is_over_threshold <= (data_x > THRESHOLD) | (data_x < -THRESHOLD);           
end

endmodule