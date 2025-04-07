`timescale 1ns / 1ps

module ImmGen(
    input [31:0] instruction,
    output reg [31:0] out
    );
    
    always@(*)
    begin
        case(instruction[6:0]) // check opcode
            7'b011011: out<=32'b0; //R-type
            7'b000011,7'b0010011: out <= {20'b0,instruction[31:20]}; //I-type
            7'b0100011: out<={20'b0,instruction[31:25],instruction[11:7]}; //S-type
            7'b1100111: out<={19'b0,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}; //SB-type
            7'b0110111: out<={instruction[31:12],12'b0}; //U-type
            7'b1101111: out<={11'b0,instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0}; //UJ-type
            default: out<=32'bX; //error
        endcase
    end
endmodule
    