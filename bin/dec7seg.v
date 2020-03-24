module dec7seg (input wire [3:0] d, output wire [7:0] q);

    reg [7:0] s;

    always @(*)
    begin
        case (d)
            4'b0000:
                s <= 8'b00111111;
            4'b0001:
                s <= 8'b00000110;
            4'b0010:
                s <= 8'b01011011;
            4'b0011:
                s <= 8'b01001111;
            4'b0100:
                s <= 8'b01100110;
            4'b0101:
                s <= 8'b01101101;
            4'b0110:
                s <= 8'b01111101;
            4'b0111:
                s <= 8'b00000111;
            4'b1000:
                s <= 8'b01111111;
            4'b1001:
                s <= 8'b01100111;
            default:
                s <= 'bx;
        endcase
    end

    assign q = s;

endmodule