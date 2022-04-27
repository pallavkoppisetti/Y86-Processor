module execute(clk,execute_reg,W_status,m_status,e_valE,e_dstE,memory_reg);
input clk;
input [216:0] execute_reg;
input W_status;
input m_status;
output [63:0] e_valE;
output [3:0] e_dstE;
output reg [144:0] memory_reg;

reg cnd = 0;
reg [2:0] op = 0;

reg [63:0] e_valE;
reg [3:0] e_dstE;
reg [144:0] M;
wire [63:0] aluA;
wire [63:0] aluB;
wire [1:0] aluC;
reg [63:0] valE;
reg [3:0] ifun;

alu1 a1(execute_reg,aluA);
alu2 a2(execute_reg,aluB);
alu3 a3(execute_reg,aluC);

always @ (posedge clk)
begin
	if (execute_reg[215:212] != 6 && aluC == 0)
		valE = aluA + aluB;
	else if (execute_reg[215:212] == 6)
	begin
		op = 0;
		if(aluC == 0)
		begin
			valE = aluA + aluB;
                if(valE == 0)
                        op[0] = 1;
                if (valE[63]==1)
                        op[1] =1;
                if( (valE[63]==1 && aluA[63]==0 && aluB[63]==0) || (valE[63]==0 && aluA[63]==1 && aluB[63]==1))
                        op[2] =1;
                end
		else if (aluC == 1)
		begin
			valE = aluB+(-aluA);
                if(valE == 0)
                        op[0] = 1;
                if (valE[63]==1)
                        op[1] =1;
                if( (valE[63]==1 && aluA[63]==0 && aluB[63]==0) || (valE[63]==0 && aluA[63]==1 && aluB[63]==1))
                        op[2] =1;
                end
		else if (aluC == 2)
		begin
			valE = aluB & aluA;
		if (valE ==  0) op[0] = 1;
		end
		else if (aluC == 3) 
		begin
			valE = aluB^aluA;
			if(valE == 0) op[0] =1;
		end
	end
	if(execute_reg[215:212] == 7 || execute_reg[215:212] == 2)
	begin
        cnd = 0;  
	    ifun = execute_reg[211:208];
        if(ifun == 1 && (op[0] == 1 || (op[1]==1 && op[2] == 0)))
                cnd = 1;

        else if(ifun == 2 &&  (op[1]==1 && op[2] == 0))
                cnd = 1;
        else if(ifun == 3 && (op[0] == 1 ))
                cnd = 1;
        else if(ifun == 4 && (op[0] == 0))
                cnd = 1;
        else if(ifun == 5 && (op[0] == 1 ||(op[1] == 0 && op[2] == 0)))
                cnd = 1;
        else if(ifun == 6 && (op[1] == 0 && op[2] == 0))
                cnd = 1;
	
	end
	memory_reg[144] = execute_reg[216];
	memory_reg[143:140] =execute_reg[215:212];
	memory_reg[139:136] = cnd;
	memory_reg[135:72] = valE;
	e_valE  = valE;
	memory_reg[71:8] = execute_reg[143:80];
	if((execute_reg[215:212] == 2 && cnd == 1) || (execute_reg[215:212] != 2))
	begin
		e_dstE = execute_reg[15:12];
		memory_reg[7:4] = execute_reg[15:12];
	end
	else
	begin
		e_dstE = 15;
		memory_reg[7:4] = 15;
	end
	memory_reg[3:0] = execute_reg[11:8];

	
end
endmodule

module alu1(execute_reg,aluA);
input [216:0] execute_reg;
output reg [63:0] aluA;
reg [3:0] icode;
always @(*) begin
    icode = execute_reg[215:212];
	if(icode == 2 || icode == 6) 
        aluA = execute_reg[143:80];
	if(icode == 3 || icode  == 4 || icode == 5) 
        aluA = execute_reg[207:144];
	if(icode == 8 || icode == 10) 
        aluA = 8;
	if(icode == 9 || icode == 11) 
        aluA = -8;
    
end
endmodule

module alu2(execute_reg,aluB);
input [216:0] execute_reg;
output reg [63:0] aluB;
reg [3:0] icode;
always @(*) begin
    icode = execute_reg[215:212];
	if(icode == 4 || icode == 5 || icode == 6 || icode  == 8 || icode == 10 || icode == 11 || icode == 9) 
        aluB = execute_reg[79:16];
	if(icode == 2 || icode == 3) 
        aluB = 0;
    
end
endmodule 

module alu3(execute_reg,aluC);
input [216:0] execute_reg;
output reg [1:0] aluC;
always @(*) begin
    if(execute_reg[215:212] == 6) aluC = execute_reg[211:208];
	else aluC = 0;
    
end
endmodule

