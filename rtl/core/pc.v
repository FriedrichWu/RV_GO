module pc (
  input             clk,
  input             rst,
  input      [31:0] nxt_pc,
  output reg [31:0] pc
);
always @(posedge clk, posedge rst) begin
  if (rst) begin
    pc <= 32'b0;
  end
  else begin
    pc <= nxt_pc;
  end
end
    
endmodule