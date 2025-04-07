module temp_register (input clk, reset_n, load, increment, decrement, input [7:0] data,
output negative, positive, zero);

  reg signed [7:0] temp; 
  
//  assign negative = temp[7];
//  assign positive = ~temp[7] && (temp != 8'd0);
//  assign zero = (temp == 8'd0);

  reg neg, pos, z; 
  
  assign negative = neg;
  assign positive = pos;
  assign zero = z;
  
  always @(posedge clk) begin
    
    if(!reset_n) begin
      temp <= 8'b0;
    end else begin
    
      if(load) begin
        temp <= data; //I don't think data will be so large that signed unsigned conversion does not work
      end
      
      else if(increment) begin
        temp <= temp + 8'd1;
      end
      
      else if(decrement) begin
        temp <= temp - 8'd1;
      end
      
      if(temp < 0) begin
        neg <= 1'b1;
        pos <= 1'b0;
        z <= 1'b0;
      end 
      
      else if (temp == 0) begin
        neg <= 1'b0;
        pos <= 1'b0;
        z <= 1'b1;
      end
      
      else if (temp > 0) begin
        neg <= 1'b0;
        pos <= 1'b1;
        z <= 1'b0;
      end
      
    end
  end



endmodule
