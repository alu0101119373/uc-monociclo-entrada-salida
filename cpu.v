module cpu(input wire clk, reset);
//Procesador sin memoria de datos de un solo ciclo

// Cables de interconexion
wire s_inc, s_inm, we3, wez, wen, s_z, s_n, wesp, bp, push, pop;
wire [2:0] opalu;
wire [5:0] opcode;

// Camino de datos
cd datapath(clk, reset, s_inc, s_inm, we3, wez, wen, wesp, bp, push, pop, opalu, s_z, s_n, opcode);

// Unidad de control
uc u(clk, opcode, s_z, s_n, s_inc, s_inm, we3, wez, wen, wesp, bp, push, pop, opalu);

endmodule
