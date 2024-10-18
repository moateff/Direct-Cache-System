`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 12:18:13 AM
// Design Name: 
// Module Name: DATA_MEM
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

module DATA_MEM(
    input        clk,            // Clock signal
    input        reset,          // Asynchrounus Reset signal (for initializing memory)

    input [31:0] addr,           // 32-bit input for memory address
    input [31:0] w_data,         // 32-bit input for writing data into memory
    input        wr_en,          // Write enable signal (if high, data is written to memory)
    input        rd_en,          // Read enable signal (if high, data is read from memory)

    output reg [31:0] r_data          // 32-bit output for reading data from memory
);
    
    reg [31:0] data_mem [127:0];  // Declare memory array with 64 words, each 32 bits wide
    integer i;                   // Iterator for the reset loop
    
    always @(negedge clk, posedge reset)  // Triggered on rising edge of clk or reset
    begin 
        if(reset)  // If reset is high, initialize the memory
        begin
            for (i = 0; i < 128; i = i + 1)  // Loop through all memory locations
                data_mem[i] = 32'b0;        // Set each memory location to 0
        end
        else if(wr_en)
        begin                   // If write enable is high
            data_mem[addr] = w_data;    // Write data to memory at address 'addr'
        end
    end
    
    always @(*)
    begin
        if(rd_en)
        begin
            // Delay of 2 time units (#2) to model read latency
            r_data = 'bx;
            #2 r_data = data_mem[addr];  
        end
        else
        begin
            r_data = 'bz;
        end
    end

endmodule

