module wb_ram
 #(
   parameter TECHNOLOGY = "GENERIC",
   //Wishbone parameters
   parameter dw = 32,
   //Memory parameters
   parameter depth = 256,
   parameter aw    = $clog2(depth),
   parameter memfile = "")
  (input 	   wb_clk_i,
   input 	   wb_rst_i,

   input [aw-1:0]  wb_adr_i,
   input [dw-1:0]  wb_dat_i,
   input [3:0] 	   wb_sel_i,
   input 	   wb_we_i,
   input [1:0] 	   wb_bte_i,
   input [2:0] 	   wb_cti_i,
   input 	   wb_cyc_i,
   input 	   wb_stb_i,

   output wb_ack_o,
   output wb_err_o,
   output [dw-1:0] wb_dat_o);

generate
if (TECHNOLOGY == "GENERIC") begin : wb_ram_generic
	wb_ram_generic #(
		.dw (dw),
		.depth (depth),
		.aw (aw),
		.memfile (memfile)
	)
	ram0 (
		.wb_clk_i (wb_clk_i),
		.wb_rst_i (wb_rst_i),

		.wb_adr_i (wb_adr_i),
		.wb_dat_i (wb_dat_i),
		.wb_sel_i (wb_sel_i),
		.wb_we_i (wb_we_i),
		.wb_bte_i (wb_bte_i),
		.wb_cti_i (wb_cti_i),
		.wb_cyc_i (wb_cyc_i),
		.wb_stb_i (wb_stb_i),

		.wb_ack_o (wb_ack_o),
		.wb_err_o (wb_err_o),
		.wb_dat_o (wb_dat_o)
	);
end else if (TECHNOLOGY == "ALTSYNCRAM") begin : wb_ram_altsyncram
	wb_ram_altsyncram #(
		.dw (dw),
		.depth (depth),
		.aw (aw),
		.memfile (memfile)
	)
	ram0 (
		.wb_clk_i (wb_clk_i),
		.wb_rst_i (wb_rst_i),

		.wb_adr_i (wb_adr_i),
		.wb_dat_i (wb_dat_i),
		.wb_sel_i (wb_sel_i),
		.wb_we_i (wb_we_i),
		.wb_bte_i (wb_bte_i),
		.wb_cti_i (wb_cti_i),
		.wb_cyc_i (wb_cyc_i),
		.wb_stb_i (wb_stb_i),

		.wb_ack_o (wb_ack_o),
		.wb_err_o (wb_err_o),
		.wb_dat_o (wb_dat_o)
	);
end
endgenerate

endmodule

