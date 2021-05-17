`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/19 14:33:17
// Design Name: 
// Module Name: BLE_CTRL
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


module BLE_CTRL(
    input           sys_clk,
    input           sys_rst,	
 //	motor state
 	input			motor_state,
 	input			motor_direction,
 	input			motor_alarm_reset,
 //	motor interface
 	output			fwd,
 	output			rev,
 	output			stop_mode,
 	output			m0,
 	output			m1,
 	output			alarm_reset,
 	input			speed_out,
 	input			alarm_out_n	
    );

	assign			m0	=	0;
	assign			m1	=	0;
//*****************************************************************************
// fwd	rev
//*****************************************************************************			
	reg				o_fwd	=	1'b0;
	reg				o_rev	=	1'b0;

	always @(posedge sys_clk) begin
		if (motor_alarm_reset) begin 
			o_fwd	<=	0;
			o_rev	<=	0;
		end
		else if(motor_state) begin
			o_fwd	<=	motor_direction;
			o_rev	<=	~motor_direction;
		end else begin
			o_fwd	<=	0;
			o_rev	<=	0;
		end
	end

	assign			fwd	=	o_fwd;
	assign			rev	=	o_rev;
//*****************************************************************************
// stop mode
//*****************************************************************************			
	reg				o_stop_mode	=	1'b0;

	always @(posedge sys_clk) begin
		if(motor_alarm_reset) begin
			o_stop_mode <= 1;
		end else begin
			o_stop_mode <= 0;
		end
	end

	assign	stop_mode	=	o_stop_mode;
//*****************************************************************************
// alarm reset
//*****************************************************************************			
	reg	[31:0]			tmie_cnt	=	0;
	localparam			TIME_10S	=	32'h3B9A_CA00,
						TIME_10MS	=	32'h001E_8480,
						TIME_10US	=	32'h0000_07D0;

	reg					o_alarm_reset	=	1'b0;
	reg					alarm_out_n_d	=	1'b0;

	always @(posedge sys_clk) begin
		alarm_out_n_d	<=	alarm_out_n;

		if(!alarm_out_n_d) begin
			tmie_cnt <= tmie_cnt + 1;
		end else if (motor_alarm_reset || alarm_reset) begin
			tmie_cnt <= 0;
		end
		else
			tmie_cnt <= tmie_cnt;
	end					

	always @(posedge sys_clk) begin
		if(motor_alarm_reset) begin
			o_alarm_reset <= 1;
		end else if (tmie_cnt > TIME_10S) begin
			o_alarm_reset <= 1;
		end
		else 
			o_alarm_reset <= 0;
	end

	assign	alarm_reset	=	o_alarm_reset;
endmodule
