module DM
  (
    input           clk_i,
    input  [31:0]   addr_i,
    input  [31:0]   wd_i,
    input           we_i,

    output [31:0]   rd_o
  );

reg [31:0] STATIC [0:512];
reg [31:0] HEAP   [0:512];
reg [31:0] STACK  [0:512];

initial begin
  $readmemh("E:/Studies/3_course/1_semestr/FPGA/labs/static.txt", STATIC);
  $readmemh("E:/Studies/3_course/1_semestr/FPGA/labs/heap.txt",     HEAP);
  $readmemh("E:/Studies/3_course/1_semestr/FPGA/labs/stack.txt",    STACK);
end

always @ ( * ) begin
  if      ( (addr_i >= `STATIC_BEGIN ) && ( addr_i <= `STATIC_END) )  rd_o <= STATIC[ addr_i[7:2] ];
  else if ( (addr_i >= `HEAP_BEGIN ) && ( addr_i <= `HEAP_END ) )       rd_o <= HEAP[ addr_i[7:2] ];
  else if ( (addr_i >= `STACK_BEGIN ) && ( addr_i <= `STACK_END ) )    rd_o <= STACK[ addr_i[7:2] ];
end

always @ ( posedge clk_i ) begin
  if ( we_i ) begin
    if      (addr_i >= `STATIC_END ) && ( addr_i <= `STATIC_END ) ) STATIC[ addr_i[7:2] ] <= wd_i;
    else if (addr_i >= `HEAP_BEGIN ) && ( addr_i <= `HEAP_END ) )     HEAP[ addr_i[7:2] ] <= wd_i;
    else if (addr_i >= `STACK_BEGIN ) && ( addr_i <= `STACK_END) )  STACK[ addr_i[7:2] ]  <= wd_i;
  end
end

endmodule //DM
