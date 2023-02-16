`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/22 18:54:57
// Design Name: 
// Module Name: ue
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


module ue(
    input wire [15:0] in, 
    output wire [31:0] out
    );
    
    assign out = {16'b0, in};
endmodule
