
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

module div2(input [11:0] x,
            output[11:0] y);

wire [10:0] x0and;

assign x0and = {11{x[0]}} & 11'd1665;
assign y     = x[11:1] + x0and;

endmodule
