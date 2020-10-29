`include "defines.v"

module riscv_decoder
(
  input       [31:0]             fetched_instr_i,    //         Decoding instruction read from instruction memory
  output  reg[1:0]               ec_op_a_sel_o,      //-srcA    Multiplexer control signal for selecting the first operand of the ALU
  output  reg[2:0]               ec_op_b_sel_o,      //-srcB    Multiplexer control signal for selecting the second operand of the ALU
  output  reg[`ALU_OP_WIDTH-1:0] alu_op_o,           //         ALU operation
  output  reg                    mem_req_o,          //-         Request for memory access (part of the memory interface)
  output  reg                    mem_we_o,           //-mwe     Signal to allow writing to memory, "write enable" (if equal to zero, reading occurs)
  output  reg                    mem_size_o,         //         Control signal for selecting the word size when reading / writing to memory (part of the memory interface)
  output  reg                    gpr_we_a_o,         //         Signal to allow writing to a register file
  output  reg                    wb_src_sel_o,       //         Multiplexer control signal for selecting data to be written to a register file
  output  reg                    illegal_instr_o,    //         Signal about an incorrect instruction (not marked in the diagram)
  output  reg                    branch_o,           //         Signal about a conditional jump instruction
  output  reg                    jal_o,              //         Signal about an unconditional jump instruction jal
  output  reg                    jarl_o              //         Signal about the Jarl unconditional jump instruction
);

assign opcode = fetched_instr_i[6:0];
assign func3  = fetched_instr_i[14:12];
assign func7  = fetched_instr_i[31:25];

always @ ( * ) begin
  { mem_req_o, mem_we_o, mem_size_o, gpr_we_a_o, wb_src_sel_o, illegal_instr_o, branch_o, jal_o, jarl_o } <= {9'b0};
  ec_op_a_sel_o <= 2'b0;
  ec_op_b_sel_o <= 2'b0;
  alu_op_o      <= 0;

  case (opcode)
    `LOAD     :
      begin
        case (func3)
          0: ;
          1: ;
          2: ;
          3: ;
          4: ;
          5: ;
          default: illegal_instr_o <= 1 ;
        endcase
      end
    `MISC_MEM :
      begin

      end
    `OP_IMM   :
      begin
        case ({func3,func7})
          0:   begin alu_op_o <= `ALU_ADD  ; ec_op_b_sel_o <= 1 ; mem_we_o <= 1;  end
          1:   begin alu_op_o <= `ALU_SLL  ; ec_op_b_sel_o <= 1 ; mem_we_o <= 1;  end
          2:   begin alu_op_o <= `ALU_SLTS ; ec_op_b_sel_o <= 1 ; mem_we_o <= 1;  end
          3:   begin alu_op_o <= `ALU_SLTU ; ec_op_b_sel_o <= 1 ; mem_we_o <= 1;  end
          4:   begin alu_op_o <= `ALU_XOR  ; ec_op_b_sel_o <= 1 ; mem_we_o <= 1;  end
          5:   begin alu_op_o <= `ALU_SRL  ; ec_op_b_sel_o <= 1 ; mem_we_o <= 1;  end
          517: begin alu_op_o <= `ALU_SRA  ; ec_op_b_sel_o <= 1 ; mem_we_o <= 1;  end
          6:   begin alu_op_o <= `ALU_OR   ; ec_op_b_sel_o <= 1 ; mem_we_o <= 1;  end
          7:   begin alu_op_o <= `ALU_AND  ; ec_op_b_sel_o <= 1 ; mem_we_o <= 1;  end
          default: illegal_instr_o <= 1 ;
        endcase
      end
    `AUIPC    :
      begin

      end
    `STORE    :
      begin

      end
    `OP       :
      begin
        case ({func7,func3})
          0:  alu_op_o <= `ALU_ADD;
          512:alu_op_o <= `ALU_SUB;
          4:  alu_op_o <= `ALU_XOR;
          6:  alu_op_o <= `ALU_OR;
          7:  alu_op_o <= `ALU_AND;
          1:  alu_op_o <= `ALU_SLL;
          5:  alu_op_o <= `ALU_SRL;
          517:alu_op_o <= `ALU_SRA;
          2:  alu_op_o <= `ALU_SLTS;
          3:  alu_op_o <= `ALU_SLTU;
          default: illegal_instr_o <= 1 ;
        endcase
      end
    `LUI      :
      begin

      end
    `BRANCH   :
      begin

      end
    `JALR     :
      begin

      end
    `JAL      :
      begin

      end
    `SYSTEM   :
      begin

      end
    default: ;
  endcase
end


endmodule // riscv_decoder
