
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
                         output reg [3:0]  raddr0,raddr1,
                         output reg [3:0]  waddr0,waddr1,
                         output reg        wen0  ,wen1  ,
                         output reg        brsel0,brsel1,
                         output reg        brselen0,brselen1,
                         output reg [2:0]  stage_count,
                         output reg [2:0]  stage_count_pwm,
                         output reg [6:0]  raddr_tw);

// ---------------------------------------------------------------------------

// Control signals
reg [2:0] c_stage;
reg [2:0] c_loop;
reg [2:0] c_pwm;
reg [6:0] c_tw;

reg       c_stl;

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
parameter STL1 = 3'b101;
parameter STL2 = 3'b110;

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
        if((c_stage == 3'd6) && (c_loop == 3'd7))
            next_state = IDLE;
        else if((c_stage <= 3'd2) && (c_loop == 3'd7))
            next_state = STL0;
        else
            next_state = FNTT;
    end
    // ---------------------------------------- PWM2
    PWM2: begin
        if((c_pwm == 3'd4) && (c_loop == 3'd7))
            next_state = IDLE;
        else
            next_state = PWM2;
    end
    // ---------------------------------------- INTT
    INTT: begin
        if((c_stage == 3'd6) && (c_loop == 3'd7))
            next_state = IDLE;
        else if((c_stage <= 3'd2) && (c_loop == 3'd7))
            next_state = STL1;
        else if(((c_stage == 3'd4) || (c_stage == 3'd5)) && (c_loop == 3'd7))
            next_state = STL2;
        else
            next_state = INTT;
    end
    STL0: begin
        next_state = (c_stl == 1'd1) ? FNTT : STL0;
    end
    STL1: begin
        next_state = INTT;
    end
    STL2: begin
        next_state = (c_stl == 1'd1) ? INTT : STL2;
    end
    // ---------------------------------------- Default
    default: begin
        next_state = IDLE;
    end
    endcase
end

// --------------------------------------------------------------------------- c_stl

always @(posedge clk or posedge reset) begin
    if(reset) begin
        c_stl <= 0;
    end
    else begin
        if((curr_state == STL0) || (curr_state == STL2))
            c_stl <= (c_stl == 1'd1) ? 0 : (c_stl+1'd1);
        else
            c_stl <= 0;
    end
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
            c_tw    <= (start_intt) ? 7'd39 : ((start_pwm2) ? 7'd78 : 0);
        end
        else if(curr_state == FNTT) begin
            // ------------------------------- c_stage
            if((c_loop == 3'd7) && (c_stage <= 3'd2))
                c_stage <= c_stage;
            else if(c_loop == 3'd7)
                c_stage <= (c_stage == 3'd6) ? 3'd6 : (c_stage + 3'd1);
            else
                c_stage <= c_stage;
            // ------------------------------- c_loop
            if((c_loop == 3'd7) && (c_stage <= 3'd2))
                c_loop <= c_loop;
            else if(c_loop == 3'd7)
                c_loop <= 3'd0;
            else
                c_loop <= c_loop + 3'd1;
            // ------------------------------- c_tw
            if((c_loop == 3'd7) && (c_stage <= 3'd2))
                c_tw <= c_tw;
            else if (c_loop == 3'd7) begin
                c_tw <= c_tw+7'd1;
            end
            else begin
                case(c_stage)
                0: begin c_tw <= c_tw; end
                1: begin c_tw <= (c_loop[1:0] == 2'd3) ? (c_tw+7'd1) : c_tw; end
                2: begin c_tw <= (c_loop[0:0] == 1'b1) ? (c_tw+7'd1) : c_tw; end
                3: begin c_tw <= c_tw+7'd1; end
                4: begin c_tw <= c_tw+7'd1; end
                5: begin c_tw <= c_tw+7'd1; end
                6: begin c_tw <= c_tw+7'd1; end
                endcase
            end
        end
        else if(curr_state == PWM2) begin
            c_stage <= 0;
            c_loop  <= (c_pwm == 3'd4) ? (c_loop+3'd1) : c_loop;
            c_pwm   <= (c_pwm == 3'd4) ? 3'd0 : (c_pwm+3'd1);
            c_tw    <= (c_pwm == 3'd4) ? (c_tw+7'd1) : c_tw;
        end
        else if(curr_state == INTT) begin
            // ------------------------------- c_stage
            if((c_loop == 3'd7) && (c_stage <= 3'd2))
                c_stage <= c_stage;
            else if((c_loop == 3'd7) && ((c_stage == 3'd4) || (c_stage == 3'd5)))
                c_stage <= c_stage;
            else if(c_loop == 3'd7)
                c_stage <= (c_stage == 3'd6) ? 3'd6 : (c_stage + 3'd1);
            else
                c_stage <= c_stage;
            // ------------------------------- c_loop
            if((c_loop == 3'd7) && ((c_stage == 3'd4) || (c_stage == 3'd5)))
                c_loop <= c_loop;
            else if(c_loop == 3'd7)
                c_loop <= 3'd0;
            else
                c_loop <= c_loop + 3'd1;
            // ------------------------------- c_tw
            if((c_loop == 3'd7) && ((c_stage == 3'd4) || (c_stage == 3'd5)))
                c_tw <= c_tw;
            else if (c_loop == 3'd7) begin
                c_tw <= c_tw+7'd1;
            end
            else begin
                case(c_stage)
                0: begin c_tw <= c_tw+7'd1; end
                1: begin c_tw <= c_tw+7'd1; end
                2: begin c_tw <= c_tw+7'd1; end
                3: begin c_tw <= c_tw+7'd1; end
                4: begin c_tw <= (c_loop[0] == 1'b0) ? (c_tw+7'd1) : (c_tw-7'd1 + ((c_loop[1:0]==2'd3)<<1)); end
                5: begin c_tw <= (c_loop[0] == 1'b0) ? (c_tw+7'd1) : (c_tw-7'd1); end
                6: begin c_tw <= c_tw; end
                endcase
            end
        end
        else if(curr_state == STL0) begin
            c_stage <= (c_stl == 1'd0) ? c_stage : c_stage+3'd1;
            c_loop  <= (c_stl == 1'd0) ? c_loop  : 0;
            c_pwm   <= (c_stl == 1'd0) ? c_pwm   : c_pwm;
            c_tw    <= (c_stl == 1'd0) ? c_tw    : c_tw+1;
        end
        else if(curr_state == STL1) begin
            c_stage <= c_stage+3'd1;
            c_loop  <= c_loop;
            c_pwm   <= c_pwm;
            c_tw    <= c_tw;
        end
        else if(curr_state == STL2) begin
            c_stage <= (c_stl == 1'd0) ? c_stage : c_stage+3'd1;
            c_loop  <= (c_stl == 1'd0) ? c_loop  : 0;
            c_pwm   <= (c_stl == 1'd0) ? c_pwm   : c_pwm;
            c_tw    <= (c_stl == 1'd0) ? c_tw    : c_tw+1;
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

reg [3:0] raddr;
reg [3:0] waddre,waddro;
reg       wen;
reg       brsel;
reg       brselen;

// --------------------------------------------------------------------------- raddr (c_loop)
always @(posedge clk or posedge reset) begin
    if(reset) begin
        raddr[3] <= 0; // alternating addressing between stages
    end
    else begin
        if(start_fntt || start_pwm2 || start_intt) begin
            raddr[3] <= (start_fntt) ? 0 : 1;
        end
        else if((raddr[2:0] == 3'd7) && ((curr_state == FNTT) || (curr_state == INTT))) begin
            // negate for next stage
            raddr[3] <= ~raddr[3];
        end
        else begin
            // otherwise, keep it
            raddr[3] <= raddr[3];
        end
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        raddr[2:0] <= 0;
    end
    else begin
        if(start_fntt || start_pwm2 || start_intt) begin
            raddr[2:0] <= 0;
        end
        else if(curr_state == FNTT) begin
            if(c_stage > 3'd1)
                raddr[2:0] <= c_loop;
            else begin
                raddr[2:0] <= ((c_loop>>1) & ((1<<(3'd2-c_stage))-1))
                            + (c_loop[0] << (3'd2-c_stage))
                            + ((c_loop>>(3'd3-c_stage)) << (3'd3-c_stage));
            end
        end
        else if(curr_state == PWM2) begin
            raddr[2:0] <= c_loop;
        end
        else if(curr_state == INTT) begin
            if(c_stage < 3'd4)
                raddr[2:0] <= c_loop;
            else if(c_stage == 3'd6)
                raddr[2:0] <= c_loop;
            else begin
                raddr[2:0] <= ((c_loop>>1) & ((1<<(c_stage-3'd3))-1))
                            + (c_loop[0] << (c_stage-3'd3))
                            + ((c_loop>>(c_stage-3'd2)) << (c_stage-3'd2));
            end
        end
        else if(curr_state == STL0) begin
            raddr[2:0] <= raddr[2:0];
        end
        else if(curr_state == STL1) begin
            raddr[2:0] <= raddr[2:0];
        end
        else if(curr_state == STL2) begin
            raddr[2:0] <= raddr[2:0];
        end
        else begin
            raddr[2:0] <= 0;
        end
    end
end

// --------------------------------------------------------------------------- waddr,wen,brsel (c_loop)

always @(posedge clk or posedge reset) begin
    if(reset) begin
        waddre[3] <= 0;
        waddro[3] <= 0;
    end
    else begin
        // waddre[5] and waddro[5]
        if(start_fntt || start_pwm2 || start_intt) begin
            waddre[3] <= (start_fntt || start_pwm2) ? 1 : 0;
            waddro[3] <= (start_fntt || start_pwm2) ? 1 : 0;
        end
        else if((waddro[2:0] == 3'd7) && (c_loop == 3'd0) && ((curr_state == FNTT) || (curr_state == INTT))) begin
            // negate for next stage
            waddre[3] <= ~waddre[3];
            waddro[3] <= ~waddro[3];
        end
        else begin
            // otherwise, keep it
            waddre[3] <= waddre[3];
            waddro[3] <= waddro[3];
        end
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        waddre[2:0] <= 0;
        waddro[2:0] <= 0;
        wen         <= 0;
        brsel       <= 0;
        brselen     <= 0;
    end
    else begin
        if(start_fntt || start_pwm2 || start_intt) begin
            waddre[2:0] <= 0;
            waddro[2:0] <= 0;
            wen         <= 0;
            brsel       <= 0;
            brselen     <= 0;
        end
        else if (curr_state == FNTT)begin
            if(c_stage > 3'd2) begin
                waddre[2:0] <= c_loop;
                waddro[2:0] <= c_loop;
            end
            else begin
                waddre[2:0] <= (c_loop>>1) + ((c_loop>>(3'd3-c_stage)) << (3'd2-c_stage));
                waddro[2:0] <= (c_loop>>1) + ((c_loop>>(3'd3-c_stage)) << (3'd2-c_stage)) + (1 << (3'd2-c_stage));
            end
            wen         <= 1;
            brsel       <= c_loop[0];
            brselen     <= 1;
        end
        else if (curr_state == PWM2) begin
            waddre[2:0] <= c_loop;
            waddro[2:0] <= c_loop;
            wen         <= (c_pwm == 3'd3) ? 1 : 0; // this will be set!
            brsel       <= 0;
            brselen     <= 0;
        end
        else if (curr_state == INTT) begin
            if(c_stage < 3'd3) begin
                waddre[2:0] <= c_loop;
                waddro[2:0] <= c_loop;
            end
            else if(c_stage == 3'd6) begin
                waddre[2:0] <= c_loop;
                waddro[2:0] <= c_loop;
            end
            else begin
                waddre[2:0] <= (c_loop>>1) + ((c_loop>>(c_stage-3'd2)) << (c_stage-3'd3));
                waddro[2:0] <= (c_loop>>1) + ((c_loop>>(c_stage-3'd2)) << (c_stage-3'd3)) + (1 << (c_stage-3'd3));
            end
            wen         <= 1;
            brsel       <= c_loop[0];
            brselen     <= 1;
        end
        else if(curr_state == STL0) begin
            waddre[2:0] <= waddre[2:0];
            waddro[2:0] <= waddro[2:0];
            wen         <= 0;
            brsel       <= 0;
            brselen     <= 0;
        end
        else if(curr_state == STL1) begin
            waddre[2:0] <= waddre[2:0];
            waddro[2:0] <= waddro[2:0];
            wen         <= 0;
            brsel       <= 0;
            brselen     <= 0;
        end
        else if(curr_state == STL2) begin
            waddre[2:0] <= waddre[2:0];
            waddro[2:0] <= waddro[2:0];
            wen         <= 0;
            brsel       <= 0;
            brselen     <= 0;
        end
        else begin
            waddre[2:0] <= 0;
            waddro[2:0] <= 0;
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
            b_pwm <= (c_pwm == 3'd4) ? 1 : 0;
        else
            b_pwm <= 0;
    end
end

// --------------------------------------------------------------------------- delays

wire       ctd0;
wire       pwmd0;
wire [3:0] waddrd0;
wire [3:0] waddrd1;
wire       wend0;
wire       wend1;
wire       brseld0;
wire       brseld1;
wire       brselend0;
wire       brselend1;
wire [2:0] stage_countd0;
wire [2:0] stage_count_pwmd0;
wire [6:0] raddr_twd0;

shiftreg #(.SHIFT(1),.DATA(1)) sre00(clk,reset,b_ct   ,ctd0);
shiftreg #(.SHIFT(1),.DATA(1)) sre01(clk,reset,b_pwm  ,pwmd0);
shiftreg #(.SHIFT(5),.DATA(4)) sre02(clk,reset,waddre ,waddrd0);
shiftreg #(.SHIFT(6),.DATA(4)) sre03(clk,reset,waddro ,waddrd1);
shiftreg #(.SHIFT(5),.DATA(1)) sre04(clk,reset,wen    ,wend0);
shiftreg #(.SHIFT(6),.DATA(1)) sre05(clk,reset,wen    ,wend1);
shiftreg #(.SHIFT(5),.DATA(1)) sre06(clk,reset,brsel  ,brseld0);
shiftreg #(.SHIFT(6),.DATA(1)) sre07(clk,reset,brsel  ,brseld1);
shiftreg #(.SHIFT(5),.DATA(1)) sre08(clk,reset,brselen,brselend0);
shiftreg #(.SHIFT(6),.DATA(1)) sre09(clk,reset,brselen,brselend1);
shiftreg #(.SHIFT(6),.DATA(3)) sre10(clk,reset,c_stage,stage_countd0);
shiftreg #(.SHIFT(2),.DATA(3)) sre11(clk,reset,c_pwm,  stage_count_pwmd0);
shiftreg #(.SHIFT(1),.DATA(7)) sre12(clk,reset,c_tw   ,raddr_twd0);

// --------------------------------------------------------------------------- outputs
// raddr (tw)
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
