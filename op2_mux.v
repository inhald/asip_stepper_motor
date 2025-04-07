module op2_mux (input [1:0] select, input [7:0] register, immediate,
output reg [7:0] result);

  always @(*) begin
  
    case (select) 
      2'h0: result = register;
      2'h1: result = immediate;
      2'h2: result = 8'h01;
      2'h3: result = 8'h02;
      default: result = 8'h02;
    endcase
    
  
  end
				


endmodule
