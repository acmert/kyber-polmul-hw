
/*
The designers:

Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>
Ferhat Yaman <ferhatyaman@sabanciuniv.edu>

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

/*
-- I/O Ports
* load_a_f   : HIGH for 1 cc, then 1st polynomial is loaded for FNTT operation
* load_a_i   : HIGH for 1 cc, then 1st polynomial is loaded for INTT operation
* load_b_f   : HIGH for 1 cc, then 2nd polynomial is loaded for FNTT operation
* load_b_i   : HIGH for 1 cc, then 2nd polynomial is loaded for INTT operation
* read_a     : HIGH for 1 cc, then read 1st polynomial (A)
* read_b     : HIGH for 1 cc, then read 2nd polynomial (B)
* start_ab   : HIGH for operation on 1st polynomial, LOW for operation on 2nd polynomial (with one of other start signals below)
* start_fntt : HIGH for 1 cc, then FNTT operation starts
* start_pwm2 : HIGH for 1 cc, then Coeff-wise Mult. operation starts
* start_intt : HIGH for 1 cc, then INTT operation starts
* din        : Input coefficients
* dout       : Output coefficients
* done       : HIGH for 1 cc, after operation is finished. Then, resulting coefficients are read
*/

/*
[0]       [1]       [2]       [3]       ...
[191:190] [189:178] [177:166] [165:154] ...
*/

module KyberHPM16PE #(parameter PE_NUMBER=16,
                               FNTT_CC=7'd69,
                               PWM2_CC=7'd47,
                               INTT_CC=7'd71)
               (input                         clk,reset,
                input                         load_a_f,load_a_i,
                input                         load_b_f,load_b_i,
                input                         read_a,read_b,
                input                         start_ab,
                input                         start_fntt,start_pwm2,start_intt,
                input      [12*PE_NUMBER-1:0] din,  // 0,1,2,3,...
                output reg [12*PE_NUMBER-1:0] dout, // 0,1,2,3,...
                output reg                    done
               );
// ---------------------------------------------------------------- connections

// parameters & control
/*
We have 8 states:
-- 0 : OP_IDLE        --> Idle state, waiting for input
-- 1 : OP_LOAD_DATA   --> loading input polynomial A or B for (ntt or intt)
-- 2 : OP_FNTT        --> performing FNTT operation
-- 3 : OP_PWM2        --> performing PWM2 operation
-- 4 : OP_INTT        --> performing INTT operation
-- 5 : OP_NULL        --> no-operation-defined (can be added later)
-- 6 : OP_NULL        --> no-operation-defined (can be added later)
-- 7 : OP_READ_DATA   --> reading out output polynomial
*/

parameter OP_IDLE        = 3'd0;
parameter OP_LOAD_DATA   = 3'd1;
parameter OP_FNTT        = 3'd2;
parameter OP_PWM2        = 3'd3;
parameter OP_INTT        = 3'd4;
parameter OP_NULL1       = 3'd5; // no-operation-defined
parameter OP_NULL2       = 3'd6; // no-operation-defined
parameter OP_READ_DATA   = 3'd7;

reg [2:0] curr_state,next_state;

reg [3:0]  di_cntr;  // counter for OP_LOAD_DATA/B state
reg [4:0]  do_cntr;  // counter for OP_READ_DATA/B state
reg [6:0]  op_cntr;  // counter for FNTT,INTT,PWM2 operations

reg        op_out_a; // where is output for A?
reg        op_out_b; // where is output for B?

reg        load_type; // 0 for FNTT, 1 for INTT

reg        load_ab; // 0 for A, 1 for B
reg        read_ab; // 0 for A, 1 for B
reg        exec_ab; // 0 for A, 1 for B

// bram signals for input polynomial
reg [11:0] di0 [2*PE_NUMBER-1:0];
wire[11:0] do0 [2*PE_NUMBER-1:0];
reg [3:0]  dw0 [2*PE_NUMBER-1:0];
reg [3:0]  dr0 [2*PE_NUMBER-1:0];
reg        de0 [2*PE_NUMBER-1:0];

reg [11:0] di1 [2*PE_NUMBER-1:0];
wire[11:0] do1 [2*PE_NUMBER-1:0];
reg [3:0]  dw1 [2*PE_NUMBER-1:0];
reg [3:0]  dr1 [2*PE_NUMBER-1:0];
reg             de1 [2*PE_NUMBER-1:0];

// signals before going to brams
reg [11:0] di2 [2*PE_NUMBER-1:0];
reg [3:0]  dw2 [2*PE_NUMBER-1:0];
reg [3:0]  dr2 [2*PE_NUMBER-1:0];
reg        de2 [2*PE_NUMBER-1:0];

