`timescale 1ns / 10ps
`include "../rtl/defines.v"

module silly_kernel_tb();
  reg           clk_i;
  reg    [9:0]  SW_i;

  wire   [6:0]  HEX_1_o;
  wire   [6:0]  HEX_2_o;


silly_kernel krk ( clk_i, SW_i, HEX_1_o, HEX_2_o);

localparam CLK_FREQ_MHZ   =     5;//100MHz
localparam CLK_SEMI       =     CLK_FREQ_MHZ / 2;


task silly_kernel_tb_test;
	input integer SW;

	begin
	SW_i = SW;
	$display("--------------------------------------------");
   $display("SW     addr_1_i = %d   ", SW_i );
   $display("HEX 	    HEX 1  = %d  ",HEX_1_o,"   HEX 2 = %d",HEX_2_o);
	end
endtask

initial begin
  clk_i = 1'b0;
  forever begin
    #CLK_SEMI clk_i = ~clk_i;
  end
end

initial silly_kernel_tb_test(0);



endmodule
