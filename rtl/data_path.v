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
wire     [31:0]   operand_a;
wire     [31:0]   operand_b;
wire     [31:0]   result;
wire     [1:0]    ex_op_a_sel; // мультиплексор на выбор первого операнда
wire     [2:0]    ex_op_b_sel; // мультиплексор на выбор второго операнда
wire     [5:0]    alu_op; // операция алу
wire              mem_req; // запрос на доступ чтения памяти
wire 			        mem_we; // сигнал разрешения записи в память (== 0 - читаем)
wire 	   [2:0]    mem_size; // сигнал для выбора размера слова при чтении-записи
wire 			        gpr_we_a; // разрешенчие записи в рег файл
wire 			        wb_src_sel; // мультиплексор выбор данных для записи в рег файл
wire 			        illegal_instr; // некоррект инстр
wire 			        branch; // условный переход
wire 			        jal;  // безусловный переход
wire 			        jalr;// безусловный переход
wire              enpc;
wire              comparsion_result;
wire 	[31:0]      imm_I;
wire 	[31:0]      imm_S;
wire 	[31:0]      imm_J;
wire 	[31:0]      imm_B;
reg 	[31:0]	    j_or_b;
reg 	[31:0]	    reg_wd3;
reg 	[31:0]	    mem_wd;
wire 	[31:0]	    mem_rd;
wire 	[31:0]	    pc_sum;
reg 	[31:0]	    pc_sum_oper;
reg   [31:0]	    pc_addr;

assign pc_sum = prog_counter + pc_sum_oper;

initial instruction_addr <= 32'h66000000;

assign imm_I = {{20{instruction[31]}},instruction[31:20]};
assign imm_S = {{20{instruction[31]}},{instruction[31:25]},{instruction[11:7]}};
assign imm_J = {{12{instruction[31]}},{instruction[19:12]},{instruction[20]},{instruction[30:21]},{1'b0}};
assign imm_B = {{20{instruction[31]}},{instruction[7]},{instruction[30:25]},{instruction[11:8]},{1'b0}};

IM det (
  .addr_i    (instruction_addr),
  .rd_o      (instruction)
);

RF dit (
  .clk_i    (clk_i),
  .addr_1_i (instruction[22:18]),
  .addr_2_i (instruction[17:13]),
  .addr_3_i (instruction[12:8]),
  .WE3_i    (instruction[29]),
  .WD3_i    (WD3),
  .reset_i  (reset),
  .RD_1_o   (RD_1),
  .RD_2_o   (RD_2)
);

miriscv_alu dut(
  .operator_i           (aluop),
  .operand_a_i          (operand_a),
  .operand_b_i          (operand_b),
  .result_o             (result),
  .comparsion_result_o  (comparsion_result)
);

riscv_decoder decoder(
  .fetched_instr_i (instruction),
  .ex_op_a_sel_o 	 (ex_op_a_sel),
  .ex_op_b_sel_o 	 (ex_op_b_sel),
  .alu_op_o 		   (alu_op),
  .mem_req_o 		   (mem_req),
  .mem_we_o 		   (mem_we),
  .mem_size_o		   (mem_size),
  .gpr_we_a_o 		 (gpr_we_a),
  .wb_src_sel_o  	 (wb_src_sel),
  .illegal_instr_o (illegal_instr),
  .branch_o 		   (branch),
  .jal_o 		       (jal),
  .jalr_o 			   (jalr),
  .enpc_o			     (enpc)
);

DM memory(
	.clk_i 		  (clk_i),
	.a_i   		  (alu_result),
	.wd_i  		  (mem_wd),
	.mem_size_i (mem_size),
	.mem_req_i 	(mem_req),
	.mem_we_i 	(mem01_we),
	.rd_o		    (mem_rd),
	.reset      (reset)
);

HEX kek(
  .in		 (RD_1[3:0]),
  .out	    (HEX_1_o)
  );

HEX kek2(
  .in		 (RD_1[7:4]),
  .out	    (HEX_2_o)
  );

assign pc_sum = prog_counter + pc_sum_oper;

always @ ( * )
	begin
		case (ex_op_a_sel)
			2'b00 : oper_1 = rd1;
			2'b01 : oper_1 = prog_counter;
			2'b10 : oper_1 = 32'd0;
			default : oper_1 = 32'd0;
		endcase
		case (ex_op_b_sel)
			3'b000 : oper_2 = rd2;
			3'b001 : oper_2 = imm_i;
			3'b010 : oper_2 = {instruction[31:12],{12{1'b0}}};
			3'b011 : oper_2 = imm_s;
			3'b100 : oper_2 = 32'd4;
			default : oper_2 = rd2;
		endcase
		case (wb_src_sel)
			1'b0 : reg_wd3 = alu_result;
			1'b1 : reg_wd3 = mem_rd;
			default : oper_2 = rd2;
		endcase
		case (branch)
			1'b0 : j_or_b = imm_j;
			1'b1 : j_or_b = imm_b;
			default : j_or_b = imm_j;
		endcase
		case ((comp_res & branch) | jal)
			1'b0 : pc_sum_oper = 3'd4;
			1'b1 : pc_sum_oper = j_or_b;
			default : pc_sum_oper = 3'd4;
		endcase
		case (jalr)
			1'b0: pc_addr <= pc_sum;
			1'b1: pc_addr <= rd1;
		endcase
	end
always @ (posedge clk_i) begin
	if	(enpc)
		prog_counter <= pc_addr;
	end
endmodule
