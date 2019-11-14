
module PS2_Demo (
	// Inputs
	CLOCK_50,
	KEY,
	LEDR,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				CLOCK_50;
input		[3:0]	KEY;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;
output		[6:0]	HEX6;
output		[6:0]	HEX7;
output reg  [9:0] LEDR;


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;

// Internal Registers
reg			[7:0]	last_data_received;
wire         [7:0] data;
reg			[3:0] pattern;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50)
begin
	
	if (KEY[0] == 1'b0) //pressed key[0]
		last_data_received <= 8'h02;
	else if (ps2_key_pressed == 1'b1)
	begin
		last_data_received <= ps2_key_data;
	end
		
end

always @(posedge CLOCK_50)
begin
	if(last_data_received == 8'h00)
		pattern <= 4'b0100;
	else if(last_data_received == 8'h02)
		pattern <= 4'b0010;
	else if(last_data_received == 8'h1C)
		pattern <= 4'b1010;
	else if(last_data_received == 8'h32)
		pattern <= 4'b1011;
	else if(last_data_received == 8'h21)
		pattern <= 4'b1100;
	else if(last_data_received == 8'h23)
		pattern <= 4'b1101;
	else if(last_data_received == 8'h24)
		pattern <= 4'b1110;
	else if(last_data_received == 8'h2B)
		pattern <= 4'b1111;	
	else
		pattern <= 4'b0000;
end

	
	
		
//	if (ps2_key_pressed == 1'b1) //beginning if 
//		begin
//			last_data_received <= ps2_key_data;
//		
//			if(last_data_received == 8'h00)
//				pattern = 4'b0000;
//			
//			if(last_data_received == 8'h1C)
//				pattern = 4'b0001;
//				
//			if(last_data_received == 8'h1B)
//				pattern = 4'b0010;
//	end //end if 


/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign HEX2 = 7'h7F;
assign HEX3 = 7'h7F;
assign HEX4 = 7'h7F;
assign HEX5 = 7'h7F;
assign HEX6 = 7'h7F;
assign HEX7 = 7'h7F;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(CLOCK_50),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

	
Hexadecimal_To_Seven_Segment Segment0 (
	// Inputs
	.hex_number			(pattern),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX0)
);

Hexadecimal_To_Seven_Segment Segment1 (
	// Inputs
	.hex_number			(pattern),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX1)
);


endmodule
