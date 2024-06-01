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

module flipFlop_counter_4b(input clk, output [3:0] stor);
    wire fpa_w, fpb_w, fpc_w, fpd_w;

    flipFlopDivider_2 fpA(
        .clk(clk),
        .out_d(fpa_w)
    );

    assign stor[0] = ~fpa_w;
    

    flipFlopDivider_2 fpB(
        .clk(fpa_w),
        .out_d(fpb_w)
    );
    assign stor[1] = ~fpb_w;

    flipFlopDivider_2 fpC(fpb_w, fpc_w);
    assign stor[2] = ~fpc_w;
    flipFlopDivider_2 fpD (fpc_w, fpd_w);
    assign stor[3] = ~fpd_w;

endmodule

module flipFlop_storage_4b(input set, input [3:0] origin, output [3:0] dest);
    flipFlopD_rise fp_A(.clk(set), .D(origin[0]), .Q(dest[0]));
    flipFlopD_rise fp_B(.clk(set), .D(origin[1]), .Q(dest[1]));
    flipFlopD_rise fp_C(.clk(set), .D(origin[2]), .Q(dest[2]));
    flipFlopD_rise fp_D(.clk(set), .D(origin[3]), .Q(dest[3]));
endmodule


module flipFlop_counter_with_storage_4b(input clk, input save,
                        output [3:0] counter, output [3:0] storage_counter);

    flipFlop_counter_4b cnt_fp(.clk(clk), .stor(counter));
    flipFlop_storage_4b storage_er(.set(save),.origin(counter),.dest(storage_counter));
endmodule


module divide_2_flipFlop_counter_with_storage_4b(input clk, input save,
                        output [3:0] counter, output [3:0] storage_counter);
    wire divided_clock;
    //please note that the storage has a delay of one clock for some reason
    flipFlopDivider_2 divider(clk, divided_clock);

    flipFlop_counter_with_storage_4b stuff(divided_clock, save, counter, storage_counter);

endmodule