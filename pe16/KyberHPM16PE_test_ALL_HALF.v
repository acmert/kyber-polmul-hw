
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

// This module tests half polynomial multiplication
// -1st polynomial in POLY domain, 2nd polynomial in NTT domain

`timescale 1ns / 1ps

module KyberHPM16PE_test_ALL_HALF();

parameter HP = 5;
parameter FP = (2*HP);

parameter PE_NUMBER=16;

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

initial begin
	// ntt
	$readmemh("../../../../test_pe16/KYBER_DIN0.txt" , dina);
	$readmemh("../../../../test_pe16/KYBER_DIN1_MFNTT.txt" , dinb);
	$readmemh("../../../../test_pe16/KYBER_DOUT.txt" , doua);
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

initial begin: LOAD_TEST_DATA
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
    load_a_f   = 1;
    #FP;
    load_a_f   = 0;

    // ---- DATA#0
    /*
    Input on txt file      : 0, 1, 2, 3, 4, 5, ...
    Input on memory (BRAMs):
    BR1 BR2 BR3 BR4 BR5 BR6 BR7 BR8 .... BR29 BR30 BR31 BR32
     0  128  1  129  2  130  3  131 ....  14   142  15   143
     16 144  17 145  18 146  19 147 ....  30   158  31   159
    ... ...
    */
    for(k=0; k<256; k=k+PE_NUMBER) begin
        din = {dina[k+0],
               dina[k+1],
               dina[k+2],
               dina[k+3],
               dina[k+4],
               dina[k+5],
               dina[k+6],
               dina[k+7],
               dina[k+8],
               dina[k+9],
               dina[k+10],
               dina[k+11],
               dina[k+12],
               dina[k+13],
               dina[k+14],
               dina[k+15]};
        #FP;
    end

	#(2*FP);

	// load input data
    load_b_i   = 1;
    #FP;
    load_b_i   = 0;

    // ---- DATA#1
    /*
    Input on txt file      : 0, 2, 1, 3, 4, 6, ...
    Input on memory (BRAMs):
    BR1 BR2 BR3 BR4 BR5 BR6 BR7 BR8 .... BR29 BR30 BR31 BR32
     0   2   1   3   4   6   5   7  ....  28   30   29   31
     32  34  33  35  36  38  37  39 ....  60   62   61   63
    ... ...
    */
    for(k=0; k<256; k=k+PE_NUMBER) begin
        din = {dinb[k+0],
               dinb[k+1],
               dinb[k+2],
               dinb[k+3],
               dinb[k+4],
               dinb[k+5],
               dinb[k+6],
               dinb[k+7],
               dinb[k+8],
               dinb[k+9],
               dinb[k+10],
               dinb[k+11],
               dinb[k+12],
               dinb[k+13],
               dinb[k+14],
               dinb[k+15]};
        #FP;
    end

	#(2*FP);

    // start FNTT (for 1st polynomial)
	start_fntt = 1; start_ab = 0; #FP;
	start_fntt = 0;	start_ab = 0; #(2*FP);

	while(done == 1'b0) begin
        #FP;
    end

    // start PWM2
	start_pwm2 = 1; start_ab = 0; #FP;
	start_pwm2 = 0;	start_ab = 0; #(2*FP);

	while(done == 1'b0) begin
        #FP;
    end

    // start INTT
	start_intt = 1; start_ab = 0; #FP;
	start_intt = 0;	start_ab = 0; #(2*FP);

	while(done == 1'b0) begin
        #FP;
    end

	#(2*FP);

	read_a = 1;
	#FP;
	read_a = 0;
	#(2*FP);

	// Store result
    /*
    Input on txt file      : 0, 1, 2, 3, 4, 5, ...
    Input on memory (BRAMs):
    BR1 BR2 BR3 BR4 BR5 BR6 BR7 BR8 .... BR29 BR30 BR31 BR32
     0  128  1  129  2  130  3  131 ....  14   142  15   143
     16 144  17 145  18 146  19 147 ....  30   158  31   159
    ... ...
    */
	for(m=0; m<128; m=m+(PE_NUMBER>>1)) begin
        {fout[m+0],fout[m+128],fout[m+1],fout[m+129],
         fout[m+2],fout[m+130],fout[m+3],fout[m+131],
         fout[m+4],fout[m+132],fout[m+5],fout[m+133],
         fout[m+6],fout[m+134],fout[m+7],fout[m+135]} = dout;
        #FP;
    end

    #100;

	// Check result
    for(m=0; m<256; m=m+1) begin
        if(fout[m] == doua[m]) begin
			e = e+1;
        end
		else begin
			$display("Wrong result -- index:%d, expected:%h --> calculated:%h",m,doua[m],fout[m]);
		end
    end

    if(e == 256)
        $display("HALF PMUL -- Correct!");
    else
        $display("HALF PMUL -- Incorrect!");

    $stop;

end

// ---------------------------------------------------------------- UUT

KyberHPM16PE uut (clk,reset,
	             load_a_f,load_a_i,
	             load_b_f,load_b_i,
	             read_a,read_b,
                 start_ab,
	             start_fntt,start_pwm2,start_intt,
	             din,
	             dout,
	             done);

endmodule
