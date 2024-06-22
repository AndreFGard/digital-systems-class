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

module timer(clk,reset,count, done);
  parameter trigger = 7;
  input clk,reset;
  output reg [3:0] count;
  output reg done;

  always@(posedge clk) 
  begin
    if(reset) begin 
      count <= 0;
      done <= 0;
    end
    else if (count == trigger )
        done <= 1;
    else      
      count <= count + 1;
  end
endmodule :timer


module fsm_traffic_light(input clk, input button, output reg [2:0] lights);
//dont spam the button :)
parameter SIZE = 3;
parameter GREEN = 3'b111; parameter WAITING_R = 3'b010; parameter RED = 3'b000;
reg [SIZE:-1] state;

reg resettimer; reg [3:0] _; reg timerDone;
timer eggtimer(clk,button,_, timerDone);
always @ (posedge clk) begin
    //resettimer <= !button;
    case (state)
        WAITING_R: begin
            //waiting for the light to get GREEN
            lights <= WAITING_R; //this light would actually be red

            if (timerDone) begin
                state <= GREEN;
                resettimer <= 1;
            end
            else resettimer <= 0;

            end


        RED: begin 
            //continue here until someone presses the button
            lights <= RED; 
            if (button) begin
                state <= WAITING_R;
                resettimer <= 1;
                
            end
        end

        GREEN: begin
            lights <= GREEN; 
            //the not resettimer is needed to make green last
            // instead of stopping instantaneously
            if (timerDone & ~resettimer) begin
                state <= RED;
            end
            else resettimer <= 0;
        end

        default: state <= RED;
    endcase

end
endmodule

module simple_traffic_light_fsm(input clk, input button, output reg [2:0] lights);
//dont spam the button :)
parameter SIZE = 3;
parameter GREEN = 3'b111; parameter WAITING_R = 3'b010; parameter RED = 3'b000;
reg [SIZE:-1] state;
always @ (posedge clk) begin
    case(state)
            RED: begin 
                //continue here until someone presses the button
                lights <= RED; 
                if (button) begin
                    state <= GREEN;
                end
            end

            GREEN: begin
                lights <= GREEN; 
                if (~button) begin 
                    state <= RED;
                end
            end

            default: state <= RED;
        endcase
end

endmodule

module onehot_bcd_encoder(input [9:0] switch, output [3:0] y, output idle);
	assign y = (switch == 10'b0000_0000_01) ? 4'b0000 :
          	(switch == 10'b0000_0000_10) ? 4'b0001 :
          	(switch == 10'b0000_0001_00) ? 4'b0010 :
          	(switch == 10'b0000_0010_00) ? 4'b0011 :
          	(switch == 10'b0000_0100_00) ? 4'b0100 :
          	(switch == 10'b0000_1000_00) ? 4'b0101 :
          	(switch == 10'b0001_0000_00) ? 4'b0110 :
          	(switch == 10'b0010_0000_00) ? 4'b0111 :
          	(switch == 10'b0100_0000_00) ? 4'b1000 :
          	(switch == 10'b1000_0000_00) ? 4'b1001 :
    	4'bxxxx;
endmodule

module displayer_i_guess(
  input [3:0] y,
  output [6:0] alphabet
);

  assign alphabet = (y == 4'b0000) ? 7'b1110111 :
                	(y == 4'b0001) ? 7'b0110000 :
                	(y == 4'b0010) ? 7'b1101101 :
                	(y == 4'b0011) ? 7'b1111001 :
                	(y == 4'b0100) ? 7'b0110010 :
                	(y == 4'b0101) ? 7'b1011011 :
                	(y == 4'b0110) ? 7'b1011111 :
                	(y == 4'b0111) ? 7'b1110000 :
                	(y == 4'b1000) ? 7'b1111111 :
                	(y == 4'b1001) ? 7'b1111011 :
                	7'b0000000;

endmodule
