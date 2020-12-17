
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

module shiftreg #(parameter SHIFT = 0, DATA=32)
   (input         clk,reset,
    input  [DATA-1:0] data_in,
    output [DATA-1:0] data_out);

reg [DATA-1:0] shift_array [SHIFT-1:0];

always @(posedge clk or posedge reset) begin
    if(reset)
        shift_array[0] <= 0;
    else
        shift_array[0] <= data_in;
end

genvar shft;

generate
    for(shft=0; shft < SHIFT-1; shft=shft+1) begin: DELAY_BLOCK
        always @(posedge clk or posedge reset) begin
            if(reset)
                shift_array[shft+1] <= 0;
            else
                shift_array[shft+1] <= shift_array[shft];
        end
    end
endgenerate

assign data_out = shift_array[SHIFT-1];

endmodule
