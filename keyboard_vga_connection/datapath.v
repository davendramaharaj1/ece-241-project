module datapath
	(
		clock, 
		reset_from_controller, 
		down, 
		right, 
		xLoc, 
		yLoc, 
		colour, 
		ldX, 
		ldY, 
		ldClr, 
		control_colour_signal, 
		control_colour,
		from_control,
		from_control_x,
		from_control_y
	);

	input clock, reset_from_controller, down, right, ldX, ldY, ldClr, control_colour_signal, from_control;
	input [2:0] control_colour;
	input [7:0] from_control_x;
	input [6:0] from_control_y;

	output [7:0] xLoc;
	output [6:0] yLoc;
	output [2:0] colour;

	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] c;

	always @(posedge clock)
	begin
		if (reset_from_controller) begin
			x <= 8'd0;
			y <= 7'b0;
			c <= 3'b100;
		end
		else begin
			if (ldX) begin
				if (right == 1'b1)
					x <= x + 1'b1;
				else
					x <= x - 1'b1;
			end
			if (ldY) begin
				if (down == 1'b1)
					y <= y + 1'b1;
				else
					y <= y - 1'b1;
			end
			if (ldClr)
				c <= 3'b100;
		end
	end
	
	assign xLoc = from_control ? from_control_x : x;
	assign yLoc = from_control ? from_control_y : y;
	assign colour = control_colour_signal? control_colour : c;

endmodule
