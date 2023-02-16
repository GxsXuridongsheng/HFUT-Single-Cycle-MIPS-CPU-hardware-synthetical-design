`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/16 22:14:42
// Design Name: 
// Module Name: seg7
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


module seg7(
    input clk,
    input rst,
    input [31:0] writedata,
    input [31:0] dataadr,
    input memwrite,
    output reg[7:0] seg = 0,
    output reg[7:0] seg1 = 0,
    output reg[7:0] an //λѡ������Ч
);

    reg[31:0] writedata2 = 0;
    reg[18:0] divclk_cnt = 0;//��Ƶ������
    reg divclk = 0;//��Ƶ���ʱ��?
    reg[3:0] disp_dat=0;//Ҫ��ʾ������
    reg[2:0] disp_bit=0;//Ҫ��ʾ��λ
    parameter maxcnt = 50000;// ���ڣ�50000*2/100M
    parameter second_count = 100000000;
    
    always @(posedge memwrite) begin
        writedata2 = writedata;
    end
    
    always@(posedge clk)
    begin
        if(divclk_cnt >= maxcnt)
        begin
            divclk = ~divclk;
            divclk_cnt = 0;
        end
        else
        begin
            divclk_cnt = divclk_cnt + 1'b1;
        end
    end

    always@(posedge divclk) begin
        if(disp_bit >= 7)
            disp_bit = 0;
         else
            disp_bit = disp_bit + 1'b1;
         case (disp_bit)
            3'b000 :
            begin
                disp_dat=writedata2[3:0];
                an=8'b10000000;//���λ
            end
            3'b001 :
            begin
                disp_dat=writedata2[7:4];
                an=8'b01000000;
            end
            3'b010 :
            begin
                disp_dat=writedata2[11:8];
                an=8'b00100000;
            end
            3'b011 :
            begin
                disp_dat=writedata2[15:12];
                an=8'b00010000;
            end
            3'b100 :
            begin
                disp_dat=writedata2[19:16];
                an=8'b00001000;
            end
            3'b101 :
            begin
                disp_dat=writedata2[23:20];
                an=8'b00000100;
            end
            3'b110 :
            begin
                disp_dat=writedata2[27:24];
                an=8'b00000010;
            end
            3'b111 :
            begin
                disp_dat=writedata2[31:28];
                an=8'b00000001;
            end
            default:
            begin
                disp_dat=0;
                an=8'b00000000;
            end
        endcase
    end
    always@(disp_dat)
    begin
        if(an < 8'b00010000) begin
            case (disp_dat)
                4'h0 : seg = 8'h3f;
                4'h1 : seg = 8'h06;
                4'h2 : seg = 8'h5b;
                4'h3 : seg = 8'h4f;
                4'h4 : seg = 8'h66;
                4'h5 : seg = 8'h6d;
                4'h6 : seg = 8'h7d;
                4'h7 : seg = 8'h07;
                4'h8 : seg = 8'h7f;
                4'h9 : seg = 8'h6f;
                4'ha : seg = 8'h77;
                4'hb : seg = 8'h7c;
                4'hc : seg = 8'h39;
                4'hd : seg = 8'h5e;
                4'he : seg = 8'h79;
                4'hf : seg = 8'h71;
                default : seg = 8'h3f;
            endcase
        end
        else begin
            case (disp_dat)
                4'h0 : seg1 = 8'h3f;
                4'h1 : seg1 = 8'h06;
                4'h2 : seg1 = 8'h5b;
                4'h3 : seg1 = 8'h4f;
                4'h4 : seg1 = 8'h66;
                4'h5 : seg1 = 8'h6d;
                4'h6 : seg1 = 8'h7d;
                4'h7 : seg1 = 8'h07;
                4'h8 : seg1 = 8'h7f;
                4'h9 : seg1 = 8'h6f;
                4'ha : seg1 = 8'h77;
                4'hb : seg1 = 8'h7c;
                4'hc : seg1 = 8'h39;
                4'hd : seg1 = 8'h5e;
                4'he : seg1 = 8'h79;
                4'hf : seg1 = 8'h71;
                default : seg = 8'h3f;
            endcase
        end
    end
endmodule
