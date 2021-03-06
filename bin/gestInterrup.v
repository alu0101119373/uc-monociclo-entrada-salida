`timescale 1 ns / 10 ps
module gestInterrup (input wire clk, reset, iport1, iport2, iport3, iport4, fin, output wire [9:0] dir, output reg s_interrup);

    // Direcciones de subrutina
    parameter sub1 = 10'b1100111000; // 824
    parameter sub2 = 10'b1101101010; // 874
    parameter sub3 = 10'b1110011100; // 924
    parameter sub4 = 10'b1111001110; // 974
                                     // 1023 ...

    reg [9:0] dirAux;
    reg active; // bit que se mantiene a uno hasta que la interrupcion actual termina

    // Orden de prioridad: 1, 2, 3, 4
    always @(reset, iport1, iport2, iport3, iport4, fin)
    begin
        if (reset)
        begin
            active <= 1'b0;
            dirAux <= 10'bx;    
        end
        else
        begin
            if (active == 1'b1 && fin == 1'b1)
                active <= 1'b0;
            else if ((active && ~fin) || ~active)
                s_interrup <= 1'b0;

            if (iport1 == 1'b1)
            begin
                if (active == 1'b0)
                begin
                    dirAux <= sub1;
                    s_interrup <= 1'b1;
                    #1;
                end
                active <= 1'b1;
            end
            else if (iport2 == 1'b1)
            begin
                if (active == 1'b0)
                begin
                    dirAux <= sub2;
                    s_interrup <= 1'b1;
                    #1;
                end
                active <= 1'b1;
            end
            else if (iport3 == 1'b1)
            begin
                if (active == 1'b0)
                begin
                    dirAux <= sub3;
                    s_interrup <= 1'b1;
                    #1;
                end
                active <= 1'b1;
            end
            else if (iport4 == 1'b1)
            begin
                if (active == 1'b0)
                begin
                    dirAux <= sub1;
                    s_interrup <= 1'b1;
                    #1;
                end
                active <= 1'b1;
            end
            else
                dirAux <= 10'bx;
        end
    end

    assign dir = dirAux;

endmodule