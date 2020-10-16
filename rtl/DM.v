module DM
  (
    input           clk_i,
    input  [31:0]   addr_i,
    input  [31:0]   wd_i,
    input           we_i,

    output [31:0]   rd_i
  );

reg [31:0] data [0:63];

initial $readmemb ("E:\\Studies\\3_course\\1_semestr\\FPGA\\labs\\rtl\\data.txt", data);

assign rd_i = ((addr_i >= 32'h66000000 ) && ( addr_i <= 32'h660000FC )) ? data[ addr_i[7:0] ] : 32'b0;

always @ ( posedge clk_i ) begin
  if ( we_i ) begin
      data[addr_i[7:0]] = wd_i;
  end
end

endmodule //DM
