module plle2_base_wb_clkgen #(
	parameter INPUT_FREQUENCY = 100,
	parameter DIVCLK_DIVIDE = 1,
	parameter CLKFBOUT_MULT = 1,
	parameter WB_DIVIDE = 1
) (
	// Main clocks in, depending on board
	input sys_clk_pad_i,
	// Asynchronous, active low reset in
	input rst_n_pad_i,

	// Input reset - through a buffer, asynchronous
	output async_rst_o,

	// Wishbone clock and reset out
	output wb_clk_o,
	output wb_rst_o
	);

	// First, deal with the asychronous reset
	wire async_rst;
	wire async_rst_n;

	assign async_rst_n = rst_n_pad_i;
	assign async_rst = ~async_rst_n;

	// Everyone likes active-high reset signals...
	assign async_rst_o = ~async_rst_n;

	// An active-low synchronous reset signal (usually a PLL lock signal)
	wire sync_rst_n;

	wire pll_lock;

	// PLL stuff
	wire clk_in1_clk_gen_sys;
	IBUF clkin1_ibufg (.O (clk_in1_clk_gen_sys), .I (sys_clk_pad_i));

	wire clk_out1_clk_gen_sys;

	wire clkfbout_clk_gen_sys;
	wire clkfbout_buf_clk_gen_sys;

	PLLE2_BASE #(
		.BANDWIDTH ("OPTIMIZED"),
		.STARTUP_WAIT ("FALSE"),
		.DIVCLK_DIVIDE (DIVCLK_DIVIDE),
		.CLKFBOUT_MULT (CLKFBOUT_MULT),
		.CLKFBOUT_PHASE (0.000),
		.CLKOUT0_DIVIDE (WB_DIVIDE),
		.CLKOUT0_PHASE (0.000),
		.CLKOUT0_DUTY_CYCLE (0.500),
		// CLKIN1_PERIOD: period in nS
		.CLKIN1_PERIOD (1000.000 / INPUT_FREQUENCY)
	)
	plle2_base_inst(
		.CLKFBIN(clkfbout_buf_clk_gen_sys),
		.CLKIN1(clk_in1_clk_gen_sys),

		.CLKFBOUT(clkfbout_clk_gen_sys),
		.CLKOUT0(clk_out1_clk_gen_sys),

		.LOCKED(pll_lock),
		.PWRDWN(1'b0),
		.RST(async_rst)
	);
	assign sync_rst_n = pll_lock;

	BUFG clkf_buf (.O (clkfbout_buf_clk_gen_sys), .I (clkfbout_clk_gen_sys));
	BUFG clkout1_buf (.O (wb_clk_o), .I (clk_out1_clk_gen_sys));

	// Reset generation for wishbone
	reg [15:0] wb_rst_shr;

	always @(posedge wb_clk_o or posedge async_rst)
		if (async_rst)
			wb_rst_shr <= 16'hffff;
		else
			wb_rst_shr <= {wb_rst_shr[14:0], ~(sync_rst_n)};

	assign wb_rst_o = wb_rst_shr[15];

endmodule
