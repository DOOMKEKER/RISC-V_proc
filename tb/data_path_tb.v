`timescale 1ns / 1ps
`include "../rtl/defines.v"

module data_path_tb();
reg          clk_i;
wire   [6:0] HEX_1;
wire   [6:0] HEX_2;
reg          reset;

data_path d_p (clk_i, reset, HEX_1, HEX_2);

localparam CLK_FREQ_MHZ   =     5;//100MHz
localparam CLK_SEMI       =     CLK_FREQ_MHZ / 2;

initial begin
  clk_i = 1'b1;
  forever begin
    #CLK_SEMI clk_i = ~clk_i;
  end
end

initial begin
	reset = 0;
	#3
	reset = 1;
	#3
	reset = 0;
	
end

endmodule