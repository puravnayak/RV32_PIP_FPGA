`timescale 1ns / 1ps

module DataPath_tb;

    reg clk;
    reg reset;
    reg btn;
    wire [3:0] out_1;
    wire iled, btn1;

    DataPath dp (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .out_1(out_1),
        .iled(iled),
        .btn1(btn1)
    );

    always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

    initial begin
        reset = 0;
        btn = 0;

        #10;

        reset = 1;
        #10;
        reset = 0;

        #20;


        btn = 1;
        #1;
        btn = 0;
        
        #20;
        btn = 1;
        #1;
        btn = 0;

        #20;

        #50;
        $finish;
    end

    initial begin
        $monitor("At time %t, out_1 = %h", $time, out_1);
    end

endmodule
