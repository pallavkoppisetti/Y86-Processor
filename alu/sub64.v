module sub64(a,b,sum,of);
input signed [63:0] a,b;
output signed [63:0] sum;
output of;

// 2's complement addition

wire signed [63:0] not_b;

not64 func(b,not_b);

wire [64:0] carry;
assign carry[0] = 1'b1;

genvar i;
generate
for (i = 0; i < 64; i = i + 1) 
begin
    add11 x(a[i], not_b[i], carry[i], sum[i],carry[i + 1]);
end
endgenerate

xor(of, carry[64], carry[63]);

endmodule

