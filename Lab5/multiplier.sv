module multiplier( 
			input logic [7:0] S,
			input logic Clk, Reset, Run, ClearA_LoadB,
			output logic [6:0] AhexU, AhexL, BhexU, BhexL,
			output logic [7:0] Aval, Bval,
			output logic X
);
		
		logic Clr_Ld, Shift, Add, Sub, M, AtoB, X_;
		logic [7:0] A,B,Sum;
		logic ResetA, LoadXA;
		
		//logic Reset, Run, ClearA_LoadB; 
		
		assign Aval = A;
		assign Bval = B;
		assign M = B[0];
		assign LoadXA = Add|Sub;
		
		reg_8 REG_A (.*, .Reset(ResetA), .Shift_In(X),
						.Load(LoadXA), .Shift_En(Shift), .D(Sum),
						.Shift_Out(AtoB), .Data_Out(A));
		
		reg_8 REG_B (.*, .Reset(!Reset), .Load(Clr_Ld), .Shift_In(AtoB), 
						.Shift_En(Shift), .D(S), .Shift_Out(), .Data_Out(B));
		X_reg  X_bit (.Reset(ResetA), .Load(LoadXA), .Clk, .D_in(X_), .D_out(X));

		
		Control		Ctrl(.*);
		
		Adder_9  Add_Sub (.*, .B(S));
		
		HexDriver        HexAL (
                        .In0(A[3:0]),
                        .Out0(AhexL) );
		HexDriver        HexBL (
                        .In0(B[3:0]),
                        .Out0(BhexL) );
		HexDriver        HexAU (
                        .In0(A[7:4]),
                        .Out0(AhexU) );	
		HexDriver        HexBU (
                       .In0(B[7:4]),
                        .Out0(BhexU) );

endmodule
