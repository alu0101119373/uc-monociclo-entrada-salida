module mempila (input wire clk, push, pop, input wire [9:0] dir, entrada, output wire [9:0] salida);

    reg [9:0] regb [0:1023]; // 1024 palabras de 10 bits para dirs

    initial
    begin
        $readmemb("memstack.dat", regb);
    end

    always @(posedge clk)
        if (push) regb[dir] = entrada;

    assign salida = pop ? regb[dir] : 1'bz;

endmodule