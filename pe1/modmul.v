
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

module modmul(input         clk,rst,
              input  [11:0] A,B,
              output [11:0] R);

wire [23:0] P;
reg  [23:0] P_R;

intmul im0(A,B,P);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        P_R <= 0;
    end
    else begin
        P_R <= P;
    end
end

// ---------------------------------------

modred mr0(P_R,R);

endmodule
