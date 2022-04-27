module reg_file(valA,valB,valM,valE,dstE,dstM,srcA,srcB);

input [63:0] valM;
input [63:0] valE;
input [3:0] dstE;
input [3:0] dstM;
input [3:0] srcA;
input [3:0] srcB;

output [63:0] valA;
output [63:0] valB;
reg [63:0] file [14:0];
wire [63:0] n_reg;
reg [63:0] val_A;
reg [63:0] val_B;
always @* begin
    if(srcA == 4'hf) begin
     val_A = 64'h0;
end
end
always @* begin
    if(srcA != 4'hf) begin
    val_A = file[srcA];
end
end

always @* begin
    if(srcB == 4'hf) begin
     val_B = 64'h0;
end
end
always @* begin
    if (srcB != 4'hf) begin
     val_B = file[srcB];
end
end



always @* 
begin
    if(dstE < 4'hf) begin 
        file[dstE] = valE;
    end

end

always @* begin
    if(dstM < 4'hf) begin
        file[dstM] = valM;
    end
end

assign valA = val_A;
assign valB = val_B;

endmodule