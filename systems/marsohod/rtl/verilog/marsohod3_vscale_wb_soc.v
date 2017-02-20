module marsohod3_vscale_wb_soc(
	input  CLK100MHZ,
	output [3:0] LED,
	inout [7:0] IO,
	input KEY1,
	input FTDI_BD0,		/* SK_i, TCK_i, TXD_i */
	output FTDI_BD1,	/* DO_o, TDI_o, RXD_o */
	input FTDI_BD2,		/* DI_i, TDO_i, RTS#_i */
	input FTDI_BD3		/* CS_i, TMS_i, CTS#_i */
	);

	wire clk10m;

	altpll0 pll(
		.inclk0(CLK100MHZ),
		.c0(clk10m)
	);

	wire [35:0] cout;
	counter counter(.out(cout), .clk(clk10m), .reset(0));
	wire slow_clock = cout[8];

	wire my_reset;
	assign LED[0] = my_reset;
	reset mreset(slow_clock, my_reset);

	vscale_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_vscale-wb-soc_10MHz_9600.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock(clk10m),
		.reset(my_reset),
		.wb_iadr_o(),
		.uart_rx(IO[7]),
		.uart_tx(IO[5])
	);

endmodule
