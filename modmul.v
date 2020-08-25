
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
