`timescale 1ns / 1ps

module tb_clkgen(
	output wb_clk_o,
	output wb_rst_o
);

	reg async_rst = 0;
	reg sync_rst_n = 0;

	// 50 MHz
	reg wb_clk_o = 0;
	always
	begin
		#10 wb_clk_o = !wb_clk_o;
	end

	initial
	begin
		#2 sync_rst_n = 1;
		#3 async_rst = 1;
		#27 async_rst = 0;
	end

	// Reset generation for wishbone
	reg [15:0]	wb_rst_shr;

	always @(posedge wb_clk_o or posedge async_rst)
		if (async_rst)
			wb_rst_shr <= 16'hffff;
		else
			wb_rst_shr <= {wb_rst_shr[14:0], ~(sync_rst_n)};

	assign wb_rst_o = wb_rst_shr[15];

endmodule


module picorv32_wb_soc_tb;

	initial
		#50000 $finish;

	initial
	begin
		$dumpfile("picorv32-wb-soc.vcd");
		$dumpvars(0, picorv32_wb_soc_tb);
	end

	wire wb_clk;
	wire wb_rst;

	tb_clkgen clkgen(
		.wb_clk_o(wb_clk),
		.wb_rst_o(wb_rst)
	);

wire altr_uart1_rx;
wire altr_uart1_tx;

	picorv32_wb_soc #(
		.SIM (1),
		.PROGADDR_RESET (32'h 0000_0000),
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_24MHz_115200.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.wb_clk (wb_clk),
		.wb_rst (wb_rst),

		.uart_rx (altr_uart1_tx),
		.uart_tx (altr_uart1_rx)
	);

endmodule
