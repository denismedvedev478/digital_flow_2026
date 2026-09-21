module statistics_unit (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        clear,
    input  logic        valid_in,
    input  logic [31:0] data_in,

    output logic [15:0] count,
    output logic [31:0] sum,
    output logic [31:0] min,
    output logic [31:0] max
);

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		count <= 'd0;
		sum   <= 'd0;
		min   <= 'd0;
		max   <= 'd0; 
	end else if(clear) begin
		count <= 'd0;
		sum   <= 'd0;
		min   <= 'd0;
		max   <= 'd0;
	end else if(valid_in) begin
		count <= count + 1'd1;
		sum   <= sum + data_in;
		min   <= (data_in < min) ? data_in : min;
		max   <= (data_in > max) ? data_in : max;
	end
end

endmodule
