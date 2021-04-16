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

 // DAC ports
 	output								sclk,
 	output								sync_n,
 	output								sdin,
 	output								reset_n,
 	input								sdo,

 //	motor state
 	output								motor_state,
 	output								motor_direction

    );
//*****************************************************************************
// output register
//*****************************************************************************			
	reg								sclk_p		=	1'b1;
	reg								sclk_n		=	1'b1;	
	reg								o_sync_n	=	1'b1;
	reg								o_sdin		=	1'b0;
	reg								o_reset_n	=	1'b1;

	reg								o_motor_state		=	1'b0;
	reg								o_moter_direction	=	1'b1;

	assign							sclk		=	sclk_p & sclk_n	;	
	assign							sync_n		=	o_sync_n;
	assign							sdin		=	o_sdin	;	
	assign							reset_n		=	o_reset_n;	

	assign                          motor_state     =   o_motor_state;
	assign                          motor_direction =   o_moter_direction;
//*****************************************************************************
// AXI Internal register and wire declarations
//*****************************************************************************

// AXI write address channel signals

	reg [C_AXI_ID_WIDTH-1:0]        s_wr_wid 	=	0;
	reg [C_AXI_ADDR_WIDTH-1:0]      s_wr_waddr	=	0;
	reg [7:0]                       s_wr_wlen	=	0;
	reg [1:0]                       s_wr_wburst	=	0;
	reg                             s_wr_wready	=	1'b0;

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
   	reg [8:0]                       s_write_state      =   0,
									s_write_next       =   0;

	reg [WATCH_DOG_WIDTH : 0]       s_wt_watch_dog_cnt =   0;          
 	reg [7:0]                       s_write_data_cnt   =   0;	
 	reg								trig_write_start   =   1'b0;
//*****************************************************************************
// Write channel control signals
//*****************************************************************************	
	always @(posedge sys_clk) begin
		if(sys_rst) begin
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
		if(sys_rst) begin
			s_write_state <= 9'b0_0010_0000;	//	RESET
		end else begin
			s_write_state	<= s_write_next;
		end
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

			s_write_next[DAC_READ]		:	begin 
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
	localparam	TIME_RESET	=	5'd4,	//	100ns	:	reset time
				TIME_SYNC	=	5'd10,	//	250ns	:	sync time
				BIT_SDI		=	5'd24;	

	reg	[9:0]	dac_voltage		=	0;	
	localparam	MOTOR_ENABLE	=	16'hEAEA,
				MOTOR_POSITVE	=	16'h1EAF;

	reg	[23:0]	dac_code		=	0;
	reg [23:0]	dac_read 		=	0;
	localparam	DAC_CMD_WRITE	=	4'd3,
				DAC_CMD_READ	=	4'd9,
				DAC_VO_ALL		=	4'd9,
				DAC_VO_A		=	4'd1;	

	reg	[2:0]	read_in_cnt 	=	0;
	reg			dac_complete	=	1'b0;

	always @(posedge sys_clk) begin
		if(sys_rst) begin

		end else begin
			case (1)
				s_write_next[S_WRITE_IDLE]	:	begin 
												sclk_cnt	<=	0;
												dac_voltage	<=	0;
												o_reset_n	<=	1;
												o_sync_n	<=	1;
												o_sdin		<=	0;

												dac_complete		<=	0;
												flag_dac_read_over	<=	0;
												flag_dac_sync_over	<=	0;
												flag_dac_write_over	<=	0;
												flag_dac_reset_over	<=	0;
				end	

				s_write_next[S_WRITE_DATA]	:	begin 
												if (saxi_wd_wvalid && saxi_wd_wready)
													sclk_cnt	<=	sclk_cnt + 1;
												else
													sclk_cnt	<=	sclk_cnt;

												case (sclk_cnt)
													5'd0	:	o_motor_state		<=	(saxi_wd_wdata == MOTOR_ENABLE);
													5'd1	:	o_moter_direction	<=	(saxi_wd_wdata == MOTOR_POSITVE);
													5'd2	:	dac_voltage			<=	saxi_wd_wdata[9:0];
													default : begin 
																o_motor_state		<=	0;
																o_moter_direction	<=	1;
																dac_voltage			<=	0;
													end
												endcase
				end

				s_write_next[S_WRITE_RESPONSE]	:	begin 
												sclk_cnt	<=	0;
				end

				s_write_next[DAC_RESET]			:	begin 
												if (sclk_cnt == TIME_RESET) begin 
													flag_dac_read_over 	<=  1;
													sclk_cnt			<=	0;
												end
												else begin 
													if (!sclk_p && sclk_n)
														sclk_cnt	<=	sclk_cnt + 1;
													else
														sclk_cnt	<=	sclk_cnt;													
												end
												o_reset_n          	<=  !(sclk_cnt  < TIME_RESET);												
				end

				s_write_next[DAC_SYNC]			:	begin 
												if (sclk_cnt == TIME_SYNC) begin 
													flag_dac_sync_over 	<=  1;
													sclk_cnt			<=	0;
													o_sync_n			<=	0;
												end
												else begin 
													if (!sclk_p && sclk_n)
														sclk_cnt	<=	sclk_cnt + 1;
													else
														sclk_cnt	<=	sclk_cnt;													
												end	

				end

				s_write_next[DAC_WRITE]			:	begin 
												if (sclk_cnt == BIT_SDI) begin 
													flag_dac_write_over <=  1;
													sclk_cnt			<=	0;
													o_sdin				<=	0;
													o_sync_n			<=	1;
												end
												else begin 
													if (!sclk_p && sclk_n)
														sclk_cnt	<=	sclk_cnt + 1;
													else
														sclk_cnt	<=	sclk_cnt;													
												end
												o_sdin	<=	dac_code[23 - sclk_cnt];

												if (read_in_cnt == 2 && sclk_p && !sclk_n)		//	read when write [nop]
													dac_read[23 - sclk_cnt]	<=	sdo;
												else
													dac_read	<=	dac_read;
				end

				s_write_next[DAC_READ]			:	begin 
												read_in_cnt	<=	read_in_cnt + 1;
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
// sclk generate
//*****************************************************************************			
	reg	[7:0]	time_cnt		=	0;
	localparam	TIME_SCLK		=	8'd5;	//	25ns	:	sclk period

	always @(posedge sys_clk) begin
		//	sclk cnt
		if (time_cnt == TIME_SCLK - 1)
			time_cnt	<=	0;
		else
			time_cnt	<=	time_cnt + 1;
	end
	
	always @(posedge sys_clk) begin
			sclk_p	<=	(time_cnt <= 2);
	end

	always @(negedge sys_clk) begin
			sclk_n	<=	(time_cnt <= 2);
	end	
