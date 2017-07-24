module altpll_wb_clkgen #(
	parameter DEVICE_FAMILY = "",
	parameter INPUT_FREQUENCY = 50,
	parameter WB_DIVIDE_BY = 1,
	parameter WB_MULTIPLY_BY = 1,
	parameter SDRAM_DIVIDE_BY = 1,
	parameter SDRAM_MULTIPLY_BY = 1
) (
	// Main clocks in, depending on board
	input sys_clk_pad_i,
	// Asynchronous, active low reset in
	input rst_n_pad_i,

	// Input reset - through a buffer, asynchronous
	output async_rst_o,

	// Wishbone clock and reset out
	output wb_clk_o,
	output wb_rst_o,

	// Main memory clocks
	output sdram_clk_o,
	output sdram_rst_o
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

	wrapped_altpll #(
		.DEVICE_FAMILY (DEVICE_FAMILY),
		.INPUT_FREQUENCY (INPUT_FREQUENCY),
		.C0_DIVIDE_BY (WB_DIVIDE_BY),
		.C0_MULTIPLY_BY (WB_MULTIPLY_BY),
		.C1_DIVIDE_BY (SDRAM_DIVIDE_BY),
		.C1_MULTIPLY_BY (SDRAM_MULTIPLY_BY)
	)
	wrapped_altpll (
		.areset (async_rst),
		.inclk0 (sys_clk_pad_i),
		.c0 (wb_clk_o),
		.c1 (sdram_clk_o),
		.locked (pll_lock)
	);
	assign sync_rst_n = pll_lock;

	// Reset generation for wishbone
	reg [15:0] wb_rst_shr;

	always @(posedge wb_clk_o or posedge async_rst)
		if (async_rst)
			wb_rst_shr <= 16'hffff;
		else
			wb_rst_shr <= {wb_rst_shr[14:0], ~(sync_rst_n)};

	assign wb_rst_o = wb_rst_shr[15];

	// Reset generation for sdram
	reg [15:0] sdram_rst_shr;

	always @(posedge sdram_clk_o or posedge async_rst)
		if (async_rst)
			sdram_rst_shr <= 16'hffff;
		else
			sdram_rst_shr <= {sdram_rst_shr[14:0], ~(sync_rst_n)};

	assign sdram_rst_o = sdram_rst_shr[15];

endmodule
