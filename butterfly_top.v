
module butterfly_top(input            clk,rst,
                     input            CT,
                     input     [11:0] A,B,W,
                     output reg[11:0] E,O,       // butterfly outputs
                     output reg[11:0] MUL,       // modular mul output
                     output reg[11:0] ADD,SUB);
//

reg        CT_R;
reg [11:0] A_R,B_R,W_R;
wire[11:0] E_W,O_W;
wire[11:0] MUL_W;
wire[11:0] ADD_W,SUB_W;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        CT_R  <= 0;
        A_R   <= 0;
        B_R   <= 0;
        W_R   <= 0;
        E     <= 0;
        O     <= 0;
        MUL   <= 0;
        ADD   <= 0;
        SUB   <= 0;
    end
    else begin
        CT_R  <= CT;
        A_R   <= A;
        B_R   <= B;
        W_R   <= W;
        E     <= E_W;
        O     <= O_W;
        MUL   <= MUL_W;
        ADD   <= ADD_W;
        SUB   <= SUB_W;
    end
end

butterfly tu(clk,rst,
             CT_R,
             A_R,B_R,W_R,
             E_W,O_W,
             MUL_W,
             ADD_W,SUB_W);

endmodule
