module IM
(
    input     [31:0]    addr_i,

    output    [31:0]    rd_o
  );

reg [31:0] data [0:63];

initial $readmemh ("E:/Studies/3_course/1_semestr/FPGA/labs/ASM/code.txt", data);

assign  rd_o = data[ addr_i[7:2] ];

endmodule
