module vscale_wb_soc #(
	parameter BOOTROM_MEMFILE = "",
	parameter BOOTROM_MEMDEPTH = 1024
	)
	(
	input  clock,
	input  reset,
	output [31:0] wb_iadr_o,
	input  uart_rx,
	output uart_tx
	);

	wire wb_clk;
	assign wb_clk = clock;
	wire wb_rst;
	assign wb_rst = reset;

`include "wb_intercon.vh"

	wb_bootrom #(
		.DEPTH (BOOTROM_MEMDEPTH),
		.MEMFILE (BOOTROM_MEMFILE)
	)
	bootrom(
		.wb_clk_i(wb_clk),
		.wb_rst_i(wb_rst),

		.wb_adr_i(wb_m2s_rom0_adr),
		.wb_stb_i(wb_m2s_rom0_stb),
		.wb_cyc_i(wb_m2s_rom0_cyc),
		.wb_dat_o(wb_s2m_rom0_dat),
		.wb_ack_o(wb_s2m_rom0_ack)
	);

	assign wb_s2m_rom0_err = 1'b0;
	assign wb_s2m_rom0_rty = 1'b0;

	uart_top uart16550(
		.wb_clk_i(wb_clk),
		.wb_rst_i(wb_rst),

		.wb_adr_i(wb_m2s_uart0_adr[4:2]),
		.wb_dat_i(wb_m2s_uart0_dat),
		.wb_sel_i(wb_m2s_uart0_sel),
		.wb_we_i(wb_m2s_uart0_we),
		.wb_cyc_i(wb_m2s_uart0_cyc),
		.wb_stb_i(wb_m2s_uart0_stb),
		.wb_dat_o(wb_s2m_uart0_dat),
		.wb_ack_o(wb_s2m_uart0_ack),

		.stx_pad_o(uart_tx),
		.srx_pad_i(uart_rx)
	);

	assign wb_s2m_uart0_err = 1'b0;
	assign wb_s2m_uart0_rty = 1'b0;

	wb_vscale wb_vscale(
		.clk(wb_clk),
		.rst(wb_rst),

		.iwbm_adr_o(wb_m2s_vscale_i_adr),
		.iwbm_dat_i(wb_s2m_vscale_i_dat),
		.iwbm_stb_o(wb_m2s_vscale_i_stb),
		.iwbm_ack_i(wb_s2m_vscale_i_ack),
		.iwbm_cyc_o(wb_m2s_vscale_i_cyc),
		.iwbm_err_i(wb_s2m_vscale_i_err),

		.dwbm_adr_o(wb_m2s_vscale_d_adr),
		.dwbm_dat_i(wb_s2m_vscale_d_dat),
		.dwbm_stb_o(wb_m2s_vscale_d_stb),
		.dwbm_ack_i(wb_s2m_vscale_d_ack),
		.dwbm_cyc_o(wb_m2s_vscale_d_cyc),
		.dwbm_dat_o(wb_m2s_vscale_d_dat),
		.dwbm_we_o(wb_m2s_vscale_d_we),
		.dwbm_sel_o(wb_m2s_vscale_d_sel),
		.dwbm_err_i(wb_s2m_vscale_d_err)
	);

	assign wb_iadr_o = wb_m2s_vscale_i_adr;
endmodule
