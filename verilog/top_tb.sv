module processing_system_tb;

logic        clk;
logic        rst_n;
logic        clear;
logic [15:0] data_a;
logic [15:0] data_b;
logic [1:0]  operation;
logic        valid_in;
logic [31:0] range_limit;

logic        valid_out;
logic [31:0] result;
logic        result_valid;
logic [15:0] count;
logic [31:0] sum;
logic [31:0] min;
logic [31:0] max;
logic [31:0] range;
logic        range_exceeded;

processing_system dut (
    .clk            (clk),
    .rst_n          (rst_n),
    .clear          (clear),
    .data_a         (data_a),
    .data_b         (data_b),
    .operation      (operation),
    .valid_in       (valid_in),
    .range_limit    (range_limit),
    .valid_out      (valid_out),
    .result         (result),
    .result_valid   (result_valid),
    .count          (count),
    .sum            (sum),
    .min            (min),
    .max            (max),
    .range          (range),
    .range_exceeded (range_exceeded)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    rst_n = 0; clear = 0; valid_in = 0;
    data_a = 0; data_b = 0; operation = 0; range_limit = 32'd100;
    repeat (3) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);

    valid_in = 1; data_a = 16'd10;   data_b = 16'd5;    operation = 2'b00;
    @(posedge clk);
    valid_in = 0; repeat (3) @(posedge clk);

    valid_in = 1; data_a = 16'd20;   data_b = 16'd3;    operation = 2'b00;
    @(posedge clk);
    valid_in = 0; repeat (3) @(posedge clk);

    valid_in = 1; data_a = 16'd100;  data_b = 16'd40;   operation = 2'b01;
    @(posedge clk);
    valid_in = 0; repeat (3) @(posedge clk);

    valid_in = 1; data_a = 16'd7;    data_b = 16'd9;    operation = 2'b11;
    @(posedge clk);
    valid_in = 0; repeat (3) @(posedge clk);

    clear = 1; @(posedge clk); clear = 0;
    repeat (3) @(posedge clk);

    valid_in = 1; data_a = 16'd200;  data_b = 16'd1;    operation = 2'b00;
    @(posedge clk);
    valid_in = 0; repeat (5) @(posedge clk);

    $finish;
end

endmodule
