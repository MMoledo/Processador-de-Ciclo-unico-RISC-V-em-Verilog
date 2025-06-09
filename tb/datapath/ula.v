module ula (
    input  wire [31:0] op_a,       
    input  wire [31:0] op_b,      
    input  wire [1:0] control,     
//      control = 2'b00 → ADD
//                2'b01 → SUB
//                2'b10 → AND
//                2'b11 → OR
    output reg  [31:0] result,     
    output wire        zero        
);


    always @(*) begin
        case (control)
            2'b00: result = op_a + op_b;  // ADD
            2'b01: result = op_a - op_b;  // SUB
            2'b10: result = op_a & op_b;  // AND
            2'b11: result = op_a | op_b;  // OR
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);

endmodule
