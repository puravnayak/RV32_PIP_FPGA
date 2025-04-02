module PC2(
    input clk, reset, btn,
    input [31:0] next,
    output reg [31:0] pc,
    output reg iled,
    output reg btn1
);
    reg [31:0] LR;
    reg iflag;
    reg v_reg;
    reg v1;

    always @(*) begin
//        if (reset)
//            v1 = 1'b0;
        if (btn)
            v1 = 1'b1; 
        else if (v_reg)
            v1 = 1'b0; // Reset when v_reg is low
        iled <= iflag;
        btn1 <= btn;
    end



    always @(posedge clk or posedge reset) begin
        if (reset) begin  
            LR    <= 0;
            iflag <= 0;
            pc    <= 0;
            v_reg<=0;
        end  
        else if (v1 && !iflag) begin
            LR    <= pc;
            iflag <= 1;
            pc    <= 32'h10000000;
            v_reg<=1;
        end 
        else if (v1 && iflag) begin
            pc    <= LR;
            iflag <= 0;
            v_reg <= 1;
        end 
        else if (!iflag) begin
            pc <= next; 
            v_reg<=0;
        end
        else
            v_reg<=0;
    end
endmodule
