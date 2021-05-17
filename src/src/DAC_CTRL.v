`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/16 14:32:32
// Design Name: 
// Module Name: DAC_CTRL
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


module DAC_CTRL  #(   
	// AXI parameters
    parameter C_AXI_ID_WIDTH       = 4,        // The AXI id width used for read and write // This is an integer between 1-16
    parameter C_AXI_ADDR_WIDTH     = 32,       // This is AXI address width for all        // SI and MI slots
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

 //	motor state
 	output								motor_state,
 	output								motor_direction,
 	output								motor_alarm_reset,
 	input								alarm_in_n,
 	input								alarm_reset,
 	output								trig_ad_convst
    );
//*****************************************************************************
// output register
//*****************************************************************************			
	reg								o_sclk		=	1'b1;	
	reg								sclk_p		=	1'b1;
	reg								o_sync_n	=	1'b1;
	reg								o_sdin		=	1'b0;
	reg								o_reset_n	=	1'b1;

	reg								o_motor_state		=	1'b0;
	reg								o_moter_direction	=	1'b1;
	reg								o_alarm_reset		=	1'b0;
	reg								o_trig_ad			=	1'b0;

	assign							sclk		=	o_sclk;	
	assign							sync_n		=	o_sync_n;
	assign							sdin		=	o_sdin	;	
	assign							reset_n		=	o_reset_n;	

	assign                          motor_state     	=   o_motor_state;
	assign                          motor_direction 	=   o_moter_direction;
	assign							motor_alarm_reset	=	o_alarm_reset;
	assign							trig_ad_convst		=	o_trig_ad;
//*****************************************************************************
// AXI Internal register and wire declarations
//*****************************************************************************

// AXI write address channel signals

	reg [C_AXI_ID_WIDTH-1:0]        s_wid 		=	0;
	reg [C_AXI_ADDR_WIDTH-1:0]      s_waddr		=	0;
	reg [7:0]                       s_wlen		=	0;
	reg [1:0]                       s_wburst	=	0;
	reg                             s_wready	=	1'b0;

// AXI write data channel signals

	reg [C_AXI_DATA_WIDTH-1:0]      s_wd_wdata	=	0;
	reg [C_AXI_DATA_WIDTH/8-1:0]    s_wd_wstrb	=	0;
	reg                             s_wd_wready	=	1'b0;

// AXI write response channel signals
	
	reg								s_wb_bvalid =	1'b0;
	reg	[C_AXI_ID_WIDTH-1:0]      	s_wb_bid	=	0;
	reg [1:0]                     	s_wb_bresp	=	0;

// AXI read address channel signals

	reg [C_AXI_ID_WIDTH-1:0]        s_rr_rid 	=	0;
	reg [C_AXI_ADDR_WIDTH-1:0]      s_rr_raddr	=	0;
	reg [7:0]                       s_rr_rlen	=	0;
	reg [2:0]                       s_rr_rsize	=	0;
	reg [1:0]                       s_rr_rburst	=	0;
	reg                             s_rr_rready	=	1'b0;

// AXI read data channel signals
	
	reg [C_AXI_ID_WIDTH-1:0]        s_rd_rid 	=	0;
	reg [1:0]                       s_rd_rresp	=	0;
	reg								s_rd_rvalid	=	1'b0;
	reg [C_AXI_DATA_WIDTH-1:0]     	s_rd_rdata	=	0;  
	reg 							s_rd_rlast	=	1'b0;
//*****************************************************************************
// local reset
//*****************************************************************************			
	reg							local_reset	=	1'b0;
	always @(posedge sys_clk) begin
		local_reset	<=	sys_rst;
	end

//*****************************************************************************
// AXI support signals
//*****************************************************************************	
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.                      
	function integer clogb2 (input integer bit_depth);              
	begin                                                           
	for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	  bit_depth = bit_depth >> 1;                                 
	end                                                           
	endfunction 

	//	AXI_SIZE : the data bytes of each burst
	localparam	[2:0]	AXI_SIZE	=	clogb2(C_AXI_DATA_WIDTH/8-1);

	//	AXI_ADDR_INC : axi address increment associate with data width
	localparam 	[7:0]	AXI_ADDR_INC	=	C_AXI_DATA_WIDTH/8;

	localparam	[2:0]	SUM_SIZE	=	clogb2(32/C_AXI_DATA_WIDTH-1);

//*****************************************************************************
// write Internal parameter declarations
//*****************************************************************************							
	localparam  [3:0]               S_WRITE_IDLE     = 4'd0, 
									S_WRITE_ADDR     = 4'd1,
									S_WRITE_DATA     = 4'd2,                                        
									S_WRITE_RESPONSE = 4'd3,
									S_WRITE_TIME_OUT = 4'd4,
									DAC_RESET        = 4'd5,
									DAC_SYNC         = 4'd6,
									DAC_WRITE        = 4'd7,
									DAC_READ         = 4'd8;                               
	//	use one-hot encode								
   (* keep="true" *) reg [8:0]                       s_write_state      =   0,
									s_write_next       =   0;

	reg [WATCH_DOG_WIDTH : 0]       s_wt_watch_dog_cnt =   0;          
 	reg [7:0]                       s_write_data_cnt   =   0;	
 	reg								trig_write_start   =   1'b0;
//*****************************************************************************
// Write channel control signals
//*****************************************************************************	
	always @(posedge sys_clk) begin
		if(local_reset) begin
			trig_write_start <= 0;
		end else begin
			trig_write_start <= saxi_wvalid;
		end
	end

//*****************************************************************************
// Write data state machine
//*****************************************************************************
	reg		flag_dac_reset_over		=	1'b0;
	reg		flag_dac_sync_over		=	1'b0;
	reg		flag_dac_write_over		=	1'b0;
	reg		flag_dac_read_over		=	1'b0;

	always @(posedge sys_clk) begin
		if(local_reset) begin
			s_write_state <= 9'b0_0010_0000;	//	RESET
		end else begin
			s_write_state	<= s_write_next;
		end
	end

	reg 		flag_saxi_respond	=	1'b0;
	reg 		flag_saxi_data		=	1'b0;
	reg			flag_saxi_addr		=	1'b0;

	always @(posedge sys_clk) begin
		flag_saxi_addr		<=	saxi_waddr && saxi_wready;
		flag_saxi_data		<=	saxi_wd_wvalid && saxi_wd_wready && saxi_wd_wlast;
		flag_saxi_respond	<=	saxi_wb_bvalid && saxi_wb_bready;
	end	

	always @(*) begin
		s_write_next	=	0;		//	next state reset
		case (1)
			s_write_state[S_WRITE_IDLE]	:	begin 
				if (trig_write_start)
					s_write_next[S_WRITE_ADDR]		=	1;
				else
					s_write_next[S_WRITE_IDLE]		=	1;
			end

			s_write_state[S_WRITE_ADDR]	:	begin 
				if (saxi_wready && saxi_wvalid)
					s_write_next[S_WRITE_DATA]		=	1;
				else
					s_write_next[S_WRITE_ADDR]		=	1;
			end

			s_write_state[S_WRITE_DATA] :	begin 
				if (saxi_wd_wvalid && saxi_wd_wready && saxi_wd_wlast)
					s_write_next[S_WRITE_RESPONSE]	=	1;
				else
					s_write_next[S_WRITE_DATA]		=	1;
			end

			s_write_state[S_WRITE_RESPONSE]	:	begin 
				if (saxi_wb_bvalid && saxi_wb_bready)
					s_write_next[DAC_READ]			=	1;		//	set	dac_code
				else
					s_write_next[S_WRITE_RESPONSE]	=	1;			
			end

			s_write_state[S_WRITE_TIME_OUT] :	begin 
					s_write_next[S_WRITE_IDLE]		=	1;
			end
				
			s_write_state[DAC_RESET]	:	begin 
				if (flag_dac_reset_over)
					s_write_next[S_WRITE_IDLE]		=	1;
				else
					s_write_next[DAC_RESET]			=	1;
			end	

			s_write_state[DAC_SYNC]		:	begin 
				if (flag_dac_sync_over)
					s_write_next[DAC_WRITE]			=	1;
				else
					s_write_next[DAC_SYNC]			=	1;
			end							

			s_write_state[DAC_WRITE]	:	begin 
				if (flag_dac_write_over)
					s_write_next[DAC_READ]			=	1;
				else
					s_write_next[DAC_WRITE]			=	1;
			end

			s_write_state[DAC_READ]		:	begin 
				if (flag_dac_read_over)
					s_write_next[S_WRITE_IDLE]		=	1;
				else
					s_write_next[DAC_SYNC]			=	1;		//	satisfy sync timing
			end
			default : s_write_next[S_WRITE_IDLE]		=	1;
		endcase
	end	

//*****************************************************************************
// doing
//*****************************************************************************			
	reg	[4:0]	sclk_cnt	=	0;
	localparam	TIME_RESET	=	5'd4,	//	200ns	:	reset time
				TIME_SYNC	=	5'd10,	//	500ns	:	sync time
				BIT_SDI		=	5'd24;	

	reg	[9:0]	dac_voltage		=	0;	
	localparam	MOTOR_ENABLE	=	16'hEAEA,
				MOTOR_POSITVE	=	16'h1EAF,
				ALARM_RESET		=	16'hAAED;
	localparam	DAC_SUCCESS		=	16'hFBFB;
	localparam	ALARM_OUT		=	16'hAAAA;

	reg	[23:0]	dac_code		=	0;
	reg [23:0]	dac_read 		=	0;
	localparam	DAC_CMD_WRITE	=	4'd3,
				DAC_CMD_READ	=	4'd9,
				DAC_VO_ALL		=	4'd9,
				DAC_VO_A		=	4'd1;	

	reg	[2:0]	read_in_cnt 	=	0;
	reg			dac_complete	=	1'b0;

	reg [31:0]	time_set		=	32'd1000000000;

//*****************************************************************************
// CMD
//*****************************************************************************			

	always @(posedge sys_clk) begin
		if(local_reset) begin
			dac_voltage			<=	0;
			o_motor_state		<=	0;
			o_alarm_reset		<=	0;
			o_moter_direction	<=	1;
		end else begin
			if (saxi_wd_wready)
				case (s_write_data_cnt)
					5'd1	:	begin 
						o_motor_state		<=	(saxi_wd_wdata[63:48] == MOTOR_ENABLE);
						o_moter_direction	<=	(saxi_wd_wdata[47:32] == MOTOR_POSITVE);
						dac_voltage			<=	 saxi_wd_wdata[25:16];
						o_alarm_reset		<=	(saxi_wd_wdata[15:00] == ALARM_RESET);															
					end
					5'd0	:	begin 
						time_set			<=	saxi_wd_wdata[63:32];
					end
					default : /* default */;
				endcase	
			else begin 
				o_motor_state	<=	alarm_reset ? 0 : o_motor_state;
			end
		end
	end

	always @(posedge sys_clk) begin
		if(local_reset) begin

		end else begin
			case (1)
				s_write_next[S_WRITE_IDLE]	:	begin 
												sclk_cnt	<=	0;
												read_in_cnt	<=	0;
												o_reset_n	<=	1;
												o_sync_n	<=	1;
												o_sdin		<=	0;
												dac_read	<=	0;

												dac_complete		<=	0;
												flag_dac_read_over	<=	0;
												flag_dac_sync_over	<=	0;
												flag_dac_write_over	<=	0;
												flag_dac_reset_over	<=	0;											
				end	

				s_write_next[S_WRITE_DATA]	:	begin 
										
				end

				s_write_next[S_WRITE_RESPONSE]	:	begin 
																	
				end

				s_write_next[DAC_RESET]			:	begin 
												if (sclk_p && !sclk) begin	//	rising edge of sclk
													if (sclk_cnt  == TIME_RESET - 1) begin 
														flag_dac_reset_over <=  1;
														sclk_cnt			<=	0;
														o_reset_n			<=	1;															
													end
													else
														sclk_cnt	<=	sclk_cnt + 1;
												end
												else begin
													sclk_cnt	<=	sclk_cnt;
												end																																					
				end

				s_write_next[DAC_SYNC]			:	begin 
												if (sclk_p && !sclk) begin
													if (sclk_cnt == TIME_SYNC - 1) begin
														flag_dac_sync_over 	<=  1;
														sclk_cnt			<=	0;
														o_sync_n			<=	0;															
													end
													else
														sclk_cnt	<=	sclk_cnt + 1;
												end
												else begin
													sclk_cnt	<=	sclk_cnt;
												end													
				end

				s_write_next[DAC_WRITE]			:	begin 
												flag_dac_sync_over 	<=  0;

												if (sclk_p && !sclk) begin
													if (sclk_cnt == BIT_SDI - 1) begin
														flag_dac_write_over <=  1;
														sclk_cnt			<=	0;
														o_sdin				<=	0;
														o_sync_n			<=	1;
													end
													else begin 
														o_sdin				<=	dac_code[23 - (sclk_cnt + 1)];
														sclk_cnt			<=	sclk_cnt + 1;															
													end
												end														
												else begin 
													sclk_cnt	<=	sclk_cnt;
													o_sdin		<=	(sclk_cnt == 0) ? dac_code[23] : o_sdin;
												end																											
												
												if (read_in_cnt == 3 && !sclk_p && sclk)		//	read when write [nop] negedge sclk
													dac_read[23 - sclk_cnt]	<=	sdo;
												else
													dac_read	<=	dac_read;
				end

				s_write_next[DAC_READ]			:	begin 
												flag_dac_write_over <=  0;
												read_in_cnt			<=	read_in_cnt + 1;
												case (read_in_cnt)
													3'd0	:	dac_code	<=	{DAC_CMD_WRITE,DAC_VO_ALL,dac_voltage,6'd0};	//	write
													3'd1	:	dac_code	<=	{DAC_CMD_READ,DAC_VO_A,10'd0,6'd0};				//	read
													3'd2	:	dac_code	<=	0;												//	nop
													3'd3	:	begin 
																dac_complete		<=	{dac_read[11:2] == dac_voltage};		//	check dac set correct
																flag_dac_read_over	<=	1;
													end 
													default : /* default */;
												endcase
				end
				default : /* default */;
			endcase
		end
	end
//*****************************************************************************
// trig ad convst
//*****************************************************************************			
reg	[31:0]	trig_cnt	=	0;

always @(posedge sys_clk) begin
	 if (motor_state) begin 
	 	if (trig_cnt == time_set) begin 
		 	trig_cnt	<=	0;
		 	o_trig_ad	<=	1;		 		
	 	end
	 	else begin 
	 		trig_cnt	<=	trig_cnt + 1;
		 	o_trig_ad	<=	0;	
	 	end
	 end
	 else begin 
	 	trig_cnt	<=	0;
	 	o_trig_ad	<=	0;
	 end
end
//*****************************************************************************
// sclk generate
//*****************************************************************************			
	reg	[7:0]	time_cnt		=	0;
	localparam	TIME_SCLK		=	8'd10;	//	50ns	:	sclk period

	always @(posedge sys_clk) begin
		//	sclk cnt
		if (time_cnt == TIME_SCLK - 1)
			time_cnt	<=	0;
		else
			time_cnt	<=	time_cnt + 1;
	end
	
	always @(posedge sys_clk) begin
			o_sclk	<=	(time_cnt < (TIME_SCLK/2));
			sclk_p	<=	(time_cnt < (TIME_SCLK/2 - 1)) || (time_cnt == TIME_SCLK - 1);
	end

//*****************************************************************************
// Watch dog signals
//*****************************************************************************	
	always @(posedge sys_clk) begin
		 if (s_write_state != s_write_next)
		 	s_wt_watch_dog_cnt	<=	0;
		 else
		 	s_wt_watch_dog_cnt	<=	s_wt_watch_dog_cnt + 1; 
	end	

//*****************************************************************************
// Write channel address signals
//*****************************************************************************	
	//	s_wready
	always @(posedge sys_clk) begin
		if (s_write_state[S_WRITE_IDLE] && s_write_next[S_WRITE_ADDR])
			s_wready	<=	1;
		else
			s_wready	<=	0;
	end

	//	s_wid
	always @(posedge sys_clk) begin
		 if (saxi_wvalid && saxi_wready)
		 	s_wid	<=	saxi_wid;
		 else
		 	s_wid	<=	s_wid;
	end

	//	s_wlen	:	INCR bursts
	always @(posedge sys_clk) begin
		if(local_reset) begin
			 s_wlen	<=	0;
		end else begin
			 if (saxi_wvalid && saxi_wready)
			 	s_wlen	<=	saxi_wlen + 1;
			 else
			 	s_wlen	<=	s_wlen;
		end
	end	

	//	s_wburst	
	//	C_EN_WRAP_TRANS :0 INCR bursts :support burst_len max to 256 (default) 	
	//	C_EN_WRAP_TRANS :1 WRAP bursts :support burst_len 2,4,8,16 				
	always @(posedge sys_clk) begin
			s_wburst	<=	saxi_wburst;	
	end	

	//	output
	assign	saxi_wready	=	s_wready;

//*****************************************************************************
// Write channel data signals
//*****************************************************************************	
	//	data count
	always @(posedge sys_clk) begin
		if (s_write_next[S_WRITE_IDLE])
			s_write_data_cnt	<=	0;
		else if (s_write_state[S_WRITE_ADDR] && s_write_next[S_WRITE_DATA])		//	user setting
			s_write_data_cnt	<=	saxi_wlen;
		else if (saxi_wd_wvalid && saxi_wd_wready)
			s_write_data_cnt	<=	s_write_data_cnt - 1;
		else
			s_write_data_cnt	<=	s_write_data_cnt;
	end

	//	s_wd_wready
	always @(posedge sys_clk) begin
		if (s_write_state[S_WRITE_DATA] && s_write_next[S_WRITE_DATA])
			s_wd_wready	<=	1;		//	user setting
		else
			s_wd_wready	<=	0;
	end	

	//	s_wd_wdata
	always @(posedge sys_clk) begin
		if (saxi_wd_wready && saxi_wd_wvalid)
			s_wd_wdata	<=	saxi_wd_wdata;		//	user setting
		else
			s_wd_wdata	<=	s_wd_wdata;
	end
	//	output
	assign	saxi_wd_wready	=	s_wd_wready;

//*****************************************************************************
// Write channel response signals
//*****************************************************************************	
	always @(posedge sys_clk) begin
		if (s_write_state[S_WRITE_RESPONSE] && s_write_next[S_WRITE_RESPONSE])
			s_wb_bvalid <= 1;
		else
			s_wb_bvalid <= 0;
	end

	assign	saxi_wb_bvalid	=	s_wb_bvalid;
	assign	saxi_wb_bid		=	s_wb_bid;
	assign	saxi_wb_bresp	=	s_wb_bresp;


//*****************************************************************************
// AXI Internal register and wire declarations
//*****************************************************************************

// AXI m_write address channel signals

	reg	[C_AXI_ID_WIDTH-1:0]		m_wid 		=	0;
	reg	[C_AXI_ADDR_WIDTH-1:0]		m_waddr		=	0;
	reg	[7:0]						m_wlen		=	0;
	reg	[1:0]						m_wburst	=	0;
	reg								m_wvalid	=	1'b0;

// AXI m_write data channel signals

	reg	[C_AXI_DATA_WIDTH-1:0]		m_wd_wdata		=	0;
	reg	[C_AXI_DATA_WIDTH/8-1:0]	m_wd_wstrb		=	0;
	reg								m_wd_wlast		=	1'b0;
	reg								m_wd_wvalid		=	1'b0;

// AXI m_write response channel signals
	
	reg								m_wb_ready 	=	1'b0;

//*****************************************************************************
// m_write Internal parameter declarations
//*****************************************************************************							
	localparam  [3:0]               M_WRITE_IDLE     = 4'd0, 
									M_WRITE_ADDR     = 4'd1,
									M_WRITE_DATA     = 4'd2,										
									M_WRITE_RESPONSE = 4'd3,
									M_WRITE_TIME_OUT = 4'd4;								
	//	use one-hot encode								
       (* keep="true" *) reg [4:0]                       m_write_state      =   0,
									m_write_next       =   0;

	reg [WATCH_DOG_WIDTH : 0]       m_wt_watch_dog_cnt	=   0;      
	reg	[7:0]						m_write_data_cnt	=	0;    
	reg                             trig_m_write_start 	=   1'b0;
	reg								flag_sum			=	1'b0;
//*****************************************************************************
// Write channel control signals
//*****************************************************************************	
	reg 		alarm_in_n_d	=	1'b0;
	reg			alarm_reset_d	=	1'b0;

	always @(posedge sys_clk) begin
		alarm_in_n_d	<=	alarm_in_n;
		alarm_reset_d	<=	alarm_reset;
	end

	always @(posedge sys_clk) begin
		if (m_write_state[M_WRITE_IDLE])
			trig_m_write_start <= flag_sum;			//	user setting
		else
			trig_m_write_start <= 0;
	end
//*****************************************************************************
// flag_sum
//*****************************************************************************			
	reg 		flag_maxi_respond	=	1'b0;
	reg 		flag_maxi_data		=	1'b0;
	reg			flag_maxi_addr		=	1'b0;

	always @(posedge sys_clk) begin
		flag_maxi_addr		<=	maxi_waddr && maxi_wready;
		flag_maxi_data		<=	maxi_wd_wvalid && maxi_wd_wready && maxi_wd_wlast;
		flag_maxi_respond	<=	maxi_wb_bvalid && maxi_wb_bready;
	end

	always @(posedge sys_clk) begin
		if(flag_maxi_respond) begin
			 flag_sum <= 0;
		end else begin
			 flag_sum <= (flag_dac_read_over || (alarm_in_n_d && !alarm_in_n) || (alarm_reset_d && !alarm_reset)) ? 1 : flag_sum;
		end
	end

	reg	[63:0]	data2eth		=	0;	
	reg	[31:0]	data_sum		=	0;
	reg	[15:0]	data_complete	=	0;
	reg [15:0]	alarm_complete	=	0;
	reg	[31:0]	time_set_sum	=	0;
	reg [31:0]	complete_sum	=	0;
	reg [31:0]	data2eth_sum	=	0;

	always @(posedge sys_clk) begin
		if(flag_sum) begin
			data2eth[63:48] <=	motor_state ? MOTOR_ENABLE : 0;
			data2eth[47:32]	<=	motor_direction ? MOTOR_POSITVE : 0;
			data2eth[31:16]	<=	dac_voltage;
			data2eth[15:00]	<=	!alarm_in_n ? ALARM_OUT : 0;
			time_set_sum	<=	time_set[31:16] + time_set[15:00];
			complete_sum	<=	data_complete + alarm_complete;
			data2eth_sum	<=	data2eth[63:48] + data2eth[47:32] + data2eth[31:16] + data2eth[15:00];
			data_sum		<=	time_set_sum + complete_sum + data2eth_sum; 
		end else if (flag_maxi_respond) begin
			data2eth 	<=	0;
			data_sum	<=	0;
			time_set_sum<=	0;
			complete_sum<=	0;
			data2eth_sum<=	0;
		end
		else begin 
			data2eth 	<=	data2eth;
			data_sum	<=	data_sum;
			time_set_sum<=	time_set_sum;
			complete_sum<=	complete_sum;
			data2eth_sum<=	data2eth_sum;						
		end
	end

	always @(posedge sys_clk) begin
		if(flag_dac_read_over) begin
			data_complete <= dac_complete ? DAC_SUCCESS : 0;
		end else begin
			data_complete <= data_complete;
		end
	end

	always @(posedge sys_clk) begin
		if(alarm_reset_d && !alarm_reset)
			alarm_complete <= ALARM_RESET;
		else if (!flag_sum && flag_maxi_respond)
			alarm_complete <= 0;
		else 
			alarm_complete <= alarm_complete;
	end	
//*****************************************************************************
// Write data state machine
//*****************************************************************************
	always @(posedge sys_clk) begin
		if(local_reset) begin
			m_write_state <= 1;
		end else begin
			m_write_state	<= m_write_next;
		end
	end

always @(*) begin
		m_write_next	=	0;		//	next state reset
		case (1)
			m_write_state[M_WRITE_IDLE]	:	begin 
				if (trig_m_write_start)
					m_write_next[M_WRITE_ADDR]		=	1;
				else
					m_write_next[M_WRITE_IDLE]		=	1;
			end

			m_write_state[M_WRITE_ADDR]	:	begin 
				if (maxi_wready && maxi_wvalid)
					m_write_next[M_WRITE_DATA]		=	1;
				else
					m_write_next[M_WRITE_ADDR]		=	1;
			end

			m_write_state[M_WRITE_DATA] :	begin 
				if (maxi_wd_wvalid && maxi_wd_wready && maxi_wd_wlast)
					m_write_next[M_WRITE_RESPONSE]	=	1;
				else
					m_write_next[M_WRITE_DATA]		=	1;
			end

			m_write_state[M_WRITE_RESPONSE]	:	begin 
				if (maxi_wb_bvalid && maxi_wb_bready)
					m_write_next[M_WRITE_IDLE]		=	1;
				else
					m_write_next[M_WRITE_RESPONSE]	=	1;			
			end

			m_write_state[M_WRITE_TIME_OUT] :	begin 
					m_write_next[M_WRITE_IDLE]		=	1;
			end
													
			default : m_write_next[M_WRITE_IDLE]		=	1;
		endcase
	end	
//*****************************************************************************
// Watch dog signals
//*****************************************************************************	
	always @(posedge sys_clk) begin
		 if (m_write_state != m_write_next)
		 	m_wt_watch_dog_cnt	<=	0;
		 else
		 	m_wt_watch_dog_cnt	<=	m_wt_watch_dog_cnt + 1; 
	end

//*****************************************************************************
// Write channel address signals
//*****************************************************************************	
	//	m_waddr	m_wvalid
	always @(posedge sys_clk) begin
		 if (m_write_state[M_WRITE_ADDR] && m_write_next[M_WRITE_ADDR]) begin
			m_waddr	<=	flag_sum ? (C_ADDR_MOTOR2ETH + C_ADDR_SUMOFFSET) : C_ADDR_MOTOR2ETH;	//	user setting			 	
		 	m_wvalid	<=	1;
		 end
		 else begin 
		 	m_waddr	<=	m_waddr;
		 	m_wvalid	<=	0;			 	
		 end
	end

	//	m_wid
	always @(posedge sys_clk) begin
		if(local_reset) begin
			 m_wid	<=	0;
		end else begin
			 if (m_write_state[M_WRITE_IDLE] && trig_m_write_start)
			 	m_wid	<=	m_wid + 1;
			 else
			 	m_wid	<=	m_wid;
		end
	end

	//	m_wlen	:	INCR bursts
	always @(posedge sys_clk) begin
		 if (m_write_state[M_WRITE_ADDR] && m_write_next[M_WRITE_ADDR])
		 	m_wlen	<=	flag_sum ? (1 - 1) : (2 - 1);			 			//	user setting
		 else
		 	m_wlen	<=	m_wlen;
	end	

	assign	maxi_wid	=	m_wid;
	assign	maxi_waddr	=	m_waddr;
	assign	maxi_wlen	=	m_wlen;
	assign	maxi_wsize	=	AXI_SIZE;
	assign	maxi_wburst	=	C_AXI_BURST_TYPE;
	assign	maxi_wvalid	=	m_wvalid;

	// Not supported and hence assigned zeros
	assign	maxi_wlock	=	2'b0;
	assign	maxi_wcache	=	4'b0;
	assign	maxi_wprot	=	3'b0;	
//*****************************************************************************
// Write channel data signals
//*****************************************************************************	

	//	data count
	always @(posedge sys_clk) begin
		if (m_write_next[M_WRITE_IDLE])
			m_write_data_cnt	<=	0;
		else if (m_write_state[M_WRITE_ADDR] && m_write_next[M_WRITE_DATA])
			m_write_data_cnt	<=	maxi_wlen;
		else if (maxi_wd_wvalid && maxi_wd_wready)
			m_write_data_cnt	<=	m_write_data_cnt - 1;
		else
			m_write_data_cnt	<=	m_write_data_cnt;
	end

	//	m_wd_wdata
	always @(posedge sys_clk) begin
		if (m_write_state[M_WRITE_DATA] && m_write_next[M_WRITE_DATA])
			if (flag_sum)
				m_wd_wdata	<=	data_sum;
			else 
				if (maxi_wd_wvalid && maxi_wd_wready)
					case (m_write_data_cnt - 1)
						8'd0	:	m_wd_wdata	<=	{data_complete,alarm_complete,time_set};		
						default : 	m_wd_wdata	<=	0;
					endcase
				else if (m_write_data_cnt == maxi_wlen)
					m_wd_wdata	<=	data2eth;
				else
					m_wd_wdata	<=	m_wd_wdata;

		else begin 
			m_wd_wdata	<=	0;				 	
		end
	end

	//	m_wd_wvalid
	always @(posedge sys_clk) begin		 
		 if (m_write_state[M_WRITE_DATA] && m_write_next[M_WRITE_DATA]) begin 
		 	m_wd_wvalid	<=	1;	 				//	user setting
		 end 
		 else begin 
		 	m_wd_wvalid	<=	0;				 	
		 end		
	end		

	//	m_wd_wlast
	always @(posedge sys_clk) begin		 
		 if (m_write_state[M_WRITE_DATA] && m_write_next[M_WRITE_DATA]) begin 
		 	m_wd_wlast	<=	(maxi_wlen == 0) ? 1 : (m_write_data_cnt == 1 && maxi_wd_wvalid && maxi_wd_wready);	 				//	user setting
		 end 
		 else begin 
		 	m_wd_wlast	<=	0;				 	
		 end		
	end	

	//	m_wd_wstrb
	//	used in narrow transfer, data bytes mask, wstrb = 4'b0001 -> only last byte valid
	always @(posedge sys_clk) begin
		if (m_write_state[M_WRITE_DATA] && m_write_next[M_WRITE_DATA])
			m_wd_wstrb	<=	{(C_AXI_DATA_WIDTH/8){1'b1}};
		else
			m_wd_wstrb	<=	0;
	end

	assign	maxi_wd_wdata	=	m_wd_wdata;
	assign	maxi_wd_wstrb	=	m_wd_wstrb;
	assign	maxi_wd_wlast	=	m_wd_wlast;
	assign	maxi_wd_wvalid	=	m_wd_wvalid;

//*****************************************************************************
// Write channel response signals
//*****************************************************************************	
	always @(posedge sys_clk) begin
		if (m_write_state[M_WRITE_RESPONSE] && !m_wb_ready)
			m_wb_ready <= maxi_wb_bvalid;
		else
			m_wb_ready <= 0;
	end

	assign	maxi_wb_bready	=	m_wb_ready;	

endmodule
