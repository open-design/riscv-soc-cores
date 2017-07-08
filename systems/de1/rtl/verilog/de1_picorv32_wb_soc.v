module de1_picorv32_wb_soc(
	input  CLOCK_50,

	inout [7:0] GPIO_1,

	input UART_RXD,
	output UART_TXD
	);

	reg reset = 0;
	wire clk10m;
	wire pll_locked;

	altpll0 pll_10(
		.inclk0(CLOCK_50),
		.areset(reset),
		.c0(clk10m),
		.locked(pll_locked)
	);

	wire [35:0] cout;
	counter counter(.out(cout), .clk(clk10m), .reset(0));
	wire slow_clock = cout[8];

	wire my_reset;
	reset mreset(slow_clock, my_reset);

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock(clk10m),
		.reset(my_reset),
		.wb_iadr_o(),
		.uart_rx(GPIO_1[3]),
		.uart_tx(GPIO_1[1])
	);

endmodule
