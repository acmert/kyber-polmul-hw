
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

// This module tests INTT operation

`timescale 1ns / 1ps

module KyberHPM1PE_test_INTT();

parameter HP = 5;
parameter FP = (2*HP);

parameter PE_NUMBER=1;

reg                     clk,reset;
reg                     load_a_f,load_a_i;
reg                     load_b_f,load_b_i;
reg                     read_a,read_b;
reg                     start_ab;
reg                     start_fntt,start_pwm2,start_intt;
reg  [12*PE_NUMBER-1:0] din;
wire [12*PE_NUMBER-1:0] dout;
wire                    done;

// ---------------------------------------------------------------- CLK

always #HP clk = ~clk;

// ---------------------------------------------------------------- TXT data

reg [11:0] dina [0:255];
reg [11:0] dinb [0:255];
reg [11:0] doua	[0:255];
reg [11:0] doub	[0:255];

initial begin
	// ntt
	$readmemh("../../../../test/KYBER_DIN0_MFNTT.txt" , dina);
	$readmemh("../../../../test/KYBER_DIN1_MFNTT.txt" , dinb);
	$readmemh("../../../../test/KYBER_DIN0.txt" , doua);
	$readmemh("../../../../test/KYBER_DIN1.txt" , doub);
end

// ---------------------------------------------------------------- TEST case

integer k;
integer m;
integer e;

reg [11:0] fout[0:255];

initial begin: CLK_RESET_INIT
	// clk & reset (150 cc)
	clk       = 0;
	reset     = 0;

	#200;
	reset    = 1;
	#200;
	reset    = 0;
	#100;

	#1000;
end

initial begin: LOAD_DATA
    e          = 0;
    load_a_f   = 0;
    load_a_i   = 0;
    load_b_f   = 0;
    load_b_i   = 0;
    read_a     = 0;
    read_b     = 0;
    start_ab   = 0;
    start_fntt = 0;
    start_pwm2 = 0;
    start_intt = 0;
    din        = 0;

    #1500;

    // load input data
    load_a_i   = 1;
    #FP;
    load_a_i   = 0;

    // ---- DATA#0
    /*
    Input on txt file      : 0, 2, 1, 3, 4, 6, ...
    Input on memory (BRAMs):
    BR1 BR2
     0   2
     1   3
     4   6
    ... ...
    */
    for(k=0; k<64; k=k+PE_NUMBER) begin
        din = dina[4*k+0];
        #FP;
        din = dina[4*k+2];
        #FP;
        din = dina[4*k+1];
        #FP;
        din = dina[4*k+3];
        #FP;
    end

	#(2*FP);

    // start INTT
	start_intt = 1; start_ab = 0;
	#FP;
	start_intt = 0; start_ab = 0;
	#(2*FP);

    while(done == 1'b0) begin
        #FP;
    end

    #FP;

    // read output data
	read_a = 1;
	#FP;
	read_a = 0;
	#(2*FP);

	// Store result
    /*
    Input on txt file      : 0, 1, 2, 3, 4, 5, ...
    Input on memory (BRAMs):
    BR1 BR2
     0  128
     1  129
     2  130
    ... ...
    */
    for(m=0; m<128; m=m+PE_NUMBER) begin
        fout[m] = dout;
        #FP;
        fout[m+128] = dout;
        #FP;
    end

    #100;

	// Check result
    for(m=0; m<256; m=m+1) begin
        if(fout[m] == doua[m]) begin
			e = e+1;
        end
		else begin
			$display("Wrong result -- index:%d, expected:%d --> calculated:%d",m,doua[m],fout[m]);
		end
    end

    if(e == 256)
        $display("INTT1 -- Correct!");
    else
        $display("INTT1 -- Incorrect!");

    #(5*FP);
    e = 0;

    // load input data
    load_b_i   = 1;
    #FP;
    load_b_i   = 0;

    // ---- DATA#0
    for(k=0; k<64; k=k+PE_NUMBER) begin
        din = dinb[4*k+0];
        #FP;
        din = dinb[4*k+2];
        #FP;
        din = dinb[4*k+1];
        #FP;
        din = dinb[4*k+3];
        #FP;
    end

	#(2*FP);

    // start INTT
	start_intt = 1; start_ab = 1;
	#FP;
	start_intt = 0; start_ab = 0;
	#(2*FP);

    while(done == 1'b0) begin
        #FP;
    end

    #FP;

    // read output data
	read_b = 1;
	#FP;
	read_b = 0;
	#(2*FP);

	// Store result
    for(m=0; m<128; m=m+PE_NUMBER) begin
        fout[m] = dout;
        #FP;
        fout[m+128] = dout;
        #FP;
    end

    #100;

	// Check result
    for(m=0; m<256; m=m+1) begin
        if(fout[m] == doub[m]) begin
			e = e+1;
        end
		else begin
			$display("Wrong result -- index:%d, expected:%d --> calculated:%d",m,doua[m],fout[m]);
		end
    end

    if(e == 256)
        $display("INTT2 -- Correct!");
    else
        $display("INTT2 -- Incorrect!");

    $stop;
end

// ---------------------------------------------------------------- UUT

KyberHPM1PE uut (clk,reset,
	             load_a_f,load_a_i,
	             load_b_f,load_b_i,
	             read_a,read_b,
                 start_ab,
	             start_fntt,start_pwm2,start_intt,
	             din,
	             dout,
	             done);

endmodule
