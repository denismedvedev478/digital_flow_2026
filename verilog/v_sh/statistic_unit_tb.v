module tb ();

logic clk, rst, clr, v_in;
logic [31:0] data_in;


 statistics_unit DUT(
    .clk (clk),
    .rst_n (rst),

    .clear (clr),
    .valid_in (v_in),
    .data_in (data_in) //31
);

initial begin
	rst = '1;
	v_in = 0;
	clr = 0;
	
	@(posedge clk);
	
	rst = '0;

	@(posedge clk);
	
	rst = 1;

	@(posedge clk);

	v_in <= '1;
	data_in <= '1;

	@(posedge clk);
		
	v_in <= '0;

	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	v_in <= '1;
	data_in <= 31'd2;

	@(posedge clk);

	v_in <= '0;

	@(posedge clk);
	@(posedge clk);
	
	clr <= '1;	
	@(posedge clk);
	clr <= '0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	$stop();
end

initial begin
	clk = '0;

	forever begin
		clk = ~clk;#500;
	end
end


endmodule
