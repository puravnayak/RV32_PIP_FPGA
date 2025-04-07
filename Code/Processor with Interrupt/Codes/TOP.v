`timescale 1ns / 1ps

module TOP(
    input reset, 
    input clk_signal,  
    input btn,
    output [3:0] out_1,
    output iled,
    output btn1
);
    wire clk;
    
    toggle_Clock ck(.reset(reset),.clk_signal(clk_signal), .clk(clk));

    Data_Path_Pipelined m1(.clk(clk) ,.start(reset),.btn(btn) ,.out_1(out_1),.iled(iled),.btn1(btn1));
endmodule