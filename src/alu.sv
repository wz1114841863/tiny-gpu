`default_nettype none
`timescale 1ns/1ns

// ARITHMETIC-LOGIC UNIT
// > Executes computations on register values
// > In this minimal implementation, the ALU supports the 4 basic arithmetic operations
// > Each thread in each core has it's own ALU
// > ADD, SUB, MUL, DIV instructions are all executed here

/*
    enable: When the ALU is enabled (i.e., the thread is active)
    core_state: When the core is in the EXECUTE state (3'b101)
    decoded_alu_output_mux: When the operation is a compare operation (1)
    decoded_alu_arithmetic_mux: When the operation is an arithmetic operation (0, 1, 2, or 3)
    rs, rt: The input register values for the ALU operation
    alu_out_reg: The output register that holds the result of the ALU operation
*/
module alu (
    input wire clk,
    input wire reset,
    input wire enable, // If current block has less threads then block size, some ALUs will be inactive

    input reg [2:0] core_state,  // 101: EXECUTE state

    input reg [1:0] decoded_alu_arithmetic_mux,  // 00: ADD, 01: SUB, 10: MUL, 11: DIV
    input reg decoded_alu_output_mux,  // 0: arithmetic operation, 1: compare operation

    input reg [7:0] rs,
    input reg [7:0] rt,
    output wire [7:0] alu_out
);
    localparam ADD = 2'b00, SUB = 2'b01, MUL = 2'b10, DIV = 2'b11;

    reg [7:0] alu_out_reg;
    assign alu_out = alu_out_reg;


    always @(posedge clk) begin
        if (reset) begin
            alu_out_reg <= 8'b0;
        end else if (enable) begin
            // Calculate alu_out when core_state = EXECUTE
            if (core_state == 3'b101) begin
                if (decoded_alu_output_mux == 1) begin
                    // Set values to compare with NZP register in alu_out[2:0]
                    // 输出比较结果(负/零/正标志位), 高位补零.
                    alu_out_reg <= {5'b0, (rs - rt > 0), (rs - rt == 0), (rs - rt < 0)};
                end else begin
                    // Execute the specified arithmetic instruction
                    case (decoded_alu_arithmetic_mux)
                        ADD: begin
                            alu_out_reg <= rs + rt;
                        end
                        SUB: begin
                            alu_out_reg <= rs - rt;
                        end
                        MUL: begin
                            // 没有考虑溢出, 乘法能不能一个周期完成,取决于综合到什么平台,以及工具怎么实现它.
                            alu_out_reg <= rs * rt;
                        end
                        DIV: begin
                            // 没有考虑除零错误, 精度问题
                            alu_out_reg <= rs / rt;
                        end
                    endcase
                end
            end
        end
    end
endmodule
