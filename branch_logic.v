module branch_logic (input [7:0] register0, output reg branch);

  always@(*) begin

		if (register0 == 8'b0) begin
			branch = 1'b1;
			end
		else begin
			branch = 1'b0;
		end

	end

endmodule
