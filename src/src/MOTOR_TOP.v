`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 09:23:06
// Design Name: 
// Module Name: MOTOR_TOP
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


module MOTOR_TOP#(   
	// AXI parameters
    parameter C_AXI_ID_WIDTH       = 4,        // The AXI id width used for read and write // This is an integer between 1-16
    parameter C_AXI_ADDR_WIDTH     = 16,       // This is AXI address width for all        // SI and MI slots
    parameter C_AXI_DATA_WIDTH     = 64,       // Width of the AXI write and read data
    parameter C_AXI_NBURST_SUPPORT = 1'b0,     // Support for narrow burst transfers       // 1-supported, 0-not supported 
    parameter C_AXI_BURST_TYPE     = 2'b00,    // 00:FIXED 01:INCR 10:WRAP
    parameter WATCH_DOG_WIDTH      = 12,        // Start address of the address map
	// ETH receive channel setting
    parameter C_ADDR_SUMOFFSET     =   32'h0000_1000,
    parameter C_ADDR_MOTOR2ETH     =   32'h0000_0000,       
    // ETH send channel setting
    parameter C_ADDR_ETH2MOTOR     =   32'hE000_0000    
)(    
    input                               sys_clk,
    input                               sys_rst,

 // AXI write address channel signals
   	output                            	saxi_wready, // Indicates slave is ready to accept a 
   	input [C_AXI_ID_WIDTH-1:0]        	saxi_wid,    // Write ID
   	input [C_AXI_ADDR_WIDTH-1:0]      	saxi_waddr,  // Write address
   	input [7:0]                       	saxi_wlen,   // Write Burst Length
   	input [2:0]                       	saxi_wsize,  // Write Burst size
   	input [1:0]                       	saxi_wburst, // Write Burst type
   	input [1:0]                       	saxi_wlock,  // Write lock type
   	input [3:0]                       	saxi_wcache, // Write Cache type
   	input [2:0]                       	saxi_wprot,  // Write Protection type
   	input                             	saxi_wvalid, // Write address valid
  
// AXI write data channel signals
   	output                            	saxi_wd_wready,  // Write data ready
   	input [C_AXI_DATA_WIDTH-1:0]      	saxi_wd_wdata,    // Write data
   	input [C_AXI_DATA_WIDTH/8-1:0]    	saxi_wd_wstrb,    // Write strobes
   	input                             	saxi_wd_wlast,    // Last write transaction   
   	input                             	saxi_wd_wvalid,   // Write valid
  
// AXI write response channel signals
   	output  [C_AXI_ID_WIDTH-1:0]      	saxi_wb_bid,     // Response ID
   	output  [1:0]                     	saxi_wb_bresp,   // Write response
   	output                            	saxi_wb_bvalid,  // Write reponse valid
   	input                             	saxi_wb_bready,  // Response ready
  
// AXI read address channel signals
   	output                            	saxi_rready,     // Read address ready
   	input [C_AXI_ID_WIDTH-1:0]        	saxi_rid,        // Read ID
   	input [C_AXI_ADDR_WIDTH-1:0]      	saxi_raddr,      // Read address
   	input [7:0]                       	saxi_rlen,       // Read Burst Length
   	input [2:0]                       	saxi_rsize,      // Read Burst size
   	input [1:0]                       	saxi_rburst,     // Read Burst type
   	input [1:0]                       	saxi_rlock,      // Read lock type
   	input [3:0]                       	saxi_rcache,     // Read Cache type
   	input [2:0]                       	saxi_rprot,      // Read Protection type
   	input                             	saxi_rvalid,     // Read address valid
  
// AXI read data channel signals   
   	output  [C_AXI_ID_WIDTH-1:0]       	saxi_rd_rid,     // Response ID
   	output  [1:0]                      	saxi_rd_rresp,   // Read response
   	output                             	saxi_rd_rvalid,  // Read reponse valid
   	output  [C_AXI_DATA_WIDTH-1:0]     	saxi_rd_rdata,   // Read data
   	output                             	saxi_rd_rlast,   // Read last
   	input                              	saxi_rd_rready,   // Read Response ready   

 // AXI write address channel signals
	input                               maxi_wready, // Indicates slave is ready to accept a 
	output [C_AXI_ID_WIDTH-1:0]         maxi_wid,    // Write ID
	output [C_AXI_ADDR_WIDTH-1:0]       maxi_waddr,  // Write address
	output [7:0]                        maxi_wlen,   // Write Burst Length
	output [2:0]                        maxi_wsize,  // Write Burst size
	output [1:0]                        maxi_wburst, // Write Burst type
	output [1:0]                        maxi_wlock,  // Write lock type
	output [3:0]                        maxi_wcache, // Write Cache type
	output [2:0]                        maxi_wprot,  // Write Protection type
	output                              maxi_wvalid, // Write address valid
   
 // AXI write data channel signals
	input                               maxi_wd_wready,  // Write data ready
	output [C_AXI_DATA_WIDTH-1:0]       maxi_wd_wdata,    // Write data
	output [C_AXI_DATA_WIDTH/8-1:0]     maxi_wd_wstrb,    // Write strobes
	output                              maxi_wd_wlast,    // Last write transaction   
	output                              maxi_wd_wvalid,   // Write valid
   
 // AXI write response channel signals
	input  [C_AXI_ID_WIDTH-1:0]         maxi_wb_bid,     // Response ID
	input  [1:0]                        maxi_wb_bresp,   // Write response
	input                               maxi_wb_bvalid,  // Write reponse valid
	output                              maxi_wb_bready,  // Response ready
   
 // AXI read address channel signals
	input                               maxi_rready,     // Read address ready
	output [C_AXI_ID_WIDTH-1:0]         maxi_rid,        // Read ID
	output [C_AXI_ADDR_WIDTH-1:0]       maxi_raddr,      // Read address
	output [7:0]                        maxi_rlen,       // Read Burst Length
	output [2:0]                        maxi_rsize,      // Read Burst size
	output [1:0]                        maxi_rburst,     // Read Burst type
	output [1:0]                        maxi_rlock,      // Read lock type
	output [3:0]                        maxi_rcache,     // Read Cache type
	output [2:0]                        maxi_rprot,      // Read Protection type
	output                              maxi_rvalid,     // Read address valid
   
 // AXI read data channel signals   
	input  [C_AXI_ID_WIDTH-1:0]         maxi_rd_bid,     // Response ID
	input  [1:0]                        maxi_rd_rresp,   // Read response
	input                               maxi_rd_rvalid,  // Read reponse valid
	input  [C_AXI_DATA_WIDTH-1:0]       maxi_rd_rdata,   // Read data
	input                               maxi_rd_rlast,   // Read last
	output                              maxi_rd_rready,   // Read Response ready
 // DAC ports
 	output								sclk,
 	output								sync_n,
 	output								sdin,
 	output								reset_n,
 	input								sdo,
 //	motor interface
 	output			fwd,
 	output			rev,
 	output			stop_mode,
 	output			m0,
 	output			m1,
 	output			alarm_reset,
 	input			speed_out,
 	input			alarm_out_n,
 //	trigger
 	output			trig_ad_convst

    );

	wire 	alarm_in_n;

	BLE_CTRL inst_BLE_CTRL
		(
			.sys_clk           (sys_clk),
			.sys_rst           (sys_rst),
			.motor_state       (motor_state),
			.motor_direction   (motor_direction),
			.motor_alarm_reset (motor_alarm_reset),
			.fwd               (fwd),
			.rev               (rev),
			.stop_mode         (stop_mode),
			.m0                (m0),
			.m1                (m1),
			.alarm_reset       (alarm_reset),
			.speed_out         (speed_out),
			.alarm_out_n       (alarm_in_n)
		);

	DAC_CTRL #(
			.C_AXI_ID_WIDTH(C_AXI_ID_WIDTH),
			.C_AXI_ADDR_WIDTH(C_AXI_ADDR_WIDTH),
			.C_AXI_DATA_WIDTH(C_AXI_DATA_WIDTH),
			.C_AXI_NBURST_SUPPORT(C_AXI_NBURST_SUPPORT),
			.C_AXI_BURST_TYPE(C_AXI_BURST_TYPE),
			.WATCH_DOG_WIDTH(WATCH_DOG_WIDTH),
			.C_ADDR_SUMOFFSET(C_ADDR_SUMOFFSET),
			.C_ADDR_MOTOR2ETH(C_ADDR_MOTOR2ETH),
			.C_ADDR_ETH2MOTOR(C_ADDR_ETH2MOTOR)
		) inst_DAC_CTRL (
			.sys_clk           (sys_clk),
			.sys_rst           (sys_rst),
			.saxi_wready       (saxi_wready),
			.saxi_wid          (saxi_wid),
			.saxi_waddr        (saxi_waddr),
			.saxi_wlen         (saxi_wlen),
			.saxi_wsize        (saxi_wsize),
			.saxi_wburst       (saxi_wburst),
			.saxi_wlock        (saxi_wlock),
			.saxi_wcache       (saxi_wcache),
			.saxi_wprot        (saxi_wprot),
			.saxi_wvalid       (saxi_wvalid),
			.saxi_wd_wready    (saxi_wd_wready),
			.saxi_wd_wdata     (saxi_wd_wdata),
			.saxi_wd_wstrb     (saxi_wd_wstrb),
			.saxi_wd_wlast     (saxi_wd_wlast),
			.saxi_wd_wvalid    (saxi_wd_wvalid),
			.saxi_wb_bid       (saxi_wb_bid),
			.saxi_wb_bresp     (saxi_wb_bresp),
			.saxi_wb_bvalid    (saxi_wb_bvalid),
			.saxi_wb_bready    (saxi_wb_bready),
			.saxi_rready       (saxi_rready),
			.saxi_rid          (saxi_rid),
			.saxi_raddr        (saxi_raddr),
			.saxi_rlen         (saxi_rlen),
			.saxi_rsize        (saxi_rsize),
			.saxi_rburst       (saxi_rburst),
			.saxi_rlock        (saxi_rlock),
			.saxi_rcache       (saxi_rcache),
			.saxi_rprot        (saxi_rprot),
			.saxi_rvalid       (saxi_rvalid),
			.saxi_rd_rid       (saxi_rd_rid),
			.saxi_rd_rresp     (saxi_rd_rresp),
			.saxi_rd_rvalid    (saxi_rd_rvalid),
			.saxi_rd_rdata     (saxi_rd_rdata),
			.saxi_rd_rlast     (saxi_rd_rlast),
			.saxi_rd_rready    (saxi_rd_rready),
			.maxi_wready       (maxi_wready),
			.maxi_wid          (maxi_wid),
			.maxi_waddr        (maxi_waddr),
			.maxi_wlen         (maxi_wlen),
			.maxi_wsize        (maxi_wsize),
			.maxi_wburst       (maxi_wburst),
			.maxi_wlock        (maxi_wlock),
			.maxi_wcache       (maxi_wcache),
			.maxi_wprot        (maxi_wprot),
			.maxi_wvalid       (maxi_wvalid),
			.maxi_wd_wready    (maxi_wd_wready),
			.maxi_wd_wdata     (maxi_wd_wdata),
			.maxi_wd_wstrb     (maxi_wd_wstrb),
			.maxi_wd_wlast     (maxi_wd_wlast),
			.maxi_wd_wvalid    (maxi_wd_wvalid),
			.maxi_wb_bid       (maxi_wb_bid),
			.maxi_wb_bresp     (maxi_wb_bresp),
			.maxi_wb_bvalid    (maxi_wb_bvalid),
			.maxi_wb_bready    (maxi_wb_bready),
			.maxi_rready       (maxi_rready),
			.maxi_rid          (maxi_rid),
			.maxi_raddr        (maxi_raddr),
			.maxi_rlen         (maxi_rlen),
			.maxi_rsize        (maxi_rsize),
			.maxi_rburst       (maxi_rburst),
			.maxi_rlock        (maxi_rlock),
			.maxi_rcache       (maxi_rcache),
			.maxi_rprot        (maxi_rprot),
			.maxi_rvalid       (maxi_rvalid),
			.maxi_rd_bid       (maxi_rd_bid),
			.maxi_rd_rresp     (maxi_rd_rresp),
			.maxi_rd_rvalid    (maxi_rd_rvalid),
			.maxi_rd_rdata     (maxi_rd_rdata),
			.maxi_rd_rlast     (maxi_rd_rlast),
			.maxi_rd_rready    (maxi_rd_rready),
			.sclk              (sclk),
			.sync_n            (sync_n),
			.sdin              (sdin),
			.reset_n           (reset_n),
			.sdo               (sdo),
			.motor_state       (motor_state),
			.motor_direction   (motor_direction),
			.motor_alarm_reset (motor_alarm_reset),
			.alarm_in_n        (alarm_in_n),
			.alarm_reset       (alarm_reset),
			.trig_ad_convst    (trig_ad_convst)
		);


	DEJITTER #(
			.C_HOLD_BIT_NUMBER(16),
			.C_INPUT_POLARITY(0)
		) inst_DEJITTER (
			.sys_clk    (sys_clk),
			.sys_rst    (sys_rst),
			.signal_in  (alarm_out_n),
			.signal_out (alarm_in_n)
		);

endmodule
