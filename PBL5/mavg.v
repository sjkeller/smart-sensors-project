module mavg
	#(parameter N=10) (
    input update_clk,
    input signed [15:0] data_x,
    output signed [15:0] data_out
);

reg data_out;

reg[15:0] mem[0:N-1]; //N Locations

integer i;

always @(posedge update_clk) begin //Clked process assignmnets use non-blocking(<=)  
  
    mem[0]<=data_x;

    for ( i = 1; i < N; i = i + 1) begin
        mem[i] <= mem[i-1];  
    end

end


always @* begin

    data_out = 0;

    for ( i = 0; i < N; i = i + 1) begin
        data_out = data_out + ( mem[i] / N );  
    end

end

endmodule