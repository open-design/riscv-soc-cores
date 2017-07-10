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
		.C1_DIVIDE_BY (1), // sdram
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

assign sdram_dq_i = sdram_dq_pad_io;
assign sdram_dq_pad_io = sdram_dq_oe ? sdram_dq_o : 16'bz;
assign sdram_clk_pad_o = sdram_clk;

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),
		.SRAM0_MEMFILE ("../src/riscv-nmon_0/memtest.txt"),
		.SRAM0_MEMDEPTH (16384)
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
