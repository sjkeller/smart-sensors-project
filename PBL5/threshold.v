module threshold
	#(parameter THRESHOLD=35) (
    input signed [15:0] data_x,
    output is_over_threshold
);

wire is_over_threshold = (data_x > THRESHOLD) | (data_x < -THRESHOLD);


endmodule