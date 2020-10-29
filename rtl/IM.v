module IM
(
    input  	  [31:0]	  	addr_i,

    output reg [31:0]    rd_o
  );

reg [31:0] data [0:63];

initial $readmemb ("E:/Studies/3_course/1_semestr/FPGA/labs/rtl/data.txt", data);

always @ ( * ) begin
      rd_o <= ((addr_i >= 32'h66000000 ) && ( addr_i <= 32'h660000FC )) ? data[ addr_i[7:2] ] : 32'b0;
end

endmodule
