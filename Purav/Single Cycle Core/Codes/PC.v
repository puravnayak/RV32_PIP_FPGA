`timescale 1ns / 1ps

module PC(
    input clk,reset,
    input [31:0] next,  // normally pc + 4 , but next for general jump cases
    output reg [31:0] pc
);

    always@(posedge clk or posedge reset)
    begin
        if(reset)
            pc<=0;
        else
            pc<=next;
    end
endmodule
