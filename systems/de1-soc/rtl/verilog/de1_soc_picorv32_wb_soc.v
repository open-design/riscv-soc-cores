module de1_soc_picorv32_wb_soc(
	input CLOCK_50,

	output [9:0] LEDR,
	inout [35:0] GPIO_0
	);

	wire wb_clk;
	wire wb_rst;

	altera_pll_wb_clkgen #(
		.INPUT_FREQUENCY ("50.0 MHz"),
		.WB_CLK_FREQUENCY ("24.0 MHz")
	)
	clkgen(
		.sys_clk_pad_i (CLOCK_50),
		.rst_n_pad_i (1),
		.wb_clk_o (wb_clk),
		.wb_rst_o (wb_rst)
	);

	wire uart0_rx;
	wire uart0_tx;

	assign GPIO_0[1] = uart0_tx;
	assign uart0_rx = GPIO_0[3];

	wire [7:0] gpio0_o;
	assign LEDR[7:0] = gpio0_o[7:0];

	wire [7:0] gpio0_i;

	picorv32_wb_soc #(
		.PROGADDR_RESET (32'h 0000_0000),

		.BOOTROM_MEMFILE ("nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock (wb_clk),
		.reset (wb_rst),

		.uart_rx (uart0_rx),
		.uart_tx (uart0_tx),

		.gpio0_i (gpio0_i),
		.gpio0_o (gpio0_o),
		.gpio0_dir_o ()
	);

endmodule
