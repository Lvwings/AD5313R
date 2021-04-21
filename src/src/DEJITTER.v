`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 09:11:51
// Design Name: 
// Module Name: DEJITTER
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


module DEJITTER#(
		parameter	C_HOLD_BIT_NUMBER	=	16,
		parameter	C_INPUT_POLARITY	=	1'b0
	)
	(
    input           sys_clk,
    input           sys_rst,		
    input			signal_in,
    output			signal_out
    );

    reg	[C_HOLD_BIT_NUMBER - 1 : 0]	signal_hold	=	0;

    always @(posedge sys_clk) begin
    	if(sys_rst) begin
    		signal_hold <= 0;
    	end else begin
    		signal_hold <= {signal_hold[C_HOLD_BIT_NUMBER - 2 : 0],signal_in};
    	end
    end

    assign	signal_out	=	(signal_hold == {C_HOLD_BIT_NUMBER{C_INPUT_POLARITY}}) ? C_INPUT_POLARITY : !C_INPUT_POLARITY;
endmodule
