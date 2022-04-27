module testbench;
reg signed [63:0] a;
reg signed [63:0] b;
wire signed [63:0] out;
xor64 func(a,b,out);


initial begin
    $dumpfile("xor64.vcd");
    $dumpvars(0,testbench);
    $monitor($time, " x=%b \n\t\t   y=%b \n\t\t   out=%b\n\t\t"  , a, b, out);
    a = 64'b0101;
    b = 64'b11;
    #5 a = 64'b11110101; b = 64'd211;
    #10 a = 64'd456; b = 64'd789;
    #15 a = 64'd123; b = 64'd456;

end

endmodule 