//*****************************************************************************
// Watch dog signals
//*****************************************************************************	
	always @(posedge sys_clk) begin
		if(sys_rst) begin
			 s_wt_watch_dog_cnt	<=	0;
		end else begin
			 if (s_write_state != s_write_next)
			 	s_wt_watch_dog_cnt	<=	0;
			 else
			 	s_wt_watch_dog_cnt	<=	s_wt_watch_dog_cnt + 1; 
		end
	end	

//*****************************************************************************
// Write channel address signals
//*****************************************************************************	
	//	s_wr_wready
	always @(posedge sys_clk) begin
		if (s_write_state[S_WRITE_IDLE] && s_write_next[S_WRITE_ADDR])
			s_wr_wready	<=	1;
		else
			s_wr_wready	<=	0;
	end

	//	s_wr_wid
	always @(posedge sys_clk) begin
		if(sys_rst) begin
			 s_wr_wid	<=	0;
		end else begin
			 if (saxi_wvalid && saxi_wready)
			 	s_wr_wid	<=	saxi_wid;
			 else
			 	s_wr_wid	<=	s_wr_wid;
		end
	end

	//	s_wr_wlen	:	INCR bursts
	always @(posedge sys_clk) begin
		if(sys_rst) begin
			 s_wr_wlen	<=	0;
		end else begin
			 if (saxi_wvalid && saxi_wready)
			 	s_wr_wlen	<=	saxi_wlen + 1;
			 else
			 	s_wr_wlen	<=	s_wr_wlen;
		end
	end	

	//	s_wr_wburst	
	//	C_EN_WRAP_TRANS :0 INCR bursts :support burst_len max to 256 (default) 	
	//	C_EN_WRAP_TRANS :1 WRAP bursts :support burst_len 2,4,8,16 				
	always @(posedge sys_clk) begin
		if(sys_rst) begin
			s_wr_wburst	<=	0;
		end else begin
			s_wr_wburst	<=	saxi_wburst;	
		end
	end	

	//	output
	assign	axi_wready	=	s_wr_wready;

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
			s_wd_wready	<=	saxi_wd_wvalid;		//	user setting
		else
			s_wd_wready	<=	0;
	end	

	//	s_wd_wdata
	always @(posedge sys_clk) begin
		if(sys_rst) begin
			 s_wd_wdata     <= 0;			 
		end else begin
			if (saxi_wd_wready && saxi_wd_wvalid)
				s_wd_wdata	<=	saxi_wd_wdata;		//	user setting
			else
				s_wd_wdata	<=	s_wd_wdata;
		end
	end
	//	output
	assign	saxi_wd_wready	=	s_wd_wready;

//*****************************************************************************
// Write channel response signals
//*****************************************************************************	
	always @(posedge sys_clk) begin
		if (s_write_next[S_WRITE_RESPONSE])
			s_wb_bvalid <= 1;
		else
			s_wb_bvalid <= 0;
	end

	assign	saxi_wb_bvalid	=	s_wb_bvalid;
	assign	saxi_wb_bid		=	s_wb_bid;
	assign	saxi_wb_bresp	=	s_wb_bresp;

endmodule
