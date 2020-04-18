`timescale 1 ns / 10 ps

module cpu_tb;


reg clk, reset;

// Contador de ciclos de reloj
reg [9:0] cont;

// generación de reloj clk
always //siempre activo, no hay condición de activación
begin
  clk = 1'b1;
  #30;
  clk = 1'b0;
  #30;
  cont = cont + 10'b1;
end

// Representacion de los 4 leds
wire led1, led2, led3, led4;
reg [7:0] iport1, iport2, iport3, iport4;
wire [7:0] oport1, oport2, oport3, oport4;
wire pInt1, pInt2, pInt3, pInt4;

// instanciación del procesador
cpu micpu(clk, reset, pInt1, pInt2, pInt3, pInt4, iport1, iport2, iport3, iport4, oport1, oport2, oport3, oport4);

// Timer
timer tm(clk, reset, oport4, pInt1);

wire pulse = 1'b0;

// TEST
initial
begin
  iport4 = 1'b0;
  iport3 = 1'b0;
  // #(30*60)
  // iport3 = 1'b1;
  // #(30*60)
  // iport3 = 1'b0;
  // #(60*60)
  // iport4 = 1'b1;
  // #(15*60)
  // iport4 = 1'b0;
  // #(15*60)
  // iport4 = 1'b1;
  // #(15*60)
  // iport4 = 1'b0;
end

initial
begin
  iport1 = 1'b0;
  #(200*60);

  // Modo 1
  iport1 = 1'b1;
  #(40*60);
  iport1 = 1'b0;

  #(300*60);

  // Modo 2
  iport1 = 1'b1;
  #(40*60)
  iport1 = 1'b0;

  #(150*60)
  
  // Modo 3
  iport1 = 1'b1;
  #(40*60)
  iport1 = 1'b0;
end

// Asignaciones
assign led1 = oport1[0];
assign led2 = oport1[1];
assign led3 = oport1[2];
assign led4 = oport1[3];

initial
begin
  $dumpfile("cpu_tb.vcd");
  $dumpvars;
  cont = 10'b0;
  reset = 1;  //a partir del flanco de subida del reset empieza el funcionamiento normal
  #10;
  reset = 0;  //bajamos el reset 
end

initial
begin
  #(1000*60);  //Esperamos 1000 ciclos o 1000 instrucciones
  $finish;
end

endmodule