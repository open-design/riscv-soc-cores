module de0_nano_picorv32_wb_soc(
	input  CLOCK_50,

	output [12:0] DRAM_ADDR,
	output [1:0] DRAM_BA,
	output DRAM_CAS_N,
	output DRAM_RAS_N,
	output DRAM_CLK,
	output DRAM_CKE,
	output DRAM_CS_N,
	output DRAM_WE_N,
	output [1:0] DRAM_DQM,
	inout [15:0] DRAM_DQ,

	inout  [33:0] GPIO_0,
	inout  [33:0] GPIO_1
	);

	wire wb_clk;
	wire wb_rst;

	wire sdram_clk;
	wire sdram_rst;

	altpll_clkgen #(
		.DEVICE_FAMILY ("Cyclone IV E"),
		.INPUT_FREQUENCY (50),
		.DIVIDE_BY (25),
		.MULTIPLY_BY (12),
		.C1_DIVIDE_BY (1),
		.C1_MULTIPLY_BY (2)
	)
	clkgen(
		.sys_clk_pad_i(CLOCK_50),
		.rst_n_pad_i(1),
		.wb_clk_o(wb_clk),
		.wb_rst_o(wb_rst),
		.sdram_clk_o(sdram_clk),
		.sdram_rst_o(sdram_rst)
	);

wire	[15:0]	sdram_dq_i;
wire	[15:0]	sdram_dq_o;
wire		sdram_dq_oe;

assign	sdram_dq_i = DRAM_DQ;
assign	DRAM_DQ = sdram_dq_oe ? sdram_dq_o : 16'bz;
assign	DRAM_CLK = sdram_clk;

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),
		.SRAM0_MEMDEPTH (32768),

		// ISSI IS42S16160G-7TLI
		.SDRAM_CLK_FREQ_MHZ	(100),	// sdram_clk freq in MHZ
		.SDRAM_POWERUP_DELAY	(200),	// power up delay in us
		.SDRAM_REFRESH_MS	(32),	// time to wait between refreshes in ms
		.SDRAM_BURST_LENGTH	(8),	// 0, 1, 2, 4 or 8 (0 = full page)
		.SDRAM_BUF_WIDTH	(3),	// Buffer size = 2^BUF_WIDTH
		.SDRAM_ROW_WIDTH	(13),	// Row width
		.SDRAM_COL_WIDTH	(9),	// Column width
		.SDRAM_BA_WIDTH		(2),	// Ba width
		.SDRAM_tCAC		(2),	// CAS Latency
		.SDRAM_tRAC		(5),	// RAS Latency
		.SDRAM_tRP		(2),	// Command Period (PRE to ACT)
		.SDRAM_tRC		(7),	// Command Period (REF to REF / ACT to ACT)
		.SDRAM_tMRD		(2)	// Mode Register Set To Command Delay time
	)
	soc(
		.clock(wb_clk),
		.reset(wb_rst),
		.wb_iadr_o(),
		.uart_rx(GPIO_0[32]),
		.uart_tx(GPIO_0[33]),

	.sdram_clk		(sdram_clk),
	.sdram_rst		(sdram_rst),
	.sdram_ba_pad_o		(DRAM_BA[1:0]),
	.sdram_a_pad_o		(DRAM_ADDR[12:0]),
	.sdram_cs_n_pad_o	(DRAM_CS_N),
	.sdram_ras_pad_o	(DRAM_RAS_N),
	.sdram_cas_pad_o	(DRAM_CAS_N),
	.sdram_we_pad_o		(DRAM_WE_N),
	.sdram_dq_o		(sdram_dq_o[15:0]),
	.sdram_dq_i		(sdram_dq_i[15:0]),
	.sdram_dq_oe		(sdram_dq_oe),
	.sdram_dqm_pad_o	(DRAM_DQM[1:0]),
	.sdram_cke_pad_o	(DRAM_CKE)
	);

endmodule
