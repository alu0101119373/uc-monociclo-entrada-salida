module cd(input wire clk, reset, s_inc, s_inm, we3, wez, input wire [2:0] op_alu, output wire s_z, output wire [5:0] opcode);
//Camino de datos de instrucciones de un solo ciclo
    wire [15:0] instruccion;

    // Program counter
    wire [9:0] e_pc, s_pc;

    registro#(10) pc(clk, reset, 1'b1, e_pc, s_pc);

    // Calculo de la entrada del pc
    wire [9:0] s_sumador;

    sum sumador(s_pc, 10'b1, s_sumador);

    mux2#(10) mux_sum_pal (instruccion[9:0], s_sumador, s_inc, e_pc);

    // Memoria de programa
    memprog memoria_programa(clk, s_pc, instruccion);

    // Banco de registros
    wire [7:0] wd3, rd1, rd2;

    regfile banco_registros (clk, we3, instruccion[11:8], instruccion[7:4], instruccion[3:0], wd3, rd1, rd2);

    // Calculo de dato a escribir (wd3)
    wire [7:0] s_alu;

    mux2 mux_wd3 (s_alu, instruccion[11:4], s_inm, wd3);

    // ALU
    wire zalu;

    alu uni_art_log(rd1, rd2, op_alu, s_alu, zalu);

    // FFZ
    ffd ffz(clk, reset, zalu, wez, s_z);

    assign opcode = instruccion[15:10];

endmodule
