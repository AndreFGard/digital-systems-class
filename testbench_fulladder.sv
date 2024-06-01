module testb_unit;

  reg [3:0] inputs;
  wire sum;
  wire carry;

  full_adder uut (inputs[2], inputs[1], inputs[0], sum, carry
  );

  initial begin
	for (inputs = 0; inputs < 8; inputs = inputs + 1) begin
  	#10
  	$display("A=%b, B=%b, cin = %b, sum = %b, carry = %b",
           	inputs[2], inputs[1], inputs[0], sum, carry);
	end
	#10
	$finish;
  end

endmodule
