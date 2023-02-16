`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/15 21:02:13
// Design Name: 
// Module Name: alu
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


module alu(
    input wire [31:0] a, 
    input wire [31:0] b, 
    input wire [3:0] op, 
    input wire sign_rst, 
    input wire is_sign, 
    output reg [31:0] result, 
    output reg overflow, 
    output wire zero
    );
    
    reg [32:0] temp_result = 0;
    reg [4:0] sa;
    reg sign;
    reg [31:0] temp;
    
    always @(*) begin
        if(is_sign) begin
            case(op)
                4'b0000: begin 
                    result <= a + b;
                    overflow <= (a[31]==b[31]) ? (a[31]!=result[31]) : 0;
                end
                4'b0001: begin 
                    result <= a - b;
                    overflow <= (a[31]!=b[31]) ? (b[31]==result[31]) : 0;
                end
                4'b0010: begin 
                    result <= a & b;
                    overflow <= 0;
                end
                4'b0011: begin 
                    result <= a | b;
                    overflow <= 0;
                end
                4'b0100: begin 
//                    result <= (a & ~b) || (~a & b);
                    result <= (a & ~b) | (~a & b);
                    overflow <= 0;
                end
                4'b0101: begin 
                    result <= ~(a | b);
                    overflow <= 0;
                end
                4'b0110: begin 
                    result <= (a[31] > b[31]) ? 1 : (a[31] == b[31]) ? (a < b) : 0;
                    overflow <= 0;
                end
                4'b0111: begin 
                    sa <= a[4:0];
                    temp = b;
                    if(sa[4]) begin
                        temp = {temp[31-16:0], 16'b0};
                    end
                    if(sa[3]) begin
                        temp = {temp[31-8:0], 8'b0};
                    end
                    if(sa[2]) begin
                        temp = {temp[31-4:0], 4'b0};
                    end
                    if(sa[1]) begin
                        temp = {temp[31-2:0], 2'b0};
                    end
                    if(sa[0]) begin
                        temp = {temp[31-1:0], 1'b0};
                    end
                    result = temp;
                    overflow <= 0;
                end
                4'b1000: begin 
                    sa <= a[4:0];
                    temp = b;
                    if(sa[4]) begin
                        temp = {16'b0, temp[31:16]};
                    end
                    if(sa[3]) begin
                        temp = {8'b0, temp[31:8]};
                    end
                    if(sa[2]) begin
                        temp = {4'b0, temp[31:4]};
                    end
                    if(sa[1]) begin
                        temp = {2'b0, temp[31:2]};
                    end
                    if(sa[0]) begin
                        temp = {1'b0, temp[31:1]};
                    end
                    result = temp;
                    overflow <= 0;
                end
                4'b1001: begin 
                    sa <= a[4:0];
                    sign <= b[31];
                    temp = b;
                    if(sa[4]) begin
                        temp = { {16{sign}}, temp[31:16]};
                    end
                    if(sa[3]) begin
                        temp = { {8{sign}}, temp[31:8]};
                    end
                    if(sa[2]) begin
                        temp = { {4{sign}}, temp[31:4]};
                    end
                    if(sa[1]) begin
                        temp = { {2{sign}}, temp[31:2]};
                    end
                    if(sa[0]) begin
                        temp = { {1{sign}}, temp[31:1]};
                    end
                    result = temp;
                    overflow <= 0;
                end
                default: begin
                    result <= 0;
                    overflow <= 0;
                end
            endcase
        end
        else begin
            overflow <= 0;// 无符号运算不会溢出
            case(op)
                4'h0000: begin 
                    temp_result <= a + b;
                end
                4'b0001: begin 
                    result <= a - b;
                end
                4'b0010: begin 
                    result <= a & b;
                end
                4'b0011: begin 
                    result <= a | b;
                end
                4'b0100: begin 
                    result <= (a & ~b) | (~a & b);
                end
                4'b0101: begin 
                    result <= ~(a | b);
                end
                4'b0110: begin 
                    result <= (a < b);
                end
                default: begin
                    result <= 0;
                end
            endcase
        end
        
        if(sign_rst) begin
            overflow <= 0;
        end
    end
    
    assign zero = sign_rst ? 0 : (result == 32'b0);
    
endmodule
