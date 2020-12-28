module RF
(
  input             clk_i,
  input     [4:0]   addr_1_i,
  input     [4:0]   addr_2_i,
  input     [4:0]   addr_3_i,
  input             WE3_i,
  input     [31:0]  WD3_i,
  input             reset_i,

  output [31:0]  RD_1_o,
  output [31:0]  RD_2_o
);

  reg [31:0] RAM [0:31];
  integer i;
  assign RD_1_o = (addr_1_i == 0 ) ? 32'b0 : RAM[addr_1_i];
  assign RD_2_o = (addr_2_i == 0 ) ? 32'b0 : RAM[addr_2_i];

  always @ ( posedge clk_i ) begin
    if (WE3_i) RAM[addr_3_i] <= WD3_i;
    if (reset_i) begin
      for(i = 0; i < 32; i = i + 1 ) begin
        RAM[i] <= 32'b0;
      end
    end
  end

endmodule //RF
