module DE1_SoC (CLOCK_50, CLOCK2_50,
	KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR,
    VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);

input logic CLOCK_50, CLOCK2_50;
input logic [3:0] KEY;
input logic [9:0] SW;
output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
output logic [9:0] LEDR;

// VGA Signals
output [7:0] VGA_R;
output [7:0] VGA_G;
output [7:0] VGA_B;
output VGA_BLANK_N;
output VGA_CLK;
output VGA_HS;
output VGA_SYNC_N;
output VGA_VS;

assign {HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} = '1;
assign LEDR = SW;

/////////////////////////////////////////////////////////////////////////////////
// Frequency Processing. without audio codec
/////////////////////////////////////////////////////////////////////////////////	
logic signed [8:0] data_in;
logic reset;
assign reset = ~KEY[0];

logic [9:0] x;
logic [8:0] y;
logic [7:0] r, g, b;

logic update, loaded;
assign update = (x == 639 && y == 479); // Update when the last pixel is reached

/////////////////////////////////////////////////////////////////////////////////
logic [12:0] addr;
logic [8:0] freq_buffer [0:15]; // 16x24-bit memory for frequency

load_new_heights load_heights (
	.clk(CLOCK_50),
	.reset(reset),
	.sel(SW[9:0]),
	.update(update),
	.freq_buffer(freq_buffer),
	.loaded(loaded)
);

/////////////////////////////////////////////////////////////////////////////////
// VGA Processing.
/////////////////////////////////////////////////////////////////////////////////

	// FPGA video driver instantiation
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);

	// Our VGA driver that displays FFT outputs
    VGA_Driver vga (
		.clk(CLOCK_50),
		.new_data(loaded),
		.x, .y,
		.heights(freq_buffer),
		.r, .g, .b
	);

endmodule
