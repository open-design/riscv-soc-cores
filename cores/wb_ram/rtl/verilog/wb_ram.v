// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module altsyncram_wrapper #(
	parameter INIT_FILE
)
(
	input clock,
	input [15:0] address,
	input [3:0] byteena,
	input [31:0] data,
	input wren,
	output [31:0] q
);

	altsyncram	altsyncram_component (
				.address_a (address),
				.byteena_a (byteena),
				.clock0 (clock),
				.data_a (data),
				.wren_a (wren),
				.q_a (q),
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
				.wren_b (1'b0));
	defparam
		altsyncram_component.byte_size = 8,
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.init_file = INIT_FILE,
		altsyncram_component.intended_device_family = "Cyclone V",
		altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = 65536,
		altsyncram_component.operation_mode = "SINGLE_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_reg_a = "CLOCK0",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.widthad_a = 16,
		altsyncram_component.width_a = 32,
		altsyncram_component.width_byteena_a = 4;
endmodule


module wb_ram
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
   output [dw-1:0] wb_dat_o);

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

//   wb_ram_generic
//     #(.depth(depth/4),
//       .memfile (memfile))
//   ram0
//     (.clk (wb_clk_i),
//      .we  ({4{ram_we}} & wb_sel_i),
//      .din (wb_dat_i),
//      .waddr(adr_r[aw-1:2]),
//      .raddr (adr[aw-1:2]),
//      .dout (wb_dat_o));

	wire [aw - 3:0] wrap_adr;
	assign wrap_adr = ram_we ? adr_r[aw-1:2] : adr[aw-1:2];

	altsyncram_wrapper #(
		.INIT_FILE (memfile)
	)
	ram0 (
		.clock(wb_clk_i),
		.address(wrap_adr),
		.byteena(wb_sel_i),
		.data(wb_dat_i),
		.wren(ram_we),
		.q(wb_dat_o)
	);

endmodule
