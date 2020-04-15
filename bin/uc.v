`timescale 1 ns / 10 ps
module uc(input wire clk, input wire [5:0] opcode, input wire s_z, s_n, s_interrup, input wire [3:0] pEntrada, output reg s_inc, s_inm, we3, wez, wen, wesp, bp, push, pop, s_inp, s_outp, owe1, owe2, owe3, owe4, finInterrup, output reg [2:0] op_alu);

    // Flag interno para el skip
    reg skip, cont;

    initial
    begin
        skip <= 1'b0;
        cont = 0;
        // Por defecto, las operaciones se realizaran en C2
        bp = 1'b1;
    end

    always @(posedge clk)
    begin
        if (skip)
        begin
            if (cont == 2)
            begin
                skip <= 1'b0;
                cont = 0;
            end
        end
    end

    always @(*)
    begin
        if (s_interrup)
        begin
            // s_inc <= 1'b0;
            // s_inm <= 1'b0;
            // we3 <= 1'b0;
            // wez <= 1'b0;
            // wen <= 1'b0;
            wesp <= 1'b1;
            push <= 1'b1;
            // pop <= 1'b0;
            // s_inp <= 1'b0;
            // s_outp <= 1'b0;
            // owe1 <= 1'b0;
            // owe2 <= 1'b0;
            // owe3 <= 1'b0;
            // owe4 <= 1'b0;
        end
        else
        begin
            if (skip == 1'b1)
            begin
                finInterrup <= 1'b0;
                s_inc <= 1'b1;
                s_inm <= 1'b0;
                we3 <= 1'b0;
                wez <= 1'b0;
                wen <= 1'b0;
                wesp <= 1'b0;
                push <= 1'b0;
                pop <= 1'b0;
                s_inp <= 1'b0;
                s_outp <= 1'b0;
                owe1 <= 1'b0;
                owe2 <= 1'b0;
                owe3 <= 1'b0;
                owe4 <= 1'b0;
                cont = cont + 1;
            end
            else
            begin
                if (opcode[5:4] == 2'b11)
                begin
                    // 6 bits (saltos)
                    s_inp <= 1'b0;
                    s_outp <= 1'b0;
                    owe1 <= 1'b0;
                    owe2 <= 1'b0;
                    owe3 <= 1'b0;
                    owe4 <= 1'b0;
                    case (opcode)
                        6'b110000:
                        begin
                            s_inc <= 1'b0;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b0;
                            wen <= 1'b0;
                            wesp <= 1'b0;
                            push <= 1'b0;
                            pop <= 1'b0;
                            finInterrup <= 1'b0;
                        end
                        6'b110001:
                        begin
                            if (s_z == 1'b1)
                                s_inc <= 1'b0;
                            else
                                s_inc <= 1'b1;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b0;
                            wen <= 1'b0;
                            wesp <= 1'b0;
                            push <= 1'b0;
                            pop <= 1'b0;
                            finInterrup <= 1'b0;
                        end
                        6'b110010:
                        begin
                            if (s_z == 1'b0)
                                s_inc <= 1'b0;
                            else
                                s_inc <= 1'b1;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b0;
                            wen <= 1'b0;
                            wesp <= 1'b0;
                            push <= 1'b0;
                            pop <= 1'b0;
                            finInterrup <= 1'b0;
                        end
                        6'b110011:
                        begin
                            if (s_n == 1'b1)
                                s_inc <= 1'b0;
                            else
                                s_inc <= 1'b1;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b0;
                            wen <= 1'b0;
                            wesp <= 1'b0;
                            push <= 1'b0;
                            pop <= 1'b0;
                            finInterrup <= 1'b0;
                        end
                        // PUSH / LINK
                        6'b110100:
                        begin
                            s_inc <= 1'b0;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b0;
                            wen <= 1'b0;
                            wesp <= 1'b1;
                            pop <= 1'b0;
                            push <= 1'b1;
                            finInterrup <= 1'b0;
                        end
                        6'b110101:
                        begin
                            s_inc <= 1'b0;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b0;
                            wen <= 1'b0;
                            wesp <= 1'b1;
                            pop <= 1'b1;
                            push <= 1'b0;
                            finInterrup <= 1'b0;
                        end
                        6'b110110:
                        begin
                            s_inc <= 1'b1;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b0;
                            wen <= 1'b0;
                            wesp <= 1'b0;
                            pop <= 1'b0;
                            push <= 1'b0;
                            if (s_z == 1'b1)
                                skip <= 1'b1;
                            finInterrup <= 1'b0;
                        end
                        6'b110111:
                        begin
                            s_inc <= 1'b1;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b0;
                            wen <= 1'b0;
                            wesp <= 1'b0;
                            pop <= 1'b0;
                            push <= 1'b0;
                            if (s_z != 1'b1)
                                skip <= 1'b1;
                            finInterrup <= 1'b0;
                        end
                        // FREE
                        6'b111000:
                        begin
                            s_inc <= 1'b0;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b1;
                            wen <= 1'b1;
                            wesp <= 1'b0;
                            pop <= 1'b1;
                            push <= 1'b0;
                            finInterrup <= 1'b1;
                        end
                        default:
                        begin
                            s_inc <= 1'b1;
                            s_inm <= 1'b0;
                            we3 <= 1'b0;
                            wez <= 1'b0;
                            wen <= 1'b0;
                            wesp <= 1'b0;
                            push <= 1'b0;
                            pop <= 1'b0;
                            finInterrup <= 1'b0;
                        end
                    endcase
                end
                else
                begin
                    finInterrup <= 1'b0;
                    // 4 bits
                    if (opcode[5] == 1'b0)
                    begin
                        // ALU
                        s_inc <= 1'b1;
                        s_inm <= 1'b0;
                        we3 <= 1'b1;
                        wez <= 1'b1;
                        wen <= 1'b1;
                        wesp <= 1'b0;
                        push <= 1'b0;
                        pop <= 1'b0;
                        s_inp <= 1'b0;
                        s_outp <= 1'b0;
                        owe1 <= 1'b0;
                        owe2 <= 1'b0;
                        owe3 <= 1'b0;
                        owe4 <= 1'b0;
                        op_alu <= opcode[4:2];
                    end
                    else
                    begin
                        // Carga
                        wesp <= 1'b0;
                        push <= 1'b0;
                        pop <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        if (opcode[5:3] == 3'b100)
                        begin
                            case (opcode[5:2])
                                // LOAD
                                4'b1000:
                                begin
                                    s_inc <= 1'b1;
                                    s_inm <= 1'b1;
                                    we3 <= 1'b1;
                                    s_inp <= 1'b0;
                                    s_outp <= 1'b0;
                                    owe1 <= 1'b0;
                                    owe2 <= 1'b0;
                                    owe3 <= 1'b0;
                                    owe4 <= 1'b0;
                                end
                                // OUTI
                                4'b1001:
                                begin
                                    s_inc <= 1'b1;
                                    s_inm <= 1'b1;
                                    we3 <= 1'b0;
                                    s_inp <= 1'b0;
                                    s_outp <= 1'b1;
                                    case (pEntrada)
                                        4'b0000:
                                        begin
                                            owe1 <= #1 1'b1;
                                            owe2 <= 1'b0;
                                            owe3 <= 1'b0;
                                            owe4 <= 1'b0;
                                        end
                                        4'b0001:
                                        begin
                                            owe1 <= 1'b0;
                                            owe2 <= #1 1'b1;
                                            owe3 <= 1'b0;
                                            owe4 <= 1'b0;
                                        end
                                        4'b0010:
                                        begin
                                            owe1 <= 1'b0;
                                            owe2 <= 1'b0;
                                            owe3 <= #1 1'b1;
                                            owe4 <= 1'b0;
                                        end
                                        4'b0011:
                                        begin
                                            owe1 <= 1'b0;
                                            owe2 <= 1'b0;
                                            owe3 <= 1'b0;
                                            owe4 <= #1 1'b1;
                                        end
                                        default:
                                        begin
                                            owe1 <= 1'b0;
                                            owe2 <= 1'b0;
                                            owe3 <= 1'b0;
                                            owe4 <= 1'b0;
                                        end
                                    endcase
                                end
                                default:
                                begin
                                    s_inc <= 1'b1;
                                    s_inm <= 1'b0;
                                    we3 <= 1'b0;
                                    s_inp <= 1'b0;
                                    s_outp <= 1'b0;
                                    owe1 <= 1'b0;
                                    owe2 <= 1'b0;
                                    owe3 <= 1'b0;
                                    owe4 <= 1'b0;
                                end
                            endcase
                        end
                        else if (opcode[5:3] == 3'b101)
                        begin
                            case (opcode)
                                // OUT
                                6'b101000:
                                begin
                                    s_inc <= 1'b1;
                                    s_inm <= 1'b0;
                                    we3 <= 1'b0;
                                    s_inp <= 1'b0;
                                    s_outp <= 1'b1;
                                    case (pEntrada)
                                        4'b0000:
                                        begin
                                            owe1 <= #1 1'b1;
                                            owe2 <= 1'b0;
                                            owe3 <= 1'b0;
                                            owe4 <= 1'b0;
                                        end
                                        4'b0001:
                                        begin
                                            owe1 <= 1'b0;
                                            owe2 <= #1 1'b1;
                                            owe3 <= 1'b0;
                                            owe4 <= 1'b0;
                                        end
                                        4'b0010:
                                        begin
                                            owe1 <= 1'b0;
                                            owe2 <= 1'b0;
                                            owe3 <= #1 1'b1;
                                            owe4 <= 1'b0;
                                        end
                                        4'b0011:
                                        begin
                                            owe1 <= 1'b0;
                                            owe2 <= 1'b0;
                                            owe3 <= 1'b0;
                                            owe4 <= #1 1'b1;
                                        end
                                        default:
                                        begin
                                            owe1 <= 1'b0;
                                            owe2 <= 1'b0;
                                            owe3 <= 1'b0;
                                            owe4 <= 1'b0;
                                        end
                                    endcase
                                end
                                // IN
                                6'b101001:
                                begin
                                    s_inc <= 1'b1;
                                    s_inm <= 1'b0;
                                    we3 <= 1'b1;
                                    s_inp <= 1'b1;
                                    s_outp <= 1'b0;
                                    owe1 <= 1'b0;
                                    owe2 <= 1'b0;
                                    owe3 <= 1'b0;
                                    owe4 <= 1'b0;
                                end
                            endcase
                        end
                    end
                end
            end
        end
    end
endmodule