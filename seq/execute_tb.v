module execute_tb;

 reg [3:0] icode;
  reg [3:0] ifun;
  reg [63:0] valA;
  reg [63:0] valB;
  reg [63:0] valC;
  wire [63:0] valE;
  wire cnd;


  execute execute(
    .icode(icode),
    .ifun(ifun),
    .valA(valA),
    .valB(valB),
    .valC(valC),
    .cnd(cnd),
    .valE(valE)
  );

  initial begin

     $dumpfile("execute.vcd");
    $dumpvars(0,execute_tb);

    icode = 4'b10;
    ifun = 4'b110;
   
    valA = 64'b11101010;
    valB = 64'b10010;
    valC = 64'b1001100;
   
  end
    

  
initial 
  begin
		$monitor("icode=%b ifun=%b valA=%d valB=%d valE=%d\n",icode,ifun,valA,valB,valE);
  end
endmodule