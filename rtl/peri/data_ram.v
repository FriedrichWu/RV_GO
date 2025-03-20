module data_ram (
  input             clk0,
  input             wen_n,
  input      [ 2:0] mem_op,
  input      [31:0] addr,
  input      [31:0] din,
  input             clk1,
  output reg [31:0] dout
);
//----------------------------------------------//
//INTERNAL SIGNAL
//----------------------------------------------//
reg  [ 3:0] wmask0;
wire [31:0] dout1;
//Decode memory option
always @(*) begin
  wmask0 = 4'b0000;
  dout = dout1;
  case (mem_op)
    3'b000: begin // signed extension, 1 byte r/w
      wmask0 = 4'b0001;
      dout = {{24{dout1[7]}}, dout1[7:0]};
    end
    3'b001: begin // signed extension, 2 byte r/w
      wmask0 = 4'b0011;
      dout = {{16{dout1[15]}}, dout1[15:0]};
    end
    3'b010: begin // 4 byte r/w
      wmask0 = 4'b1111;
    end
    3'b100: begin // unsigned extension, 1 byte r/w
      wmask0 = 4'b0001;
      dout = {{24{1'b0}}, dout1[7:0]};
    end
    3'b101: begin // unsigned extension, 2 byte r/w
      wmask0 = 4'b0011;
      dout = {{16{1'b0}}, dout1[15:0]};
    end
    default: begin
      wmask0 = 4'b0000;
      dout = dout1;
    end
  endcase
end
sky130_sram_2kbyte_1rw1r_32x512_8 sram_ins_data (
  .clk0        (clk0     ),
  .csb0        (1'b0     ),
  .web0        (wen_n    ),
  .wmask0      (wmask0   ),
  .addr0       (addr[8:0]),
  .din0        (din      ),
  .dout0       (),
  .clk1        (clk1     ),
  .csb1        (1'b0     ),
  .addr1       (addr[8:0]),
  .dout1       (dout1    )
);
    
endmodule