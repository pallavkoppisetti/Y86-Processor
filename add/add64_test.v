module testbench;
reg signed [63:0] a;
reg signed [63:0] b;
wire signed [63:0] sum;
wire signed of;
add64 y(a,b,sum,of);


initial begin
    $dumpfile("add64.vcd");
    $dumpvars(0,testbench);
    $monitor($time, " x=%b \n\t\t   y=%b \n\t\t   sum=%b\n\t\t   overflow = %b", a, b, sum,of);
    a = 64'b01;
    b = 64'b11;
    #5 a = 64'd10; b = 64'd21;
    #10 a = 64'd546 ; b = 64'd7;
    #15 a =  64'd9223372036854775807; b = 64'd1;
    

end

endmodule 
