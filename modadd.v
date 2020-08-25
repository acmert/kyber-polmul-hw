
module modadd(input [11:0] A,B,
              output[11:0] C);

wire        [12:0] R;
wire signed [13:0] Rq;

assign R = A + B;
assign Rq= R - 13'd3329;

assign C = (Rq[13] == 0) ? Rq[11:0] : R[11:0];

/*

// Another approach with CSA

wire        [11:0] R;
wire        [12:0] C,S;
wire signed [12:0] Rq;

assign R = A + B;

CSA #(13) csa0({1'b0,A},{1'b0,B},13'b1001011111111,C,S);

assign Rq = C + S;

assign C = (Rq[12] == 0) ? Rq[11:0] : R;

*/

endmodule
