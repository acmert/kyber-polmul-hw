
module modsub(input [11:0] A,B,
              output[11:0] C);

wire signed [12:0] R;
wire signed [12:0] Rq;

assign R = A - B;
assign Rq= R + 13'd3329;

assign C = (R[12] == 0) ? R[11:0] : Rq[11:0];

/*

// Another approach with CSA

wire        [12:0] C,S;
wire signed [12:0] R,Rq;

assign R = A - B;

CSA #(13) csa0({1'b0,A},{1'b0,!B[12],!B[11],!B[10],!B[9],!B[8],!B[7],!B[6],!B[5],!B[4],!B[3],!B[2],!B[1],!B[0]},13'b1110100000010,C,S);

assign Rq = C + S;

assign C = (R[12] == 0) ? R[11:0] : Rq[11:0];

*/

endmodule
