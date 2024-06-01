module tb_flipFlopD_rise;
    reg D;
    reg clk;
    wire Q;

    // Instantiate the flip-flop
    flipFlopD_rise uut (
        .D(D),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock period of 10 time units
    end

    // Test sequence
    initial begin
        // Dump waveforms
        $dumpfile("flipFlopD_rise_tb.vcd");
        $dumpvars(0, tb_flipFlopD_rise);

        // Initialize input
        D = 0;

        // Allow some time for initialization
        #10;

        // Apply test inputs
        forever @(posedge clk) begin
            D <= ~D;
        end


        // End simulation
        #20;
        $finish;
    end

    // Monitor changes to the signals
    initial begin
        $display("Time\tclk\tD\tQ");
        $monitor("%0d\t%b\t%b\t%b", $time, clk, D, Q);
    end

//stop after 30
    initial begin
        #50;  // Run the simulation for 100 time units
        $finish;
    end
endmodule

module tb_divider_2;
    reg D;
    reg clk;
    wire Q;

    // Instantiate the flip-flop
    flipFlopDivider_2 uut (
        .clk(clk),
        .out_d(Q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock period of 10 time units
    end

    // Test sequence
    initial begin
        // Dump waveforms
        $dumpfile("flipFlopD_rise_tb.vcd");
        $dumpvars(0, tb_divider_2);

        // Initialize input
        D = 0;

    end

    // Monitor changes to the signals
    initial begin
        $display("Time\tclk\tD\tQ");
        $monitor("%0d\t%b\t%b\t%b", $time, clk, D, Q);
    end

//stop after 30
    initial begin
        #20;  // Run the simulation for 100 time units
        $finish;
    end
endmodule
