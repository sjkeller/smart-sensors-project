`include "threshold.v"
`include "mavg.v"

module processing (
    input update_clk,
    input [15:0] data_x,
    output signed [15:0] data_mavg_out, // data from moving average filter
    output thres_val
);

    wire update_clk;
    wire [15:0] data_x;

    //Modules

    threshold thres(data_mavg_out, thres_val);

    mavg movavg(update_clk, data_x, data_mavg_out);

endmodule
