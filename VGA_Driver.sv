module VGA_Driver(
	input logic clk, new_data,
	input logic [9:0] x,
	input logic [8:0] y,
	input logic [8:0] heights [0:15],
	output logic [7:0] r, g, b
);
    // This module generates a VGA display with 16 rectangles of varying heights.
	// Convert FFT heights to VGA heights
	logic [8:0] vga_heights [0:15];
	
	always_ff @(posedge clk) begin
		if (new_data) begin
			// update heights for next frame when the last pixel is reached
			for (int i = 0; i < 16; i++) begin
				vga_heights[i] <= heights[i];
			end
		end
	end

    logic [15:0] on;
	genvar i;
	generate 
		for (i = 0; i < 16; i++) begin : height_check
			rectangle #(.X(i*40+2), .Y(480)) rect (
				.xin(x),
				.yin(y),
				.height(vga_heights[i]),
				.on(on[i])
			);
		end
	endgenerate

	always_comb begin
		{r, g, b} = 24'h000000; // Default to black
		case (on)
			16'd1:     {r, g, b} = 24'hFF0000;
			16'd2:     {r, g, b} = 24'hFD3500;
			16'd4:     {r, g, b} = 24'hFA4E00;
			16'd8:     {r, g, b} = 24'hF66300;
			16'd16:    {r, g, b} = 24'hEF7600;
			16'd32:    {r, g, b} = 24'hE68700;
			16'd64:    {r, g, b} = 24'hDD9500;
			16'd128:   {r, g, b} = 24'hD4A300;
			16'd256:   {r, g, b} = 24'hC9B000;
			16'd512:   {r, g, b} = 24'hBDBC00;
			16'd1024:  {r, g, b} = 24'hB0C800;
			16'd2048:  {r, g, b} = 24'hA1D300;
			16'd4096:  {r, g, b} = 24'h8FDF00;
			16'd8192:  {r, g, b} = 24'h76EA00;
			16'd16384: {r, g, b} = 24'h53F500;
			16'd32768: {r, g, b} = 24'h00FF00;
			default: {r, g, b} = 24'h000000; // Black for others
		endcase
	end

endmodule