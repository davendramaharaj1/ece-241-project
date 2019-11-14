
module controller(clock, update, keyboardCommand, Down, Right,plot_en, ldX, ldY, ldClr, reset, control_colour_signal,control_colour,reset_to_datapath,
						from_control, from_control_x, from_control_y);

	// Inputs
	input	clock;
	input	update, reset;
	input [7:0] keyboardCommand;

	// Bidirectionals

	// Outputs
	output Down, Right;
	output reg plot_en, ldX, ldY, ldClr, control_colour_signal,reset_to_datapath, from_control;
	output reg [2:0] control_colour;
	output reg [7:0] from_control_x;
	output reg [6:0] from_control_y;


	// Internal Registers
	reg down, right, stay;

	// State Machine Registers
	reg [3:0] current_state, next_state;
	reg [7:0] x_clr_count;
	reg [6:0] y_clr_count;
	
	localparam S_INIT_POS			=	4'd0,
				  S_UPDATE				=	4'd1,
				  S_CLEAR				=	4'd2,
				  S_UPDATE_DIR			=	4'd3,
//				  S_UPDATE_POS			=	4'd4,
				  S_PLOT					=	4'd4,
				  S_BLACK_CLEAR   	=  4'd5,
				  S_BLACK_CLEAR_INCR	=  4'd6,
				  S_BLACK_CLEAR_END	=	4'd7;
				  
	// Next state logic aka our state table
	 always@(posedge clock)
	 begin : state_table
		case (current_state)
			 S_INIT_POS				:		next_state = S_UPDATE;
			 S_UPDATE				:		next_state = update ? S_CLEAR : S_UPDATE;
			 S_CLEAR					:		next_state = S_UPDATE_DIR;
			 S_UPDATE_DIR			:		next_state = S_PLOT;
//			 S_UPDATE_POS			:		next_state = S_PLOT;
			 S_PLOT					:		next_state = S_UPDATE;
			 S_BLACK_CLEAR			:		next_state = S_BLACK_CLEAR_INCR;
			 S_BLACK_CLEAR_INCR	: 		next_state = S_BLACK_CLEAR_END;
			 S_BLACK_CLEAR_END	: 		next_state = x_clr_count >= 8'd160 ? S_INIT_POS : S_BLACK_CLEAR_INCR;
			 default					:		next_state = S_INIT_POS;
		endcase
	 end // End of State Table
	 
	 // Output logic aka all of our datapath control signals
	 always @(posedge clock)
	 begin: enable_signals
		  // By default make all our signals 0 to avoid latches.
		  ldX  = 1'b0;
		  ldY = 1'b0;
		  ldClr = 1'b0;
		  plot_en = 1'b0;
		  reset_to_datapath = 1'b0;
		  control_colour_signal = 1'b0;
		  right = 1'b0;
		  down = 1'b0;
		  stay = 1'b0;
		  control_colour = 3'b000;
		  from_control = 0;
		  from_control_x = 8'b0;
		  from_control_y = 7'b0;
		  
		  case (current_state)
				S_INIT_POS: begin
					 plot_en <= 1'b1;
					 reset_to_datapath <= 1'b1;
					 control_colour_signal <= 1'b0;
				end
				S_CLEAR: begin
					 plot_en <= 1'b1;
					 control_colour_signal <= 1'b1;
					 control_colour <= 3'b000;
				end
				S_UPDATE_DIR: begin
					 if(keyboardCommand == 8'h72)	//down
						begin
							ldY <= 1'b1;
							ldClr <= 1'b1;
							control_colour_signal <= 1'b0;
							down <= 1'b1;
						end
					 else if(keyboardCommand == 8'h75) //up
					 begin
							ldY <= 1'b1;
							ldClr <= 1'b1;
							control_colour_signal <= 1'b0;
							down <= 1'b0;
						end
					 else if(keyboardCommand == 8'h74)	//right
					 begin
							ldX <= 1'b1;
							ldClr <= 1'b1;
							control_colour_signal <= 1'b0;
							right <= 1'b1;
						end
					 else if(keyboardCommand == 8'h6B)	//left
					 begin
							ldX <= 1'b1;
							ldClr <= 1'b1;
							control_colour_signal <= 1'b0;
							right <= 1'b0;
					 end
				end
//				S_UPDATE_POS: begin 
//					ldX = 1'b1;
//					ldY = 1'b1;
//					ldClr = 1'b1;
//					end
				S_PLOT: begin 
					plot_en <= 1'b1;
				end
//				S_BLACK_RESET: begin
//					 plot_en = 1'b1;
//					 control_colour_signal = 1'b1;
//					 control_colour = 3'b000;
//				end
				S_BLACK_CLEAR: begin
					x_clr_count <= 8'd0;
					y_clr_count <= 7'd0;
				end
				S_BLACK_CLEAR_INCR: begin
					plot_en <= 1;
					from_control <= 1;
					control_colour_signal <= 1'b1;
					from_control_x <= x_clr_count;
					from_control_y <= y_clr_count;
					control_colour <= 3'b000;
					y_clr_count = y_clr_count + 1;
					if (y_clr_count >= 7'd120) begin
						y_clr_count <= 0;
						x_clr_count <= x_clr_count + 1;
					end
				end
		     // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
		  endcase
	 end // enable_signals


	// current_state registers
	always@(posedge clock)
	begin: state_FFs
	  if(~reset)
		  begin
				current_state <= S_BLACK_CLEAR;
		  end
	  else
			current_state <= next_state;
	end // state_FFS



	assign Down = down;
	assign Right = right;
 

endmodule
