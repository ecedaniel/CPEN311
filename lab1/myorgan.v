// myorgan module generates different clock signals based on switch inputs using clock dividers.

module myorgan(input CLK_50M, input [7:0] SW, output logic Sample_Clk_Signal, output myclock_1Hz, output myclock); 

reg [31:0] clockdiv;
				 

// This always_comb block selects the clock divider value
				 
always_comb begin

	case(SW[3:0])
		4'b0001: clockdiv = 32'hBAB9;
		4'b0011: clockdiv = 32'hA65D;
		4'b0101: clockdiv = 32'h9430;
		4'b0111: clockdiv = 32'h8BE9;
		4'b1001: clockdiv = 32'h7CB8;
		4'b1011: clockdiv = 32'h6EF9;
		4'b1101: clockdiv = 32'h62F1;
		4'b1111: clockdiv = 32'h5D5D;
		default: clockdiv = 32'h0;
	endcase
	
end

// Instantiate myclockdivider to get a output clock based on clockdiv value

myclockdivider
Generate_clk
(
.inclk(CLK_50M),
.div_clk_count(clockdiv),
.Reset(~1'h1),
.outclk(myclock),
.outclk_Not()
);  

				 
myclockdivider
Generate_1Hz_clk
(
.inclk(CLK_50M),
.div_clk_count(32'h17D_7840),
.Reset(~1'h1),
.outclk(myclock_1Hz),
.outclk_Not()
);  

assign Sample_Clk_Signal = myclock;

endmodule

