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

