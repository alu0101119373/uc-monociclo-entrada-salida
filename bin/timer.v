module timer (input wire clk, reset, input wire [7:0] s, output reg pulse);

    reg [3:0] cont;

    always @(posedge clk)
    begin
        if (reset)
        begin
            cont = 0;
            pulse <= 1'b0;
        end
        else
            if (cont < s)
            begin
                cont = cont + 1;
            end
            else
            begin
                pulse <= ~pulse;
                cont = 0;
            end
    end

endmodule