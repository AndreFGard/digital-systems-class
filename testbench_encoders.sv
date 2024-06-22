module testbench;

  reg [9:0] switch;
  wire idle;
  wire [3:0] y;
 
  onehot_bcd_encoder encod(
	.switch(switch),
	.y(y),
	.idle(idle)
  );
 
  displayer_i_guess displayeee(y, alphabet);
  reg [8:0] alphabet;
  initial begin
	switch = 0;
    

	for (int i = 0; i < 10; i = i + 1) begin
  	#10;
 	 
  	switch[i-1] = 0;
  	switch[i] = 1;
 	 
  	#10 $display("switch %0d: y = %b - %d | alphabet %b", i, switch, y, y, alphabet);
	end
    
	$finish;
  end
 
endmodule
