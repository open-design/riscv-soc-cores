module altera_pll_wb_clkgen #(
	parameter INPUT_FREQUENCY,
	parameter WB_CLK_FREQUENCY
) (
	// Main clocks in, depending on board
	input	sys_clk_pad_i,
	// Asynchronous, active low reset in
	input	rst_n_pad_i,
	// Input reset - through a buffer, asynchronous
	output	async_rst_o,

	// Wishbone clock and reset out
	output	wb_clk_o,
	output	wb_rst_o
);

// First, deal with the asychronous reset
wire	async_rst;
wire	async_rst_n;

assign	async_rst_n = rst_n_pad_i;
assign	async_rst = ~async_rst_n;

// Everyone likes active-high reset signals...
assign	async_rst_o = ~async_rst_n;

//
// Declare synchronous reset wires here
//

// An active-low synchronous reset signal (usually a PLL lock signal)
wire sync_rst_n;

wire pll_lock;

wrapped_altera_pll #(
	.INPUT_FREQUENCY (INPUT_FREQUENCY),
	.OUTPUT_CLOCK0_FREQUENCY (WB_CLK_FREQUENCY)
)
wrapped_altera_pll (
	.refclk	(sys_clk_pad_i),
	.rst	(async_rst),
	.outclk_0	(wb_clk_o),
	.locked	(pll_lock)
);

assign sync_rst_n = pll_lock;

//
// Reset generation
//

// Reset generation for wishbone
reg [15:0]	wb_rst_shr;

always @(posedge wb_clk_o or posedge async_rst)
	if (async_rst)
		wb_rst_shr <= 16'hffff;
	else
		wb_rst_shr <= {wb_rst_shr[14:0], ~(sync_rst_n)};

assign wb_rst_o = wb_rst_shr[15];

endmodule // altera_pll_clkgen
