`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/17 16:22:15
// Design Name: 
// Module Name: tb_mips
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_mips;

    reg clk;
    reg rst;
//    wire [7:0] seg = 0, seg1 = 0, an = 0;
    
    wire [31:0] pc, next_pc, pc_plus4;
    wire [31:0] instruction;
    wire [31:0] writedata;
    wire [31:0] data_addr;
    wire [31:0] mem_data;
    wire memwrite;
    wire [4:0] write_data_reg_addr;
    wire [31:0] write_data_in;
    wire [31:0] aluop1, aluop2;
//    wire [31:0] dataaddr;
    wire [4:0] readdata1_addr;
    wire [4:0] readdata2_addr;
    wire [4:0] sa;
    wire [31:0] readdata1;
    wire [31:0] readdata2;
    wire [4:0] rt_addr;
    wire [4:0] rd_addr;
    wire [31:0] alu_result;
    wire [27:0] j_addr_after_sl2;
    wire [31:0] j_addr;
    wire [31:0] branch_addr_after_se_sl2;
    wire [31:0] pc_pcplus4_branch;
    wire [31:0] branch_addr;
    wire [31:0] imm_after_se;
    wire [31:0] imm_after_ue;
    wire [31:0] imm_to_alu;
    wire [31:0] imm_after_se_sl2;
    wire overflow;
    wire alu_sign_reset;
    wire zero;
    wire equal;
    wire jump;
    wire branch_e, branch_ne;
    wire regdest;
    wire memread;
    wire memtoreg;
    wire alusrc;
    wire regwrite;
    wire [3:0] aluop;
    wire is_sign;
    wire zero_extern;
    wire use_sa;
    wire stall = 0;
    
    initial begin
        clk <= 0;
        rst <= 1;
        
        /*
        这个时间小于输入MIPS的时钟周期的一半时，
        时钟的初值对仿真结果的正确性有影响（初值为1时正确，
        初值为0时错误，这可能与指令在时钟的下降沿产生有关），
        如果这个时间大于MIPS时钟周期的一半，
        那么时钟的初值对仿真结果的正确性无影响
        */
        #30 rst <= 0;// 注意：注意事项见上面的长注释
        #10000 $stop;
    end
    
    always #20 clk = ~clk;
    
    inst_mem  inst_mem (
        .clka(~clk),
        .addra(pc),
        .douta(instruction)
    );
    
    assign data_addr = alu_result;
    assign writedata = readdata2;
    data_mem datamem (
        .clka(~clk),
        .wea(memwrite),
        .addra(data_addr),
        .dina(writedata),
        .douta(mem_data)
    );
    
    dup_mux mem_or_alu(
        .a(alu_result), 
        .b(mem_data), 
        .s(memtoreg), 
        .out(write_data_in)
    );
    
//     seg7 seg7(
//       .clk(clk),
//       .rst(rst),
//       .writedata(writedata),
//       .dataadr(data_addr),
//       .memwrite(memwrite),
//       .seg(seg),
//       .seg1(seg1),
//       .an(an)
//	);
    
    pc_reg pc_reg(
        .clk(clk), 
        .rst(rst), 
        .en(1), 
        .pc_in(next_pc), 
        .pc_out(pc)
    );
    
    adder pcplus4(
        .a(pc), 
        .b(4), 
        .result(pc_plus4)
    );
    
    sl2_jump_addr sl2_jump_addr(
        .in(instruction[25:0]), 
        .out(j_addr_after_sl2)
    );
    
    assign j_addr = {pc_plus4[31:28], j_addr_after_sl2};
    
    controller controller(
        .clk(clk), 
        .rst(rst), 
        .instruction(instruction), 
        .jump(jump), 
        .branch_e(branch_e), 
        .branch_ne(branch_ne), 
        .regdest(regdest), 
        .memread(memread), 
        .memwrite(memwrite), 
        .memtoreg(memtoreg), 
        .alusrc(alusrc), 
        .regwrite(regwrite), 
        .aluop(aluop), 
        .is_sign(is_sign), 
        .zero_extern(zero_extern), 
        .use_sa(use_sa), 
        .alu_sign_reset(alu_sign_reset)
    );
    
    assign rt_addr = instruction[20:16];
    assign rd_addr = instruction[15:11];
    dup_mux write_register_addr(
        .a(rt_addr), 
        .b(rd_addr), 
        .s(regdest), 
        .out(write_data_reg_addr)
    );
    
    assign readdata1_addr = instruction[25:21];
    assign readdata2_addr = regdest ? instruction[20:16] : 0;
    regfile regfile(
        .clk(clk), 
        .write_en(regwrite), 
        .regaddr1(readdata1_addr), 
        .regaddr2(readdata2_addr), 
        .data_out1(readdata1), 
        .data_out2(readdata2),  
        .data_addr(write_data_reg_addr), 
        .data_in(write_data_in)
    );
    
    dup_mux se_or_ue_imm_to_alu(
        .a(imm_after_se), 
        .b(imm_after_ue), 
        .s(zero_extern), 
        .out(imm_to_alu)
    );
    
    dup_mux alu_op2(
        .a(readdata2), 
        .b(imm_to_alu), 
        .s(alusrc), 
        .out(aluop2)
    );
    assign sa = instruction[10:6];
    assign aluop1 = use_sa ? {27'b0, sa} : readdata1;
    
    alu alu(
        .a(aluop1), 
        .b(aluop2), 
        .op(aluop), 
        .sign_rst(alu_sign_reset), 
        .is_sign(is_sign), 
        .result(alu_result), 
        .overflow(overflow), 
        .zero(zero)
    );
    assign equal = zero;
//    assign equal = zero;
    
    se se(
        .in(instruction[15:0]), 
        .out(imm_after_se)
    );
    
    ue ue(
        .in(instruction[15:0]), 
        .out(imm_after_ue)
    );
    
    sl2_branch_addr sl2_branch_addr(
        .in(imm_after_se), 
        .out(imm_after_se_sl2)
    );
    
    assign branch_addr_after_se_sl2 = imm_after_se_sl2;
    adder branch_addr_adder(
        .a(pc_plus4), 
        .b(branch_addr_after_se_sl2), 
        .result(branch_addr)
    );
    
    dup_mux branch_or_pcplus4(
        .a(pc_plus4), 
        .b(branch_addr), 
        .s( (branch_e && equal) || (branch_ne && ~equal) ), 
        .out(pc_pcplus4_branch)
    );
    
    dup_mux jump_or_other(
        .a(pc_pcplus4_branch), 
        .b(j_addr), 
        .s(jump), 
        .out(next_pc)
    );

endmodule