module wb_ram_generic
 #(//Wishbone parameters
   parameter dw = 32,
   //Memory parameters
   parameter depth = 256,
   parameter aw    = $clog2(depth),
   parameter memfile = "")
  (input 	   wb_clk_i,
   input 	   wb_rst_i,
   
   input [aw-1:0]  wb_adr_i,
   input [dw-1:0]  wb_dat_i,
   input [3:0] 	   wb_sel_i,
   input 	   wb_we_i,
   input [1:0] 	   wb_bte_i,
   input [2:0] 	   wb_cti_i,
   input 	   wb_cyc_i,
   input 	   wb_stb_i,
   
   output reg 	   wb_ack_o,
   output 	   wb_err_o,
   output reg [dw-1:0] wb_dat_o);

   `include "wb_common.v"
   reg [aw-1:0] 	   adr_r;

   wire [aw-1:0] 	   next_adr;

   wire 		   valid = wb_cyc_i & wb_stb_i;

   reg 			   valid_r;

   reg                     is_last_r;
   always @(posedge wb_clk_i)
     is_last_r <= wb_is_last(wb_cti_i);
   wire                    new_cycle = (valid & !valid_r) | is_last_r;

   assign next_adr = wb_next_adr(adr_r, wb_cti_i, wb_bte_i, dw);

   wire [aw-1:0] 	   adr = new_cycle ? wb_adr_i : next_adr;

   always@(posedge wb_clk_i) begin
      adr_r   <= adr;
      valid_r <= valid;
      //Ack generation
      wb_ack_o <= valid & (!((wb_cti_i == 3'b000) | (wb_cti_i == 3'b111)) | !wb_ack_o);
      if(wb_rst_i) begin
	 adr_r <= {aw{1'b0}};
	 valid_r <= 1'b0;
	 wb_ack_o <= 1'b0;
      end
   end

   wire ram_we = wb_we_i & valid & wb_ack_o;

   //TODO:ck for burst address errors
   assign wb_err_o =  1'b0;
   wire [3:0] we = {4{ram_we}} & wb_sel_i;

   wire [$clog2(depth/4)-1:0] waddr = adr_r[aw-1:2];
   wire [$clog2(depth/4)-1:0] raddr = adr[aw-1:2];

   reg [31:0] 	 mem [0:depth/4-1] /* verilator public */;

   always @(posedge wb_clk_i) begin
      if (we[0]) mem[waddr][7:0]   <= wb_dat_i[7:0];
      if (we[1]) mem[waddr][15:8]  <= wb_dat_i[15:8];
      if (we[2]) mem[waddr][23:16] <= wb_dat_i[23:16];
      if (we[3]) mem[waddr][31:24] <= wb_dat_i[31:24];
      wb_dat_o <= mem[raddr];
   end

   generate
      initial
	if(memfile != "") begin
	   $display("Preloading %m from %s", memfile);
	   $readmemh(memfile, mem);
	end
   endgenerate

endmodule

module wb_ram_altsyncram
 #(//Wishbone parameters
   parameter dw = 32,
   //Memory parameters
   parameter depth = 256,
   parameter aw    = $clog2(depth / 4),
   parameter memfile = "")
  (input wb_clk_i,
   input wb_rst_i,

   input [aw-1:0]  wb_adr_i,
   input [dw-1:0]  wb_dat_i,
   input [3:0] 	   wb_sel_i,
   input 	   wb_we_i,
   input [1:0] 	   wb_bte_i,
   input [2:0] 	   wb_cti_i,
   input 	   wb_cyc_i,
   input 	   wb_stb_i,

   output reg 	   wb_ack_o,
   output 	   wb_err_o,
   output [dw-1:0] wb_dat_o);

`include "wb_common.v"

	reg [aw - 1 : 0] adr_r;

	wire [aw - 1 : 0] next_adr;

	wire valid = wb_cyc_i & wb_stb_i;

	reg valid_r;
	reg is_last_r;

	always @(posedge wb_clk_i)
		is_last_r <= wb_is_last(wb_cti_i);

	wire new_cycle = (valid & !valid_r) | is_last_r;

	assign next_adr = wb_next_adr(adr_r, wb_cti_i, wb_bte_i, dw);

	wire [aw - 1 : 0] adr = new_cycle ? wb_adr_i : next_adr;

	reg wb_ack_o_r;
	reg wb_ack_o_rr;

	always @(posedge wb_clk_i)
		if (wb_rst_i)
		begin
			adr_r <= {aw{1'b0}};
			valid_r <= 1'b0;
			wb_ack_o <= 1'b0;
			wb_ack_o_rr <= 1'b0;
			wb_ack_o_r <= 1'b0;
		end
		else
		begin
			adr_r <= adr;
			valid_r <= valid;
			// Ack generation
			wb_ack_o <= wb_ack_o_rr;
			wb_ack_o_rr <= wb_ack_o_r;
			wb_ack_o_r <= valid & (!((wb_cti_i == 3'b000) | (wb_cti_i == 3'b111)) | !wb_ack_o_r);
		end

	wire ram_we = wb_we_i & valid & wb_ack_o;

	altsyncram #(
		.operation_mode ("SINGLE_PORT"),
		.power_up_uninitialized ("FALSE"),
		.byte_size (8),
		.width_a (32),
		.numwords_a (depth / 4),
		.widthad_a (aw),
		.width_byteena_a (4),
		.clock_enable_input_a ("BYPASS"),
		.clock_enable_output_a ("BYPASS"),
		.lpm_hint ("ENABLE_RUNTIME_MOD=NO"),
		.lpm_type ("altsyncram"),
		.outdata_aclr_a ("NONE"),
		.outdata_reg_a ("CLOCK0")
	) altsyncram0 (
		.address_a (adr_r[aw - 1 : 2]),
		.byteena_a ({4{ram_we}} & wb_sel_i),
		.clock0 (wb_clk_i),
		.data_a (wb_dat_i),
		.wren_a (ram_we),
		.q_a (wb_dat_o),
		.aclr0 (1'b0),
		.aclr1 (1'b0),
		.address_b (1'b1),
		.addressstall_a (1'b0),
		.addressstall_b (1'b0),
		.byteena_b (1'b1),
		.clock1 (1'b1),
		.clocken0 (1'b1),
		.clocken1 (1'b1),
		.clocken2 (1'b1),
		.clocken3 (1'b1),
		.data_b (1'b1),
		.eccstatus (),
		.q_b (),
		.rden_a (1'b1),
		.rden_b (1'b1),
		.wren_b (1'b0)
	);

	// TODO:ck for burst address errors
	assign wb_err_o =  1'b0;

endmodule
