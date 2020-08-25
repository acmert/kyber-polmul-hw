
module div2(input [11:0] x,
            output[11:0] y);

wire [10:0] x0and;

assign x0and = {11{x[0]}} & 11'd1665;            
assign y     = x[11:1] + x0and; 

endmodule
