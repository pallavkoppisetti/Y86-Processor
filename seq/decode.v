module decode(dstE,dstM,srcA,srcB,icode,rA,rB,cnd);
input [3:0] icode;
input [3:0] rA;
input [3:0] rB;
input cnd;

output [3:0] dstE;
output [3:0] dstM;
output [3:0] srcA;
output [3:0] srcB;

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

assign srcA = icode == IRRMOVQ ? rA: icode == IOPQ ? rA: icode == IPUSHQ ? rA: icode == IRET ? 4'h4: icode == IRRMOVQ ? rA: icode == IPOPQ ? 4'h4 : 4'hf; 

assign srcB = icode == IMRMOVQ ? rB: icode == IOPQ ? rB: icode == IRMMOVQ ? rB: icode == IRET ? 4'h4: icode == ICALL ? 4'h4: icode == IPUSHQ ? 4'h4: icode == IPOPQ ? 4'h4 : 4'hf;

assign dstE =  icode == IRRMOVQ ? (cnd ? rB : 4'hf): icode == IIRMOVQ ? rB: icode == IOPQ ? rB: icode == IRET ? 4'h4: icode == ICALL ? 4'h4: icode == IPUSHQ ? 4'h4: icode == IPOPQ ? 4'h4 : 4'hf; 

assign dstM = icode == IMRMOVQ ? rA: icode == IPOPQ ? rA: 4'hf; 

endmodule