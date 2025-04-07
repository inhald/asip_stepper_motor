module control_fsm (
	input clk, reset_n,
	// Status inputs
	input br, brz, addi, subi, sr0, srh0, clr, mov, mova, movr, movrhs, pause,
	input delay_done,
	input temp_is_positive, temp_is_negative, temp_is_zero,
	input register0_is_zero,
	// Control signal outputs
	output reg write_reg_file,
	output reg result_mux_select,
	output reg [1:0] op1_mux_select, op2_mux_select,
	output reg start_delay_counter, enable_delay_counter,
	output reg commit_branch, increment_pc,
	output reg alu_add_sub, alu_set_low, alu_set_high,
	output reg load_temp_register, increment_temp_register, decrement_temp_register,
	output reg [1:0] select_immediate,
	output reg [1:0] select_write_address
	
);
  parameter RESET=5'b00000, FETCH=5'b00001, DECODE=5'b00010,
        BR=5'b00011, BRZ=5'b00100, ADDI=5'b00101, SUBI=5'b00110, SR0=5'b00111,
        SRH0=5'b01000, CLR=5'b01001, MOV=5'b01010, MOVA=5'b01011,
        MOVR=5'b01100, MOVRHS=5'b01101, PAUSE=5'b01110, MOVR_STAGE2=5'b01111,
        MOVR_DELAY=5'b10000, MOVRHS_STAGE2=5'b10001, MOVRHS_DELAY=5'b10010,
        PAUSE_DELAY=5'b10011;

  reg [4:0] state;
  reg [4:0] next_state_logic; // NOT REALLY A REGISTER!!!
  
//  assign test = state;
 
  

// Next state logic


  always @(posedge clk) begin
    if(!reset_n) begin
      state <= RESET;
    end else begin
      state <= next_state_logic;
    end
  end
  
  
  always @(*) begin
    
    
    case(state)
      
      RESET: begin
                
                next_state_logic = FETCH;
      
      
             end
      
      FETCH: begin
                
                 next_state_logic = DECODE;
                                      
      
             end
             
      DECODE: begin

                  if(addi) begin
                    next_state_logic = ADDI;
                  end else if(subi) begin
                    next_state_logic = SUBI;
                  end else if(mov) begin
                    next_state_logic = MOV;
                  end else if(sr0) begin
                    next_state_logic = SR0;
                  end else if(srh0) begin
                    next_state_logic = SRH0;
                  end else if(clr) begin
                    next_state_logic = CLR;
                  end else if(br) begin
                    next_state_logic = BR;
                  end else if(brz) begin
                    next_state_logic = BRZ;
                  end else if(movr) begin
                    next_state_logic = MOVR;
                  end else if(movrhs) begin
                    next_state_logic = MOVRHS;
                  end else if(pause) begin
                    next_state_logic = PAUSE;
                  end
      
              end 
      
      ADDI: begin
              next_state_logic = FETCH;
            end
      
      SUBI: begin
              next_state_logic = FETCH;
            end
            
      MOV: begin
              next_state_logic = FETCH;
           end
      SR0: begin
              next_state_logic = FETCH;
           end
      SRH0: begin
              next_state_logic = FETCH;
            end
      CLR: begin
              next_state_logic = FETCH;
           end
      BR: begin
              next_state_logic = FETCH;
          end
      BRZ: begin
              next_state_logic = FETCH;
           end
      MOVR: begin
              next_state_logic = MOVR_STAGE2;
            end
      MOVR_STAGE2: begin
                      if(temp_is_zero) begin
                        next_state_logic = FETCH;
                      end else begin
                        next_state_logic = MOVR_DELAY;
                      end
                   end
      MOVR_DELAY: begin
                    if(delay_done) begin
                      next_state_logic = MOVR_STAGE2;
                    end else begin
                      next_state_logic = MOVR_DELAY;
                    end
                  end
      MOVRHS: begin
                next_state_logic = MOVRHS_STAGE2;
              end
      MOVRHS_STAGE2: begin
                      if(temp_is_zero) begin
                        next_state_logic = FETCH;
                      end else begin
                        next_state_logic = MOVRHS_DELAY;
                      end
                     end
      MOVRHS_DELAY: begin
                      if(delay_done) begin
                        next_state_logic = MOVRHS_STAGE2;
                      end else begin
                        next_state_logic = MOVRHS_DELAY;
                      end
                    end
      PAUSE: begin
      
                next_state_logic = PAUSE_DELAY;
              
             end
      PAUSE_DELAY: begin
                      if(delay_done) begin
                          next_state_logic = FETCH;
                      end else begin
                          next_state_logic = PAUSE_DELAY;
                      end
                   end
      default: next_state_logic = RESET;
    
    endcase
  end
  
  
// State register
//  always @(*) begin
//  
//  
//  end


