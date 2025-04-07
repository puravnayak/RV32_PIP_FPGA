`timescale 1ns / 1ps

module Instruction_Mem(
    input [31:0] PC,
    input reset,
    output reg [31:0] instruction
);

    reg [31:0] Memory [0:31]; 
    
    integer i;
    initial begin
        Memory[0] = 32'h00000000; 
        Memory[1] = 32'b000000000011_00000_010_00001_0010011;
        Memory[2] = 32'b000000000101_00000_010_00010_0010011;
        for (i = 3; i < 32; i = i + 1)
            Memory[i] = 32'b0000000_00001_00010_010_00010_0110011; 
    end


    
    
    
    always @(*) begin
        if (reset)
              instruction <= 0;
        else
            instruction <= Memory[PC>>2 & 5'b11111];    
    end

endmodule