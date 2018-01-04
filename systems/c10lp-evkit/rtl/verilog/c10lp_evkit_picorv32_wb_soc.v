module c10lp_evkit_picorv32_wb_soc(
	input CLK50MHZ,

	input [3:0] USER_PB,
	output [3:0] USER_LED,

	input ARDUINO_IO0,
	output ARDUINO_IO1
	);

	wire wb_clk;
	wire wb_rst;

	altpll_wb_clkgen #(
		.DEVICE_FAMILY ("Cyclone 10 LP"),
		.INPUT_FREQUENCY (50),

		/* wb_clk: 24 MHz */
		.WB_DIVIDE_BY (25),
		.WB_MULTIPLY_BY (12)
	)
	clkgen(
		.sys_clk_pad_i (CLK50MHZ),
		.rst_n_pad_i (USER_PB[0]),

		.wb_clk_o (wb_clk),
		.wb_rst_o (wb_rst)
	);

	wire uart0_rx;
	wire uart0_tx;

	assign uart0_rx = ARDUINO_IO0;
	assign ARDUINO_IO1 = uart0_tx;

	picorv32_wb_soc #(
		.PROGADDR_RESET (32'h 0000_0000),

		.BOOTROM_MEMFILE ("nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),

		.SRAM0_MEMDEPTH (16384)
	)
	soc(
		.clock (wb_clk),
		.reset (wb_rst),

		.uart_rx (uart0_rx),
		.uart_tx (uart0_tx)
	);

	assign USER_LED[0] = wb_clk;
	assign USER_LED[1] = wb_rst;
	assign USER_LED[2] = uart0_rx;
	assign USER_LED[3] = uart0_tx;

endmodule