// bram signals for twiddle factors
wire[12*PE_NUMBER-1:0] to;
reg [6:0]              tr;

// control unit signals (from control unit to top module)
wire       c_ct;
wire       c_pwm;
wire [3:0] raddr0,raddr1;
wire [3:0] waddr0,waddr1;
wire       wen0  ,wen1  ;
wire       brsel0,brsel1;
wire       brselen0,brselen1;
wire [2:0] stage_count;
wire [2:0] stage_count_pwm;
wire [6:0] raddr_tw;

// signals for PU blocks
reg        CT  [PE_NUMBER-1:0];
reg        PWM [PE_NUMBER-1:0];
reg [11:0] A   [PE_NUMBER-1:0];
reg [11:0] B   [PE_NUMBER-1:0];
reg [11:0] W   [PE_NUMBER-1:0];
wire[11:0] E   [PE_NUMBER-1:0];
wire[11:0] O   [PE_NUMBER-1:0];
wire[11:0] MUL [PE_NUMBER-1:0];
wire[11:0] ADD [PE_NUMBER-1:0];
wire[11:0] SUB [PE_NUMBER-1:0];

// ---------------------------------------------------------------- defines
// -- Data
`define dic_0 {di2[0],di2[2],di2[4],di2[6],di2[8],di2[10],di2[12],di2[14],di2[16],di2[18],di2[20],di2[22],di2[24],di2[26],di2[28],di2[30]}
`define dwc_0 {dw2[0],dw2[2],dw2[4],dw2[6],dw2[8],dw2[10],dw2[12],dw2[14],dw2[16],dw2[18],dw2[20],dw2[22],dw2[24],dw2[26],dw2[28],dw2[30]}
`define drc_0 {dr2[0],dr2[2],dr2[4],dr2[6],dr2[8],dr2[10],dr2[12],dr2[14],dr2[16],dr2[18],dr2[20],dr2[22],dr2[24],dr2[26],dr2[28],dr2[30]}
`define dec_0 {de2[0],de2[2],de2[4],de2[6],de2[8],de2[10],de2[12],de2[14],de2[16],de2[18],de2[20],de2[22],de2[24],de2[26],de2[28],de2[30]}

`define dic_1 {di2[1],di2[3],di2[5],di2[7],di2[9],di2[11],di2[13],di2[15],di2[17],di2[19],di2[21],di2[23],di2[25],di2[27],di2[29],di2[31]}
`define dwc_1 {dw2[1],dw2[3],dw2[5],dw2[7],dw2[9],dw2[11],dw2[13],dw2[15],dw2[17],dw2[19],dw2[21],dw2[23],dw2[25],dw2[27],dw2[29],dw2[31]}
`define drc_1 {dr2[1],dr2[3],dr2[5],dr2[7],dr2[9],dr2[11],dr2[13],dr2[15],dr2[17],dr2[19],dr2[21],dr2[23],dr2[25],dr2[27],dr2[29],dr2[31]}
`define dec_1 {de2[1],de2[3],de2[5],de2[7],de2[9],de2[11],de2[13],de2[15],de2[17],de2[19],de2[21],de2[23],de2[25],de2[27],de2[29],de2[31]}

`define dic_2 {di2[0],di2[1],di2[2],di2[3],di2[4],di2[5],di2[6],di2[7],di2[8],di2[9],di2[10],di2[11],di2[12],di2[13],di2[14],di2[15],di2[16],di2[17],di2[18],di2[19],di2[20],di2[21],di2[22],di2[23],di2[24],di2[25],di2[26],di2[27],di2[28],di2[29],di2[30],di2[31]}
`define dwc_2 {dw2[0],dw2[1],dw2[2],dw2[3],dw2[4],dw2[5],dw2[6],dw2[7],dw2[8],dw2[9],dw2[10],dw2[11],dw2[12],dw2[13],dw2[14],dw2[15],dw2[16],dw2[17],dw2[18],dw2[19],dw2[20],dw2[21],dw2[22],dw2[23],dw2[24],dw2[25],dw2[26],dw2[27],dw2[28],dw2[29],dw2[30],dw2[31]}
`define drc_2 {dr2[0],dr2[1],dr2[2],dr2[3],dr2[4],dr2[5],dr2[6],dr2[7],dr2[8],dr2[9],dr2[10],dr2[11],dr2[12],dr2[13],dr2[14],dr2[15],dr2[16],dr2[17],dr2[18],dr2[19],dr2[20],dr2[21],dr2[22],dr2[23],dr2[24],dr2[25],dr2[26],dr2[27],dr2[28],dr2[29],dr2[30],dr2[31]}
`define dec_2 {de2[0],de2[1],de2[2],de2[3],de2[4],de2[5],de2[6],de2[7],de2[8],de2[9],de2[10],de2[11],de2[12],de2[13],de2[14],de2[15],de2[16],de2[17],de2[18],de2[19],de2[20],de2[21],de2[22],de2[23],de2[24],de2[25],de2[26],de2[27],de2[28],de2[29],de2[30],de2[31]}

