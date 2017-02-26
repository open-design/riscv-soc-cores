project_new marsohod2-vscale-wb-soc_0 -overwrite
set_global_assignment -name FAMILY "Cyclone III"
set_global_assignment -name DEVICE EP3C10E144C8
set_global_assignment -name TOP_LEVEL_ENTITY marsohod2_vscale_wb_soc
set_global_assignment -name VERILOG_FILE ../src/or1k_bootloaders_0.9/wb_bootrom.v
set_global_assignment -name VERILOG_FILE ../src/uart16550_1.5.4/rtl/verilog/raminfr.v
set_global_assignment -name VERILOG_FILE ../src/uart16550_1.5.4/rtl/verilog/uart_receiver.v
set_global_assignment -name VERILOG_FILE ../src/uart16550_1.5.4/rtl/verilog/uart_regs.v
set_global_assignment -name VERILOG_FILE ../src/uart16550_1.5.4/rtl/verilog/uart_rfifo.v
set_global_assignment -name VERILOG_FILE ../src/uart16550_1.5.4/rtl/verilog/uart_sync_flops.v
set_global_assignment -name VERILOG_FILE ../src/uart16550_1.5.4/rtl/verilog/uart_tfifo.v
set_global_assignment -name VERILOG_FILE ../src/uart16550_1.5.4/rtl/verilog/uart_top.v
set_global_assignment -name VERILOG_FILE ../src/uart16550_1.5.4/rtl/verilog/uart_transmitter.v
set_global_assignment -name VERILOG_FILE ../src/uart16550_1.5.4/rtl/verilog/uart_wb.v
set_global_assignment -name VERILOG_FILE ../src/verilog-arbiter_0-r1/src/arbiter.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/wb_vscale.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_alu.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_csr_file.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_ctrl.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_imm_gen.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_mul_div.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_PC_mux.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_pipeline.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_regfile.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_src_a_mux.v
set_global_assignment -name VERILOG_FILE ../src/wb_riscvscale_0/vscale_src_b_mux.v
set_global_assignment -name VERILOG_FILE ../src/wb_intercon_1.0/rtl/verilog/wb_arbiter.v
set_global_assignment -name VERILOG_FILE ../src/wb_intercon_1.0/rtl/verilog/wb_data_resize.v
set_global_assignment -name VERILOG_FILE ../src/wb_intercon_1.0/rtl/verilog/wb_upsizer.v
set_global_assignment -name VERILOG_FILE ../src/wb_intercon_1.0/rtl/verilog/wb_mux.v
set_global_assignment -name VERILOG_FILE ../src/vscale-wb-soc_0/rtl/verilog/vscale_soc.v
set_global_assignment -name VERILOG_FILE ../src/vscale-wb-soc_0/rtl/verilog/wb_intercon/wb_intercon.v
set_global_assignment -name VERILOG_FILE ../src/marsohod2-vscale-wb-soc_0/rtl/verilog/aux.v
set_global_assignment -name VERILOG_FILE ../src/marsohod2-vscale-wb-soc_0/rtl/verilog/marsohod2_vscale_wb_soc.v
set_global_assignment -name VERILOG_FILE ../src/marsohod2-vscale-wb-soc_0/rtl/verilog/cyclone3-altpll/altpll0.v
set_global_assignment -name SDC_FILE ../src/marsohod2-vscale-wb-soc_0/data/marsohod2.sdc
source ../src/marsohod2-vscale-wb-soc_0/data/pinmap.tcl
source ../src/marsohod2-vscale-wb-soc_0/data/options.tcl
source ../src/marsohod2-vscale-wb-soc_0/data/vscale.tcl
set_global_assignment -name SEARCH_PATH ../src/or1k_bootloaders_0.9/
set_global_assignment -name SEARCH_PATH ../src/riscv-nmon_0/
set_global_assignment -name SEARCH_PATH ../src/uart16550_1.5.4/rtl/verilog
set_global_assignment -name SEARCH_PATH ../src/verilog_utils_0/
set_global_assignment -name SEARCH_PATH ../src/wb_common_0/
set_global_assignment -name SEARCH_PATH ../src/wb_riscvscale_0/
set_global_assignment -name SEARCH_PATH ../src/vscale-wb-soc_0/rtl/verilog/wb_intercon
