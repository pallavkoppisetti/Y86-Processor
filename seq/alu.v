//`include "../xor/xor64.v"
//`include "../add/add1.v"
//`include "../sub/not.v"
//`include "../add/add64.v"
//`include "../sub/sub64.v"
//`include "../and/and64.v"
module xor64(a,b,out);
input signed [63:0] a;
input signed [63:0] b;
output signed [63:0] out;
genvar i;
generate for (i = 0 ; i <= 63 ; i = i + 1) begin
    xor (out[i],a[i],b[i]);
end
endgenerate
endmodule

module and64(a,b,out);
input signed [63:0] a;
input signed [63:0] b;
output signed [63:0] out;
genvar i;
generate for (i = 0 ; i <= 63 ; i = i + 1) begin
    and (out[i],a[i],b[i]);
end
endgenerate
endmodule

module not64(b,not_b);
input signed [63:0] b;
output signed [63:0] not_b;

genvar i;
generate for (i = 0; i < 64 ; i = i + 1) 
begin
    not(not_b[i],b[i]);  
end
endgenerate

endmodule

module add11(a,b,carry_in,sum,carry_out);
input a,b,carry_in;
output sum,carry_out;

wire t1,t2,t3;
xor (sum,a,b,carry_in);
xor (t1,a,b);
and (t2,t1,carry_in);
and (t3,a,b);
or (carry_out,t2,t3);

endmodule

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

module add64(a,b,sum,of);
input signed [63:0] a,b;
output signed [63:0] sum;
output of;

// carry out
wire [64:0] carry;
assign carry[0] = 1'b0;

genvar i;
generate
for (i = 0; i < 64; i = i + 1) 
begin
    add11 x(a[i], b[i], carry[i], sum[i],carry[i + 1]);
end
endgenerate

xor(of, carry[64], carry[63]);

endmodule



module alu(a,b,select,out,of);
input signed [63:0] a,b;
input signed [1:0] select;
output signed [63:0] out;
output of;

wire signed [63:0] dummy_1,dummy_2,dummy_3,dummy_4;
wire signed of1,of2;
reg signed [63:0] dummy_out;
reg signed dummy_of;

and64 func1(a,b,dummy_1);
xor64 func2(a,b,dummy_2);
add64 func3(a,b,dummy_3,of1);
sub64 func4(a,b,dummy_4,of2);


always @(*) 
begin
    case(select)
        2'b00:begin
            dummy_out = dummy_3;
            dummy_of = of1;
        end
        2'b01:begin
            dummy_out = dummy_4;
            dummy_of = of2;
        end
        2'b10:begin
            dummy_out = dummy_1;
            dummy_of = 1'b0;
        end
        2'b11:begin
            dummy_out = dummy_2;
            dummy_of = 1'b0;
        end
    endcase
end

assign out = dummy_out;
assign of = dummy_of;

endmodule
