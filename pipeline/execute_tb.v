`include "execute.v"
`include "decode.v"
`include "fetch.v"

module execute_tb;
reg [3:0] M_icode,W_icode,e_dstE,M_dstE,M_dstM,W_dstE,W_dstM;
reg [63:0] M_valA,W_valM,e_valE,M_valE,m_valM,W_dstE;
reg M_cnd,clk,W_stat,m_stat;
wire [144:0] D, decode_reg1,M,memory_reg1;
wire [216:0] E, execute_reg1;

fetch a1(clk,M_icode,M_cnd,M_valA,W_icode,W_valM,decode_reg);
decode a2(decode_reg1,clk,e_dstE,e_valE,M_dstE,M_valE,M_dstM,m_valM,W_dstE,W_valE,W_dstM,W_valM,execute_reg);
execute a3(clk,execute_reg1,W_stat,m_stat,e_valE,e_dstE,memory_reg);

parameter stop_time = 2000;
initial #stop_time $finish;

initial begin

        $dumpfile("execute.vcd");
        $dumpvars(0,execute_tb);
        
        clk,M_icode,M_valA,M_cnd,W_icode,W_valM  = 0;
      

end

always @(*)
begin

        decode_reg1 = decode_reg;
        execute_reg1 = execute_reg;
	    memory_reg1 = memory_reg;
end

always begin
                $display("%h %h",D,E);
        if(decode_reg[143:140]==0)
        begin
                              #5;
                              clk=~clk;
                              #5;
			      clk=~clk;
			      #5;
                $finish;
        end
        else
        begin

                #5 clk = ~clk;
        end
end
endmodule