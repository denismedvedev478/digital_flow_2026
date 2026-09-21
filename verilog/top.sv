module top(
    input  logic       clk, 
    input  logic       rst_n,
    input  logic       clear,
    input  logic[15:0] data_a,
    input  logic[15:0] data_b,
    input  logic[1:0]  operation,
    input  logic       valid_in,
    output logic       valid_out,
    output logic[31:0] result,
    output logic       result_valid,
    output logic[15:0] count,
    output logic[31:0] sum,
    output logic[31:0] max,
    output logic[31:0] min,
    output logic[31:0] range,
    output logic       range_exceeded
    )


logic valid_ps;
logic[31:0] result_ps;


processing_unit dut (
    .clk       (clk),
    .rst_n     (rst_n),
    .valid_in  (valid_in),
    .data_a    (data_a),
    .data_b    (data_b),
    .operation (operation),
    .valid_out (valid_out),
    .result    (result)
);

statistics_unit DUT(
    .clk (clk),
    .rst_n (rst_n),

    .clear (clr),
    .valid_in (valid_ps),
    .data_in (result_ps) //31
);

statistics_unit u_statistics_unit (
    .clk      (clk),
    .rst_n    (rst_n),
    .clear    (clear),
    .valid_in (valid_in),
    .data_in  (data_in),
    .count    (count),
    .sum      (sum),
    .min      (min),
    .max      (max)
);
endmodule
