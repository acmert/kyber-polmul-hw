
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
             input      [8:0]  raddr,
             output reg [11:0] dout);
// bram
(* rom_style="block" *) reg [11:0] blockrom [511:0]; 

// read operation
always @(posedge clk) begin
    case(raddr)
    // W
    9'd0  : dout <= 12'h6c1;
    9'd1  : dout <= 12'ha14;
    9'd2  : dout <= 12'hcd9;
    9'd3  : dout <= 12'ha52;
    9'd4  : dout <= 12'h276;
    9'd5  : dout <= 12'h769;
    9'd6  : dout <= 12'h350;
    9'd7  : dout <= 12'h426;
    9'd8  : dout <= 12'h77f;
    9'd9  : dout <= 12'hc1 ;
    9'd10 : dout <= 12'h31d;
    9'd11 : dout <= 12'hae2;
    9'd12 : dout <= 12'hcbc;
    9'd13 : dout <= 12'h239;
    9'd14 : dout <= 12'h6d2;
    9'd15 : dout <= 12'h128;
    9'd16 : dout <= 12'h98f;
    9'd17 : dout <= 12'h53b;
    9'd18 : dout <= 12'h5c4;
    9'd19 : dout <= 12'hbe6;
    9'd20 : dout <= 12'h38 ;
    9'd21 : dout <= 12'h8c0;
    9'd22 : dout <= 12'h535;
    9'd23 : dout <= 12'h592;
    9'd24 : dout <= 12'h82e;
    9'd25 : dout <= 12'h217;
    9'd26 : dout <= 12'hb42;
    9'd27 : dout <= 12'h959;
    9'd28 : dout <= 12'hb3f;
    9'd29 : dout <= 12'h7b6;
    9'd30 : dout <= 12'h335;
    9'd31 : dout <= 12'h121;
    9'd32 : dout <= 12'h14b;
    9'd33 : dout <= 12'hcb5;
    9'd34 : dout <= 12'h6dc;
    9'd35 : dout <= 12'h4ad;
    9'd36 : dout <= 12'h900;
    9'd37 : dout <= 12'h8e5;
    9'd38 : dout <= 12'h807;
    9'd39 : dout <= 12'h28a;
    9'd40 : dout <= 12'h7b9;
    9'd41 : dout <= 12'h9d1;
    9'd42 : dout <= 12'h278;
    9'd43 : dout <= 12'hb31;
    9'd44 : dout <= 12'h21 ;
    9'd45 : dout <= 12'h528;
    9'd46 : dout <= 12'h77b;
    9'd47 : dout <= 12'h90f;
    9'd48 : dout <= 12'h59b;
    9'd49 : dout <= 12'h327;
    9'd50 : dout <= 12'h1c4;
    9'd51 : dout <= 12'h59e;
    9'd52 : dout <= 12'hb34;
    9'd53 : dout <= 12'h5fe;
    9'd54 : dout <= 12'h962;
    9'd55 : dout <= 12'ha57;
    9'd56 : dout <= 12'ha39;
    9'd57 : dout <= 12'h5c9;
    9'd58 : dout <= 12'h288;
    9'd59 : dout <= 12'h9aa;
    9'd60 : dout <= 12'hc26;
    9'd61 : dout <= 12'h4cb;
    9'd62 : dout <= 12'h38e;
    9'd63 : dout <= 12'h11 ;
    9'd64 : dout <= 12'hac9;
    9'd65 : dout <= 12'h247;
    9'd66 : dout <= 12'ha59;
    9'd67 : dout <= 12'h665;
    9'd68 : dout <= 12'h2d3;
    9'd69 : dout <= 12'h8f0;
    9'd70 : dout <= 12'h44c;
    9'd71 : dout <= 12'h581;
    9'd72 : dout <= 12'ha66;
    9'd73 : dout <= 12'hcd1;
    9'd74 : dout <= 12'he9 ;
    9'd75 : dout <= 12'h2f4;
    9'd76 : dout <= 12'h86c;
    9'd77 : dout <= 12'hbc7;
    9'd78 : dout <= 12'hbea;
    9'd79 : dout <= 12'h6a7;
    9'd80 : dout <= 12'h673;
    9'd81 : dout <= 12'hae5;
    9'd82 : dout <= 12'h6fd;
    9'd83 : dout <= 12'h737;
    9'd84 : dout <= 12'h3b8;
    9'd85 : dout <= 12'h5b5;
    9'd86 : dout <= 12'ha7f;
    9'd87 : dout <= 12'h3ab;
    9'd88 : dout <= 12'h904;
    9'd89 : dout <= 12'h985;
    9'd90 : dout <= 12'h954;
    9'd91 : dout <= 12'h2dd;
    9'd92 : dout <= 12'h921;
    9'd93 : dout <= 12'h10c;
    9'd94 : dout <= 12'h281;
    9'd95 : dout <= 12'h630;
    9'd96 : dout <= 12'h8fa;
    9'd97 : dout <= 12'h7f5;
    9'd98 : dout <= 12'hc94;
    9'd99 : dout <= 12'h177;
    9'd100: dout <= 12'h9f5;
    9'd101: dout <= 12'h82a;
    9'd102: dout <= 12'h66d;
    9'd103: dout <= 12'h427;
    9'd104: dout <= 12'h13f;
    9'd105: dout <= 12'had5;
    9'd106: dout <= 12'h2f5;
    9'd107: dout <= 12'h833;
    9'd108: dout <= 12'h231;
    9'd109: dout <= 12'h9a2;
    9'd110: dout <= 12'ha22;
    9'd111: dout <= 12'haf4;
    9'd112: dout <= 12'h444;
    9'd113: dout <= 12'h193;
    9'd114: dout <= 12'h402;
    9'd115: dout <= 12'h477;
    9'd116: dout <= 12'h866;
    9'd117: dout <= 12'had7;
    9'd118: dout <= 12'h376;
    9'd119: dout <= 12'h6ba;
    9'd120: dout <= 12'h4bc;
    9'd121: dout <= 12'h752;
    9'd122: dout <= 12'h405;
    9'd123: dout <= 12'h83e;
    9'd124: dout <= 12'hb77;
    9'd125: dout <= 12'h375;
    9'd126: dout <= 12'h86a;
    // WINV
    9'd127: dout <= 12'h497;
    9'd128: dout <= 12'h98c;
    9'd129: dout <= 12'h18a;
    9'd130: dout <= 12'h4c3;
    9'd131: dout <= 12'h8fc;
    9'd132: dout <= 12'h5af;
    9'd133: dout <= 12'h845;
    9'd134: dout <= 12'h647;
    9'd135: dout <= 12'h98b;
    9'd136: dout <= 12'h22a;
    9'd137: dout <= 12'h49b;
    9'd138: dout <= 12'h88a;
    9'd139: dout <= 12'h8ff;
    9'd140: dout <= 12'hb6e;
    9'd141: dout <= 12'h8bd;
    9'd142: dout <= 12'h20d;
    9'd143: dout <= 12'h2df;
    9'd144: dout <= 12'h35f;
    9'd145: dout <= 12'had0;
    9'd146: dout <= 12'h4ce;
    9'd147: dout <= 12'ha0c;
    9'd148: dout <= 12'h22c;
    9'd149: dout <= 12'hbc2;
    9'd150: dout <= 12'h8da;
    9'd151: dout <= 12'h694;
    9'd152: dout <= 12'h4d7;
    9'd153: dout <= 12'h30c;
    9'd154: dout <= 12'hb8a;
    9'd155: dout <= 12'h6d ;
    9'd156: dout <= 12'h50c;
    9'd157: dout <= 12'h407;
    9'd158: dout <= 12'h6d1;
    9'd159: dout <= 12'ha80;
    9'd160: dout <= 12'hbf5;
    9'd161: dout <= 12'h3e0;
    9'd162: dout <= 12'ha24;
    9'd163: dout <= 12'h3ad;
    9'd164: dout <= 12'h37c;
    9'd165: dout <= 12'h3fd;
    9'd166: dout <= 12'h956;
    9'd167: dout <= 12'h282;
    9'd168: dout <= 12'h74c;
    9'd169: dout <= 12'h949;
    9'd170: dout <= 12'h5ca;
    9'd171: dout <= 12'h604;
    9'd172: dout <= 12'h21c;
    9'd173: dout <= 12'h68e;
    9'd174: dout <= 12'h65a;
    9'd175: dout <= 12'h117;
    9'd176: dout <= 12'h13a;
    9'd177: dout <= 12'h495;
    9'd178: dout <= 12'ha0d;
    9'd179: dout <= 12'hc18;
    9'd180: dout <= 12'h30 ;
    9'd181: dout <= 12'h29b;
    9'd182: dout <= 12'h780;
    9'd183: dout <= 12'h8b5;
    9'd184: dout <= 12'h411;
    9'd185: dout <= 12'ha2e;
    9'd186: dout <= 12'h69c;
    9'd187: dout <= 12'h2a8;
    9'd188: dout <= 12'haba;
    9'd189: dout <= 12'h238;
    9'd190: dout <= 12'hcf0;
    9'd191: dout <= 12'h973;
    9'd192: dout <= 12'h836;
    9'd193: dout <= 12'hdb ;
    9'd194: dout <= 12'h357;
    9'd195: dout <= 12'ha79;
    9'd196: dout <= 12'h738;
    9'd197: dout <= 12'h2c8;
    9'd198: dout <= 12'h2aa;
    9'd199: dout <= 12'h39f;
    9'd200: dout <= 12'h703;
    9'd201: dout <= 12'h1cd;
    9'd202: dout <= 12'h763;
    9'd203: dout <= 12'hb3d;
    9'd204: dout <= 12'h9da;
    9'd205: dout <= 12'h766;
    9'd206: dout <= 12'h3f2;
    9'd207: dout <= 12'h586;
    9'd208: dout <= 12'h7d9;
    9'd209: dout <= 12'hce0;
    9'd210: dout <= 12'h1d0;
    9'd211: dout <= 12'ha89;
    9'd212: dout <= 12'h330;
    9'd213: dout <= 12'h548;
    9'd214: dout <= 12'ha77;
    9'd215: dout <= 12'h4fa;
    9'd216: dout <= 12'h41c;
    9'd217: dout <= 12'h401;
    9'd218: dout <= 12'h854;
    9'd219: dout <= 12'h625;
    9'd220: dout <= 12'h4c ;
    9'd221: dout <= 12'hbb6;
    9'd222: dout <= 12'hbe0;
    9'd223: dout <= 12'h9cc;
    9'd224: dout <= 12'h54b;
    9'd225: dout <= 12'h1c2;
    9'd226: dout <= 12'h3a8;
    9'd227: dout <= 12'h1bf;
    9'd228: dout <= 12'haea;
    9'd229: dout <= 12'h4d3;
    9'd230: dout <= 12'h76f;
    9'd231: dout <= 12'h7cc;
    9'd232: dout <= 12'h441;
    9'd233: dout <= 12'hcc9;
    9'd234: dout <= 12'h11b;
    9'd235: dout <= 12'h73d;
    9'd236: dout <= 12'h7c6;
    9'd237: dout <= 12'h372;
    9'd238: dout <= 12'hbd9;
    9'd239: dout <= 12'h62f;
    9'd240: dout <= 12'hac8;
    9'd241: dout <= 12'h45 ;
    9'd242: dout <= 12'h21f;
    9'd243: dout <= 12'h9e4;
    9'd244: dout <= 12'hc40;
    9'd245: dout <= 12'h582;
    9'd246: dout <= 12'h8db;
    9'd247: dout <= 12'h9b1;
    9'd248: dout <= 12'h598;
    9'd249: dout <= 12'ha8b;
    9'd250: dout <= 12'h2af;
    9'd251: dout <= 12'h28 ;
    9'd252: dout <= 12'h2ed;
    9'd253: dout <= 12'h640;
    // WP?
    9'd254: dout <= 12'h11 ;
    9'd255: dout <= 12'hcf0;
    9'd256: dout <= 12'hac9;
    9'd257: dout <= 12'h238;
    9'd258: dout <= 12'h247;
    9'd259: dout <= 12'haba;
    9'd260: dout <= 12'ha59;
    9'd261: dout <= 12'h2a8;
    9'd262: dout <= 12'h665;
    9'd263: dout <= 12'h69c;
    9'd264: dout <= 12'h2d3;
    9'd265: dout <= 12'ha2e;
    9'd266: dout <= 12'h8f0;
    9'd267: dout <= 12'h411;
    9'd268: dout <= 12'h44c;
    9'd269: dout <= 12'h8b5;
    9'd270: dout <= 12'h581;
    9'd271: dout <= 12'h780;
    9'd272: dout <= 12'ha66;
    9'd273: dout <= 12'h29b;
    9'd274: dout <= 12'hcd1;
    9'd275: dout <= 12'h30 ;
    9'd276: dout <= 12'he9 ;
    9'd277: dout <= 12'hc18;
    9'd278: dout <= 12'h2f4;
    9'd279: dout <= 12'ha0d;
    9'd280: dout <= 12'h86c;
    9'd281: dout <= 12'h495;
    9'd282: dout <= 12'hbc7;
    9'd283: dout <= 12'h13a;
    9'd284: dout <= 12'hbea;
    9'd285: dout <= 12'h117;
    9'd286: dout <= 12'h6a7;
    9'd287: dout <= 12'h65a;
    9'd288: dout <= 12'h673;
    9'd289: dout <= 12'h68e;
    9'd290: dout <= 12'hae5;
    9'd291: dout <= 12'h21c;
    9'd292: dout <= 12'h6fd;
    9'd293: dout <= 12'h604;
    9'd294: dout <= 12'h737;
    9'd295: dout <= 12'h5ca;
    9'd296: dout <= 12'h3b8;
    9'd297: dout <= 12'h949;
    9'd298: dout <= 12'h5b5;
    9'd299: dout <= 12'h74c;
    9'd300: dout <= 12'ha7f;
    9'd301: dout <= 12'h282;
    9'd302: dout <= 12'h3ab;
    9'd303: dout <= 12'h956;
    9'd304: dout <= 12'h904;
    9'd305: dout <= 12'h3fd;
    9'd306: dout <= 12'h985;
    9'd307: dout <= 12'h37c;
    9'd308: dout <= 12'h954;
    9'd309: dout <= 12'h3ad;
    9'd310: dout <= 12'h2dd;
    9'd311: dout <= 12'ha24;
    9'd312: dout <= 12'h921;
    9'd313: dout <= 12'h3e0;
    9'd314: dout <= 12'h10c;
    9'd315: dout <= 12'hbf5;
    9'd316: dout <= 12'h281;
    9'd317: dout <= 12'ha80;
    9'd318: dout <= 12'h630;
    9'd319: dout <= 12'h6d1;
    9'd320: dout <= 12'h8fa;
    9'd321: dout <= 12'h407;
    9'd322: dout <= 12'h7f5;
    9'd323: dout <= 12'h50c;
    9'd324: dout <= 12'hc94;
    9'd325: dout <= 12'h6d ;
    9'd326: dout <= 12'h177;
    9'd327: dout <= 12'hb8a;
    9'd328: dout <= 12'h9f5;
    9'd329: dout <= 12'h30c;
    9'd330: dout <= 12'h82a;
    9'd331: dout <= 12'h4d7;
    9'd332: dout <= 12'h66d;
    9'd333: dout <= 12'h694;
    9'd334: dout <= 12'h427;
    9'd335: dout <= 12'h8da;
    9'd336: dout <= 12'h13f;
    9'd337: dout <= 12'hbc2;
    9'd338: dout <= 12'had5;
    9'd339: dout <= 12'h22c;
    9'd340: dout <= 12'h2f5;
    9'd341: dout <= 12'ha0c;
    9'd342: dout <= 12'h833;
    9'd343: dout <= 12'h4ce;
    9'd344: dout <= 12'h231;
    9'd345: dout <= 12'had0;
    9'd346: dout <= 12'h9a2;
    9'd347: dout <= 12'h35f;
    9'd348: dout <= 12'ha22;
    9'd349: dout <= 12'h2df;
    9'd350: dout <= 12'haf4;
    9'd351: dout <= 12'h20d;
    9'd352: dout <= 12'h444;
    9'd353: dout <= 12'h8bd;
    9'd354: dout <= 12'h193;
    9'd355: dout <= 12'hb6e;
    9'd356: dout <= 12'h402;
    9'd357: dout <= 12'h8ff;
    9'd358: dout <= 12'h477;
    9'd359: dout <= 12'h88a;
    9'd360: dout <= 12'h866;
    9'd361: dout <= 12'h49b;
    9'd362: dout <= 12'had7;
    9'd363: dout <= 12'h22a;
    9'd364: dout <= 12'h376;
    9'd365: dout <= 12'h98b;
    9'd366: dout <= 12'h6ba;
    9'd367: dout <= 12'h647;
    9'd368: dout <= 12'h4bc;
    9'd369: dout <= 12'h845;
    9'd370: dout <= 12'h752;
    9'd371: dout <= 12'h5af;
    9'd372: dout <= 12'h405;
    9'd373: dout <= 12'h8fc;
    9'd374: dout <= 12'h83e;
    9'd375: dout <= 12'h4c3;
    9'd376: dout <= 12'hb77;
    9'd377: dout <= 12'h18a;
    9'd378: dout <= 12'h375;
    9'd379: dout <= 12'h98c;
    9'd380: dout <= 12'h86a;
    9'd381: dout <= 12'h497;
    default: dout <= 12'h0;
    endcase
end

endmodule
