module gestInterrup (input wire reset, iport1, iport2, iport3, iport4, fin, output wire [9:0] dir, output wire s_interrup);

    // Direcciones de subrutina
    parameter sub1 = 10'b1111011000; // 984
    parameter sub2 = 10'b1111100010; // 994
    parameter sub3 = 10'b1111101100; // 1004
    parameter sub4 = 10'b1111110110; // 1014

    reg dirAux;
    reg active; // bit que se mantiene a uno hasta que la interrupcion actual termina

    // Orden de prioridad: 1, 2, 3, 4
    always @(*)
    begin
        if (reset)
        begin
            active <= 1'b0;
            dirAux <= 'bx;            
        end
        else
        begin
            if (active && fin)
                active <= 1'b0;

            if (iport1 == 1'b1)
            begin
                if (active == 1'b0)
                    dirAux <= sub1;
                active <= 1'b1;
            end
            else if (iport2 == 1'b1)
            begin
                if (active == 1'b0)
                    dirAux <= sub2;
                active <= 1'b1;
            end
            else if (iport3 == 1'b1)
            begin
                if (active == 1'b0)
                    dirAux <= sub3;
                active <= 1'b1;
            end
            else if (iport4 == 1'b1)
            begin
                if (active == 1'b0)
                    dirAux <= sub4;
                active <= 1'b1;
            end
            else
                dirAux <= 'bx;
        end
    end

    assign s_interrup = (iport1 || iport2 || iport3 || iport4);
    assign dir = dirAux;

endmodule