module mux_test();
  
  reg [7:0] inp;
  reg [2:0]sel;
  reg bye;
  mux_8_1 mux(inp,sel,	bye);
  
  initial begin
    inp = 8'b0000000;
    sel = 3'b000;
  end
  
  //bye should be 1 only when the second bit of i is 1, that is, i in {2,3,6,7}
  initial begin
    #10 sel[0] = 0;
    for (int i = 0; i<8; i = i+1) begin
      inp[i] = i[1];
      sel = i;
      #10 $display("byebye %b, i %d", bye, i);
    end
  end
  
endmodule

module summer_with_one_input_test();

  reg [3:0] c;
    reg [2:0] a;
    reg ctrl;
    reg clk;
    summer_with_one_input summer(.clk(clk), .control(ctrl), .a(a), .c(c));

    initial begin
        a = 3'b000;
        ctrl = 0;
        clk = 0;
    end

    always begin
        #5 clk = ~clk;
    end

    initial begin
        for (int i = 0; i < 8; i = i + 1) begin
          #10 $display("sum %d, a %d b ", c, a, i-1);
            a = i;
            ctrl = 0; //save a
            #5 ctrl = 1; //compute a + previous a
        end
      $finish;
    end
endmodule