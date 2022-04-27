module fetch(M_icode,M_cnd,M_valA,W_icode,W_valM,clk,decode_reg);
input [3:0] M_icode;
input M_cnd;
input [63:0] M_valA;
input [3:0] W_icode;
input [63:0] W_valM;
output reg [144:0] decode_reg;
input clk;

reg [7:0] i_mem[0:12];
initial begin
    $readmemh("instruct_mem.mem", instruct_mem);
end

reg [3:0] rA;
reg [3:0] rB;
reg [3:0] icode;
reg [3:0] ifun;
reg [63:0] valC;
reg [63:0] ppc; //program counter
reg status; //status register AOK,etc
reg imem_error;
wire [63:0] f_pc;
reg valid_inst; 

initial begin 
    ppc = 64'b0;
    imem_error = 1'b0;
    valid_inst = 1'b1;
end


pc x(M_icode,M_cnd,M_valA,W_icode,W_valM,ppc,f_pc);

// align and split instructions
always @(posedge clk) // +ve edge cycle
begin 
    ppc = f_pc;
    rA = 15;
    rB = 15;
    if(f_pc >200) 
        imem_error = 1;
    else
    begin 
        if(i_mem[f_pc][7:4] >11)
                valid_inst = 0; 
        ifun = i_mem[f_pc][3:0];
        icode = i_mem[f_pc][7:4];
        ppc = ppc + 1;
        if(i_mem[f_pc][7:4] ==2 || i_mem[f_pc][7:4] ==3 || i_mem[f_pc][7:4] == 4 || i_mem[f_pc][7:4] == 5 || i_mem[f_pc][7:4] == 6 || i_mem[f_pc][7:4] == 10 || i_mem[f_pc] == 11)
		begin
			ppc =ppc+1;
			if(i_mem[f_pc][7:4] == 3)
			begin
				rA = 15;
				rB = i_mem[f_pc+1][3:0];
			end
			else if(i_mem[f_pc][7:4] == 10 || i_mem[f_pc][7:4]==11)
			begin
				rB = 15;
				rA  = i_mem[f_pc+1][7:4];
			end
			else
			begin
				rA = i_mem[f_pc+1][7:4];
				rB = i_mem[f_pc+1][3:0];
			end
		end	
		if(i_mem[f_pc][7:4] == 3 || i_mem[f_pc][7:4] == 4 ||i_mem[f_pc][7:4] == 5 || i_mem[f_pc][7:4] == 7 || i_mem[f_pc][7:4] == 8)
		begin
            if (i_mem[f_pc][7:4]==8 || i_mem[f_pc][7:4]==7)
			begin
				valC[7:0] = i_mem[f_pc+1];
				valC[15:8] = i_mem[f_pc+2];
				valC[23:16] = i_mem[f_pc+3];
				valC[31:24] = i_mem[f_pc+4];
				valC[39:32] = i_mem[f_pc+5];
				valC[47:40] = i_mem[f_pc+6];
				valC[55:48] = i_mem[f_pc+7];
				valC[63:56] = i_mem[f_pc+8];
				ppc = ppc+8;
			end
			else
			begin
				valC[7:0] = i_mem[f_pc+2];
				valC[15:8] = i_mem[f_pc+3];
				valC[23:16] = i_mem[f_pc+4];
				valC[31:24] = i_mem[f_pc+5];
				valC[39:32] = i_mem[f_pc+6];
				valC[47:40] = i_mem[f_pc+7];
				valC[55:48] = i_mem[f_pc+8];
				valC[63:56] = i_mem[f_pc+9];
				ppc = ppc+8;
			end
		end
    end 
    if(imem_error == 0 && valid_inst == 1)
		status = 1;
	else
		status = 0;

	
	decode_reg[143:140] = icode;
	decode_reg[139:136] = ifun;
	decode_reg[135:132] = rA;
	decode_reg[131:128] = rB;
	decode_reg[127:64] = valC;
	decode_reg[63:0] = ppc;
    decode_reg[144] = status;
    // To keep the outputs for the decode register
	
	if(icode == 7 || icode == 8)
		ppc = valC;
end
endmodule

module pc(M_icode,M_cnd,M_valA,W_icode,W_valM,ppc,f_pc);
input [3:0] M_icode;
input M_cnd;
input [63:0] M_valA;
input [3:0] W_icode;
input [63:0] W_valM;
input [63:0] ppc;
output reg [63:0] f_pc; 

initial begin
    f_pc = 0;
end 
always @(*)
begin 
    if(M_icode == 7 && !M_cnd)
		f_pc = M_valA;
	else if(W_icode != 9) 
		f_pc = ppc;
	else 
		f_pc = W_valM;
end 
endmodule

