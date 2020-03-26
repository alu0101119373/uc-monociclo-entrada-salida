module cd(input wire clk, reset, intPort1, intPort2, intPort3, intPort4, input wire [7:0] e_port1, e_port2, e_port3, e_port4, input wire s_inc, s_inm, we3, wez, wen, wesp, bp, push, pop, s_inp, s_outp, owe1, owe2, owe3, owe4, finInterrup, input wire [2:0] op_alu, output wire s_z, s_n, interruptionToUC, output wire [3:0] pEntrada, output wire [7:0] s_port1, s_port2, s_port3, s_port4, output wire [5:0] opcode);
//Camino de datos de instrucciones de un solo ciclo
    wire [15:0] instruccion;

    // Program counter
    wire [9:0] e_pc, s_pc, s_mux_pc;

    registro#(10) pc(clk, reset, 1'b1, e_pc, s_pc);

    // Pila
    wire [9:0] s_pila, s_sumador_pc;

    pila stack(clk, reset, wesp, push, pop, s_sumador_pc, s_pila);

    // Gestor de interrupciones
    wire intPort1, intPort2, intPort3, intPort4;
    wire [9:0] s_gestInt;

    gestInterrup gestorInt (reset, intPort1, intPort2, intPort3, intPort4, finInterrup, s_gestInt, interruptionToUC);

    // Calculo de la entrada del pc
    sum sumador(s_pc, 10'b1, s_sumador_pc);

    mux2#(10) mux_sum_pal (instruccion[9:0], s_sumador_pc, s_inc, s_mux_pc);
    
    // Para conectar el registro PC con la pila
    wire [9:0] s_mux_pc_pila;
    mux2#(10) mux_pc_stack (s_mux_pc, s_pila, pop, s_mux_pc_pila);

    // Mux para conectar el PC con el gestor de interrupciones
    mux2#(10) mux_pc_int (s_mux_pc_pila, s_gestInt, s_interrup, e_pc);

    // Memoria de programa
    memprog memoria_programa(clk, s_pc, instruccion);

    // Banco de registros
    wire [7:0] wd3, rd1, rd2;
    wire [3:0] ra1;

    // ra1 variara en funcion de si es un output o no
    mux2#(4) mux_outp (instruccion[11:8], instruccion[5:2], s_outp, ra1);

    regfile banco_registros (clk, we3, ra1, instruccion[7:4], instruccion[3:0], wd3, rd1, rd2);

    // Puertos de entrada
    wire [7:0] s_input;

    mux4 mux4_input(e_port1, e_port2, e_port3, e_port4, instruccion[7], instruccion[6], s_input);

    // Calculo de dato a escribir (wd3)
    wire [7:0] s_alu, s_mux1_wd3;

    mux2 mux_wd3 (s_alu, instruccion[11:4], s_inm, s_mux1_wd3);

    // Multiplexor para elegir si se coge del input o interno a la cpu
    mux2 mux_es_alu (s_mux1_wd3, s_input, s_inp, wd3);

    // Puertos de salida
    wire [7:0] s_port_salida;

    mux2 mux_port_salida (rd1, instruccion[11:4], s_inm, s_port_salida);

    registro oport1 (clk, reset, owe1, s_port_salida, s_port1);
    registro oport2 (clk, reset, owe2, s_port_salida, s_port2);
    registro oport3 (clk, reset, owe3, s_port_salida, s_port3);
    registro oport4 (clk, reset, owe4, s_port_salida, s_port4);

    // ALU
    wire zalu, carry, nalu;

    alu uni_art_log(rd1, rd2, op_alu, bp, carry, s_alu, nalu, zalu);

    // FFZ
    ffd ffz(clk, reset, zalu, wez, s_z);

    // FFN
    ffd ffn(clk, reset, nalu, wen, s_n);

    // TODO: Timer    

    // Selector del puerto de entrada
    mux2#(4) mux_pEntrada (instruccion[9:6], instruccion[3:0], s_inm, pEntrada);

    assign opcode = instruccion[15:10];

endmodule
