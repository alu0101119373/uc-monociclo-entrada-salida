module sumres #(parameter WIDTH = 8) (input wire [WIDTH-1:0] e1, e2,
                                      input wire s1, s2,
                                      output wire [WIDTH-1:0] salida);

    reg [WIDTH-1:0] data;

    always @(e1, e2, s1, s2)
        if (s1 == s2)
            data = e1;
        else
            data = (s1 ? e1 + e2 : e1 - e2);

    assign salida = data;

endmodule