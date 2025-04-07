module immediate_extractor (input [7:0] instruction, input [1:0] select, output reg [7:0] immediate);

  always @(*) begin
  
    case(select)
      
      2'h0: immediate = { 5'b00000 , instruction[4:2] };
      2'h1: immediate = { 4'b0000 , instruction[3:0] };
      2'h2: immediate = { {3{instruction[4]}} , instruction[4:0] };
      2'h3: immediate = 8'h00;
      
      
    endcase 
    
  end



endmodule
  