
module counter_m #(parameter WIDTH=5)(count,data,load,rst_,clk);
  
  output logic [WIDTH-1:0] count ; 
  input  logic [WIDTH-1:0] data ; 
  input  logic             load   ; 
  input  logic             rst_  ; 
  input  logic             clk   ;
  reg          [WIDTH-1:0] counter;
 
  timeunit        1ns ;
  timeprecision 100ps ;
  
  
  always_ff @(posedge clk or negedge rst_)  begin
    
    priority if(~rst_) begin
      counter <= 5'b0;
    end
    else if(load) begin
      counter <= data;
    end
    else begin
      counter <= counter + 5'b1;
    end
  end
  
  always_comb begin
    count <= counter;
  end
  
endmodule