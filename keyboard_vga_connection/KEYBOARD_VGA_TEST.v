module KEYBOARD_VGA_TEST
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		PS2_CLK,
		PS2_DAT,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input	CLOCK_50;				//	50 MHz
	input [1:0] KEY;
	
	inout PS2_CLK;
	inout PS2_DAT;
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire reset, key0;
	assign reset = KEY[1];
	assign key0 = KEY[0];
	wire PS2_CLK, PS2_DAT;
	
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	
	control ctrl1(.clock(CLOCK_50), .reset(reset), .key0(key0), .PS2_DAT(PS2_DAT), .PS2_CLK(PS2_CLK), .xOut(x), 
	              .yOut(y), .colour(colour), .PLOT_TO_VGA(writeEn));

		
	vga_adapter VGA2(
			.resetn(reset),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA2.RESOLUTION = "160x120";
		defparam VGA2.MONOCHROME = "FALSE";
		defparam VGA2.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA2.BACKGROUND_IMAGE = "black.mif";
	
endmodule

