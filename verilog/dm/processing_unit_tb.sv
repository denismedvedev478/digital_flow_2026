module processing_unit_tb;

logic        clk;
logic        rst_n;
logic        valid_in;
logic [15:0] data_a;
logic [15:0] data_b;
logic [1:0]  operation;
logic        valid_out;
logic [31:0] result;

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

initial clk = 0;
always #5 clk = ~clk;

initial begin
    rst_n = 0; valid_in = 0; data_a = 0; data_b = 0; operation = 0;
    repeat (3) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);

    valid_in = 1; data_a = 16'd10;   data_b = 16'd5;    operation = 2'b00;
    @(posedge clk);
    valid_in = 0;
    repeat (3) @(posedge clk);

    valid_in = 1; data_a = 16'd10;   data_b = 16'd5;    operation = 2'b01;
    @(posedge clk);
    valid_in = 0;
    repeat (3) @(posedge clk);

    valid_in = 1; data_a = 16'hFF00; data_b = 16'h0FF0; operation = 2'b10;
    @(posedge clk);
    valid_in = 0;
    repeat (3) @(posedge clk);

    valid_in = 1; data_a = 16'd10;   data_b = 16'd5;    operation = 2'b11;
    @(posedge clk);
    valid_in = 0;
    repeat (5) @(posedge clk);

    $finish;
end

endmodule
