module max3000a(
	input GPIO0,
	input GPIO1,

	input UART0_TXD,
	output UART0_RXD,

	output UART1_TXD,
	input UART1_RXD,

	output UART2_TXD,
	input UART2_RXD,

	output LED1,
	output LED2,

	output I2C_SEL
	);

	wire SEL;
	assign SEL = GPIO0;

	assign LED1 = ~SEL;
	assign LED2 = SEL;

	assign UART1_TXD = ~SEL ? UART0_TXD : 1'bZ;
	assign UART2_TXD = SEL ? UART0_TXD : 1'bZ;

	assign UART0_RXD = ~SEL ? UART1_RXD : UART2_RXD;

	assign I2C_SEL = SEL;

endmodule
