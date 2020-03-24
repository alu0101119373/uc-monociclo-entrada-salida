module gestInterrup (input wire reset, iport1, iport2, iport3, iport4, fin, output reg [9:0] dir, output reg s_interrup);

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
            else if ((active && ~fin) || ~active)
                s_interrup <= 1'b0;

            if (iport1 == 1'b1)
            begin
                if (active == 1'b0)
                begin
                    dirAux <= sub1;
                    s_interrup <= 1'b1;
                end
                active <= 1'b1;
            end
            else if (iport2 == 1'b1)
            begin
                if (active == 1'b0)
                begin
                    dirAux <= sub2;
                    s_interrup <= 1'b1;
                end
                active <= 1'b1;
            end
            else if (iport3 == 1'b1)
            begin
                if (active == 1'b0)
                begin
                    dirAux <= sub3;
                    s_interrup <= 1'b1;
                end
                active <= 1'b1;
            end
            else if (iport4 == 1'b1)
            begin
                if (active == 1'b0)
                begin
                    dirAux <= sub1;
                    s_interrup <= 1'b1;
                end
                active <= 1'b1;
            end
            else
                dirAux <= 'bx;
        end
    end

    assign dir = dirAux;

endmodule