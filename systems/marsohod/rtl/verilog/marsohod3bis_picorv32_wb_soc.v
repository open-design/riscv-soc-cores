module marsohod3bis_picorv32_wb_soc(
	input CLK100MHZ,

	output [7:0] LED,
	inout [7:0] IO,
	input KEY1
	);

	wire wb_clk;
	wire wb_rst;

	altpll_wb_clkgen #(
		.DEVICE_FAMILY ("MAX 10"),
		.INPUT_FREQUENCY (100),

		/* wb_clk: 24 MHz */
		.WB_DIVIDE_BY (25),
		.WB_MULTIPLY_BY (6)
	)
	clkgen(
		.sys_clk_pad_i (CLK100MHZ),
		.rst_n_pad_i (KEY1),

		.wb_clk_o (wb_clk),
		.wb_rst_o (wb_rst)
	);

	wire [7:0] gpio0_o;
	assign LED[7:0] = gpio0_o[7:0];

	wire [7:0] gpio0_i;
	wire [7:0] gpio0_dir_o;

	wire uart0_rx;
	wire uart0_tx;

	assign uart0_rx = IO[7];
	assign IO[5] = uart0_tx;

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024),
		.SRAM0_MEMDEPTH (32768)
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
