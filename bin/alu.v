module alu(input wire [7:0] a, b,
           input wire [2:0] op_alu,
           input wire bp,
           output wire carry,
           output wire [7:0] y,
           output wire negative,
           output wire zero);

reg [8:0] s;

parameter min = -64;
parameter max = 63;

always @(a, b, op_alu)
begin
  case (op_alu)              
    3'b000: s = a;
    3'b001: s = ~a;
    3'b010: s = a + b;
    3'b011: s = a - b;
    3'b100: s = a & b;
    3'b101: s = a | b;
    3'b110: s = -a;
    3'b111: s = -b;
	default: s = 9'bx; //desconocido en cualquier otro caso (x � z), por si se modifica el c�digo
  endcase
end

wire overflow;
assign overflow = (y < min || y > max) ? 1'b1 : 1'b0;
assign carry = s[8];

assign y = s[7:0];

//Calculo del flag de cero y el de negative
assign zero = ~(|y);   //operador de reducci�n |y hace la or de los bits del vector 'y' y devuelve 1 bit resultado
assign negative = (bp ? carry : overflow);
		   
endmodule