// -- Data A
`define dia_2 {di0[0],di0[1],di0[2],di0[3],di0[4],di0[5],di0[6],di0[7],di0[8],di0[9],di0[10],di0[11],di0[12],di0[13],di0[14],di0[15],di0[16],di0[17],di0[18],di0[19],di0[20],di0[21],di0[22],di0[23],di0[24],di0[25],di0[26],di0[27],di0[28],di0[29],di0[30],di0[31]}
`define doa_2 {do0[0],do0[1],do0[2],do0[3],do0[4],do0[5],do0[6],do0[7],do0[8],do0[9],do0[10],do0[11],do0[12],do0[13],do0[14],do0[15],do0[16],do0[17],do0[18],do0[19],do0[20],do0[21],do0[22],do0[23],do0[24],do0[25],do0[26],do0[27],do0[28],do0[29],do0[30],do0[31]}
`define dwa_2 {dw0[0],dw0[1],dw0[2],dw0[3],dw0[4],dw0[5],dw0[6],dw0[7],dw0[8],dw0[9],dw0[10],dw0[11],dw0[12],dw0[13],dw0[14],dw0[15],dw0[16],dw0[17],dw0[18],dw0[19],dw0[20],dw0[21],dw0[22],dw0[23],dw0[24],dw0[25],dw0[26],dw0[27],dw0[28],dw0[29],dw0[30],dw0[31]}
`define dra_2 {dr0[0],dr0[1],dr0[2],dr0[3],dr0[4],dr0[5],dr0[6],dr0[7],dr0[8],dr0[9],dr0[10],dr0[11],dr0[12],dr0[13],dr0[14],dr0[15],dr0[16],dr0[17],dr0[18],dr0[19],dr0[20],dr0[21],dr0[22],dr0[23],dr0[24],dr0[25],dr0[26],dr0[27],dr0[28],dr0[29],dr0[30],dr0[31]}
`define dea_2 {de0[0],de0[1],de0[2],de0[3],de0[4],de0[5],de0[6],de0[7],de0[8],de0[9],de0[10],de0[11],de0[12],de0[13],de0[14],de0[15],de0[16],de0[17],de0[18],de0[19],de0[20],de0[21],de0[22],de0[23],de0[24],de0[25],de0[26],de0[27],de0[28],de0[29],de0[30],de0[31]}

// -- Data B
`define dib_2 {di1[0],di1[1],di1[2],di1[3],di1[4],di1[5],di1[6],di1[7],di1[8],di1[9],di1[10],di1[11],di1[12],di1[13],di1[14],di1[15],di1[16],di1[17],di1[18],di1[19],di1[20],di1[21],di1[22],di1[23],di1[24],di1[25],di1[26],di1[27],di1[28],di1[29],di1[30],di1[31]}
`define dob_2 {do1[0],do1[1],do1[2],do1[3],do1[4],do1[5],do1[6],do1[7],do1[8],do1[9],do1[10],do1[11],do1[12],do1[13],do1[14],do1[15],do1[16],do1[17],do1[18],do1[19],do1[20],do1[21],do1[22],do1[23],do1[24],do1[25],do1[26],do1[27],do1[28],do1[29],do1[30],do1[31]}
`define dwb_2 {dw1[0],dw1[1],dw1[2],dw1[3],dw1[4],dw1[5],dw1[6],dw1[7],dw1[8],dw1[9],dw1[10],dw1[11],dw1[12],dw1[13],dw1[14],dw1[15],dw1[16],dw1[17],dw1[18],dw1[19],dw1[20],dw1[21],dw1[22],dw1[23],dw1[24],dw1[25],dw1[26],dw1[27],dw1[28],dw1[29],dw1[30],dw1[31]}
`define drb_2 {dr1[0],dr1[1],dr1[2],dr1[3],dr1[4],dr1[5],dr1[6],dr1[7],dr1[8],dr1[9],dr1[10],dr1[11],dr1[12],dr1[13],dr1[14],dr1[15],dr1[16],dr1[17],dr1[18],dr1[19],dr1[20],dr1[21],dr1[22],dr1[23],dr1[24],dr1[25],dr1[26],dr1[27],dr1[28],dr1[29],dr1[30],dr1[31]}
`define deb_2 {de1[0],de1[1],de1[2],de1[3],de1[4],de1[5],de1[6],de1[7],de1[8],de1[9],de1[10],de1[11],de1[12],de1[13],de1[14],de1[15],de1[16],de1[17],de1[18],de1[19],de1[20],de1[21],de1[22],de1[23],de1[24],de1[25],de1[26],de1[27],de1[28],de1[29],de1[30],de1[31]}

