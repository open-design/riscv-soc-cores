module de10_nano_bus_spider(
	input FPGA_CLK1_50,

	output [14:0] HPS_DDR3_ADDR,
	output [2:0] HPS_DDR3_BA,
	output HPS_DDR3_CAS_N,
	output HPS_DDR3_CK_N,
	output HPS_DDR3_CK_P,
	output HPS_DDR3_CKE,
	output HPS_DDR3_CS_N,
	output [3:0] HPS_DDR3_DM,
	inout [31:0] HPS_DDR3_DQ,
	inout [3:0] HPS_DDR3_DQS_N,
	inout [3:0] HPS_DDR3_DQS_P,
	output HPS_DDR3_ODT,
	output HPS_DDR3_RAS_N,
	output HPS_DDR3_RESET_N,
	input HPS_DDR3_RZQ,
	output HPS_DDR3_WE_N,
	input HPS_UART_RX,
	output HPS_UART_TX,

	input [3:0] SW,
	input [1:0] KEY,
	output [7:0] LED,

	inout [35:0] GPIO_0,
	inout [35:0] GPIO_1
);

`define UEXT0_UART_TXD GPIO_0[1]
`define UEXT0_UART_RXD GPIO_0[3]

`define UEXT0_I2C_SCL  GPIO_0[9]
`define UEXT0_I2C_SDA  GPIO_0[8]

`define UEXT0_SPI_MISO GPIO_0[5]
`define UEXT0_SPI_MOSI GPIO_0[4]
`define UEXT0_SPI_SCK  GPIO_0[7]
`define UEXT0_SPI_SSEL GPIO_0[6]

`define GPIO8CON0_0 GPIO_0[11]
`define GPIO8CON0_1 GPIO_0[10]

wire [7:0] rvsoc_gpio0_o;
wire [7:0] rvsoc_gpio0_i;
wire [7:0] rvsoc_gpio0_dir_o;

wire [7:0] rvsoc_gpio1_o;
wire [7:0] rvsoc_gpio1_i;
wire [7:0] rvsoc_gpio1_dir_o;

assign `UEXT0_I2C_SCL = rvsoc_gpio0_dir_o[4] ? rvsoc_gpio0_o[4] : 1'bz;
assign `UEXT0_I2C_SDA = rvsoc_gpio0_dir_o[5] ? rvsoc_gpio0_o[5] : 1'bz;
assign rvsoc_gpio0_i[4] = `UEXT0_I2C_SCL;
assign rvsoc_gpio0_i[5] = `UEXT0_I2C_SDA;

assign `GPIO8CON0_0 = rvsoc_gpio1_dir_o[0] ? rvsoc_gpio1_o[0] : 1'bz;
assign `GPIO8CON0_1 = rvsoc_gpio1_dir_o[1] ? rvsoc_gpio1_o[1] : 1'bz;
assign rvsoc_gpio1_i[0] = `GPIO8CON0_0;
assign rvsoc_gpio1_i[1] = `GPIO8CON0_1;

wire altr_uart0_rx;
wire altr_uart0_tx;
wire altr_uart0_irq;

wire altr_uart1_rx;
wire altr_uart1_tx;
wire altr_uart1_irq;

assign `UEXT0_UART_TXD = altr_uart0_tx;
assign altr_uart0_rx = `UEXT0_UART_RXD;

wire wb_clk;
wire wb_rst;

altera_pll_wb_clkgen #(
	.INPUT_FREQUENCY ("50.0 MHz"),
	.WB_CLK_FREQUENCY ("24.0 MHz")
)
clkgen (
	.sys_clk_pad_i (FPGA_CLK1_50),
	.rst_n_pad_i (1),
	.wb_clk_o (wb_clk),
	.wb_rst_o (wb_rst)
);

wire [7:0]  pio_export;
wire [31:0] hps_0_f2h_irq0_irq;

soc_system u0 (
	.clk_clk (wb_clk),

	.reset_reset_n (1),

	.memory_mem_a (HPS_DDR3_ADDR),
	.memory_mem_ba (HPS_DDR3_BA),
	.memory_mem_ck (HPS_DDR3_CK_P),
	.memory_mem_ck_n (HPS_DDR3_CK_N),
	.memory_mem_cke (HPS_DDR3_CKE),
	.memory_mem_cs_n (HPS_DDR3_CS_N),
	.memory_mem_ras_n (HPS_DDR3_RAS_N),
	.memory_mem_cas_n (HPS_DDR3_CAS_N),
	.memory_mem_we_n (HPS_DDR3_WE_N),
	.memory_mem_reset_n (HPS_DDR3_RESET_N),
	.memory_mem_dq (HPS_DDR3_DQ),
	.memory_mem_dqs (HPS_DDR3_DQS_P),
	.memory_mem_dqs_n (HPS_DDR3_DQS_N),
	.memory_mem_odt (HPS_DDR3_ODT),
	.memory_mem_dm (HPS_DDR3_DM),
	.memory_oct_rzqin (HPS_DDR3_RZQ),

	.hps_0_hps_io_hps_io_uart0_inst_RX (HPS_UART_RX),
	.hps_0_hps_io_hps_io_uart0_inst_TX (HPS_UART_TX),

	.hps_0_f2h_irq0_irq (hps_0_f2h_irq0_irq),

	.pio_export (pio_export),

	.altr_uart0_data_rxd (altr_uart0_rx),
	.altr_uart0_data_txd (altr_uart0_tx),
	.altr_uart0_irq (altr_uart0_irq),

	.altr_uart1_data_rxd (altr_uart1_rx),
	.altr_uart1_data_txd (altr_uart1_tx),
	.altr_uart1_irq (altr_uart1_irq)
);

assign hps_0_f2h_irq0_irq[0] = altr_uart0_irq;
assign hps_0_f2h_irq0_irq[1] = altr_uart1_irq;

wire picorv32_wb_soc_reset_from_hps;

assign picorv32_wb_soc_reset_from_hps = pio_export[0];

wire wb_rst2;

assign wb_rst2 = picorv32_wb_soc_reset_from_hps | wb_rst;

picorv32_wb_soc #(
	.PROGADDR_RESET (32'h 0000_0000),

	.BOOTROM_MEMFILE ("nmon_picorv32-wb-soc_24MHz_115200.txt"),
	.BOOTROM_MEMDEPTH (1024),

	.SRAM0_MEMDEPTH (32768)
)
soc (
	.wb_clk (wb_clk),
	.wb_rst (wb_rst2),

	.uart_rx (altr_uart1_tx),
	.uart_tx (altr_uart1_rx),

	.gpio0_i (rvsoc_gpio0_i),
	.gpio0_o (rvsoc_gpio0_o),
	.gpio0_dir_o (rvsoc_gpio0_dir_o),

	.gpio1_i (rvsoc_gpio1_i),
	.gpio1_o (rvsoc_gpio1_o),
	.gpio1_dir_o (rvsoc_gpio1_dir_o)
);

assign LED[0] = picorv32_wb_soc_reset_from_hps;

endmodule
