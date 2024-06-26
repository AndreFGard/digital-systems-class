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



module tb_counter_to_4;
    reg D;
    reg clk;
    wire Q;
    wire [3:0] stor; // Change stor from reg to wire

    // Instantiate the flip-flop
    flipFlop_counter_4b uut (
        .clk(clk),
        .bye(stor)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock period of 10 time units
    end

    // Monitor changes to the signals
    initial begin
        //#60
        forever #5 $display("%t   clk %b: %b", $time,clk,stor);
    end


    // Stop after x time units
    initial begin
        #150;
        $finish;
    end
endmodule



module tb_flipFlop_storage_4b;
    reg set;
    reg [3:0] origin;
    wire [3:0] dest;


    flipFlop_storage_4b uut (
        .set(set),
        .origin(origin),
        .dest(dest)
    );

    // Clock generation
    initial begin
        set = 0;
        forever #5 set = ~set;  
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        origin = 4'b0000;
        
        // Monitor changes to the signals
        $monitor("Time: %0d set: %b origin: %b dest: %b", $time, set, origin, dest);

        // Apply test vectors
        #10 origin = 4'b1010;  
        #10 origin = 4'b0101;  
        #10 origin = 4'b1111;  
        #10 origin = 4'b0000;  

        #30;  // Wait 30 time units before finishing simulation
        $finish;
    end
endmodule




module tb_flipFlop_counter_with_storage_4b;
    reg clk;
    reg save;
    wire [3:0] counter;
    wire [3:0] storage_counter;
    wire divided_clock;

    // Instantiate the flipFlop_counter_with_storage_4b module
    flipFlop_counter_with_storage_4b uut (
        .clk(clk),
        .save(save),
        .counter(counter),
        .storage_counter(storage_counter)
    );
    flipFlopDivider_2 helllll(
            .clk(clk),
            .out_d(divided_clock)
                );
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle 'clk' 
    end


    initial begin

        save = 0;

        // Initial delay  
        #800;  /
        $dumpfile("test.vcd");$dumpvars;

        


        // Monitor changes to the signals
        $monitor("Time: %0d clk: %b save: %b counter: %b storage_counter: %b", $time, divided_clock, save, counter, storage_counter);

        // Apply test vectors
        // an special delay is needed because we must make sure that save and clk are synced 
        #15 save = 1;  // Enable save after 15 time units
        #10 save = 0;  
        #10 save = 1;  
        #10 save = 0;  
        #10 save = 1;  
        #10 save = 0;  
        #10 save = 1;  
        #10 save = 0;  
        #10 save = 1;  
        #10 save = 0;  
        #10 save = 1;  
        #10 save = 0;  
        #50;  
        $finish;
    end
endmodule
