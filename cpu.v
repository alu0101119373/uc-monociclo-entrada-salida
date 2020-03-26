module cpu(input wire clk, reset, input wire [7:0] iport1, iport2, iport3, iport4, output wire [7:0] oport1, oport2, oport3, oport4);
//Procesador sin memoria de datos de un solo ciclo

// Cables de interconexion
wire s_inc, s_inm, we3, wez, wen, s_z, s_n, wesp, bp, push, pop, s_inp, s_outp;
wire owe1, owe2, owe3, owe4;
wire interrupToUC, finInterrup;
wire [2:0] opalu;
wire [5:0] opcode;
wire [3:0] pEntrada;

// Camino de datos
cd datapath(clk, reset, iport1, iport2, iport3, iport4, s_inc, s_inm, we3, wez, wen, wesp, bp, push, pop, s_inp, s_outp, owe1, owe2, owe3, owe4,finInterrup, opalu, s_z, s_n, interrupToUC, pEntrada, oport1, oport2, oport3, oport4, opcode);

// Unidad de control
uc u(clk, opcode, s_z, s_n, interrupToUC, pEntrada, s_inc, s_inm, we3, wez, wen, wesp, bp, push, pop, s_inp, s_outp, owe1, owe2, owe3, owe4, finInterrup, opalu);

endmodule
