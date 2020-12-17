
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

// read latency is 1 cc

module BRAM(input             clk,
            input             wen,
            input      [5:0]  waddr,
            input      [11:0] din,
            input      [5:0]  raddr,
            output reg [11:0] dout);
// bram
(* ram_style="block" *) reg [11:0] blockram [63:0];

// write operation
always @(posedge clk) begin
    if(wen)
        blockram[waddr] <= din;
end

// read operation
always @(posedge clk) begin
    dout <= blockram[raddr];
end

endmodule
