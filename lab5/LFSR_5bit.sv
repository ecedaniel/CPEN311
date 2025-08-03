module LFSR_5bit (
    input logic clk,
    input logic rst,
    output logic [4:0] lfsr
);

logic [4:0] lfsr_out = 5'b00001;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 5'b00001;
        end
        else begin
            lfsr_out <= {lfsr[2] ^ lfsr[0], lfsr[4:1]}; // new MSB and shhift 5:1 to 4:1
        end
    end
assign lfsr = lfsr_out;
endmodule

