// S_Array_Init.sv - Module for initializing S-array with s[i] = i for i = 0 to 255
// This module implements a start-to-finish protocol where it waits for a start signal,
// performs the initialization by interfacing with Memory_Interface, and then asserts
// a finish signal when complete.
// While it is busy, it will assert the busy signal.

module S_Array_Init (
    clk,
    nreset,
    start,              // Start initialization signal
    finish,            // Finish signal when initialization complete
    busy,              // Busy signal when initialization is in progress
    
    // Memory Interface connections - outputs to Memory_Interface
    // Write interface (used in this module)
    wr_start,          // Write start signal to Memory_Interface
    addr_out,    // Address output to Memory_Interface
    wr_data_out, // Write data output to Memory_Interface
    wr_done,            // Write done signal from Memory_Interface
    
    // Read interface (template for future FSMs - not used in this module)
    rd_start,          // Read start signal to Memory_Interface (unused)
    rd_done,            // Read done signal from Memory_Interface (unused)
    rd_data_in    // Read data from Memory_Interface (unused)
);

	input logic clk;
    input logic nreset;
    input logic start;              // Start initialization signal
    output logic finish;            // Finish signal when initialization complete
    output logic busy;              // Busy signal when initialization is in progress
    
    // Memory Interface connections - outputs to Memory_Interface
    // Write interface (used in this module)
    output logic wr_start;          // Write start signal to Memory_Interface
    output logic [7:0] addr_out;    // Address output to Memory_Interface
    output logic [7:0] wr_data_out; // Write data output to Memory_Interface
    input logic wr_done;            // Write done signal from Memory_Interface
    
    // Read interface (template for future FSMs - not used in this module)
    output logic rd_start;          // Read start signal to Memory_Interface (unused)
    input logic rd_done;            // Read done signal from Memory_Interface (unused)
    input logic [7:0] rd_data_in;    // Read data from Memory_Interface (unused)

    // State parameters with encoded output flags
    parameter IDLE       = 8'b0000_0000;  // No flags active
    parameter INIT_WRITE = 8'b0001_0001;  // State bit 0 set
    parameter WAIT  =      8'b0010_0001;  // State bit 1 set  
    parameter COMPLETE   = 8'b0100_0011;  // State bit 2 set, finish flag (bit 0) active

    // Internal signals
    logic [7:0] init_counter;
    logic [7:0] state;

    // Outputs directly from state encoding (minimizes glitches)
    assign finish = state[1];  // High during COMPLETE state
    assign busy = state[0];  // High during INIT_WRITE state
    
    // Read interface signals - unused in this module, just tied off
    assign rd_start = 1'b0;  // Never start a read operation
    // rd_done and rd_data_in are inputs, so they don't need to be driven
    
    // Main FSM for S-array initialization
    always_ff @(posedge clk) begin
        if (~nreset) begin
            state <= IDLE;
            init_counter <= 8'd0;
            wr_start <= 1'b0;
            addr_out <= 8'd0;
            wr_data_out <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        init_counter <= 8'd0;
                        state <= INIT_WRITE;
                        addr_out <= 8'd0;
                        wr_data_out <= 8'd0;  // s[0] = 0
                        wr_start <= 1'b1;
                    end else begin
                        state <= IDLE;
                    end
                end
                
                INIT_WRITE: begin
                    wr_start <= 1'b0;
                    state <= WAIT;
                end
                
                WAIT: begin
                    if (wr_done) begin
                        if (init_counter == 8'd255) begin
                            // Finished initializing all 256 locations
                            state <= COMPLETE;
                        end else begin
                            // Move to next location
                            init_counter <= init_counter + 8'd1;
                            addr_out <= init_counter + 8'd1;
                            wr_data_out <= init_counter + 8'd1;  // s[i] = i
                            wr_start <= 1'b1;
                            state <= INIT_WRITE;
                        end
                    end
                end
                
                COMPLETE: begin
                    state <= IDLE;
                end
                
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule 