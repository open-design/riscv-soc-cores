module de1_soc_picorv32_wb_soc(
	input  CLOCK_50,
	inout  [35:0] GPIO_0
	);

	reg reset = 0;
	wire clk10m;
	wire pll_locked;

	pll10MHz pll_10(
		.refclk(CLOCK_50),
		.rst(reset),
		.outclk_0(clk10m),
		.locked(pll_locked));

	wire [35:0] cout;
	counter counter(.out(cout), .clk(clk10m), .reset(0));
	wire slow_clock = cout[8];

	wire my_reset;
	reset mreset(slow_clock, my_reset);

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_10MHz_9600.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock(clk10m),
		.reset(my_reset),
		.wb_iadr_o(),
		.uart_rx(GPIO_0[3]),
		.uart_tx(GPIO_0[1])
	);

endmodule
