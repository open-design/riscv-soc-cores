`timescale 1ns / 1ps

module vscale_wb_soc_tb;

	reg clk = 0;
	always
	begin
		#5 clk = !clk;
	end

	reg reset = 0;
	initial
	begin
		#100 reset = 1;
		#100 reset = 0;
	end

	initial
		#20000 $finish;

	initial
	begin
		$dumpfile("vscale-wb-soc.vcd");
		$dumpvars(0, vscale_wb_soc_tb);
	end

	vscale_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_vscale-wb-soc_10MHz_9600.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock(clk),
		.reset(reset)
	);

endmodule
