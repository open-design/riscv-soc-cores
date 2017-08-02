`timescale 1ns / 1ps

module tb_clkgen(
	// Wishbone clock and reset out
	output	wb_clk_o,
	output	wb_rst_o,

	// Main memory clocks
	output	sdram_clk_o,
	output	sdram_rst_o
	);

	reg async_rst = 0;
	reg sync_rst_n = 0;

	// 50 MHz
	reg wb_clk_o = 0;
	always
	begin
		#10 wb_clk_o = !wb_clk_o;
	end

	// 100 MHz
	reg sdram_clk_o = 0;
	always
	begin
		#5 sdram_clk_o = !sdram_clk_o;
	end

	initial
	begin
		#2 sync_rst_n = 1;
		#3 async_rst = 1;
		#27 async_rst = 0;
	end

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

	// Reset generation for wishbone
	reg [15:0]	sdram_rst_shr;

	always @(posedge sdram_clk_o or posedge async_rst)
		if (async_rst)
			sdram_rst_shr <= 16'hffff;
		else
			sdram_rst_shr <= {sdram_rst_shr[14:0], ~(sync_rst_n)};

	assign sdram_rst_o = sdram_rst_shr[15];

endmodule


module picorv32_wb_soc_tb;

	initial
		#50000000 $finish;

	initial
	begin
		$dumpfile("picorv32-wb-soc.vcd");
		$dumpvars(0, picorv32_wb_soc_tb);
	end

	wire wb_clk;
	wire wb_rst;
	wire sdram_clk;
	wire sdram_rst;

	tb_clkgen clkgen(
		.wb_clk_o(wb_clk),
		.wb_rst_o(wb_rst),
		.sdram_clk_o(sdram_clk),
		.sdram_rst_o(sdram_rst)
	);

	wire [1:0] sdram_ba_pad;
	wire [11:0] sdram_a_pad;
	wire [15:0] sdram_dq_pad;
	wire sdram_ras_pad;
	wire sdram_cas_pad;
	wire sdram_we_pad;
	wire [15:0] sdram_dq;
	wire [15:0] sdram_dq_i;
	wire [15:0] sdram_dq_o;
	wire sdram_dq_oe;
	wire [1:0] sdram_dqm_pad;

	picorv32_wb_soc #(
		.SIM (1),
		.PROGADDR_RESET (32'h 0000_0000),
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/barebox_memtest2.txt"),
		.BOOTROM_MEMDEPTH (65536),

		// MT48LC4M16A2
		.SDRAM_CLK_FREQ_MHZ	(100),	// sdram_clk freq in MHZ
		.SDRAM_POWERUP_DELAY	(2),	// power up delay in us
		.SDRAM_REFRESH_MS	(32),	// time to wait between refreshes in ms
		.SDRAM_BURST_LENGTH	(8),	// 0, 1, 2, 4 or 8 (0 = full page)
		.SDRAM_BUF_WIDTH	(3),	// Buffer size = 2^BUF_WIDTH
		.SDRAM_ROW_WIDTH	(12),	// Row width
		.SDRAM_COL_WIDTH	(8),	// Column width
		.SDRAM_BA_WIDTH		(2),	// Ba width
		.SDRAM_tCAC		(3),	// CAS Latency
		.SDRAM_tRAC		(7),	// RAS Latency
		.SDRAM_tRP		(3),	// Command Period (PRE to ACT)
		.SDRAM_tRC		(8),	// Command Period (REF to REF / ACT to ACT)
		.SDRAM_tMRD		(2)	// Mode Register Set To Command Delay time
	)
	soc(
		.clock(wb_clk),
		.reset(wb_rst),
		.sdram_clk(sdram_clk),
		.sdram_rst(sdram_rst),

		.sdram_ba_pad_o		(sdram_ba_pad[1:0]),
		.sdram_a_pad_o		(sdram_a_pad[11:0]),
		.sdram_cs_n_pad_o	(),
		.sdram_ras_pad_o	(sdram_ras_pad),
		.sdram_cas_pad_o	(sdram_cas_pad),
		.sdram_we_pad_o		(sdram_we_pad),
		.sdram_dq_o		(sdram_dq_o[15:0]),
		.sdram_dq_i		(sdram_dq_i[15:0]),
		.sdram_dq_oe		(sdram_dq_oe),
		.sdram_dqm_pad_o	(sdram_dqm_pad[1:0]),
		.sdram_cke_pad_o	()
	);

	assign	sdram_dq_i = sdram_dq_pad;
	assign	sdram_dq_pad = sdram_dq_oe ? sdram_dq_o : 16'bz;

	mt48lc16m16a2_wrapper #(
		.TPROP_PCB (2.0),
		.ADDR_BITS (12),
		.MEM_SIZES (1048575),
		.COL_BITS  (8)
	)
	sdram_chip (
		.clk_i(sdram_clk),
		.rst_n_i(1'b1),
		.dq_io(sdram_dq_pad[15:0]),
		.addr_i(sdram_a_pad[11:0]),
		.ba_i(sdram_ba_pad[1:0]),
		.cas_i(sdram_cas_pad),
		.cke_i(1'b1),
		.cs_n_i(1'b0),
		.dqm_i(sdram_dqm_pad[1:0]),
		.ras_i(sdram_ras_pad),
		.we_i(sdram_we_pad)
	);

endmodule
