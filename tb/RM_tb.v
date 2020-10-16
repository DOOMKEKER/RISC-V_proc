`timescale 1ns / 1ps
`include "../rtl/defines.v"

module RM_tb();
reg             clk_i;
reg     [4:0]   addr_1_i;
reg     [4:0]   addr_2_i;
reg     [4:0]   addr_3_i;
reg             WE3_i;
reg     [31:0]  WD3_i;
reg             reset_i;

wire    [31:0]  RD_1_o;
wire    [31:0]  RD_2_o;

RF dit ( clk_i, addr_1_i, addr_2_i, addr_3_i, WE3_i, WD3_i, reset_i, RD_1_o, RD_2_o);

task RF_test;
  input integer addr_1;
  input integer addr_2;
  input integer addr_3;
  input integer WD3;

  begin
  addr_1_i = addr_1;
  addr_2_i = addr_2;
  addr_3_i = addr_3;
  WD3_i  =  WD3;
  #10
  $display("--------------------------------------------");
  $display("ADDR     addr_1_i = %d   ||||,", addr_1_i, " addr_2_i = %d   |||||", addr_2_i," addr_3_i = %d;   ",addr_3_i );
  $display(" WD               = %d  ", WD3_i);
  $display("RD_1 = %d       ", RD_1_o, "RD_2 = %d",RD_2_o);
  end
endtask

localparam CLK_FREQ_MHZ   =     5;//100MHz
localparam CLK_SEMI       =     CLK_FREQ_MHZ / 2;

initial begin
  clk_i = 1'b1;
  forever begin
    #CLK_SEMI clk_i = ~clk_i;
  end
end

initial begin
  WE3_i   = 1;
  reset_i = 0;
  RF_test(4'b0001,4'b0010,4'b0001,32'b00000000000000000000000000000001);
  RF_test(4'b0001,4'b0010,4'b0010,32'b00000000000000000000000000000001);
  RF_test(4'b0000,4'b0001,4'b0101,32'b00000000000000000000000000000001);
  reset_i = 1;
  #10;
  RF_test(4'b0001,4'b0010,4'b0101,32'b00000000000000000000000000000001);
end

endmodule
