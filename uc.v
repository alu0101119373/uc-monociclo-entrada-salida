module uc(input wire [5:0] opcode, input wire s_z, output reg s_inc, s_inm, we3, wez, output reg [2:0] op_alu);

    always @(*)
    begin
        if (opcode[5:4] == 2'b11)
        begin
            // 6 bits (saltos)
            case (opcode)
                6'b110000:
                begin
                    s_inc <= 1'b0;
                    s_inm <= 1'b0;
                    we3 <= 1'b0;
                    wez <= 1'b0;
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
                end
                default:
                begin
                    s_inc <= 1'b0;
                    s_inm <= 1'b0;
                    we3 <= 1'b0;
                    wez <= 1'b0;
                end
            endcase
        end
        else
        begin
            // 4 bits
            if (opcode[5] == 1'b0)
            begin
                // ALU
                s_inc <= 1'b1;
                s_inm <= 1'b0;
                we3 <= 1'b1;
                wez <= 1'b1;
                op_alu <= opcode[4:2];
            end
            else
            begin
                // Carga
                case (opcode[5:2])
                    4'b1000:
                    begin
                        s_inc <= 1'b1;
                        s_inm <= 1'b1;
                        we3 <= 1'b1;
                        wez <= 1'b0;
                    end
                    default:
                    begin
                        s_inc <= 1'b1;
                        s_inm <= 1'b1;
                        we3 <= 1'b1;
                        wez <= 1'b0;
                    end
                endcase
            end
        end
    end
endmodule