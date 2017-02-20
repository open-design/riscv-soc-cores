`timescale 1ns / 1ps

module picorv32_wb_soc_tb;

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
		$dumpfile("picorv32-wb-soc.vcd");
		$dumpvars(0, picorv32_wb_soc_tb);
	end

	picorv32_wb_soc #(
		.BOOTROM_MEMFILE ("../src/riscv-nmon_0/nmon_picorv32-wb-soc_10MHz_9600.txt"),
		.BOOTROM_MEMDEPTH (1024)
	)
	soc(
		.clock(clk),
		.reset(reset)
	);

endmodule
