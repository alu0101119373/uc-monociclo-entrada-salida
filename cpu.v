module cpu(input wire clk, reset);
//Procesador sin memoria de datos de un solo ciclo

// Cables de interconexion
wire s_inc, s_inm, we3, wez, s_z, wesp, push, pop;
wire [2:0] opalu;
wire [5:0] opcode;

// Camino de datos
cd datapath(clk, reset, s_inc, s_inm, we3, wez, wesp, push, pop, opalu, s_z, opcode);

// Unidad de control
uc u(clk, opcode, s_z, s_inc, s_inm, we3, wez, wesp, push, pop, opalu);

endmodule
