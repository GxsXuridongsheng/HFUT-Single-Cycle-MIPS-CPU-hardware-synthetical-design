`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/15 21:22:54
// Design Name: 
// Module Name: se
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


module se(
    input wire [15:0] in, 
    output wire [31:0] out
    );
    
    assign out = { { 16{in[15]} }, in };
endmodule
