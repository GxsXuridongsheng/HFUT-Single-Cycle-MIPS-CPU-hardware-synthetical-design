`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/16 22:47:46
// Design Name: 
// Module Name: regfile
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


module regfile(
    input wire clk, 
    input wire write_en, 
    input wire [4:0] regaddr1, regaddr2, 
    output wire [31:0] data_out1, data_out2,  
    input wire [4:0] data_addr, 
    input wire [31:0] data_in
    );
    
    reg [31:0] register[31:0];
    
    always @(negedge clk) begin
        if(write_en) begin
            register[data_addr] <= data_in;
        end
    end
    
    assign data_out1 = (regaddr1==0) ? 0 : register[regaddr1];
    assign data_out2 = (regaddr2==0) ? 0 : register[regaddr2];
endmodule
