module imm_gen (
    input  wire [31:0] instr, 
    input  wire [1:0]  sel,    
    output reg  [31:0] imm_out 
);

    wire [11:0] imm_i = instr[31:20];                
    wire [11:0] imm_s = {instr[31:25], instr[11:7]}; 
    wire [12:0] imm_b = {instr[31], instr[7],
                        instr[30:25], instr[11:8], 1'b0}; 

    always @(*) begin
        case (sel)
            2'b00: 
                imm_out = {{20{imm_i[11]}}, imm_i};
            2'b01: 
                imm_out = {{20{imm_s[11]}}, imm_s};
            2'b10: 
                imm_out = {{19{imm_b[12]}}, imm_b};
            default:
                imm_out = 32'd0;
        endcase
    end

endmodule
