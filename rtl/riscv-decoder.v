`include "defines.v"

module riscv_decoder
(
  input      [31:0]              fetched_instr_i,    //         Decoding instruction read from instruction memory
  output  reg[1:0]               ex_op_a_sel_o,      //-srcA    Multiplexer control signal for selecting the first operand of the ALU
  output  reg[2:0]               ex_op_b_sel_o,      //-srcB    Multiplexer control signal for selecting the second operand of the ALU
  output  reg[`ALU_OP_WIDTH-1:0] alu_op_o,           //         ALU operation
  output  reg                    mem_req_o,          //-mwe   Request for memory access (part of the memory interface)
  output  reg                    mem_we_o,           //-mwe     Signal to allow writing to memory, "write enable" (if equal to zero, reading occurs)
  output  reg[2:0]               mem_size_o,         //-memi    Control signal for selecting the word size when reading / writing to memory (part of the memory interface)
  output  reg                    gpr_we_a_o,         //-rfwe    Signal to allow writing to a register file
  output  reg                    wb_src_sel_o,       //-ws      Multiplexer control signal for selecting data to be written to a register file
  output  reg                    illegal_instr_o,    //         Signal about an incorrect instruction (not marked in the diagram)
  output  reg                    branch_o,           //         Signal about a conditional jump instruction
  output  reg                    jal_o,              //         Signal about an unconditional jump instruction jal
  output  reg                    jalr_o              //         Signal about the Jarl unconditional jump instruction
);

assign opcode = fetched_instr_i[6:0];
assign func3  = fetched_instr_i[14:12];
assign func7  = fetched_instr_i[31:25];

always @ ( * ) begin
  { mem_req_o, mem_we_o, mem_size_o, gpr_we_a_o, wb_src_sel_o, illegal_instr_o, branch_o, jal_o, jalr_o } <= {9'b0};
  ex_op_a_sel_o <= 2'b0;
  ex_op_b_sel_o <= 2'b0;
  alu_op_o      <= 0;

  case (opcode)

    `LOAD     :
      begin
        alu_op_o = `ALU_ADD ;
        wb_src_sel_o  = 1;
        gpr_we_a_o    = 1;
        mem_req_o     = 1;
        ex_op_a_sel_o = 2'd0;
        ex_op_b_sel_o = 3'd1;

        case (func3)
          0: mem_size_o = `LDST_B ;
          1: mem_size_o = `LDST_H ;
          2: mem_size_o = `LDST_W ;
          4: mem_size_o = `LDST_BU ;
          5: mem_size_o = `LDST_HU ;
          default: illegal_instr_o <= 1 ;
        endcase
      end

    `OP_IMM   :
      begin
        gpr_we_a_o = 1;
        ex_op_a_sel_o = 2'd0;
        ex_op_b_sel_o = 3'd1;

        case ({func3,func7})
          0:   begin alu_op_o <= `ALU_ADD  ; end
          1:   begin alu_op_o <= `ALU_SLL  ; end
          2:   begin alu_op_o <= `ALU_SLTS ; end
          3:   begin alu_op_o <= `ALU_SLTU ; end
          4:   begin alu_op_o <= `ALU_XOR  ; end
          5:   begin alu_op_o <= `ALU_SRL  ; end
          517: begin alu_op_o <= `ALU_SRA  ; end
          6:   begin alu_op_o <= `ALU_OR   ; end
          7:   begin alu_op_o <= `ALU_AND  ; end
          default: illegal_instr_o <= 1 ;
        endcase
      end

    `AUIPC    :
      begin
        ex_op_a_sel_o = 2'd1;
        ex_op_b_sel_o = 3'd2;
        alu_op_o      = `ALU_ADD ;
        gpr_we_a_o    = 1'b1;
      end

    `STORE    :
      begin
      ex_op_a_sel_o = 2'd0;
      ex_op_b_sel_o = 3'd3;
      alu_op_o      = `ALU_ADD;
      mem_we_o      = 1;
      mem_req_o     = 1;
      case (funct3)
          3'b000  : mem_size_o  = `LDST_B;
          3'b001  : mem_size_o  = `LDST_H;
          3'b010  : mem_size_o  = `LDST_W;
          default: illegal_instr_o = 1'b1;
      endcase
      end

    `OP       :
      begin
        case ({func7,func3})
          0:  alu_op_o <= `ALU_ADD ;
          512:alu_op_o <= `ALU_SUB ;
          4:  alu_op_o <= `ALU_XOR ;
          6:  alu_op_o <= `ALU_OR ;
          7:  alu_op_o <= `ALU_AND ;
          1:  alu_op_o <= `ALU_SLL ;
          5:  alu_op_o <= `ALU_SRL ;
          517:alu_op_o <= `ALU_SRA ;
          2:  alu_op_o <= `ALU_SLTS ;
          3:  alu_op_o <= `ALU_SLTU ;
          default: illegal_instr_o <= 1 ;
        endcase
      end

    `LUI      :
      begin
        gpr_we_a_o = 1;
        alu_op_o      = `ALU_ADD;
        ex_op_a_sel_o = 2'd2;
        ex_op_b_sel_o = 3'd2;
      end

    `BRANCH   :
      begin
      ex_op_a_sel_o = 2'd0;
      ex_op_b_sel_o = 3'd0;
      branch_o = 1;
      case (funct3)
          0 : alu_op_o = `ALU_EQ;
          1 : alu_op_o = `ALU_NE;
          4 : alu_op_o = `ALU_LTS;
          5 : alu_op_o = `ALU_GES;
          6 : alu_op_o = `ALU_LTU;
          7 : alu_op_o = `ALU_GEU;
          default: illegal_instr_o = 1'b1;
      end

    `JALR     :
      begin
      ex_op_a_sel_o = 2'd1;
      ex_op_b_sel_o = 3'd4;
      alu_op_o      = `ALU_ADD;
      gpr_we_a_o    = 1;
      jalr_o        = 1;
      end

    `JAL      :
      begin
      ex_op_a_sel_o = 2'd1;
      ex_op_b_sel_o = 3'd4;
      alu_op_o      = `ALU_ADD;
      gpr_we_a_o    = 1;
      jal_o         = 1;
      end

    `MISC_MEM ,
    `SYSTEM   :;
    default: ;
  endcase
end


endmodule // riscv_decoder
