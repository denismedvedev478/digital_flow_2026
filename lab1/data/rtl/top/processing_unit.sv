module processing_unit (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        valid_in,
    input  logic [15:0] data_a,
    input  logic [15:0] data_b,
    input  logic [1:0]  operation,

    output logic        valid_out,
    output logic [31:0] result
);

integer res_nx;

always_comb begin
    unique case (operation) inside
        2'b00: res_nx = data_a + data_b;
        2'b01: res_nx = data_a - data_b;
        2'b10: res_nx = data_a ^ data_b;
        2'b11: res_nx = data_a * data_b;
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        {valid_out, result} <= '0;
    else if (valid_in) begin
        result    <= res_nx;
        valid_out <= valid_in;
    end
end

covergroup cg @(posedge clk iff rst_n);
    op  : coverpoint operation;
    vld : coverpoint valid_in;
    op_X_vld : cross op, vld;
endgroup

cg i_cg = new();

assert property ( @(posedge clk) disable iff(~rst_n)
    valid_in |-> s_eventually valid_out
);

endmodule
