module de0_nano_picorv32_wb_soc(
	input CLOCK_50,

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

	output EPCS_DCLK,
	input EPCS_DATA0,
	output EPCS_NCSO,
	output EPCS_ASDO,

	inout I2C_SCLK,
	inout I2C_SDAT,

	input [1:0] KEY,
	inout [33:0] GPIO_0,
	inout [33:0] GPIO_1
	);

	wire wb_clk;
	wire wb_rst;

	wire sdram_clk;
	wire sdram_rst;

	altpll_wb_clkgen #(
		.DEVICE_FAMILY ("Cyclone IV E"),
		.INPUT_FREQUENCY (50),

		/* wb_clk: 24 MHz */
		.WB_DIVIDE_BY (25),
		.WB_MULTIPLY_BY (12),

		/* sdram_clk: 75 MHz */
		.SDRAM_DIVIDE_BY (2),
		.SDRAM_MULTIPLY_BY (3)
	)
	clkgen(
		.sys_clk_pad_i (CLOCK_50),
		.rst_n_pad_i (KEY[0]),

		.wb_clk_o (wb_clk),
		.wb_rst_o (wb_rst),

		.sdram_clk_o (sdram_clk),
		.sdram_rst_o (sdram_rst)
	);

	wire spi0_sck;
	wire spi0_miso;
	wire spi0_mosi;
	wire spi0_cs0;

	assign GPIO_1[4] = spi0_sck;
	assign spi0_miso = GPIO_1[2];
	assign GPIO_1[3] = spi0_mosi;
	assign GPIO_1[5] = spi0_cs0;

	wire spi1_sck;
	wire spi1_miso;
	wire spi1_mosi;
	wire spi1_cs0;

	assign EPCS_DCLK = spi1_sck;
	assign spi1_miso = EPCS_DATA0;
	assign EPCS_ASDO = spi1_mosi;
	assign EPCS_NCSO = spi1_cs0;

	wire uart0_rx;
	wire uart0_tx;

	assign GPIO_1[0] = uart0_tx;
	assign uart0_rx = GPIO_1[1];

	wire [15:0] sdram_dq_i;
	wire [15:0] sdram_dq_o;
	wire sdram_dq_oe;

	assign sdram_dq_i = DRAM_DQ;
	assign DRAM_DQ = sdram_dq_oe ? sdram_dq_o : 16'bz;
	assign DRAM_CLK = sdram_clk;

	wire [7:0] gpio0_o;
	assign spi1_sck = gpio0_o[0];
	assign spi1_mosi = gpio0_o[2];
	assign spi1_cs0 = gpio0_o[3];

	wire [7:0] gpio0_i;
	assign gpio0_i[1] = spi1_miso;

	wire [7:0] gpio0_dir_o;

	assign I2C_SCLK = gpio0_dir_o[4] ? gpio0_o[4] : 1'bz;
	assign I2C_SDAT = gpio0_dir_o[5] ? gpio0_o[5] : 1'bz;
	assign gpio0_i[4] = I2C_SCLK;
	assign gpio0_i[5] = I2C_SDAT;

	assign GPIO_1[6] = gpio0_dir_o[6] ? gpio0_o[6] : 1'bz;
	assign GPIO_1[7] = gpio0_dir_o[7] ? gpio0_o[7] : 1'bz;
	assign gpio0_i[6] = GPIO_1[6];
	assign gpio0_i[7] = GPIO_1[7];

	picorv32_wb_soc #(
		.PROGADDR_RESET (32'h 0000_0000),

		.BOOTROM_MEMFILE ("nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),

		.SRAM0_MEMDEPTH (32768),

		// ISSI IS42S16160G-7TLI
		.SDRAM_CLK_FREQ_MHZ	(75),	// sdram_clk freq in MHZ
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
		.clock (wb_clk),
		.reset (wb_rst),

		.uart_rx (uart0_rx),
		.uart_tx (uart0_tx),

		.sdram_clk (sdram_clk),
		.sdram_rst (sdram_rst),
		.sdram_ba_pad_o (DRAM_BA[1:0]),
		.sdram_a_pad_o (DRAM_ADDR[12:0]),
		.sdram_cs_n_pad_o (DRAM_CS_N),
		.sdram_ras_pad_o (DRAM_RAS_N),
		.sdram_cas_pad_o (DRAM_CAS_N),
		.sdram_we_pad_o (DRAM_WE_N),
		.sdram_dq_o (sdram_dq_o[15:0]),
		.sdram_dq_i (sdram_dq_i[15:0]),
		.sdram_dq_oe (sdram_dq_oe),
		.sdram_dqm_pad_o (DRAM_DQM[1:0]),
		.sdram_cke_pad_o (DRAM_CKE),

		.spi0_cs0 (spi0_cs0),
		.spi0_miso (spi0_miso),
		.spi0_mosi (spi0_mosi),
		.spi0_sclk (spi0_sck),

		.gpio0_i (gpio0_i),
		.gpio0_o (gpio0_o),
		.gpio0_dir_o (gpio0_dir_o)
	);

endmodule
