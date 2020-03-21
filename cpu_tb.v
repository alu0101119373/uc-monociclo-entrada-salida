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
wire [7:0] display [0:3];

// instanciación del procesador
cpu micpu(clk, reset, 8'b0, 8'b0, 8'b0, 8'b0, display[0], display[1], display[2], display[3]);

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