module PC (
    input clk,
    input rst,
    input PCWrite,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);

always @(posedge clk ) begin
	if (~rst)
		pc_o <=32'b0;
	else if(PCWrite)
		pc_o <= pc_i;
end
endmodule

