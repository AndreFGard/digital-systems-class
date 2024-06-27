module instruction_decoder_tester();

    reg [7:0][3:0] inp;
    reg [8:0] instruct;
    reg  [7:0][3:0]out;
    reg clk;

    instruction_decoder deco(clk, inp, instruct, out);
    initial begin
        //inp = 32'h00000000;
        //out = 32'h00000000;
        instruct = 9'b000000000;
        clk = 0;
    end

    initial begin
        forever #5 clk = ~clk; 
    end

    initial begin 
        instruct[2:0] = 4; //selecionar input
        instruct[5:3] = 6; //selecionar output
        inp[4] = 7;
        instruct[8:6] = 7;

        #70        instruct[2:0] = 4; //selecionar input
        instruct[5:3] = 6; //selecionar output
        inp[4] = 9;
        instruct[8:6] =4; 
        
         

        #70 instruct[2:0] = 4; //selecionar input
        instruct[5:3] = 3; //selecionar output
        inp[4] = 13;
        instruct[8:6] =3; 

        #120 $finish;
    end

    always @(clk) begin 

        //$display("sel_in %d, sel_out %d, inp %d, output:", instruct[2:0], instruct[5:3], inp[instruct[2:0]], out[instruct[5:3]]);
    end;

endmodule