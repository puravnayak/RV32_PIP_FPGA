`timescale 1ns / 1ps

module Data_Memory #(parameter N=32)(
    input clk,mem_write,mem_read,
    input [31:0]address,
    input [N-1:0]write_data,
    output [N-1:0]read_data
    );
    
    reg [N-1:0]mem[0:31];
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            mem[i] = {N{1'b0}};  // Set each memory location to 0
        end
    end
    
    always@(posedge clk)
    begin
        if(mem_write)
            mem[address]<=write_data;
    end
    assign read_data = (mem_read)?mem[address]:32'b0;
endmodule
