`timescale 1ns / 1ps

module TOP(
    input reset, 
    input clk_signal,  
    output [3:0] out_1
   
);
    wire clk;
    
    toggle_Clock ck(.reset(reset),.clk_signal(clk_signal), .clk(clk));

    DataPath m1(.clk(clk) ,.reset(!reset) ,.out_1(out_1));
endmodule