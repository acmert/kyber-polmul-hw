
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/


// read latency is 1 cc

module BROM (input             clk,
             input      [6:0]  raddr,
             output reg [12*16-1:0] dout);
// bram
(* rom_style="block" *) reg [12*16-1:0] blockrom [127:0]; // 86 is enough

// read operation
always @(posedge clk) begin
    case(raddr)
    // W
    7'd0  : dout <= {12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1,12'h6c1};
    7'd1  : dout <= {12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14,12'ha14};
    7'd2  : dout <= {12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9,12'hcd9};
    7'd3  : dout <= {12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52,12'ha52};
    7'd4  : dout <= {12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276,12'h276};
    7'd5  : dout <= {12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769,12'h769};
    7'd6  : dout <= {12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350,12'h350};
    7'd7  : dout <= {12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426,12'h426};
    7'd8  : dout <= {12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f,12'h77f};
    7'd9  : dout <= {12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 };
    7'd10 : dout <= {12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d,12'h31d};
    7'd11 : dout <= {12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2,12'hae2};
    7'd12 : dout <= {12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc,12'hcbc};
    7'd13 : dout <= {12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239,12'h239};
    7'd14 : dout <= {12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2,12'h6d2};
    7'd15 : dout <= {12'h128,12'h128,12'h128,12'h128,12'h128,12'h128,12'h128,12'h128,12'h98f,12'h98f,12'h98f,12'h98f,12'h98f,12'h98f,12'h98f,12'h98f};
    7'd16 : dout <= {12'h53b,12'h53b,12'h53b,12'h53b,12'h53b,12'h53b,12'h53b,12'h53b,12'h5c4,12'h5c4,12'h5c4,12'h5c4,12'h5c4,12'h5c4,12'h5c4,12'h5c4};
    7'd17 : dout <= {12'hbe6,12'hbe6,12'hbe6,12'hbe6,12'hbe6,12'hbe6,12'hbe6,12'hbe6,12'h38 ,12'h38 ,12'h38 ,12'h38 ,12'h38 ,12'h38 ,12'h38 ,12'h38 };
    7'd18 : dout <= {12'h8c0,12'h8c0,12'h8c0,12'h8c0,12'h8c0,12'h8c0,12'h8c0,12'h8c0,12'h535,12'h535,12'h535,12'h535,12'h535,12'h535,12'h535,12'h535};
    7'd19 : dout <= {12'h592,12'h592,12'h592,12'h592,12'h592,12'h592,12'h592,12'h592,12'h82e,12'h82e,12'h82e,12'h82e,12'h82e,12'h82e,12'h82e,12'h82e};
    7'd20 : dout <= {12'h217,12'h217,12'h217,12'h217,12'h217,12'h217,12'h217,12'h217,12'hb42,12'hb42,12'hb42,12'hb42,12'hb42,12'hb42,12'hb42,12'hb42};
    7'd21 : dout <= {12'h959,12'h959,12'h959,12'h959,12'h959,12'h959,12'h959,12'h959,12'hb3f,12'hb3f,12'hb3f,12'hb3f,12'hb3f,12'hb3f,12'hb3f,12'hb3f};
    7'd22 : dout <= {12'h7b6,12'h7b6,12'h7b6,12'h7b6,12'h7b6,12'h7b6,12'h7b6,12'h7b6,12'h335,12'h335,12'h335,12'h335,12'h335,12'h335,12'h335,12'h335};
    7'd23 : dout <= {12'h121,12'h121,12'h121,12'h121,12'h14b,12'h14b,12'h14b,12'h14b,12'hcb5,12'hcb5,12'hcb5,12'hcb5,12'h6dc,12'h6dc,12'h6dc,12'h6dc};
    7'd24 : dout <= {12'h4ad,12'h4ad,12'h4ad,12'h4ad,12'h900,12'h900,12'h900,12'h900,12'h8e5,12'h8e5,12'h8e5,12'h8e5,12'h807,12'h807,12'h807,12'h807};
    7'd25 : dout <= {12'h28a,12'h28a,12'h28a,12'h28a,12'h7b9,12'h7b9,12'h7b9,12'h7b9,12'h9d1,12'h9d1,12'h9d1,12'h9d1,12'h278,12'h278,12'h278,12'h278};
    7'd26 : dout <= {12'hb31,12'hb31,12'hb31,12'hb31,12'h21 ,12'h21 ,12'h21 ,12'h21 ,12'h528,12'h528,12'h528,12'h528,12'h77b,12'h77b,12'h77b,12'h77b};
    7'd27 : dout <= {12'h90f,12'h90f,12'h90f,12'h90f,12'h59b,12'h59b,12'h59b,12'h59b,12'h327,12'h327,12'h327,12'h327,12'h1c4,12'h1c4,12'h1c4,12'h1c4};
    7'd28 : dout <= {12'h59e,12'h59e,12'h59e,12'h59e,12'hb34,12'hb34,12'hb34,12'hb34,12'h5fe,12'h5fe,12'h5fe,12'h5fe,12'h962,12'h962,12'h962,12'h962};
    7'd29 : dout <= {12'ha57,12'ha57,12'ha57,12'ha57,12'ha39,12'ha39,12'ha39,12'ha39,12'h5c9,12'h5c9,12'h5c9,12'h5c9,12'h288,12'h288,12'h288,12'h288};
    7'd30 : dout <= {12'h9aa,12'h9aa,12'h9aa,12'h9aa,12'hc26,12'hc26,12'hc26,12'hc26,12'h4cb,12'h4cb,12'h4cb,12'h4cb,12'h38e,12'h38e,12'h38e,12'h38e};
    7'd31 : dout <= {12'h11 ,12'h11 ,12'hac9,12'hac9,12'h247,12'h247,12'ha59,12'ha59,12'h665,12'h665,12'h2d3,12'h2d3,12'h8f0,12'h8f0,12'h44c,12'h44c};
    7'd32 : dout <= {12'h581,12'h581,12'ha66,12'ha66,12'hcd1,12'hcd1,12'he9 ,12'he9 ,12'h2f4,12'h2f4,12'h86c,12'h86c,12'hbc7,12'hbc7,12'hbea,12'hbea};
    7'd33 : dout <= {12'h6a7,12'h6a7,12'h673,12'h673,12'hae5,12'hae5,12'h6fd,12'h6fd,12'h737,12'h737,12'h3b8,12'h3b8,12'h5b5,12'h5b5,12'ha7f,12'ha7f};
    7'd34 : dout <= {12'h3ab,12'h3ab,12'h904,12'h904,12'h985,12'h985,12'h954,12'h954,12'h2dd,12'h2dd,12'h921,12'h921,12'h10c,12'h10c,12'h281,12'h281};
    7'd35 : dout <= {12'h630,12'h630,12'h8fa,12'h8fa,12'h7f5,12'h7f5,12'hc94,12'hc94,12'h177,12'h177,12'h9f5,12'h9f5,12'h82a,12'h82a,12'h66d,12'h66d};
    7'd36 : dout <= {12'h427,12'h427,12'h13f,12'h13f,12'had5,12'had5,12'h2f5,12'h2f5,12'h833,12'h833,12'h231,12'h231,12'h9a2,12'h9a2,12'ha22,12'ha22};
    7'd37 : dout <= {12'haf4,12'haf4,12'h444,12'h444,12'h193,12'h193,12'h402,12'h402,12'h477,12'h477,12'h866,12'h866,12'had7,12'had7,12'h376,12'h376};
    7'd38 : dout <= {12'h6ba,12'h6ba,12'h4bc,12'h4bc,12'h752,12'h752,12'h405,12'h405,12'h83e,12'h83e,12'hb77,12'hb77,12'h375,12'h375,12'h86a,12'h86a};
    // WINV
    7'd39 : dout <= {12'h497,12'h497,12'h98c,12'h98c,12'h18a,12'h18a,12'h4c3,12'h4c3,12'h8fc,12'h8fc,12'h5af,12'h5af,12'h845,12'h845,12'h647,12'h647};
    7'd40 : dout <= {12'h98b,12'h98b,12'h22a,12'h22a,12'h49b,12'h49b,12'h88a,12'h88a,12'h8ff,12'h8ff,12'hb6e,12'hb6e,12'h8bd,12'h8bd,12'h20d,12'h20d};
    7'd41 : dout <= {12'h2df,12'h2df,12'h35f,12'h35f,12'had0,12'had0,12'h4ce,12'h4ce,12'ha0c,12'ha0c,12'h22c,12'h22c,12'hbc2,12'hbc2,12'h8da,12'h8da};
    7'd42 : dout <= {12'h694,12'h694,12'h4d7,12'h4d7,12'h30c,12'h30c,12'hb8a,12'hb8a,12'h6d ,12'h6d ,12'h50c,12'h50c,12'h407,12'h407,12'h6d1,12'h6d1};
    7'd43 : dout <= {12'ha80,12'ha80,12'hbf5,12'hbf5,12'h3e0,12'h3e0,12'ha24,12'ha24,12'h3ad,12'h3ad,12'h37c,12'h37c,12'h3fd,12'h3fd,12'h956,12'h956};
    7'd44 : dout <= {12'h282,12'h282,12'h74c,12'h74c,12'h949,12'h949,12'h5ca,12'h5ca,12'h604,12'h604,12'h21c,12'h21c,12'h68e,12'h68e,12'h65a,12'h65a};
    7'd45 : dout <= {12'h117,12'h117,12'h13a,12'h13a,12'h495,12'h495,12'ha0d,12'ha0d,12'hc18,12'hc18,12'h30 ,12'h30 ,12'h29b,12'h29b,12'h780,12'h780};
    7'd46 : dout <= {12'h8b5,12'h8b5,12'h411,12'h411,12'ha2e,12'ha2e,12'h69c,12'h69c,12'h2a8,12'h2a8,12'haba,12'haba,12'h238,12'h238,12'hcf0,12'hcf0};
    7'd47 : dout <= {12'h973,12'h973,12'h973,12'h973,12'h836,12'h836,12'h836,12'h836,12'hdb ,12'hdb ,12'hdb ,12'hdb ,12'h357,12'h357,12'h357,12'h357};
    7'd48 : dout <= {12'ha79,12'ha79,12'ha79,12'ha79,12'h738,12'h738,12'h738,12'h738,12'h2c8,12'h2c8,12'h2c8,12'h2c8,12'h2aa,12'h2aa,12'h2aa,12'h2aa};
    7'd49 : dout <= {12'h39f,12'h39f,12'h39f,12'h39f,12'h703,12'h703,12'h703,12'h703,12'h1cd,12'h1cd,12'h1cd,12'h1cd,12'h763,12'h763,12'h763,12'h763};
    7'd50 : dout <= {12'hb3d,12'hb3d,12'hb3d,12'hb3d,12'h9da,12'h9da,12'h9da,12'h9da,12'h766,12'h766,12'h766,12'h766,12'h3f2,12'h3f2,12'h3f2,12'h3f2};
    7'd51 : dout <= {12'h586,12'h586,12'h586,12'h586,12'h7d9,12'h7d9,12'h7d9,12'h7d9,12'hce0,12'hce0,12'hce0,12'hce0,12'h1d0,12'h1d0,12'h1d0,12'h1d0};
    7'd52 : dout <= {12'ha89,12'ha89,12'ha89,12'ha89,12'h330,12'h330,12'h330,12'h330,12'h548,12'h548,12'h548,12'h548,12'ha77,12'ha77,12'ha77,12'ha77};
    7'd53 : dout <= {12'h4fa,12'h4fa,12'h4fa,12'h4fa,12'h41c,12'h41c,12'h41c,12'h41c,12'h401,12'h401,12'h401,12'h401,12'h854,12'h854,12'h854,12'h854};
    7'd54 : dout <= {12'h625,12'h625,12'h625,12'h625,12'h4c ,12'h4c ,12'h4c ,12'h4c ,12'hbb6,12'hbb6,12'hbb6,12'hbb6,12'hbe0,12'hbe0,12'hbe0,12'hbe0};
    7'd55 : dout <= {12'h9cc,12'h9cc,12'h9cc,12'h9cc,12'h9cc,12'h9cc,12'h9cc,12'h9cc,12'h54b,12'h54b,12'h54b,12'h54b,12'h54b,12'h54b,12'h54b,12'h54b};
    7'd56 : dout <= {12'h1c2,12'h1c2,12'h1c2,12'h1c2,12'h1c2,12'h1c2,12'h1c2,12'h1c2,12'h3a8,12'h3a8,12'h3a8,12'h3a8,12'h3a8,12'h3a8,12'h3a8,12'h3a8};
    7'd57 : dout <= {12'h1bf,12'h1bf,12'h1bf,12'h1bf,12'h1bf,12'h1bf,12'h1bf,12'h1bf,12'haea,12'haea,12'haea,12'haea,12'haea,12'haea,12'haea,12'haea};
    7'd58 : dout <= {12'h4d3,12'h4d3,12'h4d3,12'h4d3,12'h4d3,12'h4d3,12'h4d3,12'h4d3,12'h76f,12'h76f,12'h76f,12'h76f,12'h76f,12'h76f,12'h76f,12'h76f};
    7'd59 : dout <= {12'h7cc,12'h7cc,12'h7cc,12'h7cc,12'h7cc,12'h7cc,12'h7cc,12'h7cc,12'h441,12'h441,12'h441,12'h441,12'h441,12'h441,12'h441,12'h441};
    7'd60 : dout <= {12'hcc9,12'hcc9,12'hcc9,12'hcc9,12'hcc9,12'hcc9,12'hcc9,12'hcc9,12'h11b,12'h11b,12'h11b,12'h11b,12'h11b,12'h11b,12'h11b,12'h11b};
    7'd61 : dout <= {12'h73d,12'h73d,12'h73d,12'h73d,12'h73d,12'h73d,12'h73d,12'h73d,12'h7c6,12'h7c6,12'h7c6,12'h7c6,12'h7c6,12'h7c6,12'h7c6,12'h7c6};
    7'd62 : dout <= {12'h372,12'h372,12'h372,12'h372,12'h372,12'h372,12'h372,12'h372,12'hbd9,12'hbd9,12'hbd9,12'hbd9,12'hbd9,12'hbd9,12'hbd9,12'hbd9};
    7'd63 : dout <= {12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f,12'h62f};
    7'd64 : dout <= {12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8,12'hac8};
    7'd65 : dout <= {12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 ,12'h45 };
    7'd66 : dout <= {12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f,12'h21f};
    7'd67 : dout <= {12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4,12'h9e4};
    7'd68 : dout <= {12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40,12'hc40};
    7'd69 : dout <= {12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582,12'h582};
    7'd70 : dout <= {12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db,12'h8db};
    7'd71 : dout <= {12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1,12'h9b1};
    7'd72 : dout <= {12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598,12'h598};
    7'd73 : dout <= {12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b,12'ha8b};
    7'd74 : dout <= {12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af,12'h2af};
    7'd75 : dout <= {12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 ,12'h28 };
    7'd76 : dout <= {12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed,12'h2ed};
    7'd77 : dout <= {12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640,12'h640};
    // WP
    7'd78 : dout <= {12'h11 ,12'hcf0,12'hac9,12'h238,12'h247,12'haba,12'ha59,12'h2a8,12'h665,12'h69c,12'h2d3,12'ha2e,12'h8f0,12'h411,12'h44c,12'h8b5};
    7'd79 : dout <= {12'h581,12'h780,12'ha66,12'h29b,12'hcd1,12'h30 ,12'he9 ,12'hc18,12'h2f4,12'ha0d,12'h86c,12'h495,12'hbc7,12'h13a,12'hbea,12'h117};
    7'd80 : dout <= {12'h6a7,12'h65a,12'h673,12'h68e,12'hae5,12'h21c,12'h6fd,12'h604,12'h737,12'h5ca,12'h3b8,12'h949,12'h5b5,12'h74c,12'ha7f,12'h282};
    7'd81 : dout <= {12'h3ab,12'h956,12'h904,12'h3fd,12'h985,12'h37c,12'h954,12'h3ad,12'h2dd,12'ha24,12'h921,12'h3e0,12'h10c,12'hbf5,12'h281,12'ha80};
    7'd82 : dout <= {12'h630,12'h6d1,12'h8fa,12'h407,12'h7f5,12'h50c,12'hc94,12'h6d ,12'h177,12'hb8a,12'h9f5,12'h30c,12'h82a,12'h4d7,12'h66d,12'h694};
    7'd83 : dout <= {12'h427,12'h8da,12'h13f,12'hbc2,12'had5,12'h22c,12'h2f5,12'ha0c,12'h833,12'h4ce,12'h231,12'had0,12'h9a2,12'h35f,12'ha22,12'h2df};
    7'd84 : dout <= {12'haf4,12'h20d,12'h444,12'h8bd,12'h193,12'hb6e,12'h402,12'h8ff,12'h477,12'h88a,12'h866,12'h49b,12'had7,12'h22a,12'h376,12'h98b};
    7'd85 : dout <= {12'h6ba,12'h647,12'h4bc,12'h845,12'h752,12'h5af,12'h405,12'h8fc,12'h83e,12'h4c3,12'hb77,12'h18a,12'h375,12'h98c,12'h86a,12'h497};
    default: dout <= 192'h0;
    endcase
end

endmodule
