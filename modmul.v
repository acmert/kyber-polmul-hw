
module modmul(input             clk,rst,
              input      [11:0] A,B,
              output reg [11:0] R);

reg [11:0] A_R,B_R;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        A_R <= 0;
        B_R <= 0;
    end
    else begin
        A_R <= A;
        B_R <= B;
    end
end

// ---------------------------------------

wire [23:0] P;
reg  [23:0] P_R;

intmul im0(A_R,B_R,P);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        P_R <= 0;
    end
    else begin
        P_R <= P;
    end
end

// ---------------------------------------

wire [11:0] R_W;

modred mr0(P_R,R_W);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        R <= 0;
    end
    else begin
        R <= R_W;
    end
end

endmodule
