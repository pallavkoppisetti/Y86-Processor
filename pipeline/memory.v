module memory(memory_reg,clk,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,m_valM,status,writeback_reg);

input [144:0] memory_reg;
input clk;
output reg [3:0] M_icode;
output reg M_cnd;
output reg [63:0] M_valE;
output reg[63:0] M_valA;
output reg [3:0] M_dstE;
output reg [3:0] M_dstM;
output reg [63:0] m_valM;
output status;
output reg [144:0] writeback_reg;


reg [3:0] icode;
reg [63:0] valE,valA,valM;
reg read;
reg cnd;
reg dmem_error;
reg write;
reg [63:0] address;
reg [63:0] data;
reg [63:0] mem[0:200];

// +ve edge of the clock

// read and write the memory
// address it too

always @(posedge clk) begin
    dmem_error = 0;
	read = 0;
	icode =memory_reg[143:140];
	cnd = memory_reg[139:136];
	M_cnd = cnd;
	valA = memory_reg[71:8];
	valE = memory_reg[135:72];

        read =0;
        if(icode == 11 || icode == 5 || icode== 9)
                read = 1;
        
        write = 0;
        if (icode == 4 || icode == 8 || icode == 10)
        begin
                write = 1;
        end

    
        address = 0;
        if(icode  == 9 || icode == 11 )
                address = valA;
        else if(icode == 5 || icode == 4 || icode == 10 || icode == 8)
                address = valE;

	
        data = 0;
	if(icode == 4 || icode == 10 || icode == 8)
        begin
                data = valA;
        end

	
        if(address>200)
        begin
                dmem_error = 1;
        end
        else if(write === 1)
        begin
                mem[address] = data;
                
        end
        else if(read === 1)
        begin
                valM = mem[address];
	    end

	
	writeback_reg[144] = memory_reg[144];
	writeback_reg[143:140] = icode;
	
	writeback_reg[3:0] = memory_reg[3:0];
	writeback_reg[7:4] = memory_reg[7:4];
	writeback_reg[71:8] = valM;
	writeback_reg[135:72] = valE;
	
	M_valA = valA;
	M_icode = icode;
	M_cnd = cnd;
	M_valE = valE;
	M_dstE = memory_reg[7:4];
	M_dstM = memory_reg[3:0];
	m_valM = valM;
    
end


    
endmodule