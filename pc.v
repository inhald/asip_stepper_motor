module pc (input clk, reset_n, branch, increment, input [7:0] newpc, output reg [7:0] pc);
  parameter RESET_LOCATION = 8'h00;


  always @(posedge clk) begin
    
    if (!reset_n) begin
      pc <= RESET_LOCATION;
    end
    
    else if (branch) begin
      pc <= newpc;
    end
    
    else if (increment) begin
      pc <= pc + 8'd1;
    end
  
  end


			
endmodule
