// This module implements the register file

module regfile (input clk, reset_n, write, input [7:0] data, input [1:0] select0, select1, wr_select,
				output reg [7:0] selected0, selected1, output [7:0] delay, position, register0);

// The comment /* synthesis preserve */ after the declaration of a register
// prevents Quartus from optimizing it, so that it can be observed in simulation
// It is important that the comment appear before the semicolon
  reg [7:0] reg0 /* synthesis preserve */;
  reg [7:0] reg1 /* synthesis preserve */;
  reg [7:0] reg2 /* synthesis preserve */;
  reg [7:0] reg3 /* synthesis preserve */;
  
  assign register0 = reg0;
  assign position = reg2;
  assign delay = reg3;
  
  
  always @(*) begin
    
    case (select0)
      2'h0: selected0 = reg0; 
      2'h1: selected0 = reg1;
      2'h2: selected0 = reg2;
      2'h3: selected0 = reg3;
      default: selected0 = reg0;
    endcase
    
    case (select1)
      2'h0: selected1 = reg0;
      2'h1: selected1 = reg1;
      2'h2: selected1 = reg2;
      2'h3: selected1 = reg3;
      default: selected1 = reg1;
    endcase
    
  end
  
  always @(posedge clk) begin
  
    if(!reset_n) begin
      reg0 <= 8'h00;
      reg1 <= 8'h00;
      reg2 <= 8'h00;
      reg3 <= 8'h00;
    end else if (write) begin
      
      case (wr_select) 
        2'h0: reg0 <= data;
        2'h1: reg1 <= data;
        2'h2: reg2 <= data;
        2'h3: reg3 <= data;
        default: reg0 <= data;
      endcase
      
    end
  end
  
endmodule
