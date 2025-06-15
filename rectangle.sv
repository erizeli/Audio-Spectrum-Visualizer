module rectangle #(X=0, Y=480) (
  input logic [9:0] xin,
  input logic [8:0] yin, height,
  output logic on
);

	// This module checks if the given coordinates are within the rectangle defined by (X, Y) and (X + WIDTH, Y + HEIGHT).
	// X and Y are the bottom-left corner of the rectangle.
	// WIDTH is a local parameter that defines the width of the rectangle.
	// The height is passed as an input parameter.

	// Leave 4 pixels between bars
	// X values to instantiate:
	// 2, 42, 82, 122, 162, 202, 242, 282, 322, 362, 402, 442, 482, 522, 562, 602

    localparam int WIDTH = 36; // Width of the rectangle

    assign on = (xin >= X && xin < X + WIDTH) && (yin >= (Y - height) || height > Y);
endmodule