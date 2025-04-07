module result_mux (
	input select_result,
	input [7:0] alu_result,
	output reg [7:0] result
);


  always @(*) begin
  
    case(select_result)
      1'h0: result <= alu_result;
      1'h1: result <= 8'h00;
      default: result <= 8'h00;
    endcase
    
  end


endmodule
