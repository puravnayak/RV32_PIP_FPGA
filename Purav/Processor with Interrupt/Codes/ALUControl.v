`timescale 1ns / 1ps


module ALU_CONTROL(
    input [1:0] aluop,
    input [3:0] funct,
    output reg [3:0]alu_ctr
);
    
    always@(*)
    begin
            alu_ctr<=4'b0;
            case(aluop)
                2'b00: alu_ctr <= 4'b0010; // for SW and LW we need to ADD
                2'b01: alu_ctr <= 4'b0011; // for Beq we need to subtract
                2'b10: alu_ctr <= funct;
                default: alu_ctr <= 4'b1111;
            endcase
        end
endmodule
