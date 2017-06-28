module altpll_clkgen #(
	parameter DEVICE_FAMILY = "",
	parameter INPUT_FREQUENCY = 50,
	parameter DIVIDE_BY = 1,
	parameter MULTIPLY_BY = 1
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

wrapped_altpll wrapped_altpll
(
	.areset	(async_rst),
	.inclk0	(sys_clk_pad_i),
	.c0	(wb_clk_o),
	.locked	(pll_lock)
);
defparam
	wrapped_altpll.INPUT_FREQUENCY = INPUT_FREQUENCY,
	wrapped_altpll.DIVIDE_BY = DIVIDE_BY,
	wrapped_altpll.MULTIPLY_BY = MULTIPLY_BY,
	wrapped_altpll.DEVICE_FAMILY = DEVICE_FAMILY;

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

endmodule // altpll_clkgen
