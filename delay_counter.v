module delay_counter (input clk, reset_n, start, enable, input [7:0] delay, output reg done);
parameter BASIC_PERIOD=20'd500000;   // make 1 when testing, sim end time to 2 microseconds, clock frequency is 10ns

reg [7:0] down_count;
reg [19:0] timer;

	always@(posedge clk) begin

		if (!reset_n) begin
			timer <= 20'b0;
			down_count <= 8'b00000001;
			done <= 8'b0;
		end
		
		else if (start == 1'b1) begin
			timer <= 20'd0;
			down_count <= delay;
			done <= 0;
		end
		
		else if (enable == 1'b1) begin
			
			if (timer < BASIC_PERIOD) begin
				timer <= timer + 20'd1;
			end
			else begin
				down_count <= down_count - 8'b1;
				
				if (down_count == 0) begin
					done <= 1'b1;
				end

				timer <= 20'd0;
				
			end
			
		end
	
	end

endmodule
