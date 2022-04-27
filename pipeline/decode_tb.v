//`include "decode.v"
`include "fetch.v"


module decode_tb;
reg [3:0] M_icode,W_icode,e_dstE,M_dstE,M_dstM,W_dstE,W_dstM;
reg [63:0] W_valM,M_valA,e_valE,M_valE,m_valM,W_valE;
wire [144:0] decode_reg, decode_reg1;
wire [216:0] execute_reg, execute_reg1;
reg M_cnd,clk;


fetch a1(M_icode,M_cnd,M_valA,W_icode,W_valM,clk,decode_reg);

decode a2(decode_reg,clk,e_dstE,M_dstE,W_dstE,e_valE,m_valM,W_valE,M_valE,W_dstM,M_dstM,W_valM,execute_reg);


initial begin
	
        //$monitor("main  %d ",pc);
        $dumpfile("decode.vcd");
        $dumpvars(0,decode_tb);
        clk= 0;
        M_icode = 0;
        M_valA = 0;
        M_cnd = 0;
        W_icode = 0;
        W_valM = 0;
        

end
always @(*)
begin

	decode_reg1 = deocde_reg;
	execute_reg1 = execute_reg;
end
always begin
                $display("%h %h",decode_reg,execute_reg);
        if(decode_reg[143:140]==0)
        begin
                              #5;
                              clk=~clk;
                              #5;
            #1000 $finish;
        end
        else
	begin
		
                #5 clk = ~clk;
	end
end
endmodule