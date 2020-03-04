module sumres #(parameter WIDTH = 8) (input wire [WIDTH-1:0] e1, e2, input wire selector, output wire [WIDTH-1:0] salida);

    assign salida = selector ? e1 + e2 : e1 - e2; 

endmodule