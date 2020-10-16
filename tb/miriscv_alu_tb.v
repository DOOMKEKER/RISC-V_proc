`timescale 1ns / 1ps
`include "../rtl/defines.v"
module miriscv_alu_tb();
reg  [6:0]  operator_i;
reg  [31:0] operand_a_i;
reg  [31:0] operand_b_i;
wire [31:0] result_o;
wire        comparsion_result_o;
// instantiate device under test
miriscv_alu dut(operator_i, operand_a_i, operand_b_i, result_o, comparsion_result_o);
// apply inputs one at a time

task alu_oper_test;
	input integer oper_tb;
	input integer srcA_tb;
	input integer srcB_tb;

	begin
		operator_i  = oper_tb;
		operand_a_i = srcA_tb;
		operand_b_i = srcB_tb;
		#10;
    $display(" ---- ");
		$display("******************************************");
		$display(" A = %d", $signed(operand_a_i), " B = %d", operand_b_i);
		$display(" result = %d", $signed(result_o), " comparsion_result = %d", comparsion_result_o);

	end
endtask

//ALU_ADD





initial begin

alu_oper_test(`ALU_SRL,24,1);
if (result_o != 12)
  $error("********** ERROR in ALU_SRL ********** ");
#10;

alu_oper_test(`ALU_SRL,32'b0100000000,1);

#10;

$display("------------------------------------------------");
$display("------------------------------------------------");
$display("------------------------------------------------");
$display("------------------------------------------------");
$display("------------------------------------------------");
$display("------------------------------------------------");
$display(" 										ALU_ADD ");
$display("------------------------------------------------");
alu_oper_test(`ALU_ADD,1,1);
if (result_o != 2)
  $error("********** ERROR in ALU_ADD ********** ");
#10;
alu_oper_test(`ALU_ADD,10,24);
if (result_o != 34)
  $error("********** ERROR in ALU_ADD ********** ");
#10;
alu_oper_test(`ALU_ADD,-31'd110,123);
if (result_o != 233)
  $error("********** ERROR in ALU_ADD ********** ");
#10;
alu_oper_test(`ALU_ADD,9,10000);
if (result_o != 10009)
  $error("********** ERROR in ALU_ADD ********** ");
#10;
alu_oper_test(`ALU_ADD,2500,500);
if (result_o != 3000)
  $error("********** ERROR in ALU_ADD ********** ");
#10;
alu_oper_test(`ALU_ADD,900000,100000);
if (result_o != 1000000)
  $error("********** ERROR in ALU_ADD ********** ");
#10;
alu_oper_test(`ALU_ADD,10000,10000);
if (result_o != 20000)
  $error("********** ERROR in ALU_ADD ********** ");
#10;
alu_oper_test(`ALU_ADD,42,42);
if (result_o != 84)
  $error("********** ERROR in ALU_ADD ********** ");


//ALU_SUB

$display("------------------------------------------------");
$display(" 										ALU_SUB ");
$display("------------------------------------------------");
alu_oper_test(`ALU_SUB,1,1);
if (result_o != 0)
  $error("********** ERROR in ALU_SUB ********** ");
#10;
alu_oper_test(`ALU_SUB,24,4);
if (result_o != 20)
  $error("********** ERROR in ALU_SUB ********** ");
	#10;
alu_oper_test(`ALU_SUB,150,120);
if (result_o != 30)
  $error("********** ERROR in ALU_SUB ********** ");
#10;
alu_oper_test(`ALU_SUB,1000009,9);
if (result_o != 1000000)
  $error("********** ERROR in ALU_SUB ********** ");
#10;
alu_oper_test(`ALU_SUB,2500,500);
if (result_o != 2000)
  $error("********** ERROR in ALU_SUB ********** ");
#10;
alu_oper_test(`ALU_SUB,900000,100000);
if (result_o != 800000)
  $error("********** ERROR in ALU_SUB ********** ");
#10;
alu_oper_test(`ALU_SUB,10000,10000);
if (result_o != 0)
  $error("********** ERROR in ALU_SUB ********** ");
#10;
alu_oper_test(`ALU_SUB,84,42);
if (result_o != 42)
  $error("********** ERROR in ALU_SUB ********** ");


//ALU_XOR

$display("------------------------------------------------");
$display(" 										ALU_XOR ");
$display("------------------------------------------------");
alu_oper_test(`ALU_XOR,1,1);
if (result_o != 0)
  $error("********** ERROR in ALU_XOR ********** ");
#10;
alu_oper_test(`ALU_XOR,24,4);
if (result_o != 28)
  $error("********** ERROR in ALU_XOR ********** ");
#10;
alu_oper_test(`ALU_XOR,150,-32'd120);
if (result_o != 238)
  $error("********** ERROR in ALU_XOR ********** ");
#10;
alu_oper_test(`ALU_XOR,1000009,9);
if (result_o != 1000000)
  $error("********** ERROR in ALU_XOR ********** ");
#10;
alu_oper_test(`ALU_XOR,2500,500);
if (result_o != 2096)
  $error("********** ERROR in ALU_XOR ********** ");
#10;
alu_oper_test(`ALU_XOR,900000,100000);
if (result_o != 802048)
  $error("********** ERROR in ALU_XOR ********** ");
#10;
alu_oper_test(`ALU_XOR,10000,10000);
if (result_o != 0)
  $error("********** ERROR in ALU_XOR ********** ");
#10;
alu_oper_test(`ALU_XOR,84,42);
if (result_o != 126)
  $error("********** ERROR in ALU_XOR ********** ");


//ALU_OR

$display("------------------------------------------------");
$display("										 ALU_OR ");
$display("------------------------------------------------");
alu_oper_test(`ALU_OR,1,1);
if (result_o != 1)
  $error("********** ERROR in ALU_OR ********** ");
#10;
alu_oper_test(`ALU_OR,24,4);
if (result_o != 28)
  $error("********** ERROR in ALU_OR ********** ");
#10;
alu_oper_test(`ALU_OR,150,120);
if (result_o != 254)
  $error("********** ERROR in ALU_OR ********** ");
#10;
alu_oper_test(`ALU_OR,1000009,9);
if (result_o != 1000009)
  $error("********** ERROR in ALU_OR ********** ");
#10;
alu_oper_test(`ALU_OR,2500,500);
if (result_o != 2548)
  $error("********** ERROR in ALU_OR ********** ");
#10;
alu_oper_test(`ALU_OR,900000,100000);
if (result_o != 901024)
  $error("********** ERROR in ALU_OR ********** ");
#10;
alu_oper_test(`ALU_OR,10000,10000);
if (result_o != 10000)
  $error("********** ERROR in ALU_OR ********** ");
#10;
alu_oper_test(`ALU_OR,84,42);
if (result_o != 126)
  $error("********** ERROR in ALU_OR ********** ");


//ALU_AND
$display("------------------------------------------------");
$display(" 										ALU_AND ");
$display("------------------------------------------------");
alu_oper_test(`ALU_AND,1,1);
if (result_o != 1)
  $error("********** ERROR in ALU_AND ********** ");
#10;
alu_oper_test(`ALU_AND,24,4);
if (result_o != 0)
  $error("********** ERROR in ALU_AND ********** ");
#10;
alu_oper_test(`ALU_AND,150,120);
if (result_o != 16)
  $error("********** ERROR in ALU_AND ********** ");
#10;
alu_oper_test(`ALU_AND,1000009,9);
if (result_o != 9)
  $error("********** ERROR in ALU_AND ********** ");
#10;
alu_oper_test(`ALU_AND,2500,500);
if (result_o != 452)
  $error("********** ERROR in ALU_AND ********** ");
#10;
alu_oper_test(`ALU_AND,900000,100000);
if (result_o != 98976)
  $error("********** ERROR in ALU_AND ********** ");
#10;
alu_oper_test(`ALU_AND,10000,10000);
if (result_o != 10000)
  $error("********** ERROR in ALU_AND ********** ");
#10;
alu_oper_test(`ALU_AND,84,42);
if (result_o != 0)
  $error("********** ERROR in ALU_AND ********** ");


//ALU_SRA

$display("------------------------------------------------");
$display(" 										ALU_SRA ");
$display("------------------------------------------------");
alu_oper_test(`ALU_SRA,1,1);
if (result_o != 0)
  $error("********** ERROR in ALU_SRA ********** ");
#10;
alu_oper_test(`ALU_SRA,24,4);
if (result_o != 1)
  $error("********** ERROR in ALU_SRA ********** ");
#10;
alu_oper_test(`ALU_SRA,-32'd150,2);
if (result_o != 0)
  $error("********** ERROR in ALU_SRA ********** ");
#10;
alu_oper_test(`ALU_SRA,1000009,9);
if (result_o != 1953)
  $error("********** ERROR in ALU_SRA ********** ");
#10;
alu_oper_test(`ALU_SRA,2500,500);
if (result_o != 0)
  $error("********** ERROR in ALU_SRA ********** ");
#10;
alu_oper_test(`ALU_SRA,900000,100000);
if (result_o != 0)
  $error("********** ERROR in ALU_SRA ********** ");
#10;
alu_oper_test(`ALU_SRA,10000,10000);
if (result_o != 0)
  $error("********** ERROR in ALU_SRA ********** ");
#10;
alu_oper_test(`ALU_SRA,84,42);
if (result_o != 0)
  $error("********** ERROR in ALU_SRA ********** ");


//ALU_SRL
$display("------------------------------------------------");
$display(" 										ALU_SRL ");
$display("------------------------------------------------");
alu_oper_test(`ALU_SRL,1,1);
if (result_o != 0)
  $error("********** ERROR in ALU_SRL ********** ");
#10;
alu_oper_test(`ALU_SRL,24,4);
if (result_o != 1)
  $error("********** ERROR in ALU_SRL ********** ");
#10;
alu_oper_test(`ALU_SRL,150,120);
if (result_o != 0)
  $error("********** ERROR in ALU_SRL ********** ");
#10;
alu_oper_test(`ALU_SRL,1000009,9);
if (result_o != 1953)
  $error("********** ERROR in ALU_SRL ********** ");
#10;
alu_oper_test(`ALU_SRL,2500,500);
if (result_o != 0)
  $error("********** ERROR in ALU_SRL ********** ");
#10;
alu_oper_test(`ALU_SRL,900000,2);
if (result_o != 225000)
  $error("********** ERROR in ALU_SRL ********** ");
#10;
alu_oper_test(`ALU_SRL,10000,5);
if (result_o != 312)
  $error("********** ERROR in ALU_SRL ********** ");
#10;
alu_oper_test(`ALU_SRL,84,42);
if (result_o != 0)
  $error("********** ERROR in ALU_SRL ********** ");


//ALU_SLL
$display("------------------------------------------------");
$display("										 ALU_LL ");
$display("------------------------------------------------");
alu_oper_test(`ALU_SLL,1,1);
if (result_o != 2)
  $error("********** ERROR in ALU_SLL ********** ");
#10;
alu_oper_test(`ALU_SLL,24,4);
if (result_o != 384)
  $error("********** ERROR in ALU_SLL ********** ");
#10;
alu_oper_test(`ALU_SLL,150,120);
if (result_o != 0)
  $error("********** ERROR in ALU_SLL ********** ");
#10;
alu_oper_test(`ALU_SLL,1000009,9);
if (result_o != 512004608)
  $error("********** ERROR in ALU_SLL ********** ");
#10;
alu_oper_test(`ALU_SLL,2500,500);
if (result_o != 0)
  $error("********** ERROR in ALU_SLL ********** ");
#10;
alu_oper_test(`ALU_SLL,900000,2);
if (result_o != 3600000)
  $error("********** ERROR in ALU_SLL ********** ");
#10;
alu_oper_test(`ALU_SLL,10000,5);
if (result_o != 320000)
  $error("********** ERROR in ALU_SLL ********** ");
#10;
alu_oper_test(`ALU_SLL,84,42);
if (result_o != 0)
  $error("********** ERROR in ALU_SLL ********** ");


//ALU_LTS
$display("------------------------------------------------");
$display(" 										ALU_LTS ");
$display("------------------------------------------------");
alu_oper_test(`ALU_LTS,-32'd2,1);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTS ********** ");
#10;
alu_oper_test(`ALU_LTS,3,4);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_LTS ********** ");
#10;
alu_oper_test(`ALU_LTS,150,120);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTS ********** ");
#10;
alu_oper_test(`ALU_LTS,1000009,9);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTS ********** ");
#10;
alu_oper_test(`ALU_LTS,499,500);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_LTS ********** ");
#10;
alu_oper_test(`ALU_LTS,5,-32'd5);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_LTS ********** ");
#10;
alu_oper_test(`ALU_LTS,10001,100000);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_LTS ********** ");
#10;
alu_oper_test(`ALU_LTS,84,42);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTS ********** ");


//ALU_LTU
$display("------------------------------------------------");
$display(" 										ALU_LTU ");
$display("------------------------------------------------");
alu_oper_test(`ALU_LTU,2,1);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTU ********** ");
#10;
alu_oper_test(`ALU_LTU,24,4);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTU ********** ");
#10;
alu_oper_test(`ALU_LTU,150,120);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTU ********** ");
#10;
alu_oper_test(`ALU_LTU,1000009,9);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTU ********** ");
#10;
alu_oper_test(`ALU_LTU,2500,500);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTU ********** ");
#10;
alu_oper_test(`ALU_LTU,1,2);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_LTU ********** ");
#10;
alu_oper_test(`ALU_LTU,2,5);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_LTU ********** ");
#10;
alu_oper_test(`ALU_LTU,84,42);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_LTU ********** ");


//ALU_GES
$display("------------------------------------------------");
$display(" 										ALU_GES ");
$display("------------------------------------------------");
alu_oper_test(`ALU_GES,-32'd1,10);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GES ********** ");
#10;
alu_oper_test(`ALU_GES,24,4);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GES ********** ");
#10;
alu_oper_test(`ALU_GES,120,120);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GES ********** ");
#10;
alu_oper_test(`ALU_GES,4,9);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_GES ********** ");
#10;
alu_oper_test(`ALU_GES,2500,-32'd500);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_GES ********** ");
#10;
alu_oper_test(`ALU_GES,2,2);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GES ********** ");
#10;
alu_oper_test(`ALU_GES,2,5);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_GES ********** ");
#10;
alu_oper_test(`ALU_GES,84,42);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GES ********** ");


//ALU_GEU
$display("------------------------------------------------");
$display(" 										ALU_GEU ");
$display("------------------------------------------------");
alu_oper_test(`ALU_GEU,6,1);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GEU ********** ");
#10;
alu_oper_test(`ALU_GEU,24,4);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GEU ********** ");
#10;
alu_oper_test(`ALU_GEU,150,120);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GEU ********** ");
#10;
alu_oper_test(`ALU_GEU,4,9);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_GEU ********** ");
#10;
alu_oper_test(`ALU_GEU,2500,500);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GEU ********** ");
#10;
alu_oper_test(`ALU_GEU,2,2);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GEU ********** ");
#10;
alu_oper_test(`ALU_GEU,2,5);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_GEU ********** ");
#10;
alu_oper_test(`ALU_GEU,84,42);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_GEU ********** ");


//ALU_EQ
$display("------------------------------------------------");
$display("										 ALU_EQ ");
$display("------------------------------------------------");
alu_oper_test(`ALU_EQ,1,1);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_EQ ********** ");
#10;
alu_oper_test(`ALU_EQ,24,24);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_EQ ********** ");
#10;
alu_oper_test(`ALU_EQ,150,120);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_EQ ********** ");
#10;
alu_oper_test(`ALU_EQ,4,9);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_EQ ********** ");
#10;
alu_oper_test(`ALU_EQ,2500,500);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_EQ ********** ");
#10;
alu_oper_test(`ALU_EQ,900000,2);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_EQ ********** ");
#10;
alu_oper_test(`ALU_EQ,2,5);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_EQ ********** ");
#10;
alu_oper_test(`ALU_EQ,84,42);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_EQ ********** ");


//ALU_NE
$display("------------------------------------------------");
$display("										 ALU_NE ");
$display("------------------------------------------------");
alu_oper_test(`ALU_NE,1,1);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_NE ********** ");
#10;
alu_oper_test(`ALU_NE,24,4);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_NE ********** ");
#10;
alu_oper_test(`ALU_NE,150,120);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_NE ********** ");
#10;
alu_oper_test(`ALU_NE,4,9);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_NE ********** ");
#10;
alu_oper_test(`ALU_NE,500,500);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_NE ********** ");
#10;
alu_oper_test(`ALU_NE,3,2);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_NE ********** ");
#10;
alu_oper_test(`ALU_NE,5,5);
if (comparsion_result_o != 0)
  $error("********** ERROR in ALU_NE ********** ");
#10;
alu_oper_test(`ALU_NE,84,42);
if (comparsion_result_o != 1)
  $error("********** ERROR in ALU_NE ********** ");
end

endmodule
