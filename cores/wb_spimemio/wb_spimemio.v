module wb_spimemio (
	input wb_clk_i,
	input wb_rst_i,

	input [23:0] wb_adr_i,
	input wb_cyc_i,
	input wb_stb_i,
	output reg [31:0] wb_dat_o,
	output reg wb_ack_o,

	output reg spi_cs,
	output reg spi_sclk,
	output reg spi_mosi,
	input spi_miso
);

	reg [31:0] buffer;
	reg [6:0] xfer_cnt;
	reg xfer_wait;

	always @(posedge wb_clk_i) begin
		wb_ack_o <= 1'b0;
		if (wb_rst_i) begin
			spi_cs <= 1;
			spi_sclk <= 1;
			xfer_cnt <= 8;
			/* 0xAB: Resume from Deep Power-down */
			buffer <= 8'hAB << 24;
			xfer_wait <= 0;
			wb_ack_o <= 1'b0;
		end else
		if (xfer_cnt) begin
			if (spi_cs) begin
				spi_cs <= 0;
			end else
			if (spi_sclk) begin
				spi_sclk <= 0;
				spi_mosi <= buffer[31];
			end else begin
				spi_sclk <= 1;
				buffer <= {buffer, spi_miso};
				xfer_cnt <= xfer_cnt - 1;
			end
		end else begin
		if (xfer_wait) begin
			wb_ack_o <= wb_stb_i & wb_cyc_i & !wb_ack_o;
			wb_dat_o <= {buffer[7:0], buffer[15:8], buffer[23:16], buffer[31:24]};
			xfer_wait <= 0;
		end else
		if (wb_stb_i & wb_cyc_i & !wb_ack_o) begin
			spi_cs <= 1;
			buffer <= {8'h 03, wb_adr_i};
			xfer_cnt <= 64;
			xfer_wait <= 1;
		end
		end

	end
endmodule
