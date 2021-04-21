`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 09:36:25
// Design Name: 
// Module Name: tf_MOTOR_TOP
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


module tb_MOTOR_TOP (); /* this is automatically generated */

	// clock
	logic sys_clk;
	initial begin
		sys_clk = '0;
		forever #(2.5) sys_clk = ~sys_clk;
	end

	// synchronous reset
	logic sys_rst;
	initial begin
		sys_rst <= '1;
		repeat(10)@(posedge sys_clk)
		sys_rst <= '0;
	end

	// (*NOTE*) replace reset, clock, others

	parameter       C_AXI_ID_WIDTH = 4;
	parameter     C_AXI_ADDR_WIDTH = 32;
	parameter     C_AXI_DATA_WIDTH = 64;
	parameter C_AXI_NBURST_SUPPORT = 1'b0;
	parameter     C_AXI_BURST_TYPE = 2'b00;
	parameter      WATCH_DOG_WIDTH = 12;
	parameter     C_ADDR_SUMOFFSET = 32'h0000_1000;
	parameter     C_ADDR_MOTOR2ETH = 32'h0000_0000;
	parameter     C_ADDR_ETH2MOTOR = 32'hE000_0000;

	logic                          sys_clk;
	logic                          sys_rst;
	logic                          saxi_wready;
	logic     [C_AXI_ID_WIDTH-1:0] saxi_wid;
	logic   [C_AXI_ADDR_WIDTH-1:0] saxi_waddr;
	logic                    [7:0] saxi_wlen;
	logic                    [2:0] saxi_wsize;
	logic                    [1:0] saxi_wburst;
	logic                    [1:0] saxi_wlock;
	logic                    [3:0] saxi_wcache;
	logic                    [2:0] saxi_wprot;
	logic                          saxi_wvalid;
	logic                          saxi_wd_wready;
	logic   [C_AXI_DATA_WIDTH-1:0] saxi_wd_wdata;
	logic [C_AXI_DATA_WIDTH/8-1:0] saxi_wd_wstrb;
	logic                          saxi_wd_wlast;
	logic                          saxi_wd_wvalid;
	logic     [C_AXI_ID_WIDTH-1:0] saxi_wb_bid;
	logic                    [1:0] saxi_wb_bresp;
	logic                          saxi_wb_bvalid;
	logic                          saxi_wb_bready;
	logic                          saxi_rready;
	logic     [C_AXI_ID_WIDTH-1:0] saxi_rid;
	logic   [C_AXI_ADDR_WIDTH-1:0] saxi_raddr;
	logic                    [7:0] saxi_rlen;
	logic                    [2:0] saxi_rsize;
	logic                    [1:0] saxi_rburst;
	logic                    [1:0] saxi_rlock;
	logic                    [3:0] saxi_rcache;
	logic                    [2:0] saxi_rprot;
	logic                          saxi_rvalid;
	logic     [C_AXI_ID_WIDTH-1:0] saxi_rd_rid;
	logic                    [1:0] saxi_rd_rresp;
	logic                          saxi_rd_rvalid;
	logic   [C_AXI_DATA_WIDTH-1:0] saxi_rd_rdata;
	logic                          saxi_rd_rlast;
	logic                          saxi_rd_rready;
	logic                          maxi_wready;
	logic     [C_AXI_ID_WIDTH-1:0] maxi_wid;
	logic   [C_AXI_ADDR_WIDTH-1:0] maxi_waddr;
	logic                    [7:0] maxi_wlen;
	logic                    [2:0] maxi_wsize;
	logic                    [1:0] maxi_wburst;
	logic                    [1:0] maxi_wlock;
	logic                    [3:0] maxi_wcache;
	logic                    [2:0] maxi_wprot;
	logic                          maxi_wvalid;
	logic                          maxi_wd_wready;
	logic   [C_AXI_DATA_WIDTH-1:0] maxi_wd_wdata;
	logic [C_AXI_DATA_WIDTH/8-1:0] maxi_wd_wstrb;
	logic                          maxi_wd_wlast;
	logic                          maxi_wd_wvalid;
	logic     [C_AXI_ID_WIDTH-1:0] maxi_wb_bid;
	logic                    [1:0] maxi_wb_bresp;
	logic                          maxi_wb_bvalid;
	logic                          maxi_wb_bready;
	logic                          maxi_rready;
	logic     [C_AXI_ID_WIDTH-1:0] maxi_rid;
	logic   [C_AXI_ADDR_WIDTH-1:0] maxi_raddr;
	logic                    [7:0] maxi_rlen;
	logic                    [2:0] maxi_rsize;
	logic                    [1:0] maxi_rburst;
	logic                    [1:0] maxi_rlock;
	logic                    [3:0] maxi_rcache;
	logic                    [2:0] maxi_rprot;
	logic                          maxi_rvalid;
	logic     [C_AXI_ID_WIDTH-1:0] maxi_rd_bid;
	logic                    [1:0] maxi_rd_rresp;
	logic                          maxi_rd_rvalid;
	logic   [C_AXI_DATA_WIDTH-1:0] maxi_rd_rdata;
	logic                          maxi_rd_rlast;
	logic                          maxi_rd_rready;
	logic                          sclk;
	logic                          sync_n;
	logic                          sdin;
	logic                          reset_n;
	logic                          sdo;
	logic                          fwd;
	logic                          rev;
	logic                          stop_mode;
	logic                          m0;
	logic                          m1;
	logic                          alarm_reset;
	logic                          speed_out;
	logic                          alarm_out_n;

	MOTOR_TOP #(
			.C_AXI_ID_WIDTH(C_AXI_ID_WIDTH),
			.C_AXI_ADDR_WIDTH(C_AXI_ADDR_WIDTH),
			.C_AXI_DATA_WIDTH(C_AXI_DATA_WIDTH),
			.C_AXI_NBURST_SUPPORT(C_AXI_NBURST_SUPPORT),
			.C_AXI_BURST_TYPE(C_AXI_BURST_TYPE),
			.WATCH_DOG_WIDTH(WATCH_DOG_WIDTH),
			.C_ADDR_SUMOFFSET(C_ADDR_SUMOFFSET),
			.C_ADDR_MOTOR2ETH(C_ADDR_MOTOR2ETH),
			.C_ADDR_ETH2MOTOR(C_ADDR_ETH2MOTOR)
		) inst_MOTOR_TOP (
			.sys_clk        (sys_clk),
			.sys_rst        (sys_rst),
			.saxi_wready    (saxi_wready),
			.saxi_wid       (saxi_wid),
			.saxi_waddr     (saxi_waddr),
			.saxi_wlen      (saxi_wlen),
			.saxi_wsize     (saxi_wsize),
			.saxi_wburst    (saxi_wburst),
			.saxi_wlock     (saxi_wlock),
			.saxi_wcache    (saxi_wcache),
			.saxi_wprot     (saxi_wprot),
			.saxi_wvalid    (saxi_wvalid),
			.saxi_wd_wready (saxi_wd_wready),
			.saxi_wd_wdata  (saxi_wd_wdata),
			.saxi_wd_wstrb  (saxi_wd_wstrb),
			.saxi_wd_wlast  (saxi_wd_wlast),
			.saxi_wd_wvalid (saxi_wd_wvalid),
			.saxi_wb_bid    (saxi_wb_bid),
			.saxi_wb_bresp  (saxi_wb_bresp),
			.saxi_wb_bvalid (saxi_wb_bvalid),
			.saxi_wb_bready (saxi_wb_bready),
			.saxi_rready    (saxi_rready),
			.saxi_rid       (saxi_rid),
			.saxi_raddr     (saxi_raddr),
			.saxi_rlen      (saxi_rlen),
			.saxi_rsize     (saxi_rsize),
			.saxi_rburst    (saxi_rburst),
			.saxi_rlock     (saxi_rlock),
			.saxi_rcache    (saxi_rcache),
			.saxi_rprot     (saxi_rprot),
			.saxi_rvalid    (saxi_rvalid),
			.saxi_rd_rid    (saxi_rd_rid),
			.saxi_rd_rresp  (saxi_rd_rresp),
			.saxi_rd_rvalid (saxi_rd_rvalid),
			.saxi_rd_rdata  (saxi_rd_rdata),
			.saxi_rd_rlast  (saxi_rd_rlast),
			.saxi_rd_rready (saxi_rd_rready),
			.maxi_wready    (maxi_wready),
			.maxi_wid       (maxi_wid),
			.maxi_waddr     (maxi_waddr),
			.maxi_wlen      (maxi_wlen),
			.maxi_wsize     (maxi_wsize),
			.maxi_wburst    (maxi_wburst),
			.maxi_wlock     (maxi_wlock),
			.maxi_wcache    (maxi_wcache),
			.maxi_wprot     (maxi_wprot),
			.maxi_wvalid    (maxi_wvalid),
			.maxi_wd_wready (maxi_wd_wready),
			.maxi_wd_wdata  (maxi_wd_wdata),
			.maxi_wd_wstrb  (maxi_wd_wstrb),
			.maxi_wd_wlast  (maxi_wd_wlast),
			.maxi_wd_wvalid (maxi_wd_wvalid),
			.maxi_wb_bid    (maxi_wb_bid),
			.maxi_wb_bresp  (maxi_wb_bresp),
			.maxi_wb_bvalid (maxi_wb_bvalid),
			.maxi_wb_bready (maxi_wb_bready),
			.maxi_rready    (maxi_rready),
			.maxi_rid       (maxi_rid),
			.maxi_raddr     (maxi_raddr),
			.maxi_rlen      (maxi_rlen),
			.maxi_rsize     (maxi_rsize),
			.maxi_rburst    (maxi_rburst),
			.maxi_rlock     (maxi_rlock),
			.maxi_rcache    (maxi_rcache),
			.maxi_rprot     (maxi_rprot),
			.maxi_rvalid    (maxi_rvalid),
			.maxi_rd_bid    (maxi_rd_bid),
			.maxi_rd_rresp  (maxi_rd_rresp),
			.maxi_rd_rvalid (maxi_rd_rvalid),
			.maxi_rd_rdata  (maxi_rd_rdata),
			.maxi_rd_rlast  (maxi_rd_rlast),
			.maxi_rd_rready (maxi_rd_rready),
			.sclk           (sclk),
			.sync_n         (sync_n),
			.sdin           (sdin),
			.reset_n        (reset_n),
			.sdo            (sdo),
			.fwd            (fwd),
			.rev            (rev),
			.stop_mode      (stop_mode),
			.m0             (m0),
			.m1             (m1),
			.alarm_reset    (alarm_reset),
			.speed_out      (speed_out),
			.alarm_out_n    (alarm_out_n)
		);

	task init();
		saxi_wid       <= '0;
		saxi_waddr     <= '0;
		saxi_wlen      <= '0;
		saxi_wsize     <= '0;
		saxi_wburst    <= '0;
		saxi_wlock     <= '0;
		saxi_wcache    <= '0;
		saxi_wprot     <= '0;
		saxi_wvalid    <= '0;
		saxi_wd_wdata  <= '0;
		saxi_wd_wstrb  <= '0;
		saxi_wd_wlast  <= '0;
		saxi_wd_wvalid <= '0;
		saxi_wb_bready <= '0;
		saxi_rid       <= '0;
		saxi_raddr     <= '0;
		saxi_rlen      <= '0;
		saxi_rsize     <= '0;
		saxi_rburst    <= '0;
		saxi_rlock     <= '0;
		saxi_rcache    <= '0;
		saxi_rprot     <= '0;
		saxi_rvalid    <= '0;
		saxi_rd_rready <= '0;
		maxi_wready    <= '0;
		maxi_wd_wready <= '0;
		maxi_wb_bid    <= '0;
		maxi_wb_bresp  <= '0;
		maxi_rready    <= '0;
		maxi_rd_bid    <= '0;
		maxi_rd_rresp  <= '0;
		maxi_rd_rvalid <= '0;
		maxi_rd_rdata  <= '0;
		maxi_rd_rlast  <= '0;
		sdo            <= '0;
		speed_out      <= '0;
		alarm_out_n    <= '0;
	endtask
	initial begin
		// do something

		init();
		repeat(10)@(posedge sys_clk);
	end

	localparam         [2:0] AXI_SIZE = clogb2(C_AXI_DATA_WIDTH/8-1);
	localparam     [7:0] AXI_ADDR_INC = C_AXI_DATA_WIDTH/8;
	localparam         [2:0] SUM_SIZE = clogb2(32/C_AXI_DATA_WIDTH-1);
	localparam     [3:0] S_WRITE_IDLE = 4'd0;
	localparam     [3:0] S_WRITE_ADDR = 4'd1;
	localparam     [3:0] S_WRITE_DATA = 4'd2;
	localparam [3:0] S_WRITE_RESPONSE = 4'd3;
	localparam [3:0] S_WRITE_TIME_OUT = 4'd4;
	localparam        [3:0] DAC_RESET = 4'd5;
	localparam         [3:0] DAC_SYNC = 4'd6;
	localparam        [3:0] DAC_WRITE = 4'd7;
	localparam         [3:0] DAC_READ = 4'd8;
	localparam             TIME_RESET = 5'd4;
	localparam              TIME_SYNC = 5'd10;
	localparam                BIT_SDI = 5'd24;
	localparam           MOTOR_ENABLE = 16'hEAEA;
	localparam          MOTOR_POSITVE = 16'h1EAF;
	localparam            ALARM_RESET = 16'hAAED;
	localparam            DAC_SUCCESS = 16'hFBFB;
	localparam              ALARM_OUT = 16'hAAAA;
	localparam          DAC_CMD_WRITE = 4'd3;
	localparam           DAC_CMD_READ = 4'd9;
	localparam             DAC_VO_ALL = 4'd9;
	localparam               DAC_VO_A = 4'd1;
	localparam              TIME_SCLK = 8'd5;
	localparam     [3:0] M_WRITE_IDLE = 4'd0;
	localparam     [3:0] M_WRITE_ADDR = 4'd1;
	localparam     [3:0] M_WRITE_DATA = 4'd2;
	localparam [3:0] M_WRITE_RESPONSE = 4'd3;
	localparam [3:0] M_WRITE_TIME_OUT = 4'd4;

	assign	maxi_wready		=	maxi_wvalid;
	assign	maxi_wd_wready	=	maxi_wd_wvalid;
	assign	maxi_wb_bvalid	=	1;

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
	
	// AXI read address channel signals
	
		reg	[C_AXI_ID_WIDTH-1:0]		m_rid 		=	0;
		reg	[C_AXI_ADDR_WIDTH-1:0]		m_raddr		=	0;
		reg	[7:0]						m_rlen		=	0;
		reg	[2:0]						m_rsize		=	0;
		reg	[1:0]						m_rburst	=	0;
		reg								m_rvalid	=	1'b0;
	
	// AXI read data channel signals
		
		reg								 m_rd_rready	=	1'b0;
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

	//*****************************************************************************
	// m_write Internal parameter declarations
	//*****************************************************************************							
		//localparam  [3:0]             M_WRITE_IDLE     = 4'd0, 
		//								M_WRITE_ADDR     = 4'd1,
		//								M_WRITE_DATA     = 4'd2,										
		//								M_WRITE_RESPONSE = 4'd3,
		//								M_WRITE_TIME_OUT = 4'd4;								
		//	use one-hot encode								
	    reg [4:0]                       m_write_state      =   0,
										m_write_next       =   0;
	
		reg [WATCH_DOG_WIDTH : 0]       m_wt_watch_dog_cnt=   0;      
		reg	[7:0]						m_write_data_cnt	=	0;    
		reg                             trig_m_write_start 	=   1'b0;
	//*****************************************************************************
	// Write channel control signals
	//*****************************************************************************	

		reg [11:0]	time_cnt	=	0;
		always_ff @(posedge sys_clk) begin
			if (alarm_reset)
				time_cnt	<=	12'hF71;
			else
				time_cnt	<=	time_cnt + 1;
		end

		always @(posedge sys_clk) begin
			if(sys_rst) begin
				trig_m_write_start <= 0;
			end else begin
				trig_m_write_start <= (time_cnt == 12'h050);			//	user setting
			end
		end

		always @(posedge sys_clk) begin
			if(sys_rst) begin
				alarm_out_n <= 1;
			end else begin
				alarm_out_n <= !((time_cnt >= 12'h650) && (time_cnt <= 12'hF70)) || alarm_reset;			//	user setting
			end
		end		
	//*****************************************************************************
	// Write data state machine
	//*****************************************************************************
		always @(posedge sys_clk) begin
			if(sys_rst) begin
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
					if (saxi_wready && saxi_wvalid)
						m_write_next[M_WRITE_DATA]		=	1;
					else
						m_write_next[M_WRITE_ADDR]		=	1;
				end
	
				m_write_state[M_WRITE_DATA] :	begin 
					if (saxi_wd_wvalid && saxi_wd_wready && saxi_wd_wlast)
						m_write_next[M_WRITE_RESPONSE]	=	1;
					else
						m_write_next[M_WRITE_DATA]		=	1;
				end
	
				m_write_state[M_WRITE_RESPONSE]	:	begin 
					if (saxi_wb_bvalid && saxi_wb_bready)
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
			if(sys_rst) begin
				 m_wt_watch_dog_cnt	<=	0;
			end else begin
				 if (m_write_state != m_write_next)
				 	m_wt_watch_dog_cnt	<=	0;
				 else
				 	m_wt_watch_dog_cnt	<=	m_wt_watch_dog_cnt + 1; 
			end
		end
	
	//*****************************************************************************
	// Write channel address signals
	//*****************************************************************************	
		//	m_waddr	m_wvalid
		always @(posedge sys_clk) begin
			 if (m_write_state[M_WRITE_ADDR] && m_write_next[M_WRITE_ADDR]) begin
				m_waddr	<=	C_ADDR_ETH2MOTOR;	//	user setting			 	
			 	m_wvalid	<=	1;
			 end
			 else begin 
			 	m_waddr	<=	m_waddr;
			 	m_wvalid	<=	0;			 	
			 end
		end
	
		//	m_wid
		always @(posedge sys_clk) begin
			if(sys_rst) begin
				 m_wid	<=	0;
			end else begin
				 if (m_write_state[M_WRITE_IDLE] && m_write_next[M_WRITE_ADDR])
				 	m_wid	<=	m_wid + 1;
				 else
				 	m_wid	<=	m_wid;
			end
		end
	
		//	m_wlen	:	INCR bursts
		always @(posedge sys_clk) begin
			if(sys_rst) begin
				 m_wlen	<=	0;
			end else begin
				 if (m_write_state[M_WRITE_IDLE] && m_write_next[M_WRITE_ADDR])
				 	m_wlen	<=	0;			 			//	user setting
				 else
				 	m_wlen	<=	m_wlen;
			end
		end	
	
		assign	saxi_wid	=	m_wid;
		assign	saxi_waddr	=	m_waddr;
		assign	saxi_wlen	=	m_wlen;
		assign	saxi_wsize	=	AXI_SIZE;
		assign	saxi_wburst	=	C_AXI_BURST_TYPE;
		assign	saxi_wvalid	=	m_wvalid;
	
		// Not supported and hence assigned zeros
		assign	saxi_wlock	=	2'b0;
		assign	saxi_wcache	=	4'b0;
		assign	saxi_wprot	=	3'b0;	
	//*****************************************************************************
	// Write channel data signals
	//*****************************************************************************	
		localparam	CMD_DATA	=	10'h078;
		reg [9:0]	cmd_data	=	CMD_DATA;
		always_ff @(posedge sys_clk) begin
			if(saxi_wb_bvalid && saxi_wb_bready) begin
				cmd_data <= cmd_data + 1;
			end else begin
				cmd_data <= cmd_data;
			end
		end

		//	data count
		always @(posedge sys_clk) begin
			if (m_write_next[M_WRITE_IDLE])
				m_write_data_cnt	<=	0;
			else if (m_write_state[M_WRITE_ADDR] && m_write_next[M_WRITE_DATA])
				m_write_data_cnt	<=	saxi_wlen;
			else if (saxi_wd_wvalid && saxi_wd_wready)
				m_write_data_cnt	<=	m_write_data_cnt - 1;
			else
				m_write_data_cnt	<=	m_write_data_cnt;
		end
	
		//	m_wd_wdata
		always @(posedge sys_clk) begin
			if (m_write_state[M_WRITE_DATA] && m_write_next[M_WRITE_DATA])
				m_wd_wdata	<=	{MOTOR_ENABLE,MOTOR_POSITVE,{6'h0,cmd_data},16'h0};						//	user setting
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
			 	m_wd_wlast	<=	(saxi_wlen == 0) ? 1 : (m_write_data_cnt == 1);	 				//	user setting
			 end 
			 else begin 
			 	m_wd_wlast	<=	0;				 	
			 end		
		end	
	
		//	m_wd_wstrb
		//	used in narrow transfer, data bytes mask, wstrb = 4'b0001 -> only last byte valid
		always @(posedge sys_clk) begin
			if(sys_rst) begin
				m_wd_wstrb	<=	0;
			end else begin
				if (m_write_state[M_WRITE_DATA] && m_write_next[M_WRITE_DATA])
					m_wd_wstrb	<=	{(C_AXI_DATA_WIDTH/8){1'b1}};
				else
					m_wd_wstrb	<=	0;
			end
		end
	
		assign	saxi_wd_wdata	=	m_wd_wdata;
		assign	saxi_wd_wstrb	=	m_wd_wstrb;
		assign	saxi_wd_wlast	=	m_wd_wlast;
		assign	saxi_wd_wvalid	=	m_wd_wvalid;
	
	//*****************************************************************************
	// Write channel response signals
	//*****************************************************************************	
		always @(posedge sys_clk) begin
			if (m_write_state[M_WRITE_RESPONSE] && !m_wb_ready)
				m_wb_ready <= saxi_wb_bvalid;
			else
				m_wb_ready <= 0;
		end
	
		assign	saxi_wb_bready	=	m_wb_ready;	
	
//*****************************************************************************
// sdo
//*****************************************************************************			
	reg	[7:0]	bit_cnt	=	0;
	reg	[7:0]	read_cnt=	0;
	reg			sclk_d	=	1'b0;
	reg	[23:0]	cmd		=	0;
	reg			flag_read	=	1'b0;
	reg	[23:0]	read_back	=	0;
	always_ff @(posedge sys_clk) begin
		if(sys_rst) begin
			 read_back	<=	{8'h0,4'h9,cmd_data,2'h0};	
		end else begin
			sclk_d	<=	sclk;
			if (!sync_n) begin 
				if (sclk_d && !sclk) begin 
					bit_cnt	<=	bit_cnt + 1;
					cmd[23 - bit_cnt] 	<= sdin;				
				end
				else begin 
					bit_cnt <= bit_cnt;
					cmd		<=	cmd;
				end

				if (flag_read && (!sclk_d && sclk) && (read_cnt <= 23)) begin 
					read_cnt	<=	read_cnt + 1;
					sdo			<=	read_back[23 - read_cnt];
				end
				else begin 
					read_cnt	<=	read_cnt;
					sdo			<=	(read_cnt == 0) ? read_back[23] : sdo;					
				end				
			end
			else begin 
				bit_cnt	<=	0;
				read_cnt<=	0;
				cmd		<=	0;
			end

			if ((cmd == 24'h910000) && (bit_cnt == 24))	
				flag_read	<=	1;
			else if (flag_read && bit_cnt == 24)
				flag_read	<=	0;
			else
				flag_read	<=	flag_read;			
		end
	end			
endmodule
