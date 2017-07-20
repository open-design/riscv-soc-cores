module de1_picorv32_wb_soc(
	input  CLOCK_50,

	inout [7:0] GPIO_1,

	output [1:0] sdram_ba_pad_o,
	output [11:0] sdram_a_pad_o,
	output sdram_cs_n_pad_o,
	output sdram_ras_pad_o,
	output sdram_cas_pad_o,
	output sdram_we_pad_o,
	inout [15:0] sdram_dq_pad_io,
	output [1:0] sdram_dqm_pad_o,
	output sdram_cke_pad_o,
	output sdram_clk_pad_o,

	input UART_RXD,
	output UART_TXD
	);

	wire wb_clk;
	wire wb_rst;

	wire sdram_clk;
	wire sdram_rst;

	altpll_clkgen #(
		.DEVICE_FAMILY ("Cyclone II"),
		.INPUT_FREQUENCY (50),
		.DIVIDE_BY (25),
		.MULTIPLY_BY (12),
		.C1_DIVIDE_BY (25), // sdram
		.C1_MULTIPLY_BY (33)
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

assign sdram_dq_i = sdram_dq_pad_io;
assign sdram_dq_pad_io = sdram_dq_oe ? sdram_dq_o : 16'bz;
assign sdram_clk_pad_o = sdram_clk;

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/barebox_nmon_memtest_24_115200_40000000.txt"),
		.BOOTROM_MEMDEPTH (8192),
		.SRAM0_MEMDEPTH (16384),

		// ISSI IS42S16400
		.SDRAM_CLK_FREQ_MHZ	(66),	// sdram_clk freq in MHZ
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

		.sdram_clk		(sdram_clk),
		.sdram_rst		(sdram_rst),
		.sdram_ba_pad_o		(sdram_ba_pad_o),
		.sdram_a_pad_o		(sdram_a_pad_o),
		.sdram_cs_n_pad_o	(sdram_cs_n_pad_o),
		.sdram_ras_pad_o	(sdram_ras_pad_o),
		.sdram_cas_pad_o	(sdram_cas_pad_o),
		.sdram_we_pad_o		(sdram_we_pad_o),
		.sdram_dq_o		(sdram_dq_o[15:0]),
		.sdram_dq_i		(sdram_dq_i[15:0]),
		.sdram_dq_oe		(sdram_dq_oe),
		.sdram_dqm_pad_o	(sdram_dqm_pad_o[1:0]),
		.sdram_cke_pad_o	(sdram_cke_pad_o),

		.uart_rx(GPIO_1[3]),
		.uart_tx(GPIO_1[1])
	);

endmodule
