module de1_soc_picorv32_wb_soc(
	input CLOCK_50,
	output [9:0] LEDR,
	inout [35:0] GPIO_0
	);

	wire spi0_sck;
	wire spi0_miso;
	wire spi0_mosi;
	wire spi0_cs0;

	assign GPIO_0[0] = spi0_sck;
	assign spi0_miso = GPIO_0[2];
	assign GPIO_0[4] = spi0_mosi;
	assign GPIO_0[6] = spi0_cs0;

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
//	assign LEDR[7:0] = gpio0_o[7:0];
	assign spi0_sck = gpio0_o[0];
	assign spi0_mosi = gpio0_o[2];
	assign spi0_cs0 = gpio0_o[3];

	wire [7:0] gpio0_i;
	assign gpio0_i[1] = spi0_miso;

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
