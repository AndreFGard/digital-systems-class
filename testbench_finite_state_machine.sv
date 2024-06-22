module tb_traffic_light_fsm;
    // Signals
    reg clk = 0;
    reg reset, button;
    wire done;
    wire [3:0] count;
    wire [2:0] lights;

    //timer eggtimer(clk, reset, count, done);
    //instantiate fsm_traffic_light instead for the full, more complicated version
    simple_traffic_light_fsm traffic_Light(clk,button, lights );
    initial begin
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        forever begin
            #75 button = 0;
            #90 button = 1;
        end
    end

    // Monitor the signals and display them
    always @(clk) begin
        $display("%t, reset=%b, button=%b, count=%d, LIGHT: %b", $time, reset, button, count, lights);
    end

    initial begin
        #1100 $finish;
    end

endmodule

//ALARM FSM
module tb_traffic_light_fsm;
	// Signals
	reg clk = 0;
	reg reset, button;
	wire done;
	wire [3:0] count;
	wire [2:0] lights;

 
  reg start_sim = 1;
  reg occurrence; reg alarm_l; ; reg button2;
  alarm guard(clk,button,button2,reset,occurrence,alarm_l);
	initial begin
    	forever #5 clk = ~clk;
	end

	initial begin
    	reset = 0;
  	start_sim = 1;
 	 
  	#50 button = 0;
  	#50 button2 = 1; #20 start_sim=1;
 	 
  	#50 button = 1;
  	#50 button2 = 0; #20 start_sim=1;
 	 
  	#50 button = 1;
  	#50 button2 = 1;#20 start_sim=1;
 	 
  	#50 reset = 1;
  	#50 button = 1;
  	#50 button2 = 1;#20 start_sim=1;
 	 
  	$display("back to occur");
  	reset = 0;
  	#50 button = 0;
  	#50 button2 = 0; #20 start_sim=1;
 	 
  	$display("back to QUIET");
  	reset = 1;
  	#50 button = 0;
  	#50 button2 = 0; #20 start_sim=1;
	end

	// Monitor the signals and display them
    
  always @(clk) begin
  	if (1)
    	$display("%t, reset=%b, sens1=%b, sens2=%d, alarm_l: %b occur: %b", $time, reset, button, button2,
         																 alarm_l,occurrence);
	end

	initial begin
    	#1100 $finish;
	end

endmodule