// Output logic
  always @(*) begin
    alu_set_low = 1'b0;
    alu_set_high = 1'b0; 
    alu_add_sub = 1'b0;
    
    commit_branch = 1'b0;
    increment_pc = 1'b0;
    
    load_temp_register = 1'b0;
    increment_temp_register = 1'b0;
    decrement_temp_register = 1'b0;
    
    start_delay_counter = 1'b0;
    enable_delay_counter = 1'b0;
    
    write_reg_file = 1'b0;
    
    op1_mux_select = 2'b00;
    op2_mux_select = 2'b00;
    select_immediate = 2'b11;
    result_mux_select = 1'b1;
    select_write_address = 2'b00;
    
    
    
  
  
    case(state)
    
    /* Reset handles itself within modules */
      
      ADDI: begin
      
              increment_pc = 1;
              
              
              op1_mux_select = 2'b01;
              op2_mux_select = 2'b01;
              select_immediate = 2'b00;
              alu_add_sub = 1'b0;
              
              result_mux_select = 1'b0;
              select_write_address = 2'b01;
              write_reg_file = 1;
            
            end
            
      SUBI: begin
      
              increment_pc = 1'b1;
              
              op1_mux_select = 2'b01;
              op2_mux_select = 2'b01;
              
              select_immediate = 2'b00;
              alu_add_sub = 1'b1;
              
              result_mux_select = 1'b0;
              select_write_address = 2'b01;
              write_reg_file = 1;
              
            
            
            end
            
      CLR: begin
              increment_pc = 1;
              
              
              select_write_address = 2'b01; //selecting reg_field0 
              write_reg_file = 1; // writing
              result_mux_select = 1'b1; //selecting 0
           end
      
      BR: begin
              select_immediate = 2'b10; //sign extend immediate from 5 - 8 bits
              op1_mux_select = 2'b00; // pc
              op2_mux_select = 2'b01; //immediate
              alu_add_sub = 1'b0;
              
              commit_branch = 1'b1; //pc -> newpc
              /*Unsure if the signed addition works correctly in alu 
              nvm it does because extended properly*/
      
      
           end
           
      BRZ: begin
            
            if(register0_is_zero) begin
              
              select_immediate = 2'b10; //sign extend 5-bit immediate to 8-bits
            
              op1_mux_select = 2'b00; //pc
              op2_mux_select = 2'b01; //8-bit immediate
              
              alu_add_sub = 1'b0;
              
              commit_branch = 1'b1;
              
            end else begin
              increment_pc = 1;
            end
     
           end
           
       SR0: begin
              
              increment_pc = 1'b1;
              
              select_immediate = 2'b01; //4-bit immediate
              
              op1_mux_select = 2'b11; //register0
              op2_mux_select = 2'b01; //8-bit extended immediate
              
              
              alu_set_low = 1'b1; //alu product result
              
              select_write_address = 2'b00; //selecting register0
              write_reg_file = 1; //writing
              result_mux_select = 1'b0; // alu result
                     
            end
            
            
        SRH0: begin
        
                increment_pc = 1;
                
                select_immediate = 2'b01;
                
                op1_mux_select = 2'b11; //register0
                op2_mux_select = 2'b01; //8-bit extended immediate
                
                alu_set_high = 1'b1; //alu product result
                
                
                select_write_address = 2'b00; //selecting register0
                write_reg_file = 1; //writing
                result_mux_select = 1'b0; //alu result
        
              end
              
         MOV: begin
              
              /* Move contents of register from source to destination */
              
                increment_pc = 1;
                select_immediate = 2'b11; // 0
                op1_mux_select = 2'b01; //register
                op2_mux_select = 2'b01; //immediate
                
                alu_add_sub = 1'b0;
                
                result_mux_select = 1'b0;
                select_write_address = 2'b10;
                write_reg_file = 1'b1;
             
              end
         
         MOVR: begin
               
               /* Move the motor by a number of full steps specified in the register
               
               the number is signed and after each step wait for amount in delay register */
               
               
                load_temp_register = 1;
               
               end
               
  MOVR_STAGE2: begin
                  
                  if(temp_is_zero) begin
                    increment_pc = 1'b1;
                  end else begin
                  
                    start_delay_counter = 1'b1;
                    
                    if(temp_is_positive) begin
                      decrement_temp_register = 1'b1;
                      
                      /* RF[2] <- RF[2] + 2 */
                      
                      op1_mux_select = 2'b10;
                      op2_mux_select = 2'b11;
                      
                      alu_add_sub = 1'b0;
                      
                      result_mux_select = 1'b0;
                      select_write_address = 2'b11;
                      write_reg_file = 1'b1;
                   end else begin
                      increment_temp_register = 1'b1;
                      
                      /* RF[2] <- RF[2] -2 */
                      
                      op1_mux_select = 2'b10;
                      op2_mux_select = 2'b11;
                      
                      alu_add_sub = 1'b1;   
                      
                      result_mux_select = 1'b0;
                      select_write_address = 2'b11;
                      write_reg_file = 1'b1;
                
                   end
                   
                end   
                      
             end
             
     MOVR_DELAY: begin
                  enable_delay_counter = 1'b1;
                 end
                 
     MOVRHS: begin
              load_temp_register = 1;
             end
     MOVRHS_STAGE2: begin
                      if(temp_is_zero) begin
                        increment_pc = 1'b1;
                      end else begin
                        
                        if(temp_is_positive) begin
                          decrement_temp_register = 1'b1;
                          
                          /* RF[2] <- RF[2] + 1 */
                          
                          op1_mux_select = 2'b10;
                          op2_mux_select = 2'b10;
                          
                          alu_add_sub = 1'b0;
                          
                          result_mux_select = 1'b0;
                          select_write_address = 2'b11;
                          write_reg_file = 1'b1;
                         end else begin
                          increment_temp_register = 1'b1;
                          
                          /* RF[2] <- RF[2] - 1 */
                          
                          op1_mux_select = 2'b10;
                          op2_mux_select = 2'b10;
                          
                          alu_add_sub = 1'b1;
                          result_mux_select = 1'b0;
                          select_write_address = 2'b11;
                          write_reg_file = 1'b1;
                        
                        end
                        start_delay_counter = 1'b1;
                       
                       end
                   
                     end  
                     
       MOVRHS_DELAY: begin
                      enable_delay_counter = 1'b1;
                     end
                     
       PAUSE: begin
                start_delay_counter = 1'b1;
              end
              
       PAUSE_DELAY: begin
                      
                      enable_delay_counter = 1'b1;
                      
                      if(delay_done) begin
                        increment_pc = 1;
                      end
                      
                    end
       default: result_mux_select = 1'b1;
             
    endcase
  
  end


endmodule
