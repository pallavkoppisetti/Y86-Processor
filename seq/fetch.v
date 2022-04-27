module instruction_memory(pc,s_byte,a_bytes,mem_error);
input [63:0] pc;
output reg [7:0] s_byte;
output reg [71:0] a_bytes;
output reg mem_error;
reg [7:0] instruct_mem[2047:0];

initial begin 
    $readmemh("instruct_mem.mem", instruct_mem);
end

always @(pc) begin
    s_byte <= instruct_mem[pc]; 
    a_bytes[71:64] <= instruct_mem[pc+1];
    a_bytes[63:56] <= instruct_mem[pc+2];
    a_bytes[55:48] <= instruct_mem[pc+3];
    a_bytes[47:40] <= instruct_mem[pc+4];
    a_bytes[39:32] <= instruct_mem[pc+5];
    a_bytes[31:24] <= instruct_mem[pc+6];
    a_bytes[23:16] <= instruct_mem[pc+7];
    a_bytes[15:8] <= instruct_mem[pc+8];
    a_bytes[7:0] <= instruct_mem[pc+9];
    mem_error <= (pc < 64'd0 || pc > 64'd2047) ? 1'b1 : 1'b0;


    
end

endmodule // instruction_memory 

module split(s_byte,icode,ifun);
input [7:0] s_byte;
output [3:0] icode;
output [3:0] ifun;
assign icode = s_byte[7:4];
assign ifun = s_byte[3:0];
endmodule // split

module align(a_bytes,n_regs,rA,rB,valC);
input [71:0] a_bytes;
input n_regs;
output [3:0] rA;
output [3:0] rB;
output [63:0] valC;
assign rA = a_bytes[71:68];
assign rB = a_bytes[67:64];
assign valC = n_regs ? a_bytes[63:0] : a_bytes[71:8];
endmodule // align

module pc_inc(pc1,n_regs,n_valC,valP);
input [63:0] pc1;
input n_regs;
input n_valC;
output [63:0] valP;
assign valP = pc1 + 1 + 8*n_valC + n_regs;
endmodule // pc_inc

