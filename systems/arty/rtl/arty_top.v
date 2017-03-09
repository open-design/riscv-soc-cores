module reset(clk, reset);
	parameter WIDTH = 8;

	input clk;
	output reg reset = 1;

	reg [WIDTH - 1 : 0]   out = 0;
	wire clk;

	always @(posedge clk)
		if (reset == 1)
			out <= out + 1;

	always @(posedge clk)
		if (out[7:0] == 5'b11111111)
			reset <= 0;
endmodule /* reset */

module clk_gen_sys(
	input clk_in1,
	output clk_out1
	);

	wire clk_in1_clk_gen_sys;
	IBUF clkin1_ibufg (.O (clk_in1_clk_gen_sys), .I (clk_in1));

	wire clk_out1_clk_gen_sys;

	wire clkfbout_clk_gen_sys;
	wire clkfbout_buf_clk_gen_sys;
	wire clkout1_unused;
	wire clkout2_unused;
	wire clkout3_unused;
	wire clkout4_unused;
	wire clkout5_unused;

	PLLE2_BASE #(
		.BANDWIDTH ("OPTIMIZED"),
		.STARTUP_WAIT ("FALSE"),
		.DIVCLK_DIVIDE (5),
		.CLKFBOUT_MULT (41),
		.CLKFBOUT_PHASE (0.000),
		.CLKOUT0_DIVIDE (82),
		.CLKOUT0_PHASE (0.000),
		.CLKOUT0_DUTY_CYCLE (0.500),
		.CLKIN1_PERIOD (10.000)
	)
	plle2_base_inst(
		.CLKFBIN(clkfbout_buf_clk_gen_sys),
		.CLKIN1(clk_in1_clk_gen_sys),

		.CLKFBOUT(clkfbout_clk_gen_sys),
		.CLKOUT0(clk_out1_clk_gen_sys),
		.CLKOUT1(clkout1_unused),
		.CLKOUT2(clkout2_unused),
		.CLKOUT3(clkout3_unused),
		.CLKOUT4(clkout4_unused),
		.CLKOUT5(clkout5_unused),

		.LOCKED(),
		.PWRDWN(1'b0),
		.RST(1'b0)
	);

	BUFG clkf_buf (.O (clkfbout_buf_clk_gen_sys), .I (clkfbout_clk_gen_sys));
	BUFG clkout1_buf (.O (clk_out1), .I (clk_out1_clk_gen_sys));
endmodule

module arty_top(
	input CLK100MHZ,
	input ck_rst,

	output [3:0] led,
	input [3:0] sw,
	input [3:0] btn,

	output uart_rxd_out,
	input uart_txd_in
	);

	wire clk10m;

	clk_gen_sys
	u_clk_gen_sys(
		.clk_in1(CLK100MHZ),
		.clk_out1(clk10m)
	);

	wire my_reset;
	assign led[0] = my_reset;
	reset mreset(clk10m, my_reset);

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../../src/riscv-nmon_0/nmon_picorv32-wb-soc_10MHz_9600.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock(clk10m),
		.reset(btn[0] | my_reset),
		.wb_iadr_o(),
		.uart_rx(uart_txd_in),
		.uart_tx(uart_rxd_out)
	);

endmodule
