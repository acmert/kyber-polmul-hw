
module modsub(input [11:0] A,B,
              output[11:0] C);

wire signed [12:0] R;
wire signed [12:0] Rq;

assign R = A - B;
assign Rq= R + 13'd3329;

assign C = (R[12] == 0) ? R[11:0] : Rq[11:0];

endmodule
