module DM
  (
    input 			   	    clk_i,
	  input 	[31:0] 	    a_i  ,
	  input 	[31:0] 	    wd_i ,
	  input   [2:0]       mem_size_i,
	  input 			   	    mem_req_i,
	  input 			   	    mem_we_i,
	  input 			   	    reset,
	  output reg	[31:0] 	rd_o
  );

reg [31:0] STATIC [0:511];
reg [31:0] HEAP 	[0:511];
reg [31:0] STACK 	[0:511];

//initial $readmemb ("E:\\Studies\\3_course\\1_semestr\\FPGA\\labs\\rtl\\data.txt", data);

assign rd_i = ((addr_i >= 32'h66000000 ) && ( addr_i <= 32'h660000FC )) ? data[ addr_i[7:0] ] : 32'b0;

always @ ( posedge clk_i ) begin
  if ( we_i ) begin
      data[addr_i[7:0]] = wd_i;
  end
end

endmodule //DM
