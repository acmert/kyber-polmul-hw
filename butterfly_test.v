
module butterfly_test();

reg clk,rst;
reg CT;
reg [11:0] A,B,W;
wire[11:0] E,O;
wire[11:0] MUL;
wire[11:0] ADD,SUB;

butterfly uut(clk,rst,
              CT,
              A,B,W,
              E,O,
              MUL,
              ADD,SUB);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 0;
    CT  = 0;
    A   = 0;
    B   = 0;
    W   = 0;

    #200;

    rst = 1;

    #50;
    rst = 0;
    #50;

    CT = 0;
    A  = 874;
    B  = 2788;
    W  = 187;

    #10;
end

endmodule