// ---------------------------------------------------------------- op_type & load_type & op_out

always @(posedge clk or posedge reset) begin
    if(reset)
        load_type <= 0;
    else begin
        if(load_a_i || load_b_i)
            load_type <= 1;
        else if(curr_state == OP_LOAD_DATA)
            load_type <= load_type;
        else
            load_type <= 0;
    end
end

always @(posedge clk or posedge reset) begin
    if(reset)
        op_out_a <= 0;
    else begin
        if(start_fntt && ~start_ab)
            op_out_a <= 1; // Doing FNTT (output will be at address 1)
        else if(start_pwm2 && ~start_ab)
            op_out_a <= 1; // Doing PWM2 (output will be at address 1)
        else if(start_intt && ~start_ab)
            op_out_a <= 0; // Doing INTT (output will be at address 0)
        else
            op_out_a <= op_out_a;
    end
end

always @(posedge clk or posedge reset) begin
    if(reset)
        op_out_b <= 0;
    else begin
        if(start_fntt && start_ab)
            op_out_b <= 1; // Doing FNTT (output will be at address 1)
        else if(start_pwm2 && start_ab)
            op_out_b <= 1; // Doing PWM2 (output will be at address 1)
        else if(start_intt && start_ab)
            op_out_b <= 0; // Doing INTT (output will be at address 0)
        else
            op_out_b <= op_out_b;
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        load_ab <= 0;
        read_ab <= 0;
        exec_ab <= 0;
    end
    else begin
        // load
        if(load_a_f || load_a_i)
            load_ab <= 0;
        else if(load_b_f || load_b_i)
            load_ab <= 1;
        else if(curr_state == OP_IDLE)
            load_ab <= 0;
        else
            load_ab <= load_ab;
        // read
        if(read_a)
            read_ab <= 0;
        else if(read_b)
            read_ab <= 1;
        else if(curr_state == OP_IDLE)
            read_ab <= 0;
        else
            read_ab <= read_ab;
        // exec
        if(start_fntt || start_pwm2 || start_intt)
            exec_ab <= start_ab;
        else if(curr_state == OP_IDLE)
            exec_ab <= 0;
        else
            exec_ab <= exec_ab;
    end
end

// ---------------------------------------------------------------- FSM

/*
-- 0 : OP_IDLE        --> Idle state, waiting for input
-- 1 : OP_LOAD_DATA   --> loading input polynomial A or B for (ntt or intt)
-- 2 : OP_FNTT        --> performing FNTT operation
-- 3 : OP_PWM2        --> performing PWM2 operation
-- 4 : OP_INTT        --> performing INTT operation
-- 5 : OP_NULL        --> no-operation-defined (can be added later)
-- 6 : OP_NULL        --> no-operation-defined (can be added later)
-- 7 : OP_READ_DATA   --> reading out output polynomial
*/

always @(posedge clk or posedge reset) begin
    if(reset)
        curr_state <= 0;
    else
        curr_state <= next_state;
end

