// Code your design here
module half_adder_s(
    input a,b,
    output sum, carry
);
 
    assign sum = a ^ b;
      assign carry = a & b;
endmodule

module full_adder(input a, b, cin, output sum, carry_out);
 
  wire f_sum,f_carry,sec_sum,sec_carry;
 
  half_adder_s aaaa(a,b,f_sum,f_carry);
 
 
  half_adder_s uuat(f_sum, cin, sec_sum,
               	sec_carry);
 
 
  assign sum = sec_sum;
  assign carry_out = f_carry | sec_carry;
endmodule

module flipFlopD_rise(input D, input clk, output reg Q);
    always @(posedge clk) begin
        Q <= D;
    end
endmodule

module flipFlopDivider_2(input clk, output out_d);
    reg k = 0;

    // Instantiate flipFlopD_rise
    flipFlopD_rise ff1 (
        .D(k),
        .clk(clk),
        .Q(out_d)
    );

    always @(posedge clk) begin
        k <= ~k; // Toggle k on every rising edge of clk
    end

endmodule

module flipFlop_counter_4b(input clk, output [3:0] bye);
    wire fpa_w, fpb_w, fpc_w, fpd_w;
    reg [3:0] stor;

    flipFlopDivider_2 fpA(
        .clk(clk),
        .out_d(fpa_w)
    );

    assign bye[0] = ~fpa_w;
    

    flipFlopDivider_2 fpB(
        .clk(fpa_w),
        .out_d(fpb_w)
    );
    assign bye[1] = ~fpb_w;

    flipFlopDivider_2 fpC(fpb_w, fpc_w);
    assign bye[2] = ~fpc_w;
    flipFlopDivider_2 fpD (fpc_w, fpd_w);
    assign bye[3] = ~fpd_w;

endmodule
