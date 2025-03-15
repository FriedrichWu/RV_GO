module pipeline_reg #(
  parameter WIDTH = 8) 
(
  input                  clk,
  input                  rst,
  input      [WIDTH-1:0] d,
  output reg [WIDTH-1:0] q
);
always @(posedge clk, posedge rst) begin
  if(rst) begin
    q <= 0;
  end else begin
    q <= d;
  end
end
endmodule