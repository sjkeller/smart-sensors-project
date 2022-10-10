module alu(
    input wire[2:0] OPCODE,
    input wire[31:0] A,
    input wire[31:0] B,
    output reg[31:0] RESULT
    );

    'define ADD 3'b000;
    'define MUL 3'b001;
    'define SUB 3'b010;
    'define DIV 3'b011;
    'define SHR 3'b100;
    'define SHL 3'b101;
    'define NOR 3'b110;
    'define XOR 3'b111;

    function[31:0] calc(
        input[2:0] OPCODE,
        input[31:0] A,
        input[31:0] B
        );

        case (OPCODE)
            'ADD: calc = A + B;
            'MUL: calc = A * B;
            'SUB: calc = A - B;
            'DIV: calc = A / B;
            'SHR: calc = A >> B;
            'SHL: calc = A << B;
            'NOR: calc = ~(A | B);
            'XOR: calc = A ^ B;
        endcase
            
    endfunction

    always @(OPCODE or A or B) begin
        RESULT = calc(OPCODE, A, B);
    end

endmodule
