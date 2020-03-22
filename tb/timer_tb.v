`timescale 1 ns / 10 ps

module timer_tb;

reg clk, reset;

always
begin
    clk = 1'b1;
    cont = cont + 1;
    #30;
    clk = 1'b0;
    #30;
end

wire pulse;

reg [7:0] cont;

timer tm (clk, reset, 4'b1010, pulse);

initial
begin
    $dumpfile("timer_tb.vcd");
    $dumpvars;
    cont = 0;
    reset = 1;
    #10;
    reset = 0;
end

initial
begin
    #(100*60);
    $finish;
end

endmodule