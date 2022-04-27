module decode(decode_reg,clk,e_dstE,M_dstE,W_dstE,e_valE,m_valM,W_valE,M_valE,W_dstM,M_dstM,W_valM,execute_reg);
input [144:0] decode_reg;
input clk;
input [3:0] e_dstE,M_dstE,W_dstE;
input [3:0] W_dstM,M_dstM;
input [63:0] e_valE,m_valM,W_valE,W_valM,M_valE;
output reg [216:0] execute_reg;
wire [3:0] dstE,dstM; 
wire [3:0] srcA,srcB;

reg [63:0] valA,valB; 

//register file 
reg [63:0] regfile[0:15];
initial begin
    regfile[2] = 0;
    regfile[4] = 0;
end 



// Destination and source register 
dstE1 m1(decode_reg,dstE);
dstM1 m2(decode_reg,dstM);
srcA1 m3(decode_reg,srcA);
srcB1 m4(decode_reg,srcB);

// Decode and writeback with +ve edge of clock

always @(posedge clk) 
begin
        valA = 0;
        valB = 0;
        if(srcA != 15)
		valA =regfile[srcA];
	    if(srcB != 15)
		valB =regfile[srcB];
	    if(srcA !=15)
	    begin
            if(decode_reg[143:140] == 7 || decode_reg[143:140] == 8) 
                valA = decode_reg[63:0];
            else if (srcA ==  e_dstE) 
                valA = e_valE;
            else if(srcA == M_dstM) 
                valA = m_valM;
            else if(srcA == M_dstE) 
                valA = M_valE;
            else if(srcA == W_dstM) 
                valA = W_valM;
            else if(srcA == W_dstE) 
                valA = W_valE;
	    end
	    if(srcB!=15)
	    begin
            if(srcB ==  e_dstE) 
                valB = e_valE;
            else if(srcB == M_dstM) 
                valB = m_valM;
            else if(srcB == M_dstE) 
                valB = M_valE;
            else if(srcB == W_dstM)
                valB = W_valM;
            else if(srcB == W_dstE) 
                valB = W_valE;  
	    end

   
	execute_reg[215:212] = decode_reg[143:140];
	execute_reg[211:208] = decode_reg[139:136];
	execute_reg[207:144] = decode_reg[127:64];
	execute_reg[143:80] = valA;
	execute_reg[79:16] = valB;
	execute_reg[15:12] = dstE;
	execute_reg[11:8] = dstM;
	execute_reg[7:4] = srcA;
	execute_reg[3:0] = srcB;
    execute_reg[216] = decode_reg[144];
    
    
end

// writeback on +ve edge of clock
always @(posedge clk)
begin
    if(W_dstE!= 15)
        regfile[W_dstE] = W_valE;
    if(W_dstM!= 15)
        regfile[W_dstM] = W_valM;

end
endmodule 

module srcA1(decode_reg,srcA);
input [144:0] decode_reg;
output reg [3:0] srcA;
always @(*) 
begin
    if(decode_reg[143:140] == 2 || decode_reg[143:140] == 4 || decode_reg[143:140] == 6 || decode_reg[143:140] == 10)       
        srcA = decode_reg[135:132];
	else if(decode_reg[143:140] == 11 || decode_reg[143:140] == 9) 
        srcA = 4;
	else
		srcA = 15;
end
endmodule 

module srcB1(decode_reg,srcB);
input [144:0] decode_reg;
output reg [3:0] srcB;
always @(*)
begin
	if(decode_reg[143:140] == 4 || decode_reg[143:140] == 5 || decode_reg[143:140] == 6) srcB = decode_reg[131:128];
	else
		srcB = 15;
end
endmodule 

module dstE1(decode_reg,dstE);
input [144:0] decode_reg;
output reg [3:0] dstE;
always @(*)
begin
	if(decode_reg[143:140]== 2) 
        dstE = decode_reg[131:128];
	else if(decode_reg[143:140] == 3 || decode_reg[143:140] == 6) 
            dstE = decode_reg[131:128];
	else if(decode_reg[143:140] == 8 || decode_reg[143:140] == 9 || decode_reg[143:140] == 10 ||decode_reg[143:140] == 11) 
        dstE = 4;
	else dstE = 15;
end
endmodule

module dstM1(decode_reg,dstM);
input [144:0] decode_reg;
output reg [3:0] dstM;
always @(*)
begin
	if(decode_reg[143:140] == 5 || decode_reg[143:140] == 11)
		dstM = decode_reg[135:132];
	else dstM = 15;
end
endmodule