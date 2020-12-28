`timescale 1ns / 10ps
`include "../rtl/defines.v"

module data_path(
  input           clk_i,
  input    [9:0]  SW_i,
  input           reset,

  output   [6:0]  HEX_1_o,
  output   [6:0]  HEX_2_o
);

reg      [31:0]   instruction_addr;
wire     [31:0]   instruction;

reg      [31:0]   WD3;
wire     [31:0]   RD_1;
wire     [31:0]   RD_2;
wire     [31:0]   result;
wire              comparsion_result;

reg      [31:0]   ALU_1;
reg      [31:0]   ALU_2;

wire              jalr;
wire              jal;
wire              enpc;
wire              branch;
wire              ws;
wire     [2:0]    memi;
wire              mwe;
wire              aluop;
wire     [2:0]    ALU_srcB;
wire     [1:0]    ALU_srcA;
wire              rfwe;
wire              illegal;
wire              mreq;

IM det (
  .addr_i    (instruction_addr),
  .rd_o      (instruction)
);

RF dit (
  .clk_i    (clk_i),
  .addr_1_i (instruction[19:15]),
  .addr_2_i (instruction[24:20]),
  .addr_3_i (instruction[11:7]),
  .WE3_i    (rfwe),
  .WD3_i    (),
  .reset_i  (reset),
  .RD_1_o   (RD_1),
  .RD_2_o   (RD_2)
);

miriscv_alu dut(
  .operator_i           (aluop),
  .operand_a_i          (ALU_1),
  .operand_b_i          (ALU_2),
  .result_o             (result),
  .comparsion_result_o  (comparsion_result)
);

DM data_memory(
  .clk_i      (clk_i),
  .addr_i     (),
  .wd_i       (RD_2),
  .we_i       (mwe),

  .rd_o       ()
);

riscv_decoder decoder(
  .fetched_instr_i, ( instruction[31:0] ),   //         Decoding instruction read from instruction memory
  .ex_op_a_sel_o,   ( ALU_srcA ),   //-srcA    Multiplexer control signal for selecting the first operand of the ALU
  .ex_op_b_sel_o,   ( ALU_srcB ),   //-srcB    Multiplexer control signal for selecting the second operand of the ALU
  .alu_op_o,        ( aluop ),   //         ALU operation
  .mem_req_o,       ( mreq ),   //-mwe   Request for memory access (part of the memory interface)
  .mem_we_o,        ( mwe ),   //-mwe     Signal to allow writing to memory, "write enable" (if equal to zero, reading occurs)
  .mem_size_o,      ( memi ),   //-memi    Control signal for selecting the word size when reading / writing to memory (part of the memory interface)
  .gpr_we_a_o,      ( rfwe ),   //-rfwe    Signal to allow writing to a register file
  .wb_src_sel_o,    ( ws ),   //-ws      Multiplexer control signal for selecting data to be written to a register file
  .illegal_instr_o, ( illegal ),   //         Signal about an incorrect instruction (not marked in the diagram)
  .branch_o,        ( branch ),   //         Signal about a conditional jump instruction
  .jal_o,           ( jal ),   //         Signal about an unconditional jump instruction jal
  .jalr_o           ( jalr )   //         Signal about the Jarl unconditional jump instruction
);



assign  imm_U =  {{instruction[31:12]},{20{1'b0}}};
assign  imm_B =  {{24{instruction[7]}},instruction[7:0]};
assign  imm_I =  {{20{instruction[31]}},instruction[31:20]};
assign  imm_S =  {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
assign  imm_J =  {{20{instruction[31]}},{instruction[7]},instruction[30:25],instruction[11:8],{1'b0}};



endmodule
