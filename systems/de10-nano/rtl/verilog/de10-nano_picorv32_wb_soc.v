module de10_nano_picorv32_wb_soc(
	input CLOCK_50,
	input [1:0] KEY,
	output [7:0] LED,
	inout [35:0] GPIO_0
	);

	wire wb_clk;
	wire wb_rst;

	altera_pll_clkgen #(
		.INPUT_FREQUENCY ("50.0 MHz"),
		.OUTPUT_CLOCK0_FREQUENCY ("24.0 MHz")
	)
	clkgen(
		.sys_clk_pad_i(CLOCK_50),
		.rst_n_pad_i(1),
		.wb_clk_o(wb_clk),
		.wb_rst_o(wb_rst)
	);

wire [7:0] gpio0_o;
assign LED[7:0] = gpio0_o[7:0];

wire [7:0] gpio0_i;
assign gpio0_i[1:0] = KEY[1:0];

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock(wb_clk),
		.reset(wb_rst),
		.wb_iadr_o(),
		.uart_rx(GPIO_0[3]),
		.uart_tx(GPIO_0[1]),

		.gpio0_i		(gpio0_i),
		.gpio0_o		(gpio0_o),
		.gpio0_dir_o		()
	);

endmodule
