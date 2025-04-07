`timescale 1ns / 1ps

module Data_Path_Pipelined(
    input clk, start, 
    input btn,
    input [3:0]out_1,
    output iled,
    output btn1
);

    wire [31:0] pc, next_pc, pc4;
    wire [31:0] instruction, rd1, rd2, imm;
    wire [31:0] pc_out_IFID, instruction_out_IFID;
    wire [31:0] pc_out_IDEX, rd1_out_IDEX, rd2_out_IDEX, imm_out_IDEX,instruction_out_IDEX;
    wire [3:0] func_IDEX;
    wire [4:0] wr_IDEX, wr_EXMEM, wr_MEMWB,wr_F;
    wire [1:0] alu_op,alu_op2;
    wire [3:0] alu_ctr;
    wire branch_IDEX, memread_IDEX, memreg_IDEX, memwrite_IDEX, alusrc_IDEX, regwrite_IDEX;
    wire branch_EXMEM, memread_EXMEM, memreg_EXMEM, memwrite_EXMEM, regwrite_EXMEM, zero_EXMEM;
    wire [31:0] pc_out_EXMEM, alu_out_EXMEM, rd2_out_EXMEM;
    wire branch_MEMWB, regwrite_MEMWB, memreg_MEMWB;
    wire [31:0] read_data_MEMWB, alu_out_MEMWB, write_data;
    wire [31:0] read_data_F,alu_out_F;
    wire memreg_F,regwrite_F;
    wire [1:0] FA,FB;
    wire jump_IDEX, jump_EXMEM, jalr_IDEX, jalr_EXMEM;
    
//    PC pc1 (
//        .clk(clk),
//        .reset(~start),
//        .next(next_pc),
//        .pc(pc)
//    );
    
    PC2 p1 (
        .clk(clk),
        .reset(~start),
        .btn(btn),
        .next(next_pc),
        .pc(pc),
        .iled(iled),
        .btn1(btn1));

    Instruction_Mem im (
        .PC(pc),
        .reset(~start),
        .instruction(instruction)
    );

    IF_ID_Pipeline FDP (
        .clk(clk),
        .reset(~start),
        .pc_in(pc),
        .instruction_in(instruction),
        .pc_out(pc_out_IFID),
        .instruction_out(instruction_out_IFID)
    );

    Registers #(32) r1 (
        .clk(clk),
        .reg_write(regwrite_F),
        .reset(~start),
        .read_reg1(instruction_out_IFID[19:15]),
        .read_reg2(instruction_out_IFID[24:20]),
        .write_reg(wr_F),
        .write_data(write_data),
        .read_data1(rd1),
        .read_data2(rd2)
    );
    
    ImmGen ig (
        .instruction(instruction_out_IFID),
        .out(imm)
    );
    
    Control c1 (
        .opcode(instruction_out_IFID[6:0]),
        .branch(branch_IDEX),
        .memread(memread_IDEX),
        .memreg(memreg_IDEX),
        .memwrite(memwrite_IDEX),
        .alusrc(alusrc_IDEX),
        .regwrite(regwrite_IDEX),
        .jump(jump_IDEX),
//        .jalr(jalr_IDEX);
        .aluop(alu_op)
    );
    
    ID_EX_Pipeline IEP (
        .clk(clk),
        .reset(~start),
        .pc_in(pc_out_IFID),
        .read_data1_in(rd1),
        .read_data2_in(rd2),
        .imm_in(imm),
        .funct_in({instruction_out_IFID[30], instruction_out_IFID[14:12]}),
        .wr_in(instruction_out_IFID[11:7]),
        .aluop_in(alu_op),
        .branch_in(branch_IDEX),
        .memread_in(memread_IDEX),
        .memreg_in(memreg_IDEX), 
        .memwrite_in(memwrite_IDEX),
        .alusrc_in(alusrc_IDEX),
        .regwrite_in(regwrite_IDEX),
        .instruction_in(instruction_out_IFID),
        .pc_out(pc_out_IDEX),
        .read_data1_out(rd1_out_IDEX),
        .read_data2_out(rd2_out_IDEX),
        .imm_out(imm_out_IDEX),
        .funct_out(func_IDEX),
        .wr_out(wr_IDEX),
        .aluop_out(alu_op2),
        .branch_out(branch_EXMEM),
        .memread_out(memread_EXMEM),
        .memreg_out(memreg_EXMEM), 
        .memwrite_out(memwrite_EXMEM),
        .alusrc_out(alusrc_EXMEM),
        .regwrite_out(regwrite_EXMEM),
        .instruction_out(instruction_out_IDEX)
    );

    ALU_CONTROL ac1 (
        .aluop(alu_op2),
        .funct(func_IDEX),
        .alu_ctr(alu_ctr)
    );
    
    wire [31:0] ALU_src1, ALU_src2, ALU_srct;

    assign ALU_src1 = (FA == 2'b10) ? alu_out_MEMWB : 
                  (FA == 2'b01) ? write_data :
                  rd1_out_IDEX;

    
    
    assign ALU_src2 = (FB == 2'b10) ? alu_out_MEMWB :
                      (FB == 2'b01) ? write_data :
                      rd2_out_IDEX;
                      
    assign ALU_srct = alusrc_EXMEM?imm_out_IDEX:ALU_src2;


    ALU #(32) a1 (
        .I1(ALU_src1),
        .I2(ALU_srct),
        .alu_ctr(alu_ctr),
        .out(alu_out_EXMEM),
        .Z_flag(zero_EXMEM)
    );


    EX_MEM_Pipeline EMP (
        .clk(clk),
        .reset(~start),
        .pc_in(pc_out_IDEX),
        .alu_in(alu_out_EXMEM),
        .read_data2_in(rd2_out_IDEX),
        .wr_in(wr_IDEX),
        .branch_in(branch_EXMEM),
        .memread_in(memread_EXMEM),
        .memreg_in(memreg_EXMEM), 
        .memwrite_in(memwrite_EXMEM),
        .regwrite_in(regwrite_EXMEM),
        .zero_in(zero_EXMEM),
        .pc_out(pc_out_EXMEM),
        .alu_out(alu_out_MEMWB),
        .read_data2_out(rd2_out_EXMEM),
        .wr_out(wr_EXMEM),
        .branch_out(branch_MEMWB),
        .memread_out(memread_MEMWB),
        .memreg_out(memreg_MEMWB), 
        .memwrite_out(memwrite_MEMWB),
        .regwrite_out(regwrite_MEMWB)
    );
    
    Data_Memory #(32) dm (
        .clk(clk),
        .mem_write(memwrite_MEMWB),
        .mem_read(memread_MEMWB),
        .address(alu_out_MEMWB),
        .write_data(rd2_out_EXMEM),
        .read_data(read_data_MEMWB)
    );
    
    MEM_WB_Pipeline MWP (
        .clk(clk),
        .reset(~start),
        .read_data_in(read_data_MEMWB),
        .alu_in(alu_out_MEMWB),
        .wr_in(wr_EXMEM),
        .mem_reg_in(memreg_MEMWB), 
        .reg_write_in(regwrite_MEMWB),
        .read_data_out(read_data_F),
        .alu_out(alu_out_F),
        .wr_out(wr_F),
        .mem_reg_out(memreg_F), 
        .reg_write_out(regwrite_F)
    );
    
    Forward_unit fu(
        .reset(~start),
        .regwrite_mem(regwrite_EXMEM),
        .regwrite_wb(regwrite_MEMWB),
        .rs1(instruction_out_IDEX[19:15]),
        .rs2(instruction_out_IDEX[24:20]),
        .rd_mem(wr_EXMEM),
        .rd_wb(wr_F),
        .FA(FA),
        .FB(FB)
    );
    

    
    assign write_data = memreg_F ? read_data_F : alu_out_F;
    
    assign out_1 = write_data[3:0];

    assign pc4 = pc + 4;
    assign next_pc = (branch_MEMWB && zero_EXMEM) ? pc_out_EXMEM : pc4;
//    assign next_pc = pc4;
endmodule