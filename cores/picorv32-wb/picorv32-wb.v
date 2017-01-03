/*
 *  PicoRV32 Wishbone interface
 *
 *  Copyright (C) 2015, 2016 Antony Pavlov <antonynpavlov@gmail.com>
 *
 *  based on mips32r1_bus_if_wb32 from
 *    https://github.com/open-design/mips32r1_soc_nano/blob/master/Hardware/src/mips32r1_wb.v
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

module picorv32_wb #(
	parameter [ 0:0] ENABLE_COUNTERS = 1,
	parameter [ 0:0] ENABLE_COUNTERS64 = 1,
	parameter [ 0:0] ENABLE_REGS_16_31 = 1,
	parameter [ 0:0] ENABLE_REGS_DUALPORT = 1,
	parameter [ 0:0] TWO_STAGE_SHIFT = 1,
	parameter [ 0:0] BARREL_SHIFTER = 0,
	parameter [ 0:0] TWO_CYCLE_COMPARE = 0,
	parameter [ 0:0] TWO_CYCLE_ALU = 0,
	parameter [ 0:0] COMPRESSED_ISA = 0,
	parameter [ 0:0] CATCH_MISALIGN = 1,
	parameter [ 0:0] CATCH_ILLINSN = 1,
	parameter [ 0:0] ENABLE_PCPI = 0,
	parameter [ 0:0] ENABLE_MUL = 0,
	parameter [ 0:0] ENABLE_FAST_MUL = 0,
	parameter [ 0:0] ENABLE_DIV = 0,
	parameter [ 0:0] ENABLE_IRQ = 0,
	parameter [ 0:0] ENABLE_IRQ_QREGS = 1,
	parameter [ 0:0] ENABLE_IRQ_TIMER = 1,
	parameter [ 0:0] ENABLE_TRACE = 0,
	parameter [ 0:0] REGS_INIT_ZERO = 0,
	parameter [31:0] MASKED_IRQ = 32'h 0000_0000,
	parameter [31:0] LATCHED_IRQ = 32'h ffff_ffff,
	parameter [31:0] PROGADDR_RESET = 32'h 0000_0000,
	parameter [31:0] PROGADDR_IRQ = 32'h 0000_0010
) (
	output trap,

	// Wishbone interfaces
	input wb_rst_i,
	input wb_clk_i,

	output reg [31:0] wbm_adr_o,
	output reg [31:0] wbm_dat_o,
	input [31:0] wbm_dat_i,
	output reg wbm_we_o,
	output reg [3:0] wbm_sel_o,
	output reg wbm_stb_o,
	input wbm_ack_i,
	output reg wbm_cyc_o,

	// Pico Co-Processor Interface (PCPI)
	output        pcpi_valid,
	output [31:0] pcpi_insn,
	output [31:0] pcpi_rs1,
	output [31:0] pcpi_rs2,
	input         pcpi_wr,
	input  [31:0] pcpi_rd,
	input         pcpi_wait,
	input         pcpi_ready,

	// IRQ interface
	input  [31:0] irq,
	output [31:0] eoi,

	// Trace Interface
	output        trace_valid,
	output [35:0] trace_data
);
	wire        mem_valid;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [ 3:0] mem_wstrb;
	wire        mem_instr;
	reg         mem_ready;
	reg [31:0] mem_rdata;

	wire clk;
	wire resetn;

	assign clk = wb_clk_i;
	assign resetn = ~wb_rst_i;

	picorv32 #(
		.ENABLE_COUNTERS     (ENABLE_COUNTERS     ),
		.ENABLE_COUNTERS64   (ENABLE_COUNTERS64   ),
		.ENABLE_REGS_16_31   (ENABLE_REGS_16_31   ),
		.ENABLE_REGS_DUALPORT(ENABLE_REGS_DUALPORT),
		.TWO_STAGE_SHIFT     (TWO_STAGE_SHIFT     ),
		.BARREL_SHIFTER      (BARREL_SHIFTER      ),
		.TWO_CYCLE_COMPARE   (TWO_CYCLE_COMPARE   ),
		.TWO_CYCLE_ALU       (TWO_CYCLE_ALU       ),
		.COMPRESSED_ISA      (COMPRESSED_ISA      ),
		.CATCH_MISALIGN      (CATCH_MISALIGN      ),
		.CATCH_ILLINSN       (CATCH_ILLINSN       ),
		.ENABLE_PCPI         (ENABLE_PCPI         ),
		.ENABLE_MUL          (ENABLE_MUL          ),
		.ENABLE_FAST_MUL     (ENABLE_FAST_MUL     ),
		.ENABLE_DIV          (ENABLE_DIV          ),
		.ENABLE_IRQ          (ENABLE_IRQ          ),
		.ENABLE_IRQ_QREGS    (ENABLE_IRQ_QREGS    ),
		.ENABLE_IRQ_TIMER    (ENABLE_IRQ_TIMER    ),
		.ENABLE_TRACE        (ENABLE_TRACE        ),
		.REGS_INIT_ZERO      (REGS_INIT_ZERO      ),
		.MASKED_IRQ          (MASKED_IRQ          ),
		.LATCHED_IRQ         (LATCHED_IRQ         ),
		.PROGADDR_RESET      (PROGADDR_RESET      ),
		.PROGADDR_IRQ        (PROGADDR_IRQ        )
	) picorv32_core (
		.clk      (clk   ),
		.resetn   (resetn),
		.trap     (trap  ),

		.mem_valid(mem_valid),
		.mem_addr (mem_addr ),
		.mem_wdata(mem_wdata),
		.mem_wstrb(mem_wstrb),
		.mem_instr(mem_instr),
		.mem_ready(mem_ready),
		.mem_rdata(mem_rdata),

		.pcpi_valid(pcpi_valid),
		.pcpi_insn (pcpi_insn ),
		.pcpi_rs1  (pcpi_rs1  ),
		.pcpi_rs2  (pcpi_rs2  ),
		.pcpi_wr   (pcpi_wr   ),
		.pcpi_rd   (pcpi_rd   ),
		.pcpi_wait (pcpi_wait ),
		.pcpi_ready(pcpi_ready),

		.irq(irq),
		.eoi(eoi),

		.trace_valid(trace_valid),
		.trace_data (trace_data)
	);

	reg [1:0] state;

`define IDLE 2'b00
`define WBSTART 2'b01
`define WBEND 2'b10

	wire we;
	assign we = (mem_wstrb[0] | mem_wstrb[1] | mem_wstrb[2] | mem_wstrb[3]);

	always @(posedge wb_clk_i)
	if (wb_rst_i)
	begin
		wbm_adr_o <= 0;
		wbm_dat_o <= 0;
		wbm_we_o <= 0;
		wbm_sel_o <= 0;
		wbm_stb_o <= 0;
		wbm_cyc_o <= 0;
		state <= `IDLE;
	end
	else
	begin
		case (state)
		`IDLE:
			if (mem_valid)
			begin
				wbm_adr_o <= mem_addr;
				wbm_dat_o <= mem_wdata;
				wbm_we_o <= we;
				wbm_sel_o <= mem_wstrb;

				wbm_stb_o <= 1'b1;
				wbm_cyc_o <= 1'b1;
				state <= `WBSTART;
			end
			else
			begin
				mem_ready <= 1'b0;

				wbm_stb_o <= 1'b0;
				wbm_cyc_o <= 1'b0;
				wbm_we_o <= 1'b0;
			end
		`WBSTART:
			if (wbm_ack_i)
			begin
				mem_rdata <= wbm_dat_i;
				mem_ready <= 1'b1;

				state <= `WBEND;

				wbm_stb_o <= 1'b0;
				wbm_cyc_o <= 1'b0;
				wbm_we_o <= 1'b0;
			end

		`WBEND:
			if (!mem_valid)
			begin
				mem_ready <= 1'b0;

				state <= `IDLE;
			end

		default:
			state <= `IDLE;
		endcase
	end
endmodule
