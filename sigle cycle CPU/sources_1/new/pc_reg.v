`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/15 20:55:36
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
    input wire clk, 
    input wire rst, 
    input wire en, 
    input wire [31:0] pc_in, 
    output reg [31:0] pc_out
    );
    
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            pc_out <= 0;
        end
        else if(en) begin
            pc_out <= pc_in;
        end
    end
endmodule
