`include "alu.v"


module execute(icode,ifun,valA,valB,valC,cnd,valE);
input [3:0] icode;
input [3:0] ifun;
input [63:0] valA;
input [63:0] valB; 
input [63:0] valC;
output reg [63:0] valE;
output cnd; 

// For jumping we need to following conditions 

parameter j_yes = 4'h0;
parameter j_le = 4'h1;
parameter j_l = 4'h2;
parameter j_e = 4'h3;
parameter j_ne = 4'h4;
parameter j_ge = 4'h5;
parameter j_g = 4'h6; 

// Instructions 

parameter IHALT = 4'h0;
parameter INOP = 4'h1;
parameter IRRMOVQ = 4'h2;
parameter IIRMOVQ = 4'h3;
parameter IRMMOVQ = 4'h4;
parameter IMRMOVQ = 4'h5;
parameter IOPQ = 4'h6;
parameter IJXX = 4'h7;
parameter ICALL = 4'h8;
parameter IRET = 4'h9;
parameter IPUSHQ = 4'ha;
parameter IPOPQ = 4'hb;
parameter ILEAVE = 4'hc;

assign ALUA = 
icode == IRRMOVQ ? valA :
icode == IOPQ ? valA : 
icode == IIRMOVQ ? valC :
icode == IRMMOVQ ? valC : 
icode == IMRMOVQ ? valC :
icode == ICALL ? -8: 
icode == IPUSHQ ? -8 :
icode == IRET ? 8 :
icode == IPOPQ ? 8 : 0; 

assign ALUB = 
icode == IRMMOVQ ? valB: 
icode == IMRMOVQ ? valB:
icode == IOPQ ? valB :
icode == ICALL ? valB :
icode == IPUSHQ ? valB :
icode == IRET ? valB :
icode == IPOPQ ? valB : 
icode == IRRMOVQ ? 0: 
icode == IIRMOVQ ? 0: 0;

wire[1:0] select_line;
assign select_line = 
icode == IRMMOVQ ? 2'b0: 
icode == IMRMOVQ ? 2'b0:
icode == IOPQ ? ifun :
icode == ICALL ? 2'b0 :
icode == IPUSHQ ? 2'b0 :
icode == IRET ? 2'b0 :
icode == IPOPQ ? 2'b0 :
icode == IRRMOVQ ? 2'b0:
icode == IIRMOVQ ? 2'b0: 0;

wire overflow; 
wire [63:0] ALU_result;
alu find(valA,valB,select_line,ALU_result,overflow);
reg zero_flag;
reg overflow_flag;
reg sign_flag;

always @(*) begin
    sign_flag = valE[63];
    if (ALU_result == 64'b0) begin
    zero_flag = 1;
end
else begin 
    zero_flag = 0;
end 
overflow_flag = overflow; 
valE = ALU_result;
end



assign cnd = 
(ifun == j_yes) | (ifun == j_le & ((zero_flag^overflow_flag)|zero_flag)) | (ifun == j_l & (sign_flag ^ overflow_flag)) | (ifun == j_e & zero_flag) | (ifun == j_ne & ~ zero_flag) | (ifun == j_ge & (~sign_flag^overflow_flag)) | (ifun == j_g & (~sign_flag^overflow_flag) & ~zero_flag); 

endmodule 
