module core_ep2c5_picorv32_wb_soc(
	input CLK50MHZ,
	input RST_KEY,

	output [3:0] LED,

	input H_LEFT_3,
	output H_LEFT_4
	);

	wire wb_clk;
	wire wb_rst;

	altpll_wb_clkgen #(
		.DEVICE_FAMILY ("Cyclone II"),
		.INPUT_FREQUENCY (50),

		/* wb_clk: 24 MHz */
		.WB_DIVIDE_BY (25),
		.WB_MULTIPLY_BY (12)
	)
	clkgen(
		.sys_clk_pad_i (CLK50MHZ),
		.rst_n_pad_i (RST_KEY),

		.wb_clk_o (wb_clk),
		.wb_rst_o (wb_rst)
	);

	wire uart0_rx;
	wire uart0_tx;

	assign uart0_rx = H_LEFT_3;
	assign H_LEFT_4 = uart0_tx;

	picorv32_wb_soc #(
		.PROGADDR_RESET (32'h 0000_0000),

		.BOOTROM_MEMFILE ("nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),

		.SRAM0_TECHNOLOGY ("ALTSYNCRAM"),
		.SRAM0_MEMDEPTH (8192)
	)
	soc(
		.clock (wb_clk),
		.reset (wb_rst),

		.uart_rx (uart0_rx),
		.uart_tx (uart0_tx)
	);

	assign LED[0] = wb_clk;
	assign LED[1] = wb_rst;
	assign LED[2] = uart0_rx;
	assign LED[3] = uart0_tx;

endmodule
