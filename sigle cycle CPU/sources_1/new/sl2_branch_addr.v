`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/17 09:47:17
// Design Name: 
// Module Name: sl2_branch_addr
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


module sl2_branch_addr(
    input wire [31:0] in, 
    output wire [31:0] out
    );
    
    assign out = {in[29:0], 2'b00};
endmodule
