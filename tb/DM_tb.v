`timescale 1ns / 1ps
`include "../rtl/defines.v"

module DM_tb();
reg          clk_i;
reg   [31:0] addr_i;
reg   [31:0] wd_i;
reg          we;

wire  [31:0] rd;

DM DUT (clk_i, addr_i, wd_i, we, rd);

task DM_test;
  input integer inp_addr;
  input integer inp_data;


  begin
    addr_i = inp_addr;
    wd_i   = inp_data;
    #50
    $display("--------------");
    $display(" addr_i = %d,", addr_i-32'h66000000, " wd_i = %d;", wd_i);
    $display("out_daata = %d", rd);
  end
endtask

localparam CLK_FREQ_MHZ   =     5;//100MHz
localparam CLK_SEMI       =     CLK_FREQ_MHZ / 2;


initial begin
we = 0;
DM_test(32'h66000001,32'h0);
DM_test(32'h66000002,32'h0);
we = 1;
DM_test(32'h66000003,32'b11111011111110111011111111111111);
we = 0;
DM_test(32'h66000003,32'b11111011111110111111111111111111);
we = 1;
DM_test(32'h66000013,32'b00000000000000000000000000001001);
we = 0;
DM_test(32'h66001000,32'b11111011111110111011111111111111);
end

initial begin
  clk_i = 1'b1;
  forever begin
    #CLK_SEMI clk_i = ~clk_i;
  end
end

endmodule
