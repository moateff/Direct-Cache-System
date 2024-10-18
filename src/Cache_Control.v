`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 09:02:46 PM
// Design Name: 
// Module Name: Cache_Control
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

module Cache_Control  
#(
    parameter ADDR_WIDTH  = 32,            // Width of the address bus
              CACHE_DEPTH = 8              // Number of cache words
)(
    input                              clk,            // Clock signal
    input                              reset,          // Reset signal (active high)
    
    input  [ADDR_WIDTH - 1:0]          addr,           // Address input for cache operations
    input                              wr_en,          // Write enable signal for cache
    
    output [$clog2(CACHE_DEPTH) - 1:0] cache_index,    // Index to select the cache word
    output                             hit             // Cache hit flag
    );
    
    // Valid bits array: tracks which words are valid
    reg [0: CACHE_DEPTH - 1] valid;
    
    // Cache tags: stores the address tags for each word
    reg [ADDR_WIDTH - 1:0] cache_tags [0: CACHE_DEPTH - 1];
    
    assign cache_index = addr [$clog2(CACHE_DEPTH) - 1:0];
    
    // Cache hit logic: hit if the valid bit is set and the tags match the word address
    assign hit = (valid[cache_index] && (cache_tags[cache_index] == addr));
    
    integer i;    
    always @(negedge clk or posedge reset)
    begin
        if (reset)  // On reset, invalidate all cache blocks and clear the cache tags
        begin
            valid = 'b0;   // Invalidate all cache blocks
            for (i = 0; i < CACHE_DEPTH; i = i + 1)
                cache_tags[i] <= 'b0;  // Clear all cache tags
        end
        else if (wr_en)  // If cache write is enabled
        begin
            cache_tags[cache_index] <= addr;  // Update the cache tag for the block
            valid[cache_index] <= 1'b1;             // Mark the block as valid
        end
    end
    
endmodule
