
module y86 ( clk );

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
  parameter IPUSHQ = 4'hA;
  parameter IPOPQ = 4'hB;


input clk ;

wire signed [63:0] valA;
wire signed [63:0] valB;
wire signed [63:0] valC;
wire signed [63:0] valE;
wire signed [63:0] valM;
wire signed [63:0] valP;
wire signed [63:0] pc=64'b0;
wire mem_error;
wire [3:0] dstE;
wire [3:0] dstM;
wire [3:0] srcA;
wire [3:0] srcB;
wire cnd;
wire [71:0] a_bytes;
wire [7:0] s_byte;
wire [3:0] icode;
wire [3:0] ifun;
wire nr;
wire nc;
wire [3:0] rA;
wire [3:0] rB;
wire mem_r;
wire mem_w;
wire signed [63:0] mem_add;
wire signed [63:0] mem_data;
wire dmem_error;
instruction_memory im(pc,s_byte,a_bytes,mem_error);

split x(s_byte,icode,ifun);
assign nc = ((icode == IIRMOVQ) || (icode == IRMMOVQ) || (icode == IMRMOVQ) || (icode == IJXX) || (icode == ICALL) ) ? 1'b1 : 1'b0 ;
assign nr = ((icode == IRRMOVQ) || (icode == IIRMOVQ) || (icode == IRMMOVQ) || (icode == IMRMOVQ) || (icode == IOPQ) || (icode == IPUSHQ) || (icode == IPOPQ)) ? 1'b1 : 1'b0 ;


align y(a_bytes,n_regs,rA,rB,valC));

memory m1(mem_r,mem_w,mem_add,mem_data,icode,valE,valA,valP);

memory_i m2(valM,dmem_error,mem_r,mem_w,mem_add,mem_data);

decode dec(dstE,dstM,srcA,srcB,icode,rA,rB,cnd);

execute e(icode,ifun,valA,valB,valC,cnd,valE);

reg_file f(valA,valB,valM,valE,dstE,dstM,srcA,srcB);

pc_inc z(pc,n_regs,valC,valP);

pc_update pc2(pc,icode,cnd,valC,valM,valP);


endmodule