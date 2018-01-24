module marsohod2rpi_picorv32_wb_soc(
	input CLK100MHZ,
	output [3:0] LED,
	input KEY0,
	input KEY1,
	input KEY2,

	input GPIO8,

	input GPIO14,
	output GPIO15
	);

	wire rst_n_pad;
	assign rst_n_pad = GPIO8 & KEY0;

	wire wb_clk;
	wire wb_rst;

	altpll_wb_clkgen #(
		.DEVICE_FAMILY ("Cyclone IV E"),
		.INPUT_FREQUENCY (100),

		/* wb_clk: 24 MHz */
		.WB_DIVIDE_BY (25),
		.WB_MULTIPLY_BY (6)
	)
	clkgen(
		.sys_clk_pad_i (CLK100MHZ),
		.rst_n_pad_i (rst_n_pad),

		.wb_clk_o (wb_clk),
		.wb_rst_o (wb_rst)
	);

	wire [7:0] gpio0_o;
	assign LED[3:0] = gpio0_o[3:0];

	wire [7:0] gpio0_i;
	wire [7:0] gpio0_dir_o;

	wire uart0_rx;
	wire uart0_tx;

	assign uart0_rx = GPIO14;
	assign GPIO15 = uart0_tx;

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),

		.SRAM0_MEMDEPTH (16384)
	)
	soc(
		.clock (wb_clk),
		.reset (wb_rst),

		.uart_rx (uart0_rx),
		.uart_tx (uart0_tx),

		.gpio0_i (gpio0_i),
		.gpio0_o (gpio0_o),
		.gpio0_dir_o (gpio0_dir_o)
	);

endmodule
