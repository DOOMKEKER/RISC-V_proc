`timescale 1ns / 10ps
`include "../rtl/defines.v"

module data_path(
  input           clk_i,
  input           reset,

  output   [6:0]  HEX_1_o,
  output   [6:0]  HEX_2_o
);

reg      [31:0]   PC;
wire     [31:0]   instruction;
wire     [31:0]   PC_add;
reg      [31:0]   PC_sum;
reg      [31:0]   PC_in;

reg      [31:0]   WD3;
wire     [31:0]   RD_1;
wire     [31:0]   RD_2;
wire     [31:0]   result;
wire     [31:0]   DM_RD;
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
wire     [5:0]    aluop;
wire     [2:0]    ALU_srcB;
wire     [1:0]    ALU_srcA;
wire              rfwe;
wire              illegal;
wire              mreq;

reg      [31:0]   imm_mx;
wire     [31:0]   imm_U;
wire     [31:0]   imm_I;
wire     [31:0]   imm_S;
wire     [31:0]   imm_J;
wire     [31:0]   imm_B;

IM det (
  .addr_i    (PC),
  .rd_o      (instruction)
);

RF dit (
  .clk_i    (clk_i),
  .addr_1_i (instruction[19:15]),
  .addr_2_i (instruction[24:20]),
  .addr_3_i (instruction[11:7]),
  .WE3_i    (rfwe),
  .WD3_i    (WD3),
  .reset_i  (reset),
  .RD_1_o   (RD_1),
  .RD_2_o   (RD_2)
);

miriscv_alu dut (
  .operator_i           (aluop),
  .operand_a_i          (ALU_1),
  .operand_b_i          (ALU_2),
  .result_o             (result),
  .comparsion_result_o  (comparsion_result)
);

DM data_memor (
  .clk_i      (clk_i),
  .addr_i     (result),
  .wd_i       (RD_2),
  .we_i       (mwe),

  .rd_o       (DM_RD)
);

riscv_decoder decoder(
  .fetched_instr_i ( instruction[31:0] ),   //         Decoding instruction read from instruction memory
  .ex_op_a_sel_o   ( ALU_srcA ),   //-srcA    Multiplexer control signal for selecting the first operand of the ALU
  .ex_op_b_sel_o   ( ALU_srcB ),   //-srcB    Multiplexer control signal for selecting the second operand of the ALU
  .alu_op_o        ( aluop ),   //         ALU operation
  .mem_req_o       ( mreq ),   //-mwe   Request for memory access (part of the memory interface)
  .mem_we_o        ( mwe ),   //-mwe     Signal to allow writing to memory, "write enable" (if equal to zero, reading occurs)
  .mem_size_o      ( memi ),   //-memi    Control signal for selecting the word size when reading / writing to memory (part of the memory interface)
  .gpr_we_a_o      ( rfwe ),   //-rfwe    Signal to allow writing to a register file
  .wb_src_sel_o    ( ws ),   //-ws      Multiplexer control signal for selecting data to be written to a register file
  .illegal_instr_o ( illegal ),   //         Signal about an incorrect instruction (not marked in the diagram)
  .branch_o        ( branch ),   //         Signal about a conditional jump instruction
  .jal_o           ( jal ),   //         Signal about an unconditional jump instruction jal
  .jalr_o          ( jalr ),   //         Signal about the Jarl unconditional jump instruction
  .enpc            (enpc)
);

assign PC_add = PC_sum + PC;

always @ ( * ) begin
  case(jalr)
    1'b0: PC_in <= PC_add;
    1'b1: PC_in <= RD_1 + imm_I;
  endcase

  case( ALU_srcA )
    2'b00: ALU_1 <= RD_1;
    2'b01: ALU_1 <= PC;
    2'b10: ALU_1 <= 32'b0;
  endcase

  case ( ALU_srcB )
    3'b000: ALU_2 <= RD_2;
    3'b001: ALU_2 <= imm_I;
    3'b010: ALU_2 <= imm_U;
    3'b011: ALU_2 <= imm_S;
    3'b100: ALU_2 <= 32'd4;
  endcase

  case (ws)
    1'b0: WD3 <= result;
    1'b1: WD3 <= DM_RD;
  endcase

  case (branch)
    1'b0: imm_mx <= imm_J;
    1'b1: imm_mx <= imm_B;
  endcase

  case ( (comparsion_result & branch) | jal )
    1'b0: PC_sum <= 32'd4;
    1'b1: PC_sum <= imm_mx;
  endcase

end

always @ ( posedge clk_i or posedge reset) begin
  if (reset) PC<= 0;
  else if (enpc)  PC <= PC_in;
end

assign  imm_U =  {{instruction[31:12]},{20{1'b0}}};
assign  imm_I =  {{20{instruction[31]}},instruction[31:20]};
assign  imm_S =  {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
assign  imm_J =  {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0};
assign  imm_B =  {{20{instruction[31]}},{instruction[7]},instruction[30:25],instruction[11:8],{1'b0}};



endmodule
