`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/15 20:59:17
// Design Name: 
// Module Name: dup_mux
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


module dup_mux(
    input wire [31:0] a, 
    input wire [31:0] b, 
    input wire s, 
    output wire [31:0] out
    );
    
    assign out = s ? b : a;
endmodule
