`timescale 1ns / 1ps

module DataPath(
    input clk,reset,
    input btn,
    output [3:0] out_1,
    output iled,
    output btn1
    );

    wire [31:0] pc,next,instruction,imm,alu_result,read_data,write_data,read_data1,read_data2,aluI2,mem_read_data;
    wire [3:0] alu_ctr;
    wire [1:0] alu_op;
    wire branch,memread,memreg,memwrite,alusrc,regwrite,N_flag,Z_flag,C_flag,V_flag;

//    PC p1 (.clk(clk),.reset(reset),.next(next),.pc(pc));
    
    PC2 p1 (.clk(clk),.reset(reset),.btn(btn),.next(next),.pc(pc),.iled(iled),.btn1(btn1));
    
    Instruction_Mem im1 (.PC(pc),.reset(reset),.instruction(instruction));
    
    Control c1 (.opcode(instruction[6:0]),.branch(branch),.memread(memread),.memreg(memreg),.memwrite(memwrite),.alusrc(alusrc),.regwrite(regwrite),.aluop(alu_op));
    
    ImmGen ig1(.instruction(instruction),.out(imm));
    
    Registers #(32) r1(.clk(clk),.reg_write(regwrite),.reset(reset),.read_reg1(instruction[19:15]),.read_reg2(instruction[24:20]),.write_reg(instruction[11:7]),.write_data(write_data),.read_data1(read_data1),.read_data2(read_data2));
    
    ALU_CONTROL ac1 (.aluop(alu_op),.funct({instruction[30],instruction[14:12]}),.alu_ctr(alu_ctr));
    
    ALU #(32) a1 (.I1(read_data1),.I2(aluI2),.alu_ctr(alu_ctr),.out(alu_result),.N_flag(N_flag),.Z_flag(Z_flag),.C_flag(C_flag),.V_flag(V_flag));
    
//    MUX2x1 m1 (.I0(read_data2),.I1(imm),.sel(alusrc),.out(aluI2));
    assign aluI2 = alusrc?imm:read_data2;
    
    Data_Memory #(32) dm1 (.clk(clk),.mem_write(memwrite),.mem_read(memread),.address(alu_result),.write_data(read_data2),.read_data(mem_read_data));
    
//    MUX2x1 m2 (.I0(alu_result),.I1(mem_read_data),.sel(memreg),.out(write_data));
    assign write_data = memreg?mem_read_data:alu_result;
        
    wire [31:0] pc_4,bt;
    
//    ADD add1 (.a(pc),.b(imm),.sum(bt));
    assign bt = imm+pc;    
    
//    ADD add2 (.a(pc),.b(32'd4),.sum(pc_4));
    assign pc_4 = pc+4;
    
//    MUX2x1 m3 (.I0(pc_4),.I1(bt),.sel(branch&Z_flag),.out(next));
    assign next = (branch&Z_flag)?bt:pc_4;
    
    assign out_1 = (^write_data === 1'bX) ? 4'b0 : write_data[3:0];

        
endmodule