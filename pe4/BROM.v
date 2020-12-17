
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
             input      [7:0]  raddr,
             output reg [47:0] dout);
// bram
(* rom_style="block" *) reg [12*4-1:0] blockrom [255:0]; // 222 is enough

// read operation
always @(posedge clk) begin
    case(raddr)
    // W
    8'd0  : dout <= {12'h6c1,12'h6c1,12'h6c1,12'h6c1};
    8'd1  : dout <= {12'ha14,12'ha14,12'ha14,12'ha14};
    8'd2  : dout <= {12'hcd9,12'hcd9,12'hcd9,12'hcd9};
    8'd3  : dout <= {12'ha52,12'ha52,12'ha52,12'ha52};
    8'd4  : dout <= {12'h276,12'h276,12'h276,12'h276};
    8'd5  : dout <= {12'h769,12'h769,12'h769,12'h769};
    8'd6  : dout <= {12'h350,12'h350,12'h350,12'h350};
    8'd7  : dout <= {12'h426,12'h426,12'h426,12'h426};
    8'd8  : dout <= {12'h77f,12'h77f,12'h77f,12'h77f};
    8'd9  : dout <= {12'hc1 ,12'hc1 ,12'hc1 ,12'hc1 };
    8'd10 : dout <= {12'h31d,12'h31d,12'h31d,12'h31d};
    8'd11 : dout <= {12'hae2,12'hae2,12'hae2,12'hae2};
    8'd12 : dout <= {12'hcbc,12'hcbc,12'hcbc,12'hcbc};
    8'd13 : dout <= {12'h239,12'h239,12'h239,12'h239};
    8'd14 : dout <= {12'h6d2,12'h6d2,12'h6d2,12'h6d2};
    8'd15 : dout <= {12'h128,12'h128,12'h128,12'h128};
    8'd16 : dout <= {12'h98f,12'h98f,12'h98f,12'h98f};
    8'd17 : dout <= {12'h53b,12'h53b,12'h53b,12'h53b};
    8'd18 : dout <= {12'h5c4,12'h5c4,12'h5c4,12'h5c4};
    8'd19 : dout <= {12'hbe6,12'hbe6,12'hbe6,12'hbe6};
    8'd20 : dout <= {12'h38 ,12'h38 ,12'h38 ,12'h38 };
    8'd21 : dout <= {12'h8c0,12'h8c0,12'h8c0,12'h8c0};
    8'd22 : dout <= {12'h535,12'h535,12'h535,12'h535};
    8'd23 : dout <= {12'h592,12'h592,12'h592,12'h592};
    8'd24 : dout <= {12'h82e,12'h82e,12'h82e,12'h82e};
    8'd25 : dout <= {12'h217,12'h217,12'h217,12'h217};
    8'd26 : dout <= {12'hb42,12'hb42,12'hb42,12'hb42};
    8'd27 : dout <= {12'h959,12'h959,12'h959,12'h959};
    8'd28 : dout <= {12'hb3f,12'hb3f,12'hb3f,12'hb3f};
    8'd29 : dout <= {12'h7b6,12'h7b6,12'h7b6,12'h7b6};
    8'd30 : dout <= {12'h335,12'h335,12'h335,12'h335};
    8'd31 : dout <= {12'h121,12'h121,12'h121,12'h121};
    8'd32 : dout <= {12'h14b,12'h14b,12'h14b,12'h14b};
    8'd33 : dout <= {12'hcb5,12'hcb5,12'hcb5,12'hcb5};
    8'd34 : dout <= {12'h6dc,12'h6dc,12'h6dc,12'h6dc};
    8'd35 : dout <= {12'h4ad,12'h4ad,12'h4ad,12'h4ad};
    8'd36 : dout <= {12'h900,12'h900,12'h900,12'h900};
    8'd37 : dout <= {12'h8e5,12'h8e5,12'h8e5,12'h8e5};
    8'd38 : dout <= {12'h807,12'h807,12'h807,12'h807};
    8'd39 : dout <= {12'h28a,12'h28a,12'h28a,12'h28a};
    8'd40 : dout <= {12'h7b9,12'h7b9,12'h7b9,12'h7b9};
    8'd41 : dout <= {12'h9d1,12'h9d1,12'h9d1,12'h9d1};
    8'd42 : dout <= {12'h278,12'h278,12'h278,12'h278};
    8'd43 : dout <= {12'hb31,12'hb31,12'hb31,12'hb31};
    8'd44 : dout <= {12'h21 ,12'h21 ,12'h21 ,12'h21 };
    8'd45 : dout <= {12'h528,12'h528,12'h528,12'h528};
    8'd46 : dout <= {12'h77b,12'h77b,12'h77b,12'h77b};
    8'd47 : dout <= {12'h90f,12'h90f,12'h90f,12'h90f};
    8'd48 : dout <= {12'h59b,12'h59b,12'h59b,12'h59b};
    8'd49 : dout <= {12'h327,12'h327,12'h327,12'h327};
    8'd50 : dout <= {12'h1c4,12'h1c4,12'h1c4,12'h1c4};
    8'd51 : dout <= {12'h59e,12'h59e,12'h59e,12'h59e};
    8'd52 : dout <= {12'hb34,12'hb34,12'hb34,12'hb34};
    8'd53 : dout <= {12'h5fe,12'h5fe,12'h5fe,12'h5fe};
    8'd54 : dout <= {12'h962,12'h962,12'h962,12'h962};
    8'd55 : dout <= {12'ha57,12'ha57,12'ha57,12'ha57};
    8'd56 : dout <= {12'ha39,12'ha39,12'ha39,12'ha39};
    8'd57 : dout <= {12'h5c9,12'h5c9,12'h5c9,12'h5c9};
    8'd58 : dout <= {12'h288,12'h288,12'h288,12'h288};
    8'd59 : dout <= {12'h9aa,12'h9aa,12'h9aa,12'h9aa};
    8'd60 : dout <= {12'hc26,12'hc26,12'hc26,12'hc26};
    8'd61 : dout <= {12'h4cb,12'h4cb,12'h4cb,12'h4cb};
    8'd62 : dout <= {12'h38e,12'h38e,12'h38e,12'h38e};
    8'd63 : dout <= {12'h11 ,12'h11 ,12'hac9,12'hac9};
    8'd64 : dout <= {12'h247,12'h247,12'ha59,12'ha59};
    8'd65 : dout <= {12'h665,12'h665,12'h2d3,12'h2d3};
    8'd66 : dout <= {12'h8f0,12'h8f0,12'h44c,12'h44c};
    8'd67 : dout <= {12'h581,12'h581,12'ha66,12'ha66};
    8'd68 : dout <= {12'hcd1,12'hcd1,12'he9 ,12'he9 };
    8'd69 : dout <= {12'h2f4,12'h2f4,12'h86c,12'h86c};
    8'd70 : dout <= {12'hbc7,12'hbc7,12'hbea,12'hbea};
    8'd71 : dout <= {12'h6a7,12'h6a7,12'h673,12'h673};
    8'd72 : dout <= {12'hae5,12'hae5,12'h6fd,12'h6fd};
    8'd73 : dout <= {12'h737,12'h737,12'h3b8,12'h3b8};
    8'd74 : dout <= {12'h5b5,12'h5b5,12'ha7f,12'ha7f};
    8'd75 : dout <= {12'h3ab,12'h3ab,12'h904,12'h904};
    8'd76 : dout <= {12'h985,12'h985,12'h954,12'h954};
    8'd77 : dout <= {12'h2dd,12'h2dd,12'h921,12'h921};
    8'd78 : dout <= {12'h10c,12'h10c,12'h281,12'h281};
    8'd79 : dout <= {12'h630,12'h630,12'h8fa,12'h8fa};
    8'd80 : dout <= {12'h7f5,12'h7f5,12'hc94,12'hc94};
    8'd81 : dout <= {12'h177,12'h177,12'h9f5,12'h9f5};
    8'd82 : dout <= {12'h82a,12'h82a,12'h66d,12'h66d};
    8'd83 : dout <= {12'h427,12'h427,12'h13f,12'h13f};
    8'd84 : dout <= {12'had5,12'had5,12'h2f5,12'h2f5};
    8'd85 : dout <= {12'h833,12'h833,12'h231,12'h231};
    8'd86 : dout <= {12'h9a2,12'h9a2,12'ha22,12'ha22};
    8'd87 : dout <= {12'haf4,12'haf4,12'h444,12'h444};
    8'd88 : dout <= {12'h193,12'h193,12'h402,12'h402};
    8'd89 : dout <= {12'h477,12'h477,12'h866,12'h866};
    8'd90 : dout <= {12'had7,12'had7,12'h376,12'h376};
    8'd91 : dout <= {12'h6ba,12'h6ba,12'h4bc,12'h4bc};
    8'd92 : dout <= {12'h752,12'h752,12'h405,12'h405};
    8'd93 : dout <= {12'h83e,12'h83e,12'hb77,12'hb77};
    8'd94 : dout <= {12'h375,12'h375,12'h86a,12'h86a};
    // WINV
    8'd95 : dout <= {12'h497,12'h497,12'h98c,12'h98c};
    8'd96 : dout <= {12'h18a,12'h18a,12'h4c3,12'h4c3};
    8'd97 : dout <= {12'h8fc,12'h8fc,12'h5af,12'h5af};
    8'd98 : dout <= {12'h845,12'h845,12'h647,12'h647};
    8'd99 : dout <= {12'h98b,12'h98b,12'h22a,12'h22a};
    8'd100: dout <= {12'h49b,12'h49b,12'h88a,12'h88a};
    8'd101: dout <= {12'h8ff,12'h8ff,12'hb6e,12'hb6e};
    8'd102: dout <= {12'h8bd,12'h8bd,12'h20d,12'h20d};
    8'd103: dout <= {12'h2df,12'h2df,12'h35f,12'h35f};
    8'd104: dout <= {12'had0,12'had0,12'h4ce,12'h4ce};
    8'd105: dout <= {12'ha0c,12'ha0c,12'h22c,12'h22c};
    8'd106: dout <= {12'hbc2,12'hbc2,12'h8da,12'h8da};
    8'd107: dout <= {12'h694,12'h694,12'h4d7,12'h4d7};
    8'd108: dout <= {12'h30c,12'h30c,12'hb8a,12'hb8a};
    8'd109: dout <= {12'h6d ,12'h6d ,12'h50c,12'h50c};
    8'd110: dout <= {12'h407,12'h407,12'h6d1,12'h6d1};
    8'd111: dout <= {12'ha80,12'ha80,12'hbf5,12'hbf5};
    8'd112: dout <= {12'h3e0,12'h3e0,12'ha24,12'ha24};
    8'd113: dout <= {12'h3ad,12'h3ad,12'h37c,12'h37c};
    8'd114: dout <= {12'h3fd,12'h3fd,12'h956,12'h956};
    8'd115: dout <= {12'h282,12'h282,12'h74c,12'h74c};
    8'd116: dout <= {12'h949,12'h949,12'h5ca,12'h5ca};
    8'd117: dout <= {12'h604,12'h604,12'h21c,12'h21c};
    8'd118: dout <= {12'h68e,12'h68e,12'h65a,12'h65a};
    8'd119: dout <= {12'h117,12'h117,12'h13a,12'h13a};
    8'd120: dout <= {12'h495,12'h495,12'ha0d,12'ha0d};
    8'd121: dout <= {12'hc18,12'hc18,12'h30 ,12'h30 };
    8'd122: dout <= {12'h29b,12'h29b,12'h780,12'h780};
    8'd123: dout <= {12'h8b5,12'h8b5,12'h411,12'h411};
    8'd124: dout <= {12'ha2e,12'ha2e,12'h69c,12'h69c};
    8'd125: dout <= {12'h2a8,12'h2a8,12'haba,12'haba};
    8'd126: dout <= {12'h238,12'h238,12'hcf0,12'hcf0};
    8'd127: dout <= {12'h973,12'h973,12'h973,12'h973};
    8'd128: dout <= {12'h836,12'h836,12'h836,12'h836};
    8'd129: dout <= {12'hdb ,12'hdb ,12'hdb ,12'hdb };
    8'd130: dout <= {12'h357,12'h357,12'h357,12'h357};
    8'd131: dout <= {12'ha79,12'ha79,12'ha79,12'ha79};
    8'd132: dout <= {12'h738,12'h738,12'h738,12'h738};
    8'd133: dout <= {12'h2c8,12'h2c8,12'h2c8,12'h2c8};
    8'd134: dout <= {12'h2aa,12'h2aa,12'h2aa,12'h2aa};
    8'd135: dout <= {12'h39f,12'h39f,12'h39f,12'h39f};
    8'd136: dout <= {12'h703,12'h703,12'h703,12'h703};
    8'd137: dout <= {12'h1cd,12'h1cd,12'h1cd,12'h1cd};
    8'd138: dout <= {12'h763,12'h763,12'h763,12'h763};
    8'd139: dout <= {12'hb3d,12'hb3d,12'hb3d,12'hb3d};
    8'd140: dout <= {12'h9da,12'h9da,12'h9da,12'h9da};
    8'd141: dout <= {12'h766,12'h766,12'h766,12'h766};
    8'd142: dout <= {12'h3f2,12'h3f2,12'h3f2,12'h3f2};
    8'd143: dout <= {12'h586,12'h586,12'h586,12'h586};
    8'd144: dout <= {12'h7d9,12'h7d9,12'h7d9,12'h7d9};
    8'd145: dout <= {12'hce0,12'hce0,12'hce0,12'hce0};
    8'd146: dout <= {12'h1d0,12'h1d0,12'h1d0,12'h1d0};
    8'd147: dout <= {12'ha89,12'ha89,12'ha89,12'ha89};
    8'd148: dout <= {12'h330,12'h330,12'h330,12'h330};
    8'd149: dout <= {12'h548,12'h548,12'h548,12'h548};
    8'd150: dout <= {12'ha77,12'ha77,12'ha77,12'ha77};
    8'd151: dout <= {12'h4fa,12'h4fa,12'h4fa,12'h4fa};
    8'd152: dout <= {12'h41c,12'h41c,12'h41c,12'h41c};
    8'd153: dout <= {12'h401,12'h401,12'h401,12'h401};
    8'd154: dout <= {12'h854,12'h854,12'h854,12'h854};
    8'd155: dout <= {12'h625,12'h625,12'h625,12'h625};
    8'd156: dout <= {12'h4c ,12'h4c ,12'h4c ,12'h4c };
    8'd157: dout <= {12'hbb6,12'hbb6,12'hbb6,12'hbb6};
    8'd158: dout <= {12'hbe0,12'hbe0,12'hbe0,12'hbe0};
    8'd159: dout <= {12'h9cc,12'h9cc,12'h9cc,12'h9cc};
    8'd160: dout <= {12'h54b,12'h54b,12'h54b,12'h54b};
    8'd161: dout <= {12'h1c2,12'h1c2,12'h1c2,12'h1c2};
    8'd162: dout <= {12'h3a8,12'h3a8,12'h3a8,12'h3a8};
    8'd163: dout <= {12'h1bf,12'h1bf,12'h1bf,12'h1bf};
    8'd164: dout <= {12'haea,12'haea,12'haea,12'haea};
    8'd165: dout <= {12'h4d3,12'h4d3,12'h4d3,12'h4d3};
    8'd166: dout <= {12'h76f,12'h76f,12'h76f,12'h76f};
    8'd167: dout <= {12'h7cc,12'h7cc,12'h7cc,12'h7cc};
    8'd168: dout <= {12'h441,12'h441,12'h441,12'h441};
    8'd169: dout <= {12'hcc9,12'hcc9,12'hcc9,12'hcc9};
    8'd170: dout <= {12'h11b,12'h11b,12'h11b,12'h11b};
    8'd171: dout <= {12'h73d,12'h73d,12'h73d,12'h73d};
    8'd172: dout <= {12'h7c6,12'h7c6,12'h7c6,12'h7c6};
    8'd173: dout <= {12'h372,12'h372,12'h372,12'h372};
    8'd174: dout <= {12'hbd9,12'hbd9,12'hbd9,12'hbd9};
    8'd175: dout <= {12'h62f,12'h62f,12'h62f,12'h62f};
    8'd176: dout <= {12'hac8,12'hac8,12'hac8,12'hac8};
    8'd177: dout <= {12'h45 ,12'h45 ,12'h45 ,12'h45 };
    8'd178: dout <= {12'h21f,12'h21f,12'h21f,12'h21f};
    8'd179: dout <= {12'h9e4,12'h9e4,12'h9e4,12'h9e4};
    8'd180: dout <= {12'hc40,12'hc40,12'hc40,12'hc40};
    8'd181: dout <= {12'h582,12'h582,12'h582,12'h582};
    8'd182: dout <= {12'h8db,12'h8db,12'h8db,12'h8db};
    8'd183: dout <= {12'h9b1,12'h9b1,12'h9b1,12'h9b1};
    8'd184: dout <= {12'h598,12'h598,12'h598,12'h598};
    8'd185: dout <= {12'ha8b,12'ha8b,12'ha8b,12'ha8b};
    8'd186: dout <= {12'h2af,12'h2af,12'h2af,12'h2af};
    8'd187: dout <= {12'h28 ,12'h28 ,12'h28 ,12'h28 };
    8'd188: dout <= {12'h2ed,12'h2ed,12'h2ed,12'h2ed};
    8'd189: dout <= {12'h640,12'h640,12'h640,12'h640};
    // WP?
    8'd190: dout <= {12'h11 ,12'hcf0,12'hac9,12'h238};
    8'd191: dout <= {12'h247,12'haba,12'ha59,12'h2a8};
    8'd192: dout <= {12'h665,12'h69c,12'h2d3,12'ha2e};
    8'd193: dout <= {12'h8f0,12'h411,12'h44c,12'h8b5};
    8'd194: dout <= {12'h581,12'h780,12'ha66,12'h29b};
    8'd195: dout <= {12'hcd1,12'h30 ,12'he9 ,12'hc18};
    8'd196: dout <= {12'h2f4,12'ha0d,12'h86c,12'h495};
    8'd197: dout <= {12'hbc7,12'h13a,12'hbea,12'h117};
    8'd198: dout <= {12'h6a7,12'h65a,12'h673,12'h68e};
    8'd199: dout <= {12'hae5,12'h21c,12'h6fd,12'h604};
    8'd200: dout <= {12'h737,12'h5ca,12'h3b8,12'h949};
    8'd201: dout <= {12'h5b5,12'h74c,12'ha7f,12'h282};
    8'd202: dout <= {12'h3ab,12'h956,12'h904,12'h3fd};
    8'd203: dout <= {12'h985,12'h37c,12'h954,12'h3ad};
    8'd204: dout <= {12'h2dd,12'ha24,12'h921,12'h3e0};
    8'd205: dout <= {12'h10c,12'hbf5,12'h281,12'ha80};
    8'd206: dout <= {12'h630,12'h6d1,12'h8fa,12'h407};
    8'd207: dout <= {12'h7f5,12'h50c,12'hc94,12'h6d };
    8'd208: dout <= {12'h177,12'hb8a,12'h9f5,12'h30c};
    8'd209: dout <= {12'h82a,12'h4d7,12'h66d,12'h694};
    8'd210: dout <= {12'h427,12'h8da,12'h13f,12'hbc2};
    8'd211: dout <= {12'had5,12'h22c,12'h2f5,12'ha0c};
    8'd212: dout <= {12'h833,12'h4ce,12'h231,12'had0};
    8'd213: dout <= {12'h9a2,12'h35f,12'ha22,12'h2df};
    8'd214: dout <= {12'haf4,12'h20d,12'h444,12'h8bd};
    8'd215: dout <= {12'h193,12'hb6e,12'h402,12'h8ff};
    8'd216: dout <= {12'h477,12'h88a,12'h866,12'h49b};
    8'd217: dout <= {12'had7,12'h22a,12'h376,12'h98b};
    8'd218: dout <= {12'h6ba,12'h647,12'h4bc,12'h845};
    8'd219: dout <= {12'h752,12'h5af,12'h405,12'h8fc};
    8'd220: dout <= {12'h83e,12'h4c3,12'hb77,12'h18a};
    8'd221: dout <= {12'h375,12'h98c,12'h86a,12'h497};
    default: dout <= 48'h0;
    endcase
end

endmodule
