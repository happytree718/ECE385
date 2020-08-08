/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

enum logic[100:0] {Wait, S_start, S_1_1, S_2_1, S_3_1, S_4_1, S_5_1, S_6_1, S_7_1, S_8_1, S_9_1, S_10_1,
S_1_2, S_2_2, S_3_2, S_4_2, S_5_2, S_6_2, S_7_2, S_8_2, S_9_2, S_10_2,
S_1_3, S_2_3, S_3_3, S_4_3, S_5_3, S_6_3, S_7_3, S_8_3, S_9_3, S_10_3,
S_1_2_2, S_2_2_2, S_3_2_2, S_4_2_2, S_5_2_2, S_6_2_2, S_7_2_2, S_8_2_2, S_9_2_2, S_10_2_2,
S_1_3_2, S_2_3_2, S_3_3_2, S_4_3_2, S_5_3_2, S_6_3_2, S_7_3_2, S_8_3_2, S_9_3_2, S_10_3_2,
S_1_4_1, S_2_4_1, S_3_4_1, S_4_4_1, S_5_4_1, S_6_4_1, S_7_4_1, S_8_4_1, S_9_4_1,
S_1_4_2, S_2_4_2, S_3_4_2, S_4_4_2, S_5_4_2, S_6_4_2, S_7_4_2, S_8_4_2, S_9_4_2,
S_1_4_3, S_2_4_3, S_3_4_3, S_4_4_3, S_5_4_3, S_6_4_3, S_7_4_3, S_8_4_3, S_9_4_3,
S_1_4_4, S_2_4_4, S_3_4_4, S_4_4_4, S_5_4_4, S_6_4_4, S_7_4_4, S_8_4_4, S_9_4_4, 
S_1_4_5, S_2_4_5, S_3_4_5, S_4_4_5, S_5_4_5, S_6_4_5, S_7_4_5, S_8_4_5, S_9_4_5, 
W1, W2, W3, W4, W5, W6, W7, W8, W9, W10, Done } State, Next_state;
logic [1407:0] KeySchedule;
logic [127:0] INT_1, INT_2, INT_3, INT_4, row_in, row_out, sub_in,sub_out, Result;
logic [31:0] col_in, col_out;
logic sub, row, col1, col2, col3, col4, copy, add1, add;

InvMixColumns	Col(
				.in(col_in),
				.out(col_out)
);

InvShiftRows	Row(
				.data_in(row_in),
				.data_out(row_out)
);

KeyExpansion	Exp(
				.clk(CLK),
				.Cipherkey(AES_KEY),
				.KeySchedule
);
genvar i;
generate 
for (i = 0; i < 16; i++) begin : generate_block_identifier
	InvSubBytes	Sub(
				.clk(CLK),
				.in(sub_in[8*i+7:8*i]),
				.out(sub_out[8*i+7:8*i])
	);
end
endgenerate

always_ff @(posedge CLK) begin
	if (RESET)
		State <= Wait;
	else
		State <= Next_state;
end


always_ff @(posedge CLK) begin
	if(col1) begin
		col_in <= INT_4[127:96];
	end
	if(col2) begin
		INT_1[127:96] <= col_out;
		col_in <= INT_4[95:64];
		
	end
	if(col3) begin
		INT_1[95:64] <= col_out;
		col_in <= INT_4[63:32];
		
	end
	if(col4) begin
		INT_1[63:32] <= col_out;
		col_in <= INT_4[31:0];
		
	end
	if(row) begin
		row_in <= INT_1;
		INT_2 <= row_out;
	end
	if(sub) begin
		sub_in <= INT_2;
		INT_3 <= sub_out;
	end		
	if(copy) begin
		INT_1[31:0] <= col_out;
	end
	if(add1) begin
		INT_1 <= AES_MSG_ENC ^ KeySchedule[127:0];
	end
end

always_comb begin
	INT_4 = 128'bX;
	case(State)
		S_9_3, S_9_3_2, S_9_4_1, S_9_4_2, S_9_4_3, S_9_4_4: 
			INT_4 <= INT_3 ^ KeySchedule[1279:1152];
		S_8_3, S_8_3_2, S_8_4_1, S_8_4_2, S_8_4_3, S_8_4_4: 
			INT_4 <= INT_3 ^ KeySchedule[1151:1024];
		S_7_3, S_7_3_2, S_7_4_1, S_7_4_2, S_7_4_3, S_7_4_4: 
			INT_4 <= INT_3 ^ KeySchedule[1023:896];
		S_6_3, S_6_3_2, S_6_4_1, S_6_4_2, S_6_4_3, S_6_4_4: 
			INT_4 <= INT_3 ^ KeySchedule[895:768];
		S_5_3, S_5_3_2, S_5_4_1, S_5_4_2, S_5_4_3, S_5_4_4: 
			INT_4 <= INT_3 ^ KeySchedule[767:640];
		S_4_3, S_4_3_2, S_4_4_1, S_4_4_2, S_4_4_3, S_4_4_4: 
			INT_4 <= INT_3 ^ KeySchedule[639:512];
		S_3_3, S_3_3_2, S_3_4_1, S_3_4_2, S_3_4_3, S_3_4_4: 
			INT_4 <= INT_3 ^ KeySchedule[511:384];
		S_2_3, S_2_3_2, S_2_4_1, S_2_4_2, S_2_4_3, S_2_4_4: 
			INT_4 <= INT_3 ^ KeySchedule[383:256];
		S_1_3, S_1_3_2, S_1_4_1, S_1_4_2, S_1_4_3, S_1_4_4: 
			INT_4 <= INT_3 ^ KeySchedule[255:128];
		S_10_3, S_10_3_2, Done:
			INT_4 <= INT_3 ^ KeySchedule[1407:1280];
		default: ;
	endcase
end

