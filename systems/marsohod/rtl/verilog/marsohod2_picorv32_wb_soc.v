module marsohod2_picorv32_wb_soc(
	input  CLK100MHZ,
	output [3:0] LED,
	inout [7:0] IO,
	input KEY0,
	input KEY1,

	output [11:0] SDRAM_A,
	output [1:0] SDRAM_BA,
	output SDRAM_CAS,
	output SDRAM_RAS,
	output SDRAM_CLK,
	output SDRAM_WE,
	output [1:0] SDRAM_DQM,
	inout [15:0] SDRAM_DQ,

	input FTDI_BD0,		/* SK_i, TCK_i, TXD_i */
	output FTDI_BD1,	/* DO_o, TDI_o, RXD_o */
	input FTDI_BD2,		/* DI_i, TDO_i, RTS#_i */
	input FTDI_BD3		/* CS_i, TMS_i, CTS#_i */
	);

	wire wb_clk;
	wire wb_rst;

	wire sdram_clk;
	wire sdram_rst;

	altpll_clkgen #(
		.DEVICE_FAMILY ("Cyclone III"),
		.INPUT_FREQUENCY (100),
		.DIVIDE_BY (25),
		.MULTIPLY_BY (6),
		.C1_DIVIDE_BY (1), // sdram
		.C1_MULTIPLY_BY (1)
	)
	clkgen(
		.sys_clk_pad_i(CLK100MHZ),
		.rst_n_pad_i(KEY1),
		.wb_clk_o(wb_clk),
		.wb_rst_o(wb_rst),
		.sdram_clk_o(sdram_clk),
		.sdram_rst_o(sdram_rst)
	);

wire	[15:0]	sdram_dq_i;
wire	[15:0]	sdram_dq_o;
wire		sdram_dq_oe;

assign sdram_dq_i = SDRAM_DQ;
assign SDRAM_DQ = sdram_dq_oe ? sdram_dq_o : 16'bz;
assign SDRAM_CLK = sdram_clk;

wire [7:0] gpio0_o;
assign LED[3:0] = gpio0_o[3:0];

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),
		.SRAM0_MEMDEPTH (16384),

		// MT48LC4M16A2
		.SDRAM_CLK_FREQ_MHZ	(100),	// sdram_clk freq in MHZ
		.SDRAM_POWERUP_DELAY	(200),	// power up delay in us
		.SDRAM_REFRESH_MS	(64),	// time to wait between refreshes in ms
		.SDRAM_BURST_LENGTH	(8),	// 0, 1, 2, 4 or 8 (0 = full page)
		.SDRAM_BUF_WIDTH	(3),	// Buffer size = 2^BUF_WIDTH
		.SDRAM_ROW_WIDTH	(12),	// Row width
		.SDRAM_COL_WIDTH	(8),	// Column width
		.SDRAM_BA_WIDTH		(2),	// Ba width
		.SDRAM_tCAC		(3),	// CAS Latency
		.SDRAM_tRAC		(7),	// RAS Latency
		.SDRAM_tRP		(3),	// Command Period (PRE to ACT)
		.SDRAM_tRC		(8),	// Command Period (REF to REF / ACT to ACT)
		.SDRAM_tMRD		(2)	// Mode Register Set To Command Delay time
	)
	soc(
		.clock(wb_clk),
		.reset(wb_rst),
		.wb_iadr_o(),
		.uart_rx(FTDI_BD0),
		.uart_tx(FTDI_BD1),

		.sdram_clk		(sdram_clk),
		.sdram_rst		(sdram_rst),
		.sdram_ba_pad_o		(SDRAM_BA[1:0]),
		.sdram_a_pad_o		(SDRAM_A[11:0]),
		.sdram_cs_n_pad_o	(),
		.sdram_ras_pad_o	(SDRAM_RAS),
		.sdram_cas_pad_o	(SDRAM_CAS),
		.sdram_we_pad_o		(SDRAM_WE),
		.sdram_dq_o		(sdram_dq_o[15:0]),
		.sdram_dq_i		(sdram_dq_i[15:0]),
		.sdram_dq_oe		(sdram_dq_oe),
		.sdram_dqm_pad_o	(SDRAM_DQM[1:0]),
		.sdram_cke_pad_o	(),

		.gpio0_i		(),
		.gpio0_o		(gpio0_o),
		.gpio0_dir_o		()
	);

endmodule
