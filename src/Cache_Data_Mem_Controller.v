`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2024 01:37:01 AM
// Design Name: 
// Module Name: Cache_Data_Mem_Controller
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


module Cache_Data_Mem_Controller(
    input  [31:0] data_in,
    input  [31:0] word_from_mem,
    input  [31:0] word_from_cache,
    input         hit,
    input         read,
    input         write,
    
    output        mem_read,
    output        cache_read,
    output        cache_write,
    output [31:0] word_to_cache,
    output [31:0] data_out
    );
    
    assign mem_read = read & ~hit;
    assign cache_read = read & hit;
    assign cache_write = write | (read & ~hit);
    assign word_to_cache = read & ~hit ? word_from_mem : data_in;
    assign data_out = read & hit ? word_from_cache : word_from_mem;
         
endmodule
