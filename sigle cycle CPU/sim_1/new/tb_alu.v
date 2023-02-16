`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/16 17:42:52
// Design Name: 
// Module Name: tb_alu
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


module tb_alu;

    reg clk = 0;
    reg rst;
    reg [31:0] num1 = 32'h00000001, num2 = 32'h00000002;
    reg [1:0] op = 0;
    reg is_sign = 1;
    wire [31:0] result;
    wire overflow;
    wire zero;
    
    always #20 clk = ~clk;
    
    always @(posedge clk) begin
        if(op >= 4'h3) begin
            op = 0;
        end
        else begin
           op = op + 1;
        end
    end
    
    initial begin
        #500 $stop;
    end
    
    alu alu(
        .a(num1), 
        .b(num2), 
        .op(op), 
        .is_sign(is_sign), 
        .result(result), 
        .overflow(overflow), 
        .zero(zero)
    );
    
endmodule
