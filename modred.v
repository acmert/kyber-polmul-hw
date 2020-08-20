
module modred(input      [23:0] C,
              output reg [11:0] R);

// Optimization (use Dadda tree here.)
`define L0 {1'b0  ,1'b0  ,1'b0  , C[11], C[10], C[9] , C[8] , C[7] , C[6] , C[5] , C[4] , C[3] , C[2] , C[1] , C[0] }
`define L1 {1'b0  ,1'b0  ,1'b0  , C[14], C[13], C[12],!C[23],!C[19],!C[18],!C[17],!C[16],!C[15],!C[14],!C[13],!C[12]}
`define L2 {1'b0  ,1'b0  ,1'b0  , C[15], C[14], C[13], C[12],!C[22],!C[21],!C[20],!C[19],!C[18],!C[17],!C[16],!C[15]}
`define L3 {1'b0  ,1'b0  ,1'b0  , C[16], C[17], C[15], C[15],!C[23],!C[22],!C[21],!C[20],!C[19],!C[18],!C[17],!C[16]}
`define L4 {1'b0  ,1'b0  ,1'b0  , C[18], C[22], C[21], C[16],1'b0  ,!C[23],!C[22],!C[21],!C[20],!C[19],!C[18],!C[17]}
`define L5 {1'b0  ,1'b0  ,1'b0  , C[21], C[20], C[19], C[17],1'b0  ,1'b1  ,1'b0  ,!C[23],!C[22],!C[21],!C[20],!C[19]}
`define L6 {1'b0  ,1'b0  ,1'b0  , C[20], C[19], C[18], C[19],1'b0  ,1'b0  ,1'b0  ,1'b1  ,!C[23],!C[22],1'b0  ,!C[21]}
`define L7 {1'b0  ,1'b0  ,1'b0  , C[23], C[21], C[20], C[21],1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b1  ,1'b0  ,1'b0  ,1'b0  }
`define L8 {1'b0  ,1'b0  ,1'b0  ,!C[23],!C[22],!C[21],!C[20],1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  }
`define L9 {1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b0  ,1'b0  ,1'b1  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b1  }

/*
// debug
wire [14:0] R_DB0;
assign R_DB0 = `L0 + `L1 + `L2 + `L3 + `L4 + `L5 + `L6 + `L7 + `L8 + `L9;
*/

// First Stage

wire [14:0] C00,C01,C02,C03,C04,C05,C06,C07;
wire [14:0] S00,S01,S02,S03,S04,S05,S06,S07;

CSA #(15) level0_00 (`L0,`L1,`L2,C00,S00);
CSA #(15) level0_01 (`L3,`L4,`L5,C01,S01);
CSA #(15) level0_02 (`L6,`L7,`L8,C02,S02);

CSA #(15) level1_00 (C00,C01,C02,C03,S03);
CSA #(15) level1_01 (S00,S01,S02,C04,S04);

CSA #(15) level2_00 (C03,C04,S03,C05,S05);

CSA #(15) level3_00 (C05,S05,S04,C06,S06);

CSA #(15) level4_00 (C06,S06,`L9,C07,S07);

/*
// debug
wire [14:0] R_DB1;
assign R_DB1 = C07 + S07;
*/

// Second Stage

wire [14:0] K;

assign K = C07+S07;

// Optimization (use Dadda tree here.)
`define K0 {1'b0  ,1'b0  ,1'b0  , K[11], K[10], K[9] , K[8] , K[7] , K[6] , K[5] , K[4] , K[3] , K[2] , K[1] , K[0] }
`define K1 {1'b0  ,1'b0  ,1'b0  , K[14], K[13], K[12],1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,!K[14],!K[13],!K[12]}
`define K2 {1'b0  ,1'b0  ,1'b0  ,1'b0  , K[14], K[13], K[12],1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  ,1'b0  }
`define KM {1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b1  ,1'b0  ,1'b0  ,1'b1  }

/*
// debug
wire [14:0] R_DB2;
assign R_DB2 = `K0 + `K1 + `K2 + `KM;
*/

wire [14:0] C08,C09;
wire [14:0] S08,S09;

CSA #(15) level5_00 (`K0,`K1,`K2,C08,S08);

CSA #(15) level6_00 (C08,S08,`KM,C09,S09);

/*
// debug
wire [14:0] R_DB3;
assign R_DB3 = C09 + S09;
*/

// Final Stage

wire [14:0] R0,R1,R2,R3;

CSA #(15) level9_00 (C09,S09,15'b111001011111111,R0,R1);
CSA #(15) level9_01 (C09,S09,15'b110010111111110,R2,R3);

wire [15:0] RF0,RF1,RF2;

assign RF0 = C09+S09;
assign RF1 = R0 +R1;
assign RF2 = R2 +R3;

always @(*) begin
    if(RF2[14] == 0)
        R = RF2;
    else if(RF1[14] == 0)
        R = RF1;
    else
        R = RF0;
end

endmodule

