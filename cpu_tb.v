`timescale 1 ns / 10 ps

module cpu_tb;


reg clk, reset;


// generación de reloj clk
always //siempre activo, no hay condición de activación
begin
  clk = 1'b1;
  #30;
  clk = 1'b0;
  #30;
end

// Representacion de los 4 displays 7 seg
wire led1, led2, led3, led4;
wire [7:0] iport1, iport2, iport3, iport4;
wire [7:0] oport1, oport2, oport3, oport4;
wire pInt1, pInt2, pInt3, pInt4;

// instanciación del procesador
cpu micpu(clk, reset, pInt1, pInt2, pInt3, pInt4, iport1, iport2, iport3, iport4, oport1, oport2, oport3, oport4);

// Timer
timer tm(clk, reset, port4, pInt1);

// Asignaciones
assign led1 = oport1[0];
assign led2 = oport1[1];
assign led3 = oport1[2];
assign led4 = oport1[3];

initial
begin
  $dumpfile("cpu_tb.vcd");
  $dumpvars;
  reset = 1;  //a partir del flanco de subida del reset empieza el funcionamiento normal
  #10;
  reset = 0;  //bajamos el reset 
end

initial
begin
  #(100*60);  //Esperamos 100 ciclos o 100 instrucciones
  $finish;
end

endmodule