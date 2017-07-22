module de10_nano_picorv32_wb_soc(
	input CLOCK_50,
	input [1:0] KEY,
	output [7:0] LED,
	inout [7:0] GPIO_0,
	inout [7:0] GPIO_1
	);

	wire spi0_sck;
	wire spi0_miso;
	wire spi0_mosi;
	wire spi0_cs0;

	assign GPIO_0[0] = spi0_sck;
	assign spi0_miso = GPIO_0[2];
	assign GPIO_0[4] = spi0_mosi;
	assign GPIO_0[6] = spi0_cs0;

	/* debug */
	assign GPIO_1[0] = GPIO_0[0];
	assign GPIO_1[1] = GPIO_0[1];
	assign GPIO_1[2] = GPIO_0[2];
	assign GPIO_1[3] = GPIO_0[3];
	assign GPIO_1[4] = GPIO_0[4];
	assign GPIO_1[5] = GPIO_0[5];
	assign GPIO_1[6] = GPIO_0[6];
	assign GPIO_1[7] = GPIO_0[7];

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
	//assign LED[7:0] = gpio0_o[7:0];
	assign spi0_sck = gpio0_o[0];
	assign spi0_mosi = gpio0_o[2];
	assign spi0_cs0 = gpio0_o[3];

	wire [7:0] gpio0_i;
	//assign gpio0_i[1:0] = KEY[1:0];
	assign gpio0_i[1] = spi0_miso;

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
