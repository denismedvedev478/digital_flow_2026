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

logic flag_max, flag_max_d;
logic signed [31:0] count_;

assign  count_ = sum + data_in;
assign flag_max_d = (~data_in[31] & ~sum[31] & count_[31] ) | (data_in[31] & sum[31] & ~count_[31]);

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		flag_max <= 'd0;
		count <= 'd0;
		sum   <= 'd0;
		min   <= {1'd0, {30{1'd1}}};
		max   <= -'d1; 
	end else if(clear) begin
		flag_max <= 'd0;
		count <= 'd0;
		sum   <= 'd0;
		min   <= {1'd0, {30{1'd1}}};
		max   <= -'d1;
	end else if(valid_in&~flag_max) begin
		flag_max <= flag_max_d;
		count    <= flag_max_d ? {1'd0, {14{1'd1}}} : (count+1'd1);
		sum   <= ( flag_max_d ? ( 32'h80000000 ) : (sum + data_in) );
		min   <= (data_in < min) ? data_in : min;
		max   <= (data_in > max) ? data_in : max;
	end
end

endmodule
