module pipeline_wrapper;

wire [3:0] M_icode;
wire [63:0] M_valA;
wire M_cnd;
wire [3:0] W_icode;
wire [63:0] W_valM;
wire [144:0] decode_reg;
wire [3:0] e_dstE;
wire [63:0] e_valE;
wire [3:0] M_dstE;
wire [63:0] M_valE;
wire [3:0] M_dstM;
wire [63:0] m_valM;
wire [3:0] W_dstE;
wire [63:0] W_valE;
wire [3:0] W_dstM;
wire [216:0] execute_reg;
wire [144:0] memory_reg;
wire status;
wire [144:0] writeback_reg;

reg [144:0] decode_reg1;
reg [216:0] execute_reg1;
reg W_status;
reg m_status;
reg clk;
reg [144:0] memory_reg1;
reg [144:0] writeback_reg1;

fetch q1(M_icode,M_cnd,M_valA,W_icode,W_valM,clk,decode_reg);
decode q2(decode_reg,clk,e_dstE,M_dstE,W_dstE,e_valE,m_valM,W_valE,M_valE,W_dstM,M_dstM,W_valM,execute_reg);
execute q3();
memory q4(memory_reg,clk,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,m_valM,status,writeback_reg);

initial begin
    $dumpfile("pipeline_wrapper.vcd");
    $dumpvars(0,pipelinetb);
    clk = 0; 
    M_icode = 0;
    M_cnd = 0;
    M_valA = 0;
    W_icode = 0;
    W_valM = 0;
end
always @(*) begin
    decode_reg1 = decode_reg;
    execute_reg1 = execute_reg;
    memory_reg1 = memory_reg;
    writeback_reg1 = writeback_reg;
end

always begin
    $display("%h %h",decode_reg,execute_reg);
    if (decode[143:140] == 0) begin
        #5 clk = ~clk;
        #5 clk = ~clk;
        
        #1000 $finish;
        
    end
    else 
    begin
        #5 clk = ~clk;
        
    end
end

endmodule