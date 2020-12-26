module DM
  (
    input 			   	    clk_i,
	  input 	[31:0] 	    a_i  ,
	  input 	[31:0] 	    wd_i ,
	  input   [2:0]       mem_size_i,
	  input 			   	    mem_req_i,
	  input 			   	    mem_we_i,
	  input 			   	    reset,
	  output reg	[31:0] 	rd_o
  );

reg [31:0] STATIC [0:511];
reg [31:0] HEAP 	[0:511];
reg [31:0] STACK 	[0:511];

//initial $readmemb ("E:\\Studies\\3_course\\1_semestr\\FPGA\\labs\\rtl\\data.txt", data);

integer i = 0;
always @(posedge clk_i) begin
  if( reset ) begin
		for( i = 0; i < 512; i = i + 1 ) begin
			STATIC[i] <= 32'h0;
			HEAP[i]   <= 32'h0;
			STACK[i]  <= 32'h0;
		end
  end
  if (mem_req_i & mem_we_i) begin
  		case(mem_size_i)
			`LDST_B: begin
				if		((a_i >= 8'h10008000) && (a_i <= 8'h100081ff)) STATIC[a_i][7:0] <= wd_i[7:0];
				else if ((a_i >= 8'h10008200) && (a_i <= 8'h100083ff)) HEAP[a_i][7:0]   <= wd_i[7:0];
				else if ((a_i >= 8'hbffffdf0) && (a_i <= 8'hbffffff0)) STACK[a_i][7:0]  <= wd_i[7:0];
				end
			`LDST_H: begin
				if		((a_i >= 8'h10008000) && (a_i <= 8'h100081ff)) STATIC[{a_i[31:1],1'b0}][15:0] <= wd_i[15:0];
				else if ((a_i >= 8'h10008200) && (a_i <= 8'h100083ff)) HEAP  [{a_i[31:1],1'b0}][15:0] <= wd_i[15:0];
				else if ((a_i >= 8'hbffffdf0) && (a_i <= 8'hbffffff0)) STACK [{a_i[31:1],1'b0}][15:0] <= wd_i[15:0];
				end
			`LDST_W: begin
				if		((a_i >= 8'h10008000) && (a_i <= 8'h100081ff)) STATIC[{a_i[31:2],2'b00}] <= wd_i;
				else if ((a_i >= 8'h10008200) && (a_i <= 8'h100083ff)) HEAP  [{a_i[31:2],2'b00}] <= wd_i;
				else if ((a_i >= 8'hbffffdf0) && (a_i <= 8'hbffffff0)) STACK [{a_i[31:2],2'b00}] <= wd_i;
				end
		endcase
	end
	else if(mem_req_i) begin
		case(mem_size_i)
			`LDST_B: begin
				if		((a_i >= 8'h10008000) && (a_i <= 8'h100081ff)) rd_o <= {{24{STATIC[a_i][7]}}, STATIC[a_i][7:0]};
				else if ((a_i >= 8'h10008200) && (a_i <= 8'h100083ff)) rd_o <= {{24{HEAP  [a_i][7]}}, HEAP  [a_i][7:0]};
				else if ((a_i >= 8'hbffffdf0) && (a_i <= 8'hbffffff0)) rd_o <= {{24{STACK [a_i][7]}}, STACK [a_i][7:0]};
				else rd_o <= 32'b0;
				end
			`LDST_H: begin
				if		((a_i >= 8'h10008000) && (a_i <= 8'h100081ff)) rd_o <= {{16{STATIC[a_i][15]}}, STATIC[a_i][15:0]};
				else if ((a_i >= 8'h10008200) && (a_i <= 8'h100083ff)) rd_o <= {{16{HEAP  [a_i][15]}}, HEAP  [a_i][15:0]};
				else if ((a_i >= 8'hbffffdf0) && (a_i <= 8'hbffffff0)) rd_o <= {{16{STACK [a_i][15]}}, STACK [a_i][15:0]};
				else rd_o <= 32'b0;
				end
			`LDST_W: begin
				if		((a_i >= 8'h10008000) && (a_i <= 8'h100081ff)) rd_o <= STATIC[a_i];
				else if ((a_i >= 8'h10008200) && (a_i <= 8'h100083ff)) rd_o <= HEAP  [a_i];
				else if ((a_i >= 8'hbffffdf0) && (a_i <= 8'hbffffff0)) rd_o <= STACK [a_i];
				else rd_o <= 32'b0;
				end
			`LDST_BU: begin
				if		((a_i >= 8'h10008000) && (a_i <= 8'h100081ff)) rd_o[7:0] <= STATIC[a_i][7:0];
				else if ((a_i >= 8'h10008200) && (a_i <= 8'h100083ff)) rd_o[7:0] <= HEAP  [a_i][7:0];
				else if ((a_i >= 8'hbffffdf0) && (a_i <= 8'hbffffff0)) rd_o[7:0] <= STACK [a_i][7:0];
				else rd_o <= 32'b0;
				end
			`LDST_HU: begin
				if		((a_i >= 8'h10008000) && (a_i <= 8'h100081ff)) rd_o[15:0] <= STATIC[a_i][15:0];
				else if ((a_i >= 8'h10008200) && (a_i <= 8'h100083ff)) rd_o[15:0] <= HEAP  [a_i][15:0];
				else if ((a_i >= 8'hbffffdf0) && (a_i <= 8'hbffffff0)) rd_o[15:0] <= STACK [a_i][15:0];
				else rd_o <= 32'b0;
				end
			endcase
	end
end
endmodule
