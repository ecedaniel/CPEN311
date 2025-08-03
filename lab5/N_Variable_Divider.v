module N_Variable_Divider (
    input logic clk,
    input logic rst,
    input logic [31:0] div_count,
    output logic clk_out
);
// This clk counts rising edges and outputs a divided clock that flips output (1 or 0) dependant on the half period.
// Example calculation to solve for Do div_count: 

/* Do 523 Hz */
/*
	Work:
	(50E6/523)/2 = 47801.1472 ~ 47801
	(50E6/(2*47801) = 523.0016
	div_clk_count = 32'hBAB9
*/

logic [31:0] count;
// counter reg counts to the div_count - 1 half period
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 32'b0;
    end
    else if (count >= div_count -1) begin
        count <= 32'b0;
    end
    else begin
        count <= count + 1;
    end
end

// flip-flop with comparator that inverts clock when div_count - 1 half period is reached
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        clk_out <= 1'b0;
    end
    else if (count >= div_count -1) begin
        clk_out <= ~clk_out;
    end
	// else statement is redundant, but included for clarity
    else begin
        clk_out <= clk_out;
    end
end

endmodule


/* Do 523 Hz */
/*
	Work:
	(50E6/523)/2 = 47801.1472 ~ 47801
	(50E6/(2*47801) = 523.0016
	div_clk_count = 32'hBAB9
*/

/* Re 587 Hz */
/*
	Work:
	(50E6/587)/2 = 42589.4378 ~ 42589
	(50E6/(2*42589) = 587.0060342
	div_clk_count = 32'hA999
*/

/* Mi 659 Hz */
/*
	Work:
	(50E6/659)/2 = 37936.26707 ~ 37936
	(50E6/(2*37936) = 659.0046399
	div_clk_count = 32'h9430
*/

/* Fa 698 Hz */
/*
	Work:
	(50E6/698)/2 = 35816.6189 ~ 35817
	(50E6/(2*35817) = 697.99257
	div_clk_count = 32'h8BE9
*/

/* So 783 Hz */
/*
	Work:
	(50E6/783)/2 = 31928.4802 ~ 31928
	(50E6/(2*31928) = 783.011776497
	div_clk_count = 32'h7CB8
*/

/* La 880 Hz */
/*
	Work:
	(50E6/880)/2 = 28409.0909 ~ 28409
	(50E6/(2*28409) = 880.002816
	div_clk_count = 32'h6EF9
*/

/* Si 987 Hz */
/*
	Work:
	(50E6/987)/2 = 25329.2806 ~ 25329
	(50E6/(2*25329) = 987.010936081
	div_clk_count = 32'h62F1
*/

/* Do 1046 Hz */
/*
	Work:
	(50E6/1046)/2 = 23900.5736138 ~ 23901
	(50E6/(2*23901) = 1045.98133 (23901 is a bit further off % error wise)
	div_clk_count = 32'h5D5D
*/