module decode_tb();

reg [3:0] icode;
reg [3:0] rA;
reg [3:0] rB; 
reg cnd;
output [3:0] srcA;
output [3:0] srcB;
output [3:0] dstE;
output [3:0] dstM;

decode decode(
    .dstE(dstE),
    .dstM(dstM),
    .srcA(srcA),
    .srcB(srcB),
    .icode(icode),
    .rA(rA),
    .rB(rB),
    .cnd(cnd)


  );

initial begin 
    $dumpfile("decode.vcd");
    $dumpvars(0,decode_tb);

    cnd=1'b0;

    icode = 4'b0010; rA = 4'b0010; rB = 4'b0010;
    #10 cnd = ~cnd; 
    #10 cnd = ~cnd;
    icode = 4'b0011; rA = 4'b0000; rB = 4'b1000;
    #10 cnd = ~cnd; 
    #10 cnd = ~cnd;
    icode = 4'b0100; rA = 4'b1100; rB = 4'b0101;
    #10 cnd = ~cnd; 
    #10 cnd = ~cnd;
    icode = 4'b0101; rA = 4'b1110; rB = 4'b1001;
    #10 cnd = ~cnd; 
    #10 cnd = ~cnd;
    icode = 4'b0110; rA = 4'b0011; rB = 4'b0001;
    #10 cnd = ~cnd; 
    #10 cnd = ~cnd;
    icode = 4'b1000; rA = 4'b0000; rB = 4'b1110;
    #10 cnd = ~cnd; 
    #10 cnd = ~cnd;
    icode = 4'b1001; rA = 4'b0100; rB = 4'b1001;
    #10 cnd = ~cnd; 
    #10 cnd = ~cnd;
    icode = 4'b1010; rA = 4'b0101; rB = 4'b1101;
    #10 cnd = ~cnd; 
    #10 cnd = ~cnd;
    icode = 4'b1011; rA = 4'b0000; rB = 4'b0000;
    #10 cnd = ~cnd; 
    #10 cnd = ~cnd;

end 
  
initial 
    $monitor("cnd = %d icode = %b rA = %b rB = %b srcA = %g srcB = %g\n",cnd,icode,rA,rB,srcA,srcB);
endmodule