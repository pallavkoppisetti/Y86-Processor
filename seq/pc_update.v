module pc_update(pc,icode,cnd,valC,valM,valP);
   input [3:0] icode;
   input cnd;
   input signed [63:0] valC;
   input signed [63:0] valM;
   input signed [63:0] valP;
   output reg signed [63:0] pc;

  
   always @(*) 
   begin
    pc = icode==4'h8 ? valC: icode==4'h7 ? (cnd ? valC : valP): icode==4'h9 ? valM : valP;
   end


endmodule