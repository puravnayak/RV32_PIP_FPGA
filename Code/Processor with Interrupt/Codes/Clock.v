`timescale 1ns / 1ps

module toggle_Clock (
    input wire clk_signal, 
   input wire reset,        
    output reg clk         
);

    reg [26:0] counter;    

    always @(posedge clk_signal) begin
    
        if (~reset) begin
            counter <= 0;
            clk <= 0;
        end else if (counter == 27'd75000000) begin
            counter <= 0;
            clk <= ~clk;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule