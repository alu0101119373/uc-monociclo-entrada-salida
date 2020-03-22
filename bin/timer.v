module timer (input wire clk, reset, input wire [3:0] s, output reg pulse);

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
                pulse <= 1'b0;
                cont = cont + 1;
            end
            else
            begin
                pulse <= 1'b1;
                cont = 0;
            end
    end

endmodule