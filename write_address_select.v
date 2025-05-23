module write_address_select (input [1:0] select, input [1:0] reg_field0, reg_field1, output reg [1:0] write_address);

  always @ (*) begin
    
    case(select)
      2'd0: write_address = 2'd0;
      2'd1: write_address = reg_field0;
      2'd2: write_address = reg_field1;
      2'd3: write_address = 2'd2;
      default: write_address = 2'd0; 
    endcase
  
  end
  
 



endmodule
