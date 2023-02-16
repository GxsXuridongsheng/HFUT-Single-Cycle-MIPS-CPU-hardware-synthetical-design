`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/15 21:01:00
// Design Name: 
// Module Name: tri_mux
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


module tri_mux(
    input wire [31:0] a, 
    input wire [31:0] b, 
    input wire [31:0] c, 
    input wire [1:0] s, 
    output wire [31:0] out
    );
    
    assign out = (s == 2'b10) ? c : 
                 (s == 2'b01) ? b : a;
endmodule
