module testbench;
reg [1:0] select;
reg signed [63:0] a;
reg signed [63:0] b;

wire signed [63:0] out;
wire of;

alu func(a,b,select,out,of);

initial begin
    $dumpfile("Alu.vcd");
    $dumpvars(0, testbench);
    a = 64'b11; 
    b = 64'b01;
    select = 2'b00;
    #10 select = 2'b01; a = 64'd34 ; b = 64'd12;
    #10 select = 2'b10; a = 64'd12 ; b = 64'd34;
    #10 select = 2'b11; a = 64'd1112; b = 64'd345;
    #10 select = 2'b00; a = 64'd8; b = 64'd2;
    #10 select = 2'b01; a = 64'd9; b = 64'd8;
    #10 select = 2'b10; a = 64'd15; b = 64'd7;
    #10 select = 2'b11; a = 64'd15; b = 64'd7;
    #10 select = 2'b00; a = 64'd9223372036854775807; b = 64'd1;
    #10 select = 2'b01; a = 64'd9223372036854775807; b = ~64'd1;
    #10 select = 2'b10; a = 64'd0; b = 64'd9223372036854775807;
    #10 select = 2'b11; a = 64'd0; b = 64'd9223372036854775807;
    #10 select = 2'b00; a = 64'd1; b = 64'd1;
    #10 select = 2'b01; a = 64'd1; b = 64'd1;
    #10 select = 2'b10; a = 64'd100001; b = 64'd000011;
    #10 select = 2'b11; a = 64'd101101; b = 64'd110011;
end

initial 
    $monitor($time, " x = %b\n\t\t     y = %b\n\t\t     output = %b\n\t\t     Overflow = %d\n", a, b, out, of);

endmodule