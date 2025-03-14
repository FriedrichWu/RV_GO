module contr_gen (
  input [6:0] op,
  input [2:0] func3,
  input [6:0] func7,
  output reg [2:0] ext_op,
  output reg_w,
  output alu_src_a,
  output [1:0] alu_src_b, 
  output [3:0] alu_ctr,
  output [2:0] branch,
  output mem_to_reg,
  output mem_w,
  output [2:0] mem_op
);
//----------------------------------------//
//INTERNAL SIGNAL
//----------------------------------------//
always @(*) begin
  ext_op     = 3'b000;
  reg_w      = 1'b1;
  branch     = 3'b000;
  mem_to_reg = 1'b0;
  mem_w      = 1'b0;
  mem_op     = 1'b0;
  alu_src_a  = 1'b0;
  alu_src_b  = 2'b00;
  alu_ctr    = 4'b0000;
  case (op[6:2])
	5'b01101: begin // lui, U-type
	  ext_op = 3'b001;
	  alu_src_b = 2'b01;
	  alu_ctr = 4'b0011; 
	end 
	5'b00101: begin // auipc, U-type
	  ext_op = 3'b001;
      reg_w = 1'b1;
      alu_src_a = 1'b1;
	  alu_src_b = 2'b01;
	end
	5'b00100: begin // I-type
	  alu_src_b = 2'b01;
	  case (func3)
		3'b011: begin // sltiu
		  alu_ctr = 4'b1010;
		end
		3'b101: begin // srli, srai
		  alu_ctr = {func7[5], func3};
		end
		default: begin
		  alu_ctr = {1'b0, func3};
		end
	  endcase
	end
	5'b01100: begin // R-type
	  case (func3)
	    3'b000: begin // add, sub
		  alu_ctr = {func7[5], func3};
		end
		3'b011: begin // sltu
		  alu_ctr = 4'b1010;
		end
        3'b101: begin // srl, sra
		  alu_ctr = {func7[5], func3};
		end
		default: begin
		  alu_ctr = {1'b0, func3};
		end
	  endcase
	end
    5'b11011: begin // jal
	   ext_op = 3'b100;
	   branch = 3'b001;
	   alu_src_a = 1'b1;
	   alu_src_b = 2'b10;
	end
	5'b11001: begin // jalr
	  branch = 3'b010;
	  alu_src_a = 1'b1;
	  alu_src_b = 2'b10;
	end
	default: 
  endcase
end
endmodule