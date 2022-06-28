`include "threshold.v"

module worker (
    input update_clk,
    input [15:0] data_x,

    output threshold
);

    wire update_clk;
    wire [15:0] data_x;

    //Modules

    threshold thres(update_clk, data_x, thres);



    // if positive edge of update_clk take new value of data_x and calculate the new values
    always @(posedge update_clk)
    begin
      
           
    end


    

endmodule
