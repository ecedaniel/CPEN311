module task3 (
		input logic clk, 
		input logic nreset,
		input logic start,
		input logic [7:0] data_in,
		output logic error,
		output logic finished,
		output logic [4:0] d_address
);

	parameter IDLE		   = 5'b000_00;
	parameter WAIT		   = 5'b010_00;
	parameter CHECK_DATA 	   = 5'b010_00;
	parameter INCREMENT_COUNT  = 5'b011_00;
	parameter COMPLETE	   = 5'b101_01;
  	parameter ERROR		   = 5'b100_11;

	logic [4:0] count;
	logic [4:0] state;

	assign error = state[1];
	assign finished = state[0];
	assign d_address = count;

	always_ff @(posedge clk) begin
		if (~nreset) begin
			state	<= IDLE;
		end else begin
		
		case(state)
			IDLE: begin
			if (start)
					state <= WAIT;
					count <= 5'b0;
			end
			
			WAIT: state <= CHECK_DATA;

			CHECK_DATA: begin
			if ((data_in == 8'd32) || (data_in >= 8'd97) && (data_in <= 8'd122))
				state <= INCREMENT_COUNT;
			else
				state <= ERROR;
			end
			
			INCREMENT_COUNT: begin
			if (count == 5'd31)
				state <= COMPLETE;
			else
				count <= count + 1;
				state <= WAIT;
			end
			
			ERROR: state <= IDLE;
			 
			COMPLETE: state <= IDLE;
		endcase
		end
	end

endmodule