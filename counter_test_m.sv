module counter_test_m ;

  timeunit        1ns ;
  timeprecision 100ps ;

  localparam time PERIOD = 20 ;
  localparam int  WIDTH  =  5 ;

  logic [WIDTH-1:0] count_out ; // counter count output
  logic [WIDTH-1:0] count_in  ; // counter_test count input
  logic             load      ; // counter_test load
  logic             rst_      ; // counter_test reset (asynch low)
  logic             clk       ; // counter_test clock

  // Instantiate counter
  counter_m  #(WIDTH)  counter  ( .data(count_in), .count(count_out), .* ) ;

  // Generate Clock
  initial clk = 0 ;
  always #(PERIOD/2) clk = ~clk ;

  // Monitor Results
  initial
    begin
      $timeformat ( -9, 0, "ns", 5 ) ;
      $monitor ( "%t clk=%b rst_=%b load=%b count_in=%h count_out=%h",
 	         $time,   clk,   rst_,   load,   count_in,   count_out );
      #(PERIOD * 99)
      $display ( "COUNTER TEST TIMEOUT" ) ;
      $finish ;
    end

  // Verify Results
  task xpect ( input logic [WIDTH-1:0] expects) ;
    if ( count_out !== expects )
      begin
        $display ( "count is %b and should be %b", count_out, expects ) ;
        $display ( "COUNTER TEST FAILED" ) ;
        $finish ;
      end
  endtask

  // Apply Stimulus
  initial
    begin
      @ ( negedge clk )  // synchronize
      rst_=1; load=1'bx; count_in='x; @(negedge clk)                   ;
      rst_=0; load=1'bx; count_in='x; @(negedge clk) xpect(0);
      rst_=1; load=1'b0; count_in='x; @(negedge clk) xpect(1);
      rst_=1; load=1'b0; count_in='x; @(negedge clk) xpect(2);
      rst_=1; load=1'b0; count_in='x; @(negedge clk) xpect(3);
      rst_=1; load=1'b0; count_in='x; @(negedge clk) xpect(4);
      rst_=1; load=1'b1; count_in=29; @(negedge clk) xpect(29);
      rst_=1; load=1'b0; count_in='x; @(negedge clk) xpect(30);
      rst_=1; load=1'b0; count_in='x; @(negedge clk) xpect(31);
      rst_=1; load=1'b0; count_in='x; @(negedge clk) xpect(0);
      rst_=1; load=1'b0; count_in='x; @(negedge clk) xpect(1);
      $display ( "COUNTER TEST PASSED" ) ;
      $finish ;
    end

endmodule : counter_test_m