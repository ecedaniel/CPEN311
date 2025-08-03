module Fast_Clk1_To_Slow_Clk2(
    input logic clk1,
    input logic rst,
    input logic clk2,
    input logic [11:0] data_in,
    output logic [11:0] data_out
);

logic [11:0] reg1_out;
logic [11:0] reg2_out;
logic [11:0] reg3_out;
logic small_reg1_out;
logic small_reg2_out;

assign data_out = reg3_out;

flipflop #(.WIDTH(12)) Reg1 (
    .clk(clk1),
    .reset(rst),
    .D(data_in),
    .Q(reg1_out)
);

flipflop_w_enable #(.WIDTH(12)) Reg2 (
    .clk(clk1),
    .reset(rst),
    .enable(small_reg2_out),
    .D(data_in),
    .Q(reg2_out)
);

flipflop #(.WIDTH(12)) Reg3 (
    .clk(clk2),
    .reset(rst),
    .D(data_in),
    .Q(reg3_out)
);

flipflop #(.WIDTH(1)) small_reg1 (
    .clk(~clk1),
    .reset(rst),
    .D(clk2),
    .Q(small_reg1_out)
);

flipflop #(.WIDTH(1)) small_reg2 (
    .clk(~clk1),
    .reset(rst),
    .D(small_reg1_out),
    .Q(small_reg2_out)
);

endmodule

module flipflop #(
    parameter WIDTH = 1
)(
    input logic clk,
    input logic reset,
    input logic [WIDTH-1:0] D,
    output logic [WIDTH-1:0] Q
);
    always_ff @(posedge clk) begin
        if (reset) begin
            Q <= {WIDTH{1'b0}};
        end
        else begin
            Q <= D;
        end 
    end
endmodule

module flipflop_w_enable #(
    parameter WIDTH = 1
)(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [WIDTH-1:0] D,
    output logic [WIDTH-1:0] Q
);
    always_ff @(posedge clk) begin
        if (reset) begin
            Q <= {WIDTH{1'b0}};
        end
        else if (enable) begin
            Q <= D;
        end
        else begin
            Q <= Q;
        end
    end
endmodule