always @(*) begin
    case(curr_state)
    OP_IDLE: begin
        if(load_a_f || load_a_i || load_b_f || load_b_i)
            next_state = OP_LOAD_DATA;
        else if(start_fntt)
            next_state = OP_FNTT;
        else if(start_pwm2)
            next_state = OP_PWM2;
        else if(start_intt)
            next_state = OP_INTT;
        else if(read_a)
            next_state = OP_READ_DATA;
        else
            next_state = OP_IDLE;
    end
    OP_LOAD_DATA: begin
        next_state = (di_cntr == 4'd15) ? OP_IDLE : OP_LOAD_DATA;
    end
    OP_FNTT: begin
        next_state = (op_cntr == (FNTT_CC-7'd1)) ? OP_IDLE : OP_FNTT;
    end
    OP_PWM2: begin
        next_state = (op_cntr == (PWM2_CC-7'd1)) ? OP_IDLE : OP_PWM2;
    end
    OP_INTT: begin
        next_state = (op_cntr == (INTT_CC-7'd1)) ? OP_IDLE : OP_INTT;
    end
    OP_READ_DATA: begin
        next_state = (do_cntr == 5'd17) ? OP_IDLE : OP_READ_DATA;
    end
    default: next_state = OP_IDLE;
    endcase
end

// ---------------------------------------------------------------- di_cntr,do_cntr,op_cntr

always @(posedge clk or posedge reset) begin
    if(reset) begin
        di_cntr <= 0;
        do_cntr <= 0;
        op_cntr <= 0;
    end
    else begin
        if (curr_state == OP_LOAD_DATA)
            di_cntr <= (di_cntr == 4'd15) ? 0 : (di_cntr + 1);

        if (curr_state == OP_READ_DATA)
            do_cntr <= (do_cntr == 5'd17) ? 0 : (do_cntr + 1);

        case(curr_state)
        OP_FNTT: op_cntr <= (op_cntr == (FNTT_CC-7'd1)) ? 0 : (op_cntr+7'd1);
        OP_PWM2: op_cntr <= (op_cntr == (PWM2_CC-7'd1)) ? 0 : (op_cntr+7'd1);
        OP_INTT: op_cntr <= (op_cntr == (INTT_CC-7'd1)) ? 0 : (op_cntr+7'd1);
        default: op_cntr <= op_cntr;
        endcase
    end
end

// ---------------------------------------------------------------- BRAM signals
// ---------------------------------------------------------------- data, tw, ntt

// twiddle (read)
always @(posedge clk or posedge reset) begin
    if(reset)
        tr <= 0;
    else
        tr <= raddr_tw;
end

// data 1 (write & read)
always @(*) begin
    case(curr_state)
    OP_LOAD_DATA: begin
        `dic_2 = (load_type == 1'd0) ? {{2{din[191:180]}},{2{din[179:168]}},{2{din[167:156]}},{2{din[155:144]}},{2{din[143:132]}},{2{din[131:120]}},{2{din[119:108]}},{2{din[107:96]}},
                                        {2{din[95:84]}}  ,{2{din[83:72]}}  ,{2{din[71:60]}}  ,{2{din[59:48]}},{2{din[47:36]}},{2{din[35:24]}},{2{din[23:12]}},{2{din[11:0]}}} : {din,din};
        `dwc_2 = (load_type == 1'd0) ? {32{1'b0,di_cntr[2:0]}} : {32{1'b1,di_cntr[3:1]}};
        `drc_2 = 0;
        `dec_2 = (load_type == 1'd0) ? {16{~di_cntr[3],di_cntr[3]}} : {{16{~di_cntr[0]}},{16{di_cntr[0]}}};
    end
    OP_FNTT: begin
        // ------------------------------------------------------ READ
        `drc_2 = {16{raddr0,raddr1}};
        // ------------------------------------------------------ WRITE
        case(stage_count)
        3'd0,3'd1,3'd2: begin
            if(brselen0) begin
                if(brsel0 == 1'd0) begin
                    `dic_0 = {E[0],E[1],E[2],E[3],E[4],E[5],E[6],E[7],E[8],E[9],E[10],E[11],E[12],E[13],E[14],E[15]};
                    `dwc_0 = {16{waddr0}};
                    `dec_0 = {16{wen0}};
                end
                else begin // brsel0 == 1
                    `dic_0 = {O[0],O[1],O[2],O[3],O[4],O[5],O[6],O[7],O[8],O[9],O[10],O[11],O[12],O[13],O[14],O[15]};
                    `dwc_0 = {16{waddr1}};
                    `dec_0 = {16{wen1}};
                end
            end
            else begin
                `dic_0 = 0;
                `dwc_0 = 0;
                `dec_0 = 0;
            end

            if(brselen1) begin
                if(brsel1 == 1'd0) begin
                    `dic_1 = {E[0],E[1],E[2],E[3],E[4],E[5],E[6],E[7],E[8],E[9],E[10],E[11],E[12],E[13],E[14],E[15]};
                    `dwc_1 = {16{waddr0}};
                    `dec_1 = {16{wen0}};
                end
                else begin // brsel1 == 1
                    `dic_1 = {O[0],O[1],O[2],O[3],O[4],O[5],O[6],O[7],O[8],O[9],O[10],O[11],O[12],O[13],O[14],O[15]};
                    `dwc_1 = {16{waddr1}};
                    `dec_1 = {16{wen1}};
                end
            end
            else begin
                `dic_1 = 0;
                `dwc_1 = 0;
                `dec_1 = 0;
            end
        end
        3'd3: begin
            `dic_2 = {E[0],E[8],E[1],E[9],E[2],E[10],E[3],E[11],E[4],E[12],E[5],E[13],E[6],E[14],E[7],E[15],
                      SUB[0],SUB[8],SUB[1],SUB[9],SUB[2],SUB[10],SUB[3],SUB[11],SUB[4],SUB[12],SUB[5],SUB[13],SUB[6],SUB[14],SUB[7],SUB[15]};
            `dwc_2 = {32{waddr0}};
            `dec_2 = {32{wen0}};
        end
        3'd4: begin
            `dic_2 = {E[0],E[4],E[1],E[5],E[2],E[6],E[3],E[7],SUB[0],SUB[4],SUB[1],SUB[5],SUB[2],SUB[6],SUB[3],SUB[7],
                      E[8],E[12],E[9],E[13],E[10],E[14],E[11],E[15],SUB[8],SUB[12],SUB[9],SUB[13],SUB[10],SUB[14],SUB[11],SUB[15]};
            `dwc_2 = {32{waddr0}};
            `dec_2 = {32{wen0}};
        end
        3'd5: begin
            `dic_2 = {E[0],E[2],E[1],E[3],SUB[0],SUB[2],SUB[1],SUB[3],E[4],E[6],E[5],E[7],SUB[4],SUB[6],SUB[5],SUB[7],
                      E[8],E[10],E[9],E[11],SUB[8],SUB[10],SUB[9],SUB[11],E[12],E[14],E[13],E[15],SUB[12],SUB[14],SUB[13],SUB[15]};
            `dwc_2 = {32{waddr0}};
            `dec_2 = {32{wen0}};
        end
        default: begin // 3'd6
            `dic_2 = {E[0],E[1],SUB[0],SUB[1],E[2],E[3],SUB[2],SUB[3],E[4],E[5],SUB[4],SUB[5],E[6],E[7],SUB[6],SUB[7],
                      E[8],E[9],SUB[8],SUB[9],E[10],E[11],SUB[10],SUB[11],E[12],E[13],SUB[12],SUB[13],E[14],E[15],SUB[14],SUB[15]};
            `dwc_2 = {32{waddr0}};
            `dec_2 = {32{wen0}};
        end
        endcase
    end
    OP_PWM2: begin
        `drc_2 = {32{raddr0}};
        `dic_2 = {E[0],E[1],E[0],E[1],E[2],E[3],E[2],E[3],E[4],E[5],E[4],E[5],E[6],E[7],E[6],E[7],
                  E[8],E[9],E[8],E[9],E[10],E[11],E[10],E[11],E[12],E[13],E[12],E[13],E[14],E[15],E[14],E[15]};
        `dwc_2 = {8{waddr1,waddr1,waddr0,waddr0}};
        `dec_2 = {8{wen1,wen1,wen0,wen0}};
    end
    OP_INTT: begin
        // ------------------------------------------------------ READ
        `drc_2 = {16{raddr0,raddr1}};
        // ------------------------------------------------------ WRITE
        case(stage_count)
        3'd0: begin
            `dic_2 = {E[0],E[2],E[1],E[3],O[0],O[2],O[1],O[3],E[4],E[6],E[5],E[7],O[4],O[6],O[5],O[7],
                      E[8],E[10],E[9],E[11],O[8],O[10],O[9],O[11],E[12],E[14],E[13],E[15],O[12],O[14],O[13],O[15]};
            `dwc_2 = {4{{4{waddr0}},{4{waddr1}}}};
            `dec_2 = {4{{4{wen0}},{4{wen1}}}};
        end
        3'd1: begin
            `dic_2 = {E[0],E[4],E[1],E[5],E[2],E[6],E[3],E[7],O[0],O[4],O[1],O[5],O[2],O[6],O[3],O[7],
                      E[8],E[12],E[9],E[13],E[10],E[14],E[11],E[15],O[8],O[12],O[9],O[13],O[10],O[14],O[11],O[15]};
            `dwc_2 = {2{{8{waddr0}},{8{waddr1}}}};
            `dec_2 = {2{{8{wen0}},{8{wen1}}}};
        end
        3'd2: begin
            `dic_2 = {E[0],E[8],E[1],E[9],E[2],E[10],E[3],E[11],E[4],E[12],E[5],E[13],E[6],E[14],E[7],E[15],
                      O[0],O[8],O[1],O[9],O[2],O[10],O[3],O[11],O[4],O[12],O[5],O[13],O[6],O[14],O[7],O[15]};
            `dwc_2 = {{16{waddr0}},{16{waddr1}}};
            `dec_2 = {{16{wen0}},{16{wen1}}};
        end
        3'd6: begin
            `dic_2 = {E[0],O[0],E[1],O[1],E[2],O[2],E[3],O[3],E[4],O[4],E[5],O[5],E[6],O[6],E[7],O[7],
                      E[8],O[8],E[9],O[9],E[10],O[10],E[11],O[11],E[12],O[12],E[13],O[13],E[14],O[14],E[15],O[15]};
            `dwc_2 = {16{waddr0,waddr1}};
            `dec_2 = {16{wen0,wen1}};
        end
        default: begin
            if(brselen0) begin
                if(brsel0 == 1'd0) begin
                    `dic_0 = {E[0],E[1],E[2],E[3],E[4],E[5],E[6],E[7],E[8],E[9],E[10],E[11],E[12],E[13],E[14],E[15]};
                    `dwc_0 = {16{waddr0}};
                    `dec_0 = {16{wen0}};
                end
                else begin // brsel0 == 1
                    `dic_0 = {O[0],O[1],O[2],O[3],O[4],O[5],O[6],O[7],O[8],O[9],O[10],O[11],O[12],O[13],O[14],O[15]};
                    `dwc_0 = {16{waddr1}};
                    `dec_0 = {16{wen1}};
                end
            end
            else begin
                `dic_0 = 0;
                `dwc_0 = 0;
                `dec_0 = 0;
            end

            if(brselen1) begin
                if(brsel1 == 1'd0) begin
                    `dic_1 = {E[0],E[1],E[2],E[3],E[4],E[5],E[6],E[7],E[8],E[9],E[10],E[11],E[12],E[13],E[14],E[15]};
                    `dwc_1 = {16{waddr0}};
                    `dec_1 = {16{wen0}};
                end
                else begin // brsel1 == 1
                    `dic_1 = {O[0],O[1],O[2],O[3],O[4],O[5],O[6],O[7],O[8],O[9],O[10],O[11],O[12],O[13],O[14],O[15]};
                    `dwc_1 = {16{waddr1}};
                    `dec_1 = {16{wen1}};
                end
            end
            else begin
                `dic_1 = 0;
                `dwc_1 = 0;
                `dec_1 = 0;
            end
        end
        endcase
    end
    OP_READ_DATA: begin
        `dic_2 = 0;
        `dwc_2 = 0;
        `drc_2 = (read_ab == 1'b0) ? {32{op_out_a,do_cntr[3:1]}} : {32{op_out_b,do_cntr[3:1]}};
        `dec_2 = 0;
    end
    default: begin
        `dic_2 = 0;
        `dwc_2 = 0;
        `drc_2 = 0;
        `dec_2 = 0;
    end
    endcase
end

// brams
always @(*) begin
    // read
    `dra_2 = `drc_2;
    `drb_2 = (curr_state == OP_PWM2) ? {32{1'b1,raddr0[2:0]}} : `drc_2;
    // write
    `dwa_2 = `dwc_2;
    `dwb_2 = `dwc_2;
    // input
    `dia_2 = `dic_2;
    `dib_2 = `dic_2;
    // enable
    `dea_2 = (load_ab || read_ab || exec_ab) ? 0 : `dec_2;
    `deb_2 = (load_ab || read_ab || exec_ab) ? `dec_2 : 0;
end

// ---------------------------------------------------------------- DONE, DOUT

// ntt unit
integer ntt_loop = 0;

always @(posedge clk or posedge reset) begin
    for(ntt_loop = 0; ntt_loop<PE_NUMBER; ntt_loop=ntt_loop+1) begin
        if(reset) begin
            A[ntt_loop]   <= 0;
            B[ntt_loop]   <= 0;
            W[ntt_loop]   <= 0;
            CT[ntt_loop]  <= 0;
            PWM[ntt_loop] <= 0;
        end
        else begin
            case(curr_state)
            OP_FNTT,OP_INTT: begin
                A[ntt_loop]   <= (exec_ab == 1'b0) ? do0[2*ntt_loop+0] : do1[2*ntt_loop+0];
                B[ntt_loop]   <= (exec_ab == 1'b0) ? do0[2*ntt_loop+1] : do1[2*ntt_loop+1];
                W[ntt_loop]   <= to[12*(15-ntt_loop)+:12];
                CT[ntt_loop]  <= c_ct;
                PWM[ntt_loop] <= c_pwm;
            end
            OP_PWM2: begin
                case(stage_count_pwm)
                3'd0: begin
                    A[ntt_loop] <= 0;
                    B[ntt_loop] <= do0[2*ntt_loop+1];
                    W[ntt_loop] <= do1[2*ntt_loop+0];
                end
                3'd1: begin
                    A[ntt_loop] <= 0;
                    B[ntt_loop] <= do0[2*ntt_loop+1];
                    W[ntt_loop] <= do1[2*ntt_loop+1];
                end
                3'd2: begin
                    A[ntt_loop] <= 0;
                    B[ntt_loop] <= do0[2*ntt_loop+0];
                    W[ntt_loop] <= do1[2*ntt_loop+0];
                end
                3'd3: begin
                    A[ntt_loop] <= MUL[ntt_loop];
                    B[ntt_loop] <= do0[2*ntt_loop+0];
                    W[ntt_loop] <= do1[2*ntt_loop+1];
                end
                3'd4: begin
                    A[ntt_loop] <= 0;
                    B[ntt_loop] <= MUL[ntt_loop];
                    W[ntt_loop] <= to[12*(15-ntt_loop)+:12];
                end
                default: begin
                    A[ntt_loop] <= 0;
                    B[ntt_loop] <= 0;
                    W[ntt_loop] <= 0;
                end
                endcase
                CT[ntt_loop]  <= c_ct;
                PWM[ntt_loop] <= c_pwm;
            end
            default: begin
                A[ntt_loop]   <= A[ntt_loop];
                B[ntt_loop]   <= B[ntt_loop];
                W[ntt_loop]   <= W[ntt_loop];
                CT[ntt_loop]  <= CT[ntt_loop];
                PWM[ntt_loop] <= PWM[ntt_loop];
            end
            endcase
        end
    end
end

// ---------------------------------------------------------------- DONE, DOUT

// done
always @(posedge clk or posedge reset) begin
    if(reset)
        done <= 0;
    else begin
        case(curr_state)
        OP_FNTT: done <= (op_cntr == (FNTT_CC-7'd1)) ? 1'b1 : 1'b0;
        OP_INTT: done <= (op_cntr == (INTT_CC-7'd1)) ? 1'b1 : 1'b0;
        OP_PWM2: done <= (op_cntr == (PWM2_CC-7'd1)) ? 1'b1 : 1'b0;
        default: done <= 1'b0;
        endcase
    end
end

// dout
always @(posedge clk or posedge reset) begin
    if(reset) begin
        dout <= 0;
    end
    else begin
        if(curr_state == OP_READ_DATA) begin
            if(do_cntr > 5'd0)
                dout <= (do_cntr[0] == 1'd1) ? ((read_ab == 1'd0) ? {do0[0] ,do0[1] ,do0[2] ,do0[3] ,do0[4] ,do0[5] ,do0[6] ,do0[7] ,do0[8] ,do0[9] ,do0[10],do0[11],do0[12],do0[13],do0[14],do0[15]} : {do1[0] ,do1[1] ,do1[2] ,do1[3] ,do1[4] ,do1[5] ,do1[6] ,do1[7] ,do1[8] ,do1[9] ,do1[10],do1[11],do1[12],do1[13],do1[14],do1[15]}) :
                                               ((read_ab == 1'd0) ? {do0[16],do0[17],do0[18],do0[19],do0[20],do0[21],do0[22],do0[23],do0[24],do0[25],do0[26],do0[27],do0[28],do0[29],do0[30],do0[31]} : {do1[16],do1[17],do1[18],do1[19],do1[20],do1[21],do1[22],do1[23],do1[24],do1[25],do1[26],do1[27],do1[28],do1[29],do1[30],do1[31]});
        end
        else begin
            dout <= 0;
        end
    end
end

// ---------------------------------------------------------------- CONTROL UNIT

addressgenerator ag(clk,reset,
                    start_fntt,start_pwm2,start_intt,
                    c_ct,
                    c_pwm,
                    raddr0,raddr1,
                    waddr0,waddr1,
                    wen0  ,wen1  ,
                    brsel0,brsel1,
                    brselen0,brselen1,
                    stage_count,
                    stage_count_pwm,
                    raddr_tw
                    );

// ---------------------------------------------------------------- BRAMs

generate
	genvar k;

    for(k=0; k<PE_NUMBER ;k=k+1) begin: BRAM1_GEN_BLOCK
        BRAM bd00(clk,de0[2*k+0],dw0[2*k+0],di0[2*k+0],dr0[2*k+0],do0[2*k+0]);
        BRAM bd01(clk,de0[2*k+1],dw0[2*k+1],di0[2*k+1],dr0[2*k+1],do0[2*k+1]);
    end
endgenerate

generate
	genvar j;

    for(j=0; j<PE_NUMBER ;j=j+1) begin: BRAM2_GEN_BLOCK
        BRAM bd10(clk,de1[2*j+0],dw1[2*j+0],di1[2*j+0],dr1[2*j+0],do1[2*j+0]);
        BRAM bd11(clk,de1[2*j+1],dw1[2*j+1],di1[2*j+1],dr1[2*j+1],do1[2*j+1]);
    end
endgenerate

// ---------------------------------------------------------------- BROMs

BROM bt00(clk,tr,to);

// ---------------------------------------------------------------- BUTTERFLY UNIT

generate
	genvar m;

    for(m=0; m<PE_NUMBER ;m=m+1) begin: BTF_GEN_BLOCK
        butterfly btfu(clk,reset,
                       CT[m],
                       PWM[m],
			           A[m],B[m],W[m],
				       E[m],O[m],
				       MUL[m],
				       ADD[m],SUB[m]);
    end
endgenerate

// ----------------------------------------------------------------

endmodule
