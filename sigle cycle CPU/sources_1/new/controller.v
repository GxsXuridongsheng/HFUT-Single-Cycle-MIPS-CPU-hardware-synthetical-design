`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/15 21:02:40
// Design Name: 
// Module Name: controller
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


module controller(
    input wire clk, 
    input wire rst, 
    input wire [31:0] instruction, 
    output reg jump = 0, 
    output reg branch_e = 0,
    output reg branch_ne = 0,  
    output reg regdest = 0, 
    output reg memread = 0, 
    output reg memwrite = 0, 
    output reg memtoreg = 0, 
    output reg alusrc = 0, 
    output reg regwrite = 0, 
    output reg [3:0] aluop = 4'b0000, 
    output reg is_sign = 1, 
    output reg zero_extern = 0, 
    output reg use_sa = 0, 
    output reg alu_sign_reset = 1
    );
    
    always @(*) begin
        //*************************************************************************************
        //清零
        if(rst) begin
            jump <= 0;// 不跳转
            branch_e <= 0;// 不是beq
            branch_ne <= 0;// 不是bne
            regdest <= 0;// 控制要写的目标寄存器 或者 要不要读rt寄存器； 这里是要写的寄存器是rt或者不读rt寄存器
            memread <= 0;// 不读内存
            memtoreg <= 0;// 不加载内存到寄存器
            memwrite <= 0;// 不写内存
            memtoreg <= 0;// 不加载内存到寄存器
            alusrc <= 0;// alu第二个操作数来源为寄存器
            regwrite <= 0;// 不写寄存器
            aluop <= 4'b0000;// 加
            is_sign <= 1;// 有符号
            zero_extern <= 0;// 不用0拓展立即数
            use_sa <= 0;// 不使用shift amount
            alu_sign_reset <= 1;// 清零时将alu的标志位清零
        end
        //*************************************************************************************
        // R 类指令
        else if(instruction[31:26] == 6'b0) begin
            regdest <= 1;// 目标寄存器是rd
            alusrc <= 0;// 第二个操作数来源是寄存器
            regwrite <= 1;// 要写寄存器
            memread <= 0;// 不读内存
            memwrite <= 0;// 不写内存
            branch_e <= 0;// 不是beq指令
            branch_ne <= 0;// 不是bne指令
            jump <= 0;// 不是无条件跳转指令
            is_sign <= 1;// 有符号数运算
            zero_extern <= 0;// 不用0拓展立即数
            use_sa <= 0;// 不使用shift amount
            alu_sign_reset <= 1;// 清空alu的标志位
            if(instruction[5:0] == 0) begin//sll
                use_sa <= 1;// 使用shift amount
                aluop <= 4'b0111;// 要进行sll
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 2) begin//srl
                use_sa <= 1;// 使用shift amount
                aluop <= 4'b1000;// 要进行srl
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 3) begin//sra
                use_sa <= 1;// 使用shift amount
                aluop <= 4'b1001;// 要进行sra
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 4) begin//sllv
                aluop <= 4'b0111;// 要进行sllv
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 6) begin//srlv
                aluop <= 4'b1000;// 要进行srlv
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 7) begin//srav
                aluop <= 4'b1001;// 要进行srav
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 8) begin//jr
                
            end
            else if(instruction[5:0] == 9) begin//jalr
                
            end
            else if(instruction[5:0] == 10) begin//movz
                
            end
            else if(instruction[5:0] == 11) begin//movn
                
            end
            else if(instruction[5:0] == 12) begin//syscall
                
            end
            else if(instruction[5:0] == 13) begin//break
                
            end
            else if(instruction[5:0] == 15) begin//sync
                
            end
            else if(instruction[5:0] == 16) begin//mfhi
                
            end
            else if(instruction[5:0] == 17) begin//mthi
                
            end
            else if(instruction[5:0] == 18) begin//mflo
                
            end
            else if(instruction[5:0] == 19) begin//mtlo
                
            end
            else if(instruction[5:0] == 24) begin//mult
                
            end
            else if(instruction[5:0] == 25) begin//multu
                
            end
            else if(instruction[5:0] == 26) begin//div
                
            end
            else if(instruction[5:0] == 27) begin//divu
                
            end
            else if(instruction[5:0] == 32) begin//add
                aluop <= 4'b0000;// 要进行加
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 33) begin//addu
                aluop <= 4'b0000;// 要进行加
                is_sign <= 0;// 无符号数
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 34) begin//sub
                aluop <= 4'b0001;// 要进行减
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 35) begin//subu
                aluop <= 4'b0001;// 要进行减
                is_sign <= 0;// 无符号数
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 36) begin//and
                aluop <= 4'b0010;// 要进行与
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 37) begin//or
                aluop <= 4'b0011;// 要进行或
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 38) begin//xor
                aluop <= 4'b0100;// 要进行异或
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 39) begin//nor
                aluop <= 4'b0101;// 要进行或非
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 42) begin//slt
                aluop <= 4'b0110;// 要进行slt操作
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[5:0] == 43) begin//sltu
                aluop <= 4'b0110;// 要进行sltu
                alu_sign_reset <= 0;// 不清空alu的标志位
                is_sign <= 0;// 无符号数
            end
            else if(instruction[5:0] == 48) begin//tge
                
            end
            else if(instruction[5:0] == 49) begin//tgeu
                
            end
            else if(instruction[5:0] == 50) begin//tlt
                
            end
            else if(instruction[5:0] == 51) begin//tltu
                
            end
            else if(instruction[5:0] == 52) begin//teq
                
            end
            else if(instruction[5:0] == 54) begin//tne
                
            end
            else begin//错误
                
            end
        end
        //*************************************************************************************
        // J 类指令
        else if(instruction[31:26] >= 2 && instruction[31:26] <= 3) begin
            jump <= 1;// 是无条件跳转指令
            alu_sign_reset <= 1;// 清空alu的标志位
            zero_extern <= 0;// 不用0拓展立即数
            use_sa <= 0;// 不使用shift amount
            if(instruction[31:26] == 2) begin//j
                branch_e <= 0;// 不是beq
                branch_ne <= 0;// 不是bne
                regdest <= 0;// 控制要写的目标寄存器 或者 要不要读rt寄存器； 这里是要写的寄存器是rt或者不读rt寄存器
                memread <= 0;// 不读内存
                memwrite <= 0;// 不写内存
                memtoreg <= 0;// 不加载内存到寄存器
                alusrc <= 0;// alu第二个操作数来源为寄存器
                regwrite <= 0;// 不写寄存器
                aluop <= 4'b0000;// 加
                is_sign <= 1;// 有符号
            end
            else begin//jal
                
            end
        end
        //*************************************************************************************
        // I 类指令
        else begin
            regdest <= 0;// 目标寄存器是rt
            alusrc <= 1;// 第二个操作数来源于立即数
            regwrite <= 1;// 要写寄存器
            memread <= 0;// 不读内存
            memtoreg <= 0;// 不加载内存到寄存器
            memwrite <= 0;// 不写内存
            branch_e <= 0;// 不是beq指令
            branch_ne <= 0;// 不是bne指令
            jump <= 0;// 不是无条件跳转指令
            is_sign <= 1;// 有符号数运算
            zero_extern <= 0;// 不用0拓展立即数
            use_sa <= 0;// 不使用shift amount
            alu_sign_reset <= 1;// 清空alu的标志位
            if(instruction[31:26] == 4) begin//beq
                branch_e <= 1;// beq指令
                regdest <= 1;// 只有regdest为1的情况下，rt寄存器的输出才是正常的，否则输出全0
                alusrc <= 0;// 第二个操作数来自寄存器
                aluop <= 4'b0001;// 要进行减
                regwrite <= 0;// 不写寄存器
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[31:26] == 5) begin//bne
                branch_ne <= 1;// bne指令
                regdest <= 1;// 只有regdest为1的情况下，rt寄存器的输出才是正常的，否则输出全0
                alusrc <= 0;// 第二个操作数来自寄存器
                aluop <= 4'b0001;// 要进行减
                regwrite <= 0;// 不写寄存器
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[31:26] == 6) begin//blez
                
            end
            else if(instruction[31:26] == 7) begin//bgtz
                
            end
            else if(instruction[31:26] == 8) begin//addi
                aluop <= 4'b0000;// 要进行加
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[31:26] == 9) begin//addiu
                aluop <= 4'b0000;// 要进行加
                is_sign = 0;// 无符号数
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[31:26] == 10) begin//slti
                aluop <= 4'b0110;// 要进行slti
                alu_sign_reset <= 0;// 不清空alu的标志位
            end
            else if(instruction[31:26] == 11) begin//sltiu
                aluop <= 4'b0110;// 要进行sltiu
                alu_sign_reset <= 0;// 不清空alu的标志位
                is_sign = 0;// 无符号数
            end
            else if(instruction[31:26] == 12) begin//andi
                aluop <= 4'b0010;// 要进行与
                alu_sign_reset <= 0;// 不清空alu的标志位
                zero_extern <= 1;// 立即数用0拓展
            end
            else if(instruction[31:26] == 13) begin//ori
                aluop <= 4'b0011;// 要进行立即数或
                alu_sign_reset <= 0;// 不清空alu的标志位
                zero_extern <= 1;// 立即数用0拓展
            end
            else if(instruction[31:26] == 14) begin//xori
                aluop <= 4'b0100;// 要进行立即数异或
                alu_sign_reset <= 0;// 不清空alu的标志位
                zero_extern <= 1;// 立即数用0拓展
            end
            else if(instruction[31:26] == 15) begin//lui
                
            end
            else if(instruction[31:26] == 32) begin//lb
                
            end
            else if(instruction[31:26] == 33) begin//lh
                
            end
            else if(instruction[31:26] == 34) begin//lwl
                
            end
            else if(instruction[31:26] == 35) begin//lw
                memread <= 1;// 要读内存
                memtoreg <= 1;// 要写寄存器
                aluop <= 4'b0000;// 要进行加
            end
            else if(instruction[31:26] == 36) begin//lbu
                
            end
            else if(instruction[31:26] == 37) begin//lhu
                
            end
            else if(instruction[31:26] == 38) begin//lwr
                
            end
            else if(instruction[31:26] == 40) begin//sb
                
            end
            else if(instruction[31:26] == 41) begin//sh
                
            end
            else if(instruction[31:26] == 42) begin//swl
                
            end
            else if(instruction[31:26] == 43) begin//sw
                memwrite <= 1;// sw要写内存
                aluop <= 4'b0000;// sw要进行加
                regwrite <= 0;// sw不写寄存器
                regdest <= 1;//regdest控制要写哪个寄存器，也控制是否要读rt寄存器，这里控制要读rt寄存器
            end
            else if(instruction[31:26] == 46) begin//swr
                
            end
            else if(instruction[31:26] == 47) begin//cache
                
            end
            else if(instruction[31:26] == 48) begin//ll
                
            end
            else if(instruction[31:26] == 49) begin//lwc1
                
            end
            else if(instruction[31:26] == 50) begin//lwc2
                
            end
            else if(instruction[31:26] == 51) begin//pref
                
            end
            else if(instruction[31:26] == 53) begin//ldc1
                
            end
            else if(instruction[31:26] == 54) begin//ldc2
                
            end
            else if(instruction[31:26] == 56) begin//sc
                
            end
            else if(instruction[31:26] == 57) begin//swc1
                
            end
            else if(instruction[31:26] == 58) begin//swc2
                
            end
            else if(instruction[31:26] == 61) begin//sdc1
                
            end
            else if(instruction[31:26] == 62) begin//sdc2
                
            end
            else begin//错误
                
            end
        end
    end
endmodule
