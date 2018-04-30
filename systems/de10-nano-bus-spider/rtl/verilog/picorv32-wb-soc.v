// Error (10162): Verilog HDL Object Declaration error at hps_sdram_pll.sv(168): can't declare implicit net "pll_dr_clk" because the current value of 'default_nettype is "none" File: /home/antony/riscv-soc-cores/build/de10-nano-bus-spider_0/bld-quartus/qsys/soc_system/synthesis/submodules/hps_sdram_pll.sv Line: 168
// `default_nettype none

module picorv32_wb_soc #(
	parameter SIM = 0,
	parameter PROGADDR_RESET = 32'h 0000_0000,
	parameter BOOTROM_MEMFILE = "",
	parameter BOOTROM_MEMDEPTH = 1024,

	parameter SRAM0_TECHNOLOGY = "GENERIC",
	parameter SRAM0_MEMDEPTH = 16384
	)
	(
	input wb_clk,
	input wb_rst,

	input uart_rx,
	output uart_tx,

	input [7:0] gpio0_i,
	output [7:0] gpio0_o,
	output [7:0] gpio0_dir_o,

	input [7:0] gpio1_i,
	output [7:0] gpio1_o,
	output [7:0] gpio1_dir_o
	);

`include "wb_common_params.v"
`include "wb_intercon.vh"

wb_ram #(
	.TECHNOLOGY (SRAM0_TECHNOLOGY),
	.depth (SRAM0_MEMDEPTH)
)
sram0 (
	.wb_clk_i (wb_clk),
	.wb_rst_i (wb_rst),

	.wb_adr_i (wb_m2s_sram0_adr),
	.wb_dat_i (wb_m2s_sram0_dat),
	.wb_sel_i (wb_m2s_sram0_sel),
	.wb_we_i (wb_m2s_sram0_we),
	.wb_cyc_i (wb_m2s_sram0_cyc),
	.wb_stb_i (wb_m2s_sram0_stb),
	.wb_cti_i (wb_m2s_sram0_cti),
	.wb_bte_i (wb_m2s_sram0_bte),
	.wb_dat_o (wb_s2m_sram0_dat),
	.wb_ack_o (wb_s2m_sram0_ack),
	.wb_err_o (wb_s2m_sram0_err)
);

wb_bootrom #(
	.DEPTH (BOOTROM_MEMDEPTH),
	.MEMFILE (BOOTROM_MEMFILE)
)
bootrom (
	.wb_clk_i (wb_clk),
	.wb_rst_i (wb_rst),

	.wb_adr_i (wb_m2s_rom0_adr),
	.wb_stb_i (wb_m2s_rom0_stb),
	.wb_cyc_i (wb_m2s_rom0_cyc),
	.wb_dat_o (wb_s2m_rom0_dat),
	.wb_ack_o (wb_s2m_rom0_ack)
);

uart_top #(
	.SIM (0)
)
uart0 (
	.wb_clk_i (wb_clk),
	.wb_rst_i (wb_rst),

	.wb_adr_i (wb_m2s_uart0_adr[4:2]),
	.wb_dat_i (wb_m2s_uart0_dat),
	.wb_sel_i (wb_m2s_uart0_sel),
	.wb_we_i (wb_m2s_uart0_we),
	.wb_cyc_i (wb_m2s_uart0_cyc),
	.wb_stb_i (wb_m2s_uart0_stb),
	.wb_dat_o (wb_s2m_uart0_dat),
	.wb_ack_o (wb_s2m_uart0_ack),

	.stx_pad_o (uart_tx),
	.srx_pad_i (uart_rx)
);

gpio gpio0 (
	.wb_clk (wb_clk),
	.wb_rst (wb_rst),

	// Wishbone slave interface
	.wb_adr_i (wb_m2s_gpio0_adr[2]),
	.wb_dat_i (wb_m2s_gpio0_dat),
	.wb_we_i (wb_m2s_gpio0_we),
	.wb_cyc_i (wb_m2s_gpio0_cyc),
	.wb_stb_i (wb_m2s_gpio0_stb),
	.wb_cti_i (wb_m2s_gpio0_cti),
	.wb_bte_i (wb_m2s_gpio0_bte),
	.wb_dat_o (wb_s2m_gpio0_dat),
	.wb_ack_o (wb_s2m_gpio0_ack),
	.wb_err_o (wb_s2m_gpio0_err),
	.wb_rty_o (wb_s2m_gpio0_rty),

	// GPIO bus
	.gpio_i (gpio0_i),
	.gpio_o (gpio0_o),
	.gpio_dir_o (gpio0_dir_o)
);

gpio gpio1 (
	.wb_clk (wb_clk),
	.wb_rst (wb_rst),

	// Wishbone slave interface
	.wb_adr_i (wb_m2s_gpio1_adr[2]),
	.wb_dat_i (wb_m2s_gpio1_dat),
	.wb_we_i (wb_m2s_gpio1_we),
	.wb_cyc_i (wb_m2s_gpio1_cyc),
	.wb_stb_i (wb_m2s_gpio1_stb),
	.wb_cti_i (wb_m2s_gpio1_cti),
	.wb_bte_i (wb_m2s_gpio1_bte),
	.wb_dat_o (wb_s2m_gpio1_dat),
	.wb_ack_o (wb_s2m_gpio1_ack),
	.wb_err_o (wb_s2m_gpio1_err),
	.wb_rty_o (wb_s2m_gpio1_rty),

	// GPIO bus
	.gpio_i (gpio1_i),
	.gpio_o (gpio1_o),
	.gpio_dir_o (gpio1_dir_o)
);

picorv32_wb #(
	.PROGADDR_RESET (PROGADDR_RESET),
	.COMPRESSED_ISA (1),
	.ENABLE_MUL (1),
	.ENABLE_DIV (1)
)
picorv32_wb (
	.wb_clk_i (wb_clk),
	.wb_rst_i (wb_rst),

	.wbm_adr_o (wb_m2s_picorv32_adr),
	.wbm_dat_i (wb_s2m_picorv32_dat),
	.wbm_stb_o (wb_m2s_picorv32_stb),
	.wbm_ack_i (wb_s2m_picorv32_ack),
	.wbm_cyc_o (wb_m2s_picorv32_cyc),
	.wbm_dat_o (wb_m2s_picorv32_dat),
	.wbm_we_o (wb_m2s_picorv32_we),
	.wbm_sel_o (wb_m2s_picorv32_sel)
);
assign wb_m2s_picorv32_cti = CTI_CLASSIC;

endmodule
