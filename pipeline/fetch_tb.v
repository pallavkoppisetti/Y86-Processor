`include "fetch.v"

module fetch_tb;
reg clk,M_cnd;
reg [3:0] M_icode,W_icode;
reg [63:0] M_valA,W_valM;
wire [144:0] decode_reg;


parameter stop_time = 2000;
initial #stop_time $finish;

fetch calls(clk,M_icode,M_cnd,M_valA,W_icode,W_valM,decode_reg);

initial begin
	
	$dumpfile("fetch.vcd");
	$dumpvars(0,fetch_tb);
	clk = 0;
	M_icode= 0;
	M_valA = 0;
	M_cnd = 0;
	W_icode =0;
	W_valM = 0;
end
always begin
	if(D[143:140]==0)
	begin
		$display("done");
		$finish;
	end
	else
		#5 clk = ~clk;
end
endmodule