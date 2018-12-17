module de2_115_picorv32_wb_soc(
	input CLOCK_50,
	input KEY,
	inout [1:0] GPIO_0
	);

	wire wb_clk;
	wire wb_rst;

	altpll_wb_clkgen #(
		.DEVICE_FAMILY ("Cyclone IV E"),
		.INPUT_FREQUENCY (50),

		/* wb_clk: 24 MHz */
		.WB_DIVIDE_BY (25),
		.WB_MULTIPLY_BY (12)
	)
	clkgen(
		.sys_clk_pad_i (CLOCK_50),
		.rst_n_pad_i (KEY),

		.wb_clk_o (wb_clk),
		.wb_rst_o (wb_rst)
	);

	wire uart0_rx;
	wire uart0_tx;

	assign GPIO_0[0] = uart0_tx;
	assign uart0_rx = GPIO_0[1];

	picorv32_wb_soc #(
		.PROGADDR_RESET (32'h 0000_0000),

		.BOOTROM_MEMFILE ("nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),

		.SRAM0_MEMDEPTH (32768)
	)
	soc(
		.clock (wb_clk),
		.reset (wb_rst),

		.uart_rx (uart0_rx),
		.uart_tx (uart0_tx)
	);

endmodule
