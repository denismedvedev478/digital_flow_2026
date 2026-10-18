module processing_system(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        clear,
    input  logic [15:0] data_a,
    input  logic [15:0] data_b,
    input  logic [1:0]  operation,
    input  logic        valid_in,
    input  logic [31:0] range_limit,
    output logic        valid_out,
    output logic signed [31:0] result,
    output logic        result_valid,
    output logic [15:0] count,
    output logic [31:0] sum,
    output logic [31:0] min,
    output logic [31:0] max,
    output logic [31:0] range,
    output logic        range_exceeded
);

logic valid_ps;
logic signed [31:0] result_ps;

processing_unit u_processing_unit (
    .clk       (clk),
    .rst_n     (rst_n),
    .valid_in  (valid_in),
    .data_a    (data_a),
    .data_b    (data_b),
    .operation (operation),
    .valid_out (valid_out),
    .result    (result)
);

assign result_ps = result;
assign valid_ps  = valid_out;
assign result_valid = valid_out;

statistics_unit u_statistics_unit (
    .clk      (clk),
    .rst_n    (rst_n),
    .clear    (clear),
    .valid_in (valid_ps),
    .data_in  (result_ps),
    .count    (count),
    .sum      (sum),
    .min      (min),
    .max      (max)
);

always_comb begin
    if (count == '0) begin
        range          = '0;
        range_exceeded = 1'b0;
    end else begin
        range          = max - min;
        range_exceeded = (range > range_limit) ? 1'b1 : 1'b0;
    end
end

endmodule
