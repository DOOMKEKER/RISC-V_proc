module IM
(
    input  	  [31:0]	  	addr_i,

    output reg [31:0]    rd_o
  );

reg [31:0] data [0:63];

initial $readmemb ("E:/Studies/3_course/1_semestr/FPGA/labs/rtl/data.txt", data);

always @ ( * ) begin
      rd_o <= data[addr_i[31:2]];//
end

endmodule
