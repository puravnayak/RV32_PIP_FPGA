`timescale 1ns / 1ps

module TOP_tb;

    reg clk;
    reg reset;
    wire [3:0] out;
    TOP uut (
        .clk_signal(clk),
        .reset(reset),
        .out_1(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
    reset = 0;

    #10;
    reset = 1;
    #200;
        $finish;
end

endmodule