`timescale 1ns / 1ps

module IF_ID_Pipeline(
    input clk,reset,
    input [31:0] pc_in,instruction_in,
    output reg [31:0] pc_out,instruction_out
    );
    
    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            pc_out<=0;
            instruction_out<=0;
        end
        else
        begin
            pc_out<=pc_in;
            instruction_out<=instruction_in;
        end
    end
endmodule
