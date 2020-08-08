module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	
	
	logic PG0,PG1,PG2,PG3,GG0,GG1,GG2,GG3,C_4,C_8,C_12;
	
	CLA_4 unit0(.A(A[3:0]), .B(B[3:0]), .S(Sum[3:0]), .C0(1'b0), .PG(PG0), .GG(GG0));
	CLA_4 unit1(.A(A[7:4]), .B(B[7:4]), .S(Sum[7:4]), .C0(C_4), .PG(PG1), .GG(GG1));
	CLA_4 unit2(.A(A[11:8]), .B(B[11:8]), .S(Sum[11:8]), .C0(C_8), .PG(PG2), .GG(GG2));
	CLA_4 unit3(.A(A[15:12]), .B(B[15:12]), .S(Sum[15:12]), .C0(C_12), .PG(PG3), .GG(GG3));
	CL_unit CL(.P0(PG0), .P1(PG1), .P2(PG2), .P3(PG3), .C0(1'b0),
					.G0(GG0), .G1(GG1), .G2(GG2), .G3(GG3), 
					.C1(C_4), .C2(C_8), .C3(C_12), .C4(CO));
	
endmodule

module CL_unit(input P0,P1,P2,P3,C0,
		input G0,G1,G2,G3,
		output PG,GG,
		output C1,C2,C3,C4);
			
		assign PG = P0&P1&P2&P3;
		assign GG = G3|(G2&P3)|(G1&P3&P2)|(G0&P3&P2&P1);
		assign C1 = (C0&P0)|G0;
		assign C2 = (C0&P0&P1)|(G0&P1)|G1;
		assign C3 = (C0&P0&P1&P2)|(G0&P1&P2)|(G1&P2)|G2;
		assign C4 = (C3&P3)|G3;
			
endmodule	

module full_pg_adder(input x,y,z,
			output s,p,g);
		
			assign p = x^y;
			assign g = x&y;
			assign s = x^y^z;
	
endmodule

module CLA_4(
		input 	logic[3:0]		A,
		input 	logic[3:0]		B,
		input		logic				C0,
		output 	logic[3:0]		S,
		output	logic				PG,
		output	logic				GG);
		
		logic P0,G0,C1,P1,G1,C2,P2,G2,C3,P3,G3,C4;
		
		full_pg_adder FPA0(.x(A[0]), .y(B[0]), .z(C0), .s(S[0]), .p(P0), .g(G0));
		full_pg_adder FPA1(.x(A[1]), .y(B[1]), .z(C1), .s(S[1]), .p(P1), .g(G1));
		full_pg_adder FPA2(.x(A[2]), .y(B[2]), .z(C2), .s(S[2]), .p(P2), .g(G2));
		full_pg_adder FPA3(.x(A[3]), .y(B[3]), .z(C3), .s(S[3]), .p(P3), .g(G3));
		CL_unit lookforward(.*);
		
endmodule 