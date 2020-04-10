module timer (input wire clk, reset, input wire [7:0] limit, output reg pulse);

    reg [7:0] cont;

    always @(posedge clk)
    begin
        if (reset)
        begin
            cont = 7'b1;
            pulse <= 1'b0;
        end
        else
            if (cont < limit)
            begin
                cont = cont + 8'b1;
                pulse <= 1'b0;
            end
            else
            begin
                if (limit != 8'b0)
                    pulse <= 1'b1;
                else
                    pulse <= 8'b0;
                cont = 8'b1;
            end
    end

endmodule