module testbench();

timeunit 10ns;

timeprecision 1ns;

logic CLK;

logic RESET, AES_START, AES_DONE;

logic [127:0] AES_KEY, AES_MSG_ENC, AES_MSG_DEC;


AES sim(.*);
	

always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

initial begin: TEST_VECTORS
RESET = 1'b0;		//reset is inactive
AES_START = 1'b0;
AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;
AES_KEY = 128'h000102030405060708090a0b0c0d0e0f;

#2 RESET = 1;//trigger Reset
#2 RESET = 0;
#2 AES_START = 1;//triger Run

#210 if(AES_MSG_DEC == 128'hece298dcece298dcece298dcece298dc)
			$display("Passed");
		else
			$display("Failed");

#2 AES_START = 0;
end
endmodule
