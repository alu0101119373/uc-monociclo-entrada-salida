module pila (input clk, reset, weSP, push, pop, input wire [9:0] entrada, output wire [9:0] salida);

    wire [9:0] dir, s_sp, e_sp;

    // Memoria de la pila
    mempila memoria(clk, push, pop, dir, entrada, salida);

    // Registro pila
    sumres#(10) op(s_sp, 10'b0000000001, push, pop, e_sp);
    registro#(10) sp(clk, reset, weSP, e_sp, s_sp);

    // Obtenemos dir
    mux2#(10) mux(e_sp, s_sp, pop, dir);

endmodule