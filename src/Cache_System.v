`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 01:31:34 AM
// Design Name: 
// Module Name: Cache_System
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Cache_System
#(
    parameter ADDR_WIDTH  = 32,            // Width of the address bus
              DATA_WIDTH  = 8,             // Width of the data bus
              CACHE_DEPTH = 8              // Number of cache words
)(
    input                     clk,            // Clock signal
    input                     reset,          // Reset signal (active high)
    
    input                     wr_en,          // Write enable signal for the cache
    input                     rd_en,          // Read enable signal for the cache
    input  [ADDR_WIDTH - 1:0] addr,           // Input address for cache operations
    input  [DATA_WIDTH - 1:0] w_data,         // Write data (4 words of DATA_WIDTH)
    
    output [DATA_WIDTH - 1:0] r_data,         // Read data (1 word of DATA_WIDTH)
    output                    hit             // Cache hit flag
    );
    
    // Internal wires to connect between Cache_Control and Cache_Mem
    wire [$clog2(CACHE_DEPTH) - 1:0] cache_index;   // Index to select the cache word
    
    // Instantiate the Cache_Control module
    Cache_Control #(
        .ADDR_WIDTH(ADDR_WIDTH), 
        .CACHE_DEPTH(CACHE_DEPTH)
    ) cache_control (
        .clk(clk),                  // Connect clock signal
        .reset(reset),              // Connect reset signal
        .addr(addr),                // Input address from the system
        .wr_en(wr_en),              // Write enable from the system
        .cache_index(cache_index),  // Output cache index to connect to cache memory
        .hit(hit)                   // Output cache hit flag
    );
    
    // Instantiate Cache_Mem module
    Cache_Mem #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .CACHE_DEPTH(CACHE_DEPTH)
    ) cache_mem_inst (
        .clk(clk),                          // Connect clock signal
        .reset(reset),                      // Connect reset signal
        .wr_en(wr_en),                      // Write enable signal connected to write enable input
        .rd_en(rd_en),                      // Read enable signal connected to read enable input
        .cache_index(cache_index),          // Input cache index from Cache_Control
        .data_in(w_data),                   // Input write data (1 word)
        .data_out(r_data)                   // Output read data (1 word)
    );

endmodule

