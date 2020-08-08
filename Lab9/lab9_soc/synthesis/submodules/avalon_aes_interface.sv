/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

logic [31:0] Reg[15:0];
logic [31:0] data_in, mask;
assign mask =  {{8{AVL_BYTE_EN[3]}},{8{AVL_BYTE_EN[2]}},{8{AVL_BYTE_EN[1]}},{8{AVL_BYTE_EN[0]}}};
assign data_in = mask & AVL_WRITEDATA;

always_ff @(posedge CLK) begin
	if (RESET)
		Reg[15] = 32'b0;
		Reg[14] = 32'b0;
		Reg[13] = 32'b0;
		Reg[12] = 32'b0;
		Reg[11] = 32'b0;
		Reg[10] = 32'b0;
		Reg[9] = 32'b0;
		Reg[8] = 32'b0;
		Reg[7] = 32'b0;
		Reg[6] = 32'b0;
		Reg[5] = 32'b0;
		Reg[4] = 32'b0;
		Reg[3] = 32'b0;
		Reg[2] = 32'b0;
		Reg[1] = 32'b0;
		Reg[0] = 32'b0;
	if (AVL_CS && AVL_WRITE) begin	
//		case(AVL_ADDR)
//			4'b0000: Reg[0] = data_in;
//			4'b0001: Reg[1] = data_in;
//			4'b0010: Reg[2] = data_in;
//			4'b0011: Reg[3] = data_in;
//			4'b0100: Reg[4] = data_in;
//			4'b0101: Reg[5] = data_in;
//			4'b0110: Reg[6] = data_in;
//			4'b0111: Reg[7] = data_in;
//			4'b0000: Reg[8] = data_in;
//			4'b1001: Reg[9] = data_in;
//			4'b1010: Reg[10] = data_in;
//			4'b1011: Reg[11] = data_in;
//			4'b1100: Reg[12] = data_in;
//			4'b1101: Reg[13] = data_in;
//			4'b1110: Reg[14] = data_in;
//			4'b1111: Reg[15] = data_in;
//		endcase
		Reg[AVL_ADDR] <= data_in;
	end


end



always_comb begin
	AVL_READDATA = 32'b0;
	if (AVL_CS && AVL_READ) begin	
//		case(AVL_ADDR)
//			4'b0000: AVL_READDATA = Reg[0];
//			4'b0001: AVL_READDATA = Reg[1];
//			4'b0010: AVL_READDATA = Reg[2];
//			4'b0011: AVL_READDATA = Reg[3];
//			4'b0100: AVL_READDATA = Reg[4];
//			4'b0101: AVL_READDATA = Reg[5];
//			4'b0110: AVL_READDATA = Reg[6];
//			4'b0111: AVL_READDATA = Reg[7];
//			4'b0000: AVL_READDATA = Reg[8];
//			4'b1001: AVL_READDATA = Reg[9];
//			4'b1010: AVL_READDATA = Reg[10];
//			4'b1011: AVL_READDATA = Reg[11];
//			4'b1100: AVL_READDATA = Reg[12];
//			4'b1101: AVL_READDATA = Reg[13];
//			4'b1110: AVL_READDATA = Reg[14];
//			4'b1111: AVL_READDATA = Reg[15];
//		endcase
		AVL_READDATA = Reg[AVL_ADDR];
	end
end

//AES  Decryption_logic(
//			.AES_START(Reg[14][0]),
//			.AES_DONE(Reg[15][0]),
//			.AES_KEY({{Reg[0]},{Reg[1]},{Reg[2]},{Reg[3]}}),
//			.AES_MSG_ENC({{Reg[4]},{Reg[5]},{Reg[6]},{Reg[7]}}),
//			.AES_MSG_DEC({{Reg[8]},{Reg[9]},{Reg[10]},{Reg[11]}}),
//			.*
//);

assign EXPORT_DATA[31:16] = Reg[4][31:16];
assign EXPORT_DATA[15:0]  = Reg[7][15:0];

endmodule
