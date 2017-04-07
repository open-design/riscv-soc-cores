module picorv32_wb_soc #(
	parameter BOOTROM_MEMFILE = "",
	parameter BOOTROM_MEMDEPTH = 1024,
	parameter SRAM0_MEMDEPTH = 16384
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

	wb_ram #(
		.depth (SRAM0_MEMDEPTH)
	)
	sram0 (
		.wb_clk_i		(wb_clk),
		.wb_rst_i		(wb_rst),

		.wb_adr_i		(wb_m2s_sram0_adr),
		.wb_dat_i		(wb_m2s_sram0_dat),
		.wb_sel_i		(wb_m2s_sram0_sel),
		.wb_we_i		(wb_m2s_sram0_we),
		.wb_cyc_i		(wb_m2s_sram0_cyc),
		.wb_stb_i		(wb_m2s_sram0_stb),
		.wb_cti_i		(wb_m2s_sram0_cti),
		.wb_bte_i		(wb_m2s_sram0_bte),
		.wb_dat_o		(wb_s2m_sram0_dat),
		.wb_ack_o		(wb_s2m_sram0_ack),
		.wb_err_o		(wb_s2m_sram0_err)
	);

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

	picorv32_wb picorv32_wb(
		.wb_clk_i(wb_clk),
		.wb_rst_i(wb_rst),

		.wbm_adr_o(wb_m2s_picorv32_adr),
		.wbm_dat_i(wb_s2m_picorv32_dat),
		.wbm_stb_o(wb_m2s_picorv32_stb),
		.wbm_ack_i(wb_s2m_picorv32_ack),
		.wbm_cyc_o(wb_m2s_picorv32_cyc),
		.wbm_dat_o(wb_m2s_picorv32_dat),
		.wbm_we_o(wb_m2s_picorv32_we),
		.wbm_sel_o(wb_m2s_picorv32_sel)
	);

	assign wb_iadr_o = wb_m2s_picorv32_adr;
endmodule