always_comb begin
	Next_state = State;
	AES_DONE = 1'b0;
	sub = 1'b0;
	row = 1'b0;
	col1 = 1'b0;
	col2 = 1'b0;
	col3 = 1'b0;
	col4 = 1'b0;
	copy = 1'b0;
	Result = 128'b0;
	add1 = 1'b0;
	add = 1'b0;
	
	unique case(State)
		Wait:	if(AES_START)
					Next_state = W1;
		W1:	Next_state = W2;
		W2:	Next_state = W3;
		W3:	Next_state = W4;
		W4:	Next_state = W5;
		W5:	Next_state = W6;
		W6:	Next_state = W7;
		W7:	Next_state = W8;
		W8:	Next_state = W9;
		W9:	Next_state = W10;
		W10:	Next_state = S_start;
		S_start:	Next_state = S_1_1;
		S_1_1:		Next_state = S_1_2;
		S_1_2:		Next_state = S_1_2_2;
		S_1_2_2:		Next_state = S_1_3;
		S_1_3:		Next_state = S_1_3_2;
		S_1_3_2:		Next_state = S_1_4_1;
		S_1_4_1:	Next_state = S_1_4_2;
		S_1_4_2:	Next_state = S_1_4_3;
		S_1_4_3:	Next_state = S_1_4_4;
		S_1_4_4:	Next_state = S_2_1;
		S_2_1:		Next_state = S_2_2;
		S_2_2:		Next_state = S_2_2_2;
		S_2_2_2:		Next_state = S_2_3;
		S_2_3:		Next_state = S_2_3_2;
		S_2_3_2:		Next_state = S_2_4_1;
		S_2_4_1:	Next_state = S_2_4_2;
		S_2_4_2:	Next_state = S_2_4_3;
		S_2_4_3:	Next_state = S_2_4_4;
		S_2_4_4:	Next_state = S_3_1;
		S_3_1:		Next_state = S_3_2;
		S_3_2:		Next_state = S_3_2_2;
		S_3_2_2:		Next_state = S_3_3;
		S_3_3:		Next_state = S_3_3_2;
		S_3_3_2:		Next_state = S_3_4_1;
		S_3_4_1:	Next_state = S_3_4_2;
		S_3_4_2:	Next_state = S_3_4_3;
		S_3_4_3:	Next_state = S_3_4_4;
		S_3_4_4:	Next_state = S_4_1;
		S_4_1:		Next_state = S_4_2;
		S_4_2:		Next_state = S_4_2_2;
		S_4_2_2:		Next_state = S_4_3;
		S_4_3:		Next_state = S_4_3_2;
		S_4_3_2:		Next_state = S_4_4_1;
		S_4_4_1:	Next_state = S_4_4_2;
		S_4_4_2:	Next_state = S_4_4_3;
		S_4_4_3:	Next_state = S_4_4_4;
		S_4_4_4:	Next_state = S_5_1;
		S_5_1:		Next_state = S_5_2;
		S_5_2:		Next_state = S_5_2_2;
		S_5_2_2:		Next_state = S_5_3;
		S_5_3:		Next_state = S_5_3_2;
		S_5_3_2:		Next_state = S_5_4_1;
		S_5_4_1:	Next_state = S_5_4_2;
		S_5_4_2:	Next_state = S_5_4_3;
		S_5_4_3:	Next_state = S_5_4_4;
		S_5_4_4:	Next_state = S_6_1;
		S_6_1:		Next_state = S_6_2;
		S_6_2:		Next_state = S_6_2_2;
		S_6_2_2:		Next_state = S_6_3;
		S_6_3:		Next_state = S_6_3_2;
		S_6_3_2:		Next_state = S_6_4_1;
		S_6_4_1:	Next_state = S_6_4_2;
		S_6_4_2:	Next_state = S_6_4_3;
		S_6_4_3:	Next_state = S_6_4_4;
		S_6_4_4:	Next_state = S_7_1;
		S_7_1:		Next_state = S_7_2;
		S_7_2:		Next_state = S_7_2_2;
		S_7_2_2:		Next_state = S_7_3;
		S_7_3:		Next_state = S_7_3_2;
		S_7_3_2:		Next_state = S_7_4_1;
		S_7_4_1:	Next_state = S_7_4_2;
		S_7_4_2:	Next_state = S_7_4_3;
		S_7_4_3:	Next_state = S_7_4_4;
		S_7_4_4:	Next_state = S_8_1;
		S_8_1:		Next_state = S_8_2;
		S_8_2:		Next_state = S_8_2_2;
		S_8_2_2:		Next_state = S_8_3;
		S_8_3:		Next_state = S_8_3_2;
		S_8_3_2:		Next_state = S_8_4_1;
		S_8_4_1:	Next_state = S_8_4_2;
		S_8_4_2:	Next_state = S_8_4_3;
		S_8_4_3:	Next_state = S_8_4_4;
		S_8_4_4:	Next_state = S_9_1;
		S_9_1:		Next_state = S_9_2;
		S_9_2:		Next_state = S_9_2_2;
		S_9_2_2:		Next_state = S_9_3;
		S_9_3:		Next_state = S_9_3_2;
		S_9_3_2:		Next_state = S_9_4_1;
		S_9_4_1:	Next_state = S_9_4_2;
		S_9_4_2:	Next_state = S_9_4_3;
		S_9_4_3:	Next_state = S_9_4_4;
		S_9_4_4:	Next_state = S_10_1;
		S_10_1:		Next_state = S_10_2;
		S_10_2:		Next_state = S_10_2_2;
		S_10_2_2:	Next_state = S_10_3;
		S_10_3:		Next_state = S_10_3_2;
		S_10_3_2:	Next_state = Done;
		Done:	if(~AES_START)
					Next_state = Wait;	
		default: ;
	endcase
	
	case(State)
		Wait:;
		S_start: 
			add1 = 1'b1;
		S_1_1, S_2_1, S_3_1, S_4_1, S_5_1, S_6_1, S_7_1, S_8_1, S_9_1, S_10_1: 
			begin
				row = 1'b1;
			end
		S_1_2, S_2_2, S_3_2, S_4_2, S_5_2, S_6_2, S_7_2, S_8_2, S_9_2, S_10_2:
			begin
				row = 1'b1;
				sub = 1'b1;				
			end
		S_1_2_2, S_2_2_2, S_3_2_2, S_4_2_2, S_5_2_2, S_6_2_2, S_7_2_2, S_8_2_2, S_9_2_2, S_10_2_2:
			begin
				add = 1'b1;
				sub = 1'b1;
			end
		S_1_3, S_2_3, S_3_3, S_4_3, S_5_3, S_6_3, S_7_3, S_8_3, S_9_3, S_10_3:
			begin 
				add = 1'b1;
				sub = 1'b1;
				col1 = 1'b1;
			end
		S_1_3_2, S_2_3_2, S_3_3_2, S_4_3_2, S_5_3_2, S_6_3_2, S_7_3_2, S_8_3_2, S_9_3_2, S_10_3_2:
			begin
				add = 1'b1;
				col1 = 1'b1;
			end
		S_1_4_1, S_2_4_1, S_3_4_1, S_4_4_1, S_5_4_1, S_6_4_1, S_7_4_1, S_8_4_1, S_9_4_1:
			begin
				col2 = 1'b1;
			end
		S_1_4_2, S_2_4_2, S_3_4_2, S_4_4_2, S_5_4_2, S_6_4_2, S_7_4_2, S_8_4_2, S_9_4_2:
			begin
				col3 = 1'b1;
			end
		S_1_4_3, S_2_4_3, S_3_4_3, S_4_4_3, S_5_4_3, S_6_4_3, S_7_4_3, S_8_4_3, S_9_4_3:
			begin
				col4 = 1'b1;
			end
		S_1_4_4, S_2_4_4, S_3_4_4, S_4_4_4, S_5_4_4, S_6_4_4, S_7_4_4, S_8_4_4, S_9_4_4:
			begin
				copy = 1'b1;
			end
		Done:
			begin
				Result = INT_4;
				AES_DONE = 1'b1;
			end
		default: ;
	endcase
end

assign AES_MSG_DEC = Result;

endmodule
