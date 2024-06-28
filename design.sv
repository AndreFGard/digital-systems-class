`define ZERO_ARRAY_OUT \
    out[0] <= 4'b0000; \
    out[1] <= 4'b0000; \
    out[2] <= 4'b0000; \
    out[3] <= 4'b0000; \
    out[4] <= 4'b0000; \
    out[5] <= 4'b0000; \
    out[6] <= 4'b0000; \
    out[7] <= 4'b0000;

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

//ALARM FSM
module alarm(input clk, input sens1, sens2, input rest, output reg occurence, output reg alarm_l);
  parameter QUIET = 3'b001;
  parameter OCCURRENCE = 3'b010;
  parameter ALARMING = 3'b100;
 
  reg [2:0] state; reg [2:0] toprintstate;
  always @ (posedge clk) begin
    
	case(state)
 	 
  	QUIET: begin
    	if (sens1 & sens2) begin
      	state <= ALARMING;
    	end else state <= QUIET;
   	 
  	 
     	 alarm_l <= 0;
    	occurence <= 0;
   	 
  	end
 	 
  	OCCURRENCE: begin
    	if (rest) begin
      	state <= QUIET;
    	end
    	else begin
      	if (sens1 & sens2) begin
        	state <= ALARMING;
      	end
    	end
          	 
     	 alarm_l <= 0;
    	occurence <= 1;
   	 
  	end
 	 
  	ALARMING:begin
    	if (~rest) begin
      	if (sens1 || sens2) begin
     		 state <= ALARMING;
      	end
      	else state <= OCCURRENCE;
    	end
    	else state <= QUIET;
          	 
     	 alarm_l <= 1;
    	occurence <= 1;
   	 
  	end
  	default: state <= QUIET;
	endcase
  end
endmodule

module mux_8_1(
    input [7:0][3:0] inp,
    input [2:0] sel,
    output [3:0] byebye
);

    assign byebye = (sel == 3'b000) ? inp[0] :
                    (sel == 3'b001) ? inp[1] :
                    (sel == 3'b010) ? inp[2] :
                    (sel == 3'b011) ? inp[3] :
                    (sel == 3'b100) ? inp[4] :
                    (sel == 3'b101) ? inp[5] :
                    (sel == 3'b110) ? inp[6] :
                    (sel == 3'b111) ? inp[7] :
                    4'b0000; // Default case to 0

endmodule
module clocked_mux_8_1(
    input wire clk,
    input wire [7:0][3:0] inp,
    input wire [2:0] sel,
    output reg [3:0] byebye
);

    always @(negedge clk) begin
        case (sel)
            3'b000: byebye <= inp[0];
            3'b001: byebye <= inp[1];
            3'b010: byebye <= inp[2];
            3'b011: byebye <= inp[3];
            3'b100: byebye <= inp[4];
            3'b101: byebye <= inp[5];
            3'b110: byebye <= inp[6];
            3'b111: byebye <= inp[7];
            default: byebye <= 4'b0000; // Default case to 0
        endcase
    end

endmodule






module demux_2_1(input clk,
    input [2:0] a,
    input sel,
    output reg [2:0] c1,
    output reg [2:0] c2
);

  always @(clk) begin
        case (sel)
            1'b0: begin
                c1 = a;
            end
            1'b1: begin
                c2 = a;
            end
        endcase
    end

endmodule


module summer_with_one_input(input clk, input control, input [2:0] a, output reg [3:0] c);
 
  reg [2:0] stored;
  reg [2:0] b;
 
  demux_2_1 j(clk,a,control,stored,b);
 
  always @(posedge clk) begin
    $display("%b ctrl %d stored and %d b %d sum",control, stored,b,c);
    case (control)
      1'b0: begin
        c = 13;//armazenando
      end
      1'b1:begin
        c = a + stored;
      end
    endcase
  end
endmodule






    

module demux_8_1(
    input clk,
    input [3:0] inp,
    input [2:0] sel,
    output reg [7:0][3:0] out 
);

    always @(*) begin
        //out = {4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0};

        case (sel)
            3'b000: out[0] <= inp;
            3'b001: out[1] <= inp;
            3'b010: out[2] <= inp;
            3'b011: out[3] <= inp;
            3'b100: out[4] <= inp;
            3'b101: out[5] <= inp;
            3'b110: out[6] <= inp;
            3'b111: out[7] <= inp;
        endcase
    end
endmodule

module instruction_decoder(input clk, input [7:0][3:0] inp, input [8:0] instruct, output wire  [7:0][3:0]out  );
    //the minimum delay is 3, because the circuit itself takes 3 clocks to display something

    parameter DISPLAYING = 4'h1; parameter RECEIVING = 4'h0;

    reg [3:0] chosen_in; reg [3:0] current;
    reg [7:0][3:0]buffer ;
    reg demuxclk;
    reg [3:0] counter;
    reg [3:0] demux_buffer;
    reg[3:0] toprint; reg[3:0] next;


    initial begin
         counter = 2; demuxclk = 0; 
    end

    assign out = buffer; //I've gotta figure out some way to zero 
    // out everything else but the selected slot
    // in less than 8 lines
    
    mux_8_1 mux(inp,instruct[2:0],chosen_in); //choose the input
    demux_8_1 demux(clk, toprint, instruct[5:3], buffer); //store the chosen_in in it's appropriate place
    //demux_8_1 juanmux(clk, demux_buffer, instruct[5:3], out);
    always @(posedge clk) begin
        
        $display("x|%d: chosen_in  N%d=%d, next %d toprint %d chosen_ out %d=",
        counter, instruct[2:0], chosen_in, next, toprint, instruct[5:3], buffer[instruct[5:3]]);
        
        //wait instruct[5:3] clocks before 
        case (counter)
            //counter = 0
            RECEIVING: begin
                $display("beginning");
                toprint = next;
                next = chosen_in; 
                counter = instruct[8:6];

                //out = {4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0};
                
            end
            // counter = 2
            DISPLAYING: begin 
                counter = counter - 1;
                demuxclk = 1;
            end

            default: begin 
                counter = counter -1;
                demuxclk = 0;
            end

        endcase 
    end

endmodule