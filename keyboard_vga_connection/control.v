module control(clock, reset, key0, PS2_DAT, PS2_CLK, xOut, yOut, colour, PLOT_TO_VGA);

	input clock, reset;
	input key0;
	
	inout PS2_CLK;
	inout PS2_DAT;
	
	output [7:0] xOut;
	output [6:0] yOut;
	output [2:0] colour;
	output PLOT_TO_VGA;
	
	wire Down, Right, ldX, ldY, ldClr, control_colour_signal,reset_to_datapath;
	wire [2:0] control_colour;
	wire [7:0] ps2_key_data;
	wire ps2_key_pressed, enable, from_control;
	wire [7:0] from_control_x;
	wire [6:0] from_control_y;
	
	reg [7:0] keyboardData;
	
	PS2_Controller PS2 (
	// Inputs
		.CLOCK_50(clock),
		.reset(~key0),

		// Bidirectionals
		.PS2_CLK			(PS2_CLK),
		.PS2_DAT			(PS2_DAT),

		// Outputs
		.received_data		(ps2_key_data),
		.received_data_en	(ps2_key_pressed)
	);
	
	always @(posedge clock)
	begin
		
		if (key0 == 1'b0) //pressed KEY[0]
			keyboardData <= 8'h02;
		else if (ps2_key_pressed == 1'b1)
			keyboardData <= ps2_key_data;
	end
	
	assign enable = ps2_key_pressed == 1 ? 1 : 0;
	//assign enable = (keyboardData == 8'h72 | keyboardData == 8'h75 | keyboardData == 8'h74 | keyboardData == 8'h6B) ? 1 : 0;
	
	controller c1(.clock(clock), .update(enable), .keyboardCommand(keyboardData), .Down(Down), .Right(Right),.plot_en(PLOT_TO_VGA), .ldX(ldX), .ldY(ldY), 
					  .ldClr(ldClr), .reset(reset), .control_colour_signal(control_colour_signal),.control_colour(control_colour),.reset_to_datapath(reset_to_datapath),
					  .from_control(from_control), .from_control_x(from_control_x), .from_control_y(from_control_y));
	
	datapath d1(.clock(clock), .reset_from_controller(reset_to_datapath), .down(Down), .right(Right), .xLoc(xOut), .yLoc(yOut), .colour(colour), .ldX(ldX), 
					.ldY(ldY), .ldClr(ldClr), .control_colour_signal(control_colour_signal), .control_colour(control_colour), .from_control(from_control),
					.from_control_x(from_control_x), .from_control_y(from_control_y));
	
endmodule
v
