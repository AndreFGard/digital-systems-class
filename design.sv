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

