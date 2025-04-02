module Registers #(parameter N=32)(
    input clk, reg_write, reset,
    input [4:0] read_reg1, read_reg2, write_reg,
    input [N-1:0] write_data,
    output [N-1:0] read_data1, read_data2
);

    reg [N-1:0] regi [0:31]; 
    
    assign read_data1 = regi[read_reg1];
    assign read_data2 = regi[read_reg2];

    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                regi[i] <= 0;
        end
        else if (reg_write) begin
            regi[write_reg] <= write_data;
        end
    end

endmodule
