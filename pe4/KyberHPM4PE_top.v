
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

module KyberHPM4PE_top #(parameter PE_NUMBER=4)
                        (input                         clk,reset,
                         input                         load_a_f,load_a_i,
                         input                         load_b_f,load_b_i,
                         input                         read_a,read_b,
                         input                         start_ab,
                         input                         start_fntt,start_pwm2,start_intt,
                         input      [12*PE_NUMBER-1:0] din,  // 0,1,2,3
                         output reg [12*PE_NUMBER-1:0] dout, // 0,1,2,3
                         output reg                    done
                        );

// Connections
reg                     load_a_f_R,load_a_i_R;
reg                     load_b_f_R,load_b_i_R;
reg                     read_a_R,read_b_R;
reg                     start_ab_R;
reg                     start_fntt_R,start_pwm2_R,start_intt_R;
reg  [12*PE_NUMBER-1:0] din_R;
wire [12*PE_NUMBER-1:0] dout_W;
wire                    done_W;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        load_a_f_R   <= 0;
        load_a_i_R   <= 0;
        load_b_f_R   <= 0;
        load_b_i_R   <= 0;
        read_a_R     <= 0;
        read_b_R     <= 0;
        start_ab_R   <= 0;
        start_fntt_R <= 0;
        start_pwm2_R <= 0;
        start_intt_R <= 0;
        din_R        <= 0;
        dout         <= 0;
        done         <= 0;
    end
    else begin
        load_a_f_R   <= load_a_f  ;
        load_a_i_R   <= load_a_i  ;
        load_b_f_R   <= load_b_f  ;
        load_b_i_R   <= load_b_i  ;
        read_a_R     <= read_a    ;
        read_b_R     <= read_b    ;
        start_ab_R   <= start_ab  ;
        start_fntt_R <= start_fntt;
        start_pwm2_R <= start_pwm2;
        start_intt_R <= start_intt;
        din_R        <= din       ;
        dout         <= dout_W    ;
        done         <= done_W    ;
    end
end

KyberHPM4PE unit
    (
    clk,reset,
    load_a_f_R,load_a_i_R,
    load_b_f_R,load_b_i_R,
    read_a_R,read_b_R,
    start_ab_R,
    start_fntt_R,start_pwm2_R,start_intt_R,
    din_R,
    dout_W,
    done_W
    );

endmodule
