module silly_kernel
(
  input           clk_i,
  input    [9:0]  SW_i,
  input           reset,

  output   [6:0]  HEX_1_o,
  output   [6:0]  HEX_2_o

);

reg     	[31:0]   instruction_addr;
wire     [31:0]   instruction;
reg     	[31:0]   WD3;
wire     [31:0]   RD_1;
wire     [31:0]   RD_2;
wire     [31:0]   result;
wire              comparsion_result;

initial instruction_addr <= 32'h66000000;

HEX kek(
   .in		 (RD_1[3:0]),
   .out	    (HEX_1_o)
);

HEX kek2(
   .in		 (RD_1[7:4]),
   .out	    (HEX_2_o)
);

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
  .operator_i           (instruction[26:23]),
  .operand_a_i          (RD_1),
  .operand_b_i          (RD_2),
  .result_o             (result),
  .comparsion_result_o  (comparsion_result)
);

wire     [31:0]   SE;

assign  SE =  {{24{instruction[7]}},instruction[7:0]};

always @ (posedge clk_i)
begin
	if (reset) instruction_addr <= 32'h66000000;
	else if (instruction[31])
		instruction_addr <= instruction_addr + (SE << 2);
	else if (instruction[30])
				begin
					if (comparsion_result == 1)
						instruction_addr <= instruction_addr + (SE << 2);
					else
						instruction_addr <= instruction_addr + 32'd4;
				end
	else
		instruction_addr <= instruction_addr + 32'd4;
end



always @ ( * )
	begin
		case (instruction[28:27])
			2'b00 :   WD3[31:0] <= SE;
			2'b01	:   WD3[31:0] <= SW_i[9:0];
			2'b10 :   WD3[31:0] <= result;
			default : WD3[31:0] <= 32'd0;
		endcase
	end



endmodule
