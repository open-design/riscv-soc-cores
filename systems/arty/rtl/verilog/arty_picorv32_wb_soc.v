module arty_picorv32_wb_soc(
	input CLK100MHZ,

	output [3:0] led,
	input [3:0] sw,
	input [3:0] btn,

	output uart_rxd_out,
	input uart_txd_in
	);

	wire wb_clk;
	wire wb_rst;

	plle2_base_wb_clkgen #(
		.INPUT_FREQUENCY (100),
		.DIVCLK_DIVIDE (5),
		.CLKFBOUT_MULT (42),
		.WB_DIVIDE (35)
	) wb_clkgen (
		.sys_clk_pad_i (CLK100MHZ),
		.rst_n_pad_i (~btn[0]),

		.wb_clk_o (wb_clk),
		.wb_rst_o (wb_rst)
	);

	assign led[0] = wb_rst;

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock (wb_clk),
		.reset (wb_rst),

		.uart_rx (uart_txd_in),
		.uart_tx (uart_rxd_out)
	);

endmodule
