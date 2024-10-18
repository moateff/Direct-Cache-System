`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 06:27:36 PM
// Design Name: 
// Module Name: Cache_Mem
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
module Cache_Mem 
#(
    parameter ADDR_WIDTH  = 32,           // Width of the address bus
              DATA_WIDTH  = 8,            // Width of the data bus (each word is 8 bits)
              CACHE_DEPTH = 8             // Depth of the cache memory (number of words in cache)
)(
    input                              clk,             // Clock signal
    input                              reset,           // Reset signal (active high)
    
    input                              wr_en,           // Write enable signal (to write data into cache)
    input                              rd_en,           // Read enable signal (to read data from cache)
    input  [$clog2(CACHE_DEPTH) - 1:0] cache_index,     // Index to select the cache word (log2 of depth to access a specific word)
    input  [DATA_WIDTH - 1:0]          data_in,         // Input data (1 word) to be written into cache
    
    output [DATA_WIDTH - 1:0]          data_out         // Output data (1 word) read from cache
    );

    // Declare the cache memory array, each word is DATA_WIDTH bits wide, and there are CACHE_DEPTH words
    reg [DATA_WIDTH - 1:0] cache_mem [0: CACHE_DEPTH - 1];
    
    integer i;  // Loop variable for reset initialization
    
    always @(negedge clk or posedge reset) 
    begin
        if (reset)  // On reset, initialize all cache memory elements to zero
        begin
            for (i = 0; i < CACHE_DEPTH; i = i + 1)  // Loop through the cache memory
                cache_mem[i] = {DATA_WIDTH{1'b0}};   // Initialize each memory element with zeros
        end
        else if (wr_en)  // If write enable is high, write data into the cache
        begin
            // Write the input data into the cache memory at the location specified by cache_index
            cache_mem[cache_index] <= data_in;
        end
    end 

    // If read enable (rd_en) is high, output the data from the cache at the specified index.
    // If rd_en is low, output high impedance ('bz) to indicate no valid data on the output.
    assign data_out = rd_en ? cache_mem[cache_index] : 'bz;

endmodule
