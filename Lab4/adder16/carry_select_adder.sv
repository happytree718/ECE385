module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic c4, c8, c12;
	  four_bit_CRA fbcra1 (.A (A[3:0]), .B (B[3:0]), .c (1'd0), .Sum (Sum[3:0]), .CO (c4));
	  high_four_bit_CSA fcsa0 (.A (A[7:4]), .B (B[7:4]), .c (c4), .Sum (Sum[7:4]), .CO (c8));
	  high_four_bit_CSA fcsa1 (.A (A[11:8]), .B (B[11:8]), .c (c8), .Sum (Sum[11:8]), .CO (c12));
	  high_four_bit_CSA fcsa2 (.A (A[15:12]), .B (B[15:12]), .c (c12), .Sum (Sum[15:12]), .CO (CO));
     
endmodule

module two_one_mux(input logic[3:0] A, 
						 input logic[3:0] B, 
						 input logic select, 
						 output logic[3:0] Dout);
	always_comb
	begin
		case (select)
			1'b0  :	Dout = A;
			default	:	Dout = B;
		endcase
	end
endmodule

module four_bit_CRA(
	 input   logic[3:0]     A,
    input   logic[3:0]     B,
	 input	logic 			c,
    output  logic[3:0]     Sum,
    output  logic          CO);
	 
	 logic c0, c1, c2;
	 full_adder	fa0 (.x (A[0]), .y (B[0]), .z (c), .s (Sum[0]), .c (c0));
	 full_adder	fa1 (.x (A[1]), .y (B[1]), .z (c0), .s (Sum[1]), .c (c1));
	 full_adder	fa2 (.x (A[2]), .y (B[2]), .z (c1), .s (Sum[2]), .c (c2));
	 full_adder	fa3 (.x (A[3]), .y (B[3]), .z (c2), .s (Sum[3]), .c (CO));
	 
endmodule

// used for high bits of 16 bit CSA excluding 0-3 bits
module high_four_bit_CSA(
	 input   logic[3:0]     A,
    input   logic[3:0]     B,
	 input	logic				c,
	 output  logic[3:0]     Sum,
    output  logic          CO);
	 
	 logic c1, c0;
	 logic[3:0]	sum1, sum0;
	 four_bit_CRA fbCA0 (.A, .B, .c (1'b0), .Sum (sum0), .CO (c0));
	 four_bit_CRA fbCA1 (.A, .B, .c (1'b1), .Sum (sum1), .CO (c1));
	 two_one_mux  mx0 (.A (sum0), .B (sum1), .select (c), .Dout(Sum));
	 assign CO = (c & c1) | c0;
	 
endmodule
