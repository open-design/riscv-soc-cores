module marsohod2_picorv32_wb_soc(
	input  CLK100MHZ,
	output [2:0] LED,
	inout [7:0] IO,
	input KEY1,
	input FTDI_BD0,		/* SK_i, TCK_i, TXD_i */
	output FTDI_BD1,	/* DO_o, TDI_o, RXD_o */
	input FTDI_BD2,		/* DI_i, TDO_i, RTS#_i */
	input FTDI_BD3		/* CS_i, TMS_i, CTS#_i */
	);

	wire wb_clk;
	wire wb_rst;

	altpll_clkgen #(
		.INPUT_FREQUENCY (100),
		.DIVIDE_BY (10),
		.MULTIPLY_BY (1),
		.DEVICE_FAMILY ("Cyclone IV E")
	)
	clkgen(
		.sys_clk_pad_i(CLK100MHZ),
		.rst_n_pad_i(KEY1),
		.wb_clk_o(wb_clk),
		.wb_rst_o(wb_rst)
	);

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_10MHz_9600.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock(wb_clk),
		.reset(wb_rst),
		.wb_iadr_o(),
		.uart_rx(FTDI_BD0),
		.uart_tx(FTDI_BD1)
	);

endmodule
