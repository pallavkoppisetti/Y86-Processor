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