module statistics_unit (
    input  logic        clk,
    input  logic        rst_n,

    input  logic               clear,
    input  logic               valid_in,
    input  logic signed [31:0] data_in,

    output logic        [15:0] count,
    output logic signed [31:0] sum,
    output logic signed [31:0] min,
    output logic signed [31:0] max
);

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		count <= 'd0;
		sum   <= 'd0;
		min   <= {1'd0, {30{1'd1}}};
		max   <= -'d1; 
	end else if(clear) begin
		count <= 'd0;
		sum   <= 'd0;
		min   <= {1'd0, {30{1'd1}}};
		max   <= -'d1;
	end else if(valid_in) begin
		count <= count + 1'd1;
		sum   <= sum + data_in;
		min   <= (data_in < min) ? data_in : min;
		max   <= (data_in > max) ? data_in : max;
	end
end

endmodule
