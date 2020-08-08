module Adder_9(
			input logic[7:0] A,
			input logic[7:0] B,
			input logic Sub, Add,
			output logic[7:0] Sum,
			output logic X_
);

	logic c0, c1, c2, c3, c4, c5, c6, c7;
	logic [7:0] C;
	assign C = B^{8{(~Add)&Sub}};

	full_adder	FA0 (.x (A[0]), .y (C[0]), .z (Sub), .s (Sum[0]), .c (c0));
	full_adder	FA1 (.x (A[1]), .y (C[1]), .z (c0), .s (Sum[1]), .c (c1));
	full_adder	FA2 (.x (A[2]), .y (C[2]), .z (c1), .s (Sum[2]), .c (c2));
	full_adder	FA3 (.x (A[3]), .y (C[3]), .z (c2), .s (Sum[3]), .c (c3));
	full_adder	FA4 (.x (A[4]), .y (C[4]), .z (c3), .s (Sum[4]), .c (c4));
	full_adder	FA5 (.x (A[5]), .y (C[5]), .z (c4), .s (Sum[5]), .c (c5));
	full_adder	FA6 (.x (A[6]), .y (C[6]), .z (c5), .s (Sum[6]), .c (c6));
	full_adder	FA7 (.x (A[7]), .y (C[7]), .z (c6), .s (Sum[7]), .c (c7));
	full_adder	FA8 (.x (A[7]), .y (C[7]), .z (c7), .s (X_), .c ());


endmodule


module full_adder(
			input x,y,z,
			output s,c
);
	assign s = x^y^z;
	assign c = (x&y)|(y&z)|(x&z);
endmodule
