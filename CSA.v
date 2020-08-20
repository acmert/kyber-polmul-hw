
module CSA
       #(parameter N=15)
        (input [N-1:0] A,B,D,
         output[N-1:0] C,S);

wire [N-1:0] CC,SS;

genvar i;

generate
    for (i = 0; i < N; i = i + 1) begin
        FA f0(A[i], B[i], D[i], CC[i], SS[i]);
    end
endgenerate

assign C = {CC[N-2:0],1'b0};
assign S = SS;

endmodule

