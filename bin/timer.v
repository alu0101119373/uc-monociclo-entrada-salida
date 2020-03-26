module timer (input wire clk, reset, input wire [7:0] limit, output reg pulse);

    reg [3:0] cont;

    always @(posedge clk)
    begin
        if (reset)
        begin
            cont = 0;
            pulse <= 1'b0;
        end
        else
            pulse <= ~pulse;
            if (cont < limit)
            begin
                cont = cont + 1;
            end
            else
            begin
                cont = 0;
            end
    end

endmodule