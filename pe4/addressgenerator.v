
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

module addressgenerator (input             clk,reset,
                         input             start_fntt,start_pwm2,start_intt,
                         output reg        ct,
                         output reg        pwm,
                         output reg [5:0]  raddr0,raddr1,
                         output reg [5:0]  waddr0,waddr1,
                         output reg        wen0  ,wen1  ,
                         output reg        brsel0,brsel1,
                         output reg        brselen0,brselen1,
                         output reg [2:0]  stage_count,
                         output reg [2:0]  stage_count_pwm,
                         output reg [7:0]  raddr_tw);

// ---------------------------------------------------------------------------

// Control signals
reg [2:0] c_stage;
reg [4:0] c_loop;
reg [2:0] c_pwm;
reg [7:0] c_tw;

// ---------------------------------------------------------------------------
// FSM
/*
FSM:

-- IDLE
-- NTT
-- PWM
-- INTT

*/

parameter IDLE = 3'b000;
parameter FNTT = 3'b001;
parameter PWM2 = 3'b010;
parameter INTT = 3'b011;
parameter STL0 = 3'b100;
parameter STL1 = 3'b110;

reg [2:0] curr_state,next_state;

always @(posedge clk or posedge reset) begin
    if(reset)
        curr_state <= 0;
    else
        curr_state <= next_state;
end

always @(*) begin
    case(curr_state)
	// ---------------------------------------- IDLE
	IDLE: begin
        if(start_fntt)
            next_state = FNTT;
        else if(start_pwm2)
            next_state = PWM2;
        else if(start_intt)
            next_state = INTT;
        else
            next_state = IDLE;
    end
    // ---------------------------------------- FNTT
    FNTT: begin
        if((c_stage == 3'd6) && (c_loop == 5'd31))
            next_state = IDLE;
        else if((c_stage == 3'd4) && (c_loop == 5'd31))
            next_state = STL0;
        else
            next_state = FNTT;
    end
    // ---------------------------------------- PWM2
    PWM2: begin
        if((c_pwm == 3'd4) && (c_loop == 5'd31))
            next_state = IDLE;
        else
            next_state = PWM2;
    end
    // ---------------------------------------- INTT
    INTT: begin
        if((c_stage == 3'd6) && (c_loop == 5'd31))
            next_state = IDLE;
        else if((c_stage == 3'd0) && (c_loop == 5'd31))
            next_state = STL1;
        else
            next_state = INTT;
    end
    STL0: begin
        next_state = FNTT;
    end
    STL1: begin
        next_state = INTT;
    end
    // ---------------------------------------- Default
    default: begin
        next_state = IDLE;
    end
    endcase
end

// ---------------------------------------------------------------------------
// Control operations

// counters (NTT)
always @(posedge clk or posedge reset) begin
    if(reset) begin
        c_stage <= 0;
        c_loop  <= 0;
        c_pwm   <= 0;
        c_tw    <= 0;
    end
    else begin
        if(start_fntt || start_pwm2 || start_intt) begin
            c_stage <= 0;
            c_loop  <= 0;
            c_pwm   <= 0;
            c_tw    <= (start_intt) ? 8'd95 : ((start_pwm2) ? 8'd190 : 0);
        end
        else if(curr_state == FNTT) begin
            // ------------------------------- c_stage
            if((c_loop == 5'd31) && (c_stage == 3'd4))
                c_stage <= c_stage;
            else if(c_loop == 5'd31)
                c_stage <= (c_stage == 3'd6) ? 3'd6 : (c_stage + 3'd1);
            else
                c_stage <= c_stage;
            // ------------------------------- c_loop
            if(c_loop == 5'd31)
                c_loop <= 5'd0;
            else
                c_loop <= c_loop + 5'd1;
            // ------------------------------- c_tw
            if (c_loop == 5'd31) begin
                c_tw <= c_tw+1;
            end
            else begin
                case(c_stage)
                0: begin c_tw <= c_tw; end
                1: begin c_tw <= (c_loop[3:0] == 4'd15) ? (c_tw+8'd1) : c_tw; end
                2: begin c_tw <= (c_loop[2:0] == 3'd7)  ? (c_tw+8'd1) : c_tw; end
                3: begin c_tw <= (c_loop[1:0] == 2'd3)  ? (c_tw+8'd1) : c_tw; end
                4: begin c_tw <= (c_loop[0:0] == 1'b1)  ? (c_tw+8'd1) : c_tw; end
                5: begin c_tw <= c_tw+8'd1; end
                6: begin c_tw <= c_tw+8'd1; end
                endcase
            end
        end
        else if(curr_state == PWM2) begin
            c_stage <= 0;
            c_loop  <= (c_pwm == 3'd4) ? (c_loop+5'd1) : c_loop;
            c_pwm   <= (c_pwm == 3'd4) ? 3'd0 : (c_pwm+3'd1);
            c_tw    <= (c_pwm == 3'd4) ? (c_tw+8'd1) : c_tw;
        end
        else if(curr_state == INTT) begin
            // ------------------------------- c_stage
            if((c_loop == 5'd31) && (c_stage == 0))
                c_stage <= c_stage;
            else if(c_loop == 5'd31)
                c_stage <= (c_stage == 3'd6) ? 3'd6 : (c_stage + 3'd1);
            else
                c_stage <= c_stage;
            // ------------------------------- c_loop
            if(c_loop == 5'd31)
                c_loop <= 5'd0;
            else
                c_loop <= c_loop + 5'd1;
            // ------------------------------- c_tw
            if (c_loop == 5'd31) begin
                c_tw <= c_tw+8'd1;
            end
            else begin
                case(c_stage)
                0: begin c_tw <= c_tw+8'd1; end
                1: begin c_tw <= c_tw+8'd1; end
                2: begin c_tw <= (c_loop[0] == 1'b0) ? (c_tw+8'd1) : (c_tw-8'd1 + ((c_loop[1:0]==5'd3)<<1)); end
                3: begin c_tw <= (c_loop[0] == 1'b0) ? (c_tw+8'd1) : (c_tw-8'd1 + ((c_loop[2:0]==5'd7)<<1)); end
                4: begin c_tw <= (c_loop[0] == 1'b0) ? (c_tw+8'd1) : (c_tw-8'd1 + ((c_loop[3:0]==5'd15)<<1)); end
                5: begin c_tw <= (c_loop[0] == 1'b0) ? (c_tw+8'd1) : (c_tw-8'd1); end
                6: begin c_tw <= c_tw; end
                endcase
            end
        end
        else if(curr_state == STL0) begin
            c_stage <= c_stage+3'd1;
            c_loop  <= c_loop;
            c_pwm   <= c_pwm;
            c_tw    <= c_tw;
        end
        else if(curr_state == STL1) begin
            c_stage <= c_stage+3'd1;
            c_loop  <= c_loop;
            c_pwm   <= c_pwm;
            c_tw    <= c_tw;
        end
        else begin // curr_state == IDLE
            c_stage <= 0;
            c_loop  <= 0;
            c_pwm   <= 0;
            c_tw    <= 0;
        end
    end
end


// --------------------------------------------------------------------------- signals

reg [5:0] raddr;
reg [5:0] waddre,waddro;
reg       wen;
reg       brsel;
reg       brselen;

// --------------------------------------------------------------------------- raddr (c_loop)
always @(posedge clk or posedge reset) begin
    if(reset) begin
        raddr[5] <= 0; // alternating addressing between stages
    end
    else begin
        if(start_fntt || start_pwm2 || start_intt) begin
            raddr[5] <= (start_fntt) ? 0 : 1;
        end
        else if((raddr[4:0] == 5'd31) && ((curr_state == FNTT) || (curr_state == INTT))) begin
            // negate for next stage
            raddr[5] <= ~raddr[5];
        end
        else begin
            // otherwise, keep it
            raddr[5] <= raddr[5];
        end
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        raddr[4:0] <= 0;
    end
    else begin
        if(start_fntt || start_pwm2 || start_intt) begin
            raddr[4:0] <= 0;
        end
        else if(curr_state == FNTT) begin
            if(c_stage >3'd3)
                raddr[4:0] <= c_loop;
            else begin
                raddr[4:0] <= ((c_loop>>1) & ((1<<(3'd4-c_stage))-1))
                            + (c_loop[0] << (3'd4-c_stage))
                            + ((c_loop>>(3'd5-c_stage)) << (3'd5-c_stage));
            end
        end
        else if(curr_state == PWM2) begin
            raddr[4:0] <= c_loop;
        end
        else if(curr_state == INTT) begin
            if(c_stage < 3'd2)
                raddr[4:0] <= c_loop;
            else if(c_stage == 3'd6)
                raddr[4:0] <= c_loop;
            else begin
                raddr[4:0] <= ((c_loop>>1) & ((1<<(c_stage-3'd1))-1))
                            + (c_loop[0] << (c_stage-3'd1))
                            + ((c_loop>>(c_stage)) << (c_stage));
            end
        end
        else if(curr_state == STL0) begin
            raddr[4:0] <= raddr[4:0];
        end
        else if(curr_state == STL1) begin
            raddr[4:0] <= raddr[4:0];
        end
        else begin
            raddr[4:0] <= 0;
        end
    end
end

// --------------------------------------------------------------------------- waddr,wen,brsel (c_loop)

always @(posedge clk or posedge reset) begin
    if(reset) begin
        waddre[5] <= 0;
        waddro[5] <= 0;
    end
    else begin
        if(start_fntt || start_pwm2 || start_intt) begin
            waddre[5] <= (start_fntt || start_pwm2) ? 1 : 0;
            waddro[5] <= (start_fntt || start_pwm2) ? 1 : 0;
        end
        else if((waddro[4:0] == 5'd31) && (c_loop == 0) && ((curr_state == FNTT) || (curr_state == INTT))) begin
            // negate for next stage
            waddre[5] <= ~waddre[5];
            waddro[5] <= ~waddro[5];
        end
        else begin
            // otherwise, keep it
            waddre[5] <= waddre[5];
            waddro[5] <= waddro[5];
        end
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        waddre[4:0] <= 0;
        waddro[4:0] <= 0;
        wen         <= 0;
        brsel       <= 0;
        brselen     <= 0;
    end
    else begin
        if(start_fntt || start_pwm2 || start_intt) begin
            waddre[4:0] <= 0;
            waddro[4:0] <= 0;
            wen         <= 0;
            brsel       <= 0;
            brselen     <= 0;
        end
        else if (curr_state == FNTT)begin
            if(c_stage > 3'd4) begin
                waddre[4:0] <= c_loop;
                waddro[4:0] <= c_loop;
            end
            else begin
                waddre[4:0] <= (c_loop>>1) + ((c_loop>>(3'd5-c_stage)) << (3'd4-c_stage));
                waddro[4:0] <= (c_loop>>1) + ((c_loop>>(3'd5-c_stage)) << (3'd4-c_stage)) + (1 << (3'd4-c_stage));
            end
            wen         <= 1;
            brsel       <= c_loop[0];
            brselen     <= 1;
        end
        else if (curr_state == PWM2) begin
            waddre[4:0] <= c_loop;
            waddro[4:0] <= c_loop;
            wen         <= (c_pwm == 3'd3) ? 1 : 0; // this will be set!
            brsel       <= 0;
            brselen     <= 0;
        end
        else if (curr_state == INTT) begin
            if(c_stage < 3'd1) begin
                waddre[4:0] <= c_loop;
                waddro[4:0] <= c_loop;
            end
            else if(c_stage == 3'd6) begin
                waddre[4:0] <= c_loop;
                waddro[4:0] <= c_loop;
            end
            else begin
                waddre[4:0] <= (c_loop>>1) + ((c_loop>>(c_stage)) << (c_stage-3'd1));
                waddro[4:0] <= (c_loop>>1) + ((c_loop>>(c_stage)) << (c_stage-3'd1)) + (1 << (c_stage-3'd1));
            end
            wen         <= 1;
            brsel       <= c_loop[0];
            brselen     <= 1;
        end
        else if(curr_state == STL0) begin
            waddre[4:0] <= waddre[4:0];
            waddro[4:0] <= waddro[4:0];
            wen         <= 0;
            brsel       <= 0;
            brselen     <= 0;
        end
        else if(curr_state == STL1) begin
            waddre[4:0] <= waddre[4:0];
            waddro[4:0] <= waddro[4:0];
            wen         <= 0;
            brsel       <= 0;
            brselen     <= 0;
        end
        else begin
            waddre[4:0] <= 0;
            waddro[4:0] <= 0;
            wen         <= 0;
            brsel       <= 0;
            brselen     <= 0;
        end
    end
end

reg b_ct;
reg b_pwm;

// --------------------------------------------------------------------------- ct, pwm
always @(posedge clk or posedge reset) begin
    if(reset) begin
        b_ct  <= 0;
        b_pwm <= 0;
    end
    else begin
        if((curr_state == FNTT) || (curr_state == PWM2))
            b_ct <= 1;
        else if(curr_state == INTT)
            b_ct <= 0;
        else
            b_ct <= b_ct;

        if(curr_state == PWM2)
            b_pwm <= (c_pwm == 4) ? 1 : 0;
        else
            b_pwm <= 0;
    end
end

// --------------------------------------------------------------------------- delays

wire       ctd0;
wire       pwmd0;
wire [5:0] waddrd0;
wire [5:0] waddrd1;
wire       wend0;
wire       wend1;
wire       brseld0;
wire       brseld1;
wire       brselend0;
wire       brselend1;
wire [2:0] stage_countd0;
wire [2:0] stage_count_pwmd0;
wire [7:0] raddr_twd0;

shiftreg #(.SHIFT(1),.DATA(1)) sre00(clk,reset,b_ct   ,ctd0);
shiftreg #(.SHIFT(1),.DATA(1)) sre01(clk,reset,b_pwm  ,pwmd0);
shiftreg #(.SHIFT(5),.DATA(6)) sre02(clk,reset,waddre ,waddrd0);
shiftreg #(.SHIFT(6),.DATA(6)) sre03(clk,reset,waddro ,waddrd1);
shiftreg #(.SHIFT(5),.DATA(1)) sre04(clk,reset,wen    ,wend0);
shiftreg #(.SHIFT(6),.DATA(1)) sre05(clk,reset,wen    ,wend1);
shiftreg #(.SHIFT(5),.DATA(1)) sre06(clk,reset,brsel  ,brseld0);
shiftreg #(.SHIFT(6),.DATA(1)) sre07(clk,reset,brsel  ,brseld1);
shiftreg #(.SHIFT(5),.DATA(1)) sre08(clk,reset,brselen,brselend0);
shiftreg #(.SHIFT(6),.DATA(1)) sre09(clk,reset,brselen,brselend1);
shiftreg #(.SHIFT(6),.DATA(3)) sre10(clk,reset,c_stage,stage_countd0);
shiftreg #(.SHIFT(2),.DATA(3)) sre11(clk,reset,c_pwm  ,stage_count_pwmd0);
shiftreg #(.SHIFT(1),.DATA(8)) sre12(clk,reset,c_tw   ,raddr_twd0);

// --------------------------------------------------------------------------- outputs

always @(posedge clk or posedge reset) begin
    if(reset) begin
        ct              <= 0;
        pwm             <= 0;
        raddr0          <= 0;
        raddr1          <= 0;
        waddr0          <= 0;
        waddr1          <= 0;
        wen0            <= 0;
        wen1            <= 0;
        brsel0          <= 0;
        brsel1          <= 0;
        brselen0        <= 0;
        brselen1        <= 0;
        stage_count     <= 0;
        stage_count_pwm <= 0;
    end
    else begin
        ct              <= ctd0;
        pwm             <= pwmd0;
        raddr0          <= raddr;
        raddr1          <= raddr;
        waddr0          <= waddrd0;
        waddr1          <= waddrd1;
        wen0            <= wend0;
        wen1            <= wend1;
        brsel0          <= brseld0;
        brsel1          <= brseld1;
        brselen0        <= brselend0;
        brselen1        <= brselend1;
        stage_count     <= stage_countd0;
        stage_count_pwm <= stage_count_pwmd0;
    end
end

always @(*) begin
    raddr_tw = raddr_twd0;
end

endmodule
