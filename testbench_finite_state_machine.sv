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
