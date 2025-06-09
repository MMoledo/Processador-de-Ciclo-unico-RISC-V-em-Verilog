module control (
    input  wire [6:0] opcode,    
    input  wire [2:0] funct3,     
    input  wire       funct7_5, 
    output reg        RegWrite,  
    output reg        MemRead,   
    output reg        MemWrite,  
    output reg        Branch,     
    output reg        ALUSrc,    
    output reg        MemToReg,  
    output reg [1:0]  ALUControl 
);

    always @(*) begin
        // Defaults (nenhuma ação)
        RegWrite   = 1'b0;
        MemRead    = 1'b0;
        MemWrite   = 1'b0;
        Branch     = 1'b0;
        ALUSrc     = 1'b0;
        MemToReg   = 1'b0;
        ALUControl = 2'b00;

        case (opcode)
            7'b0000011: begin  // lw
                RegWrite   = 1;
                MemRead    = 1;
                ALUSrc     = 1;
                MemToReg   = 1;
                // ALUControl = ADD (address calc)
                ALUControl = 2'b00;
            end
            7'b0100011: begin  // sw
                MemWrite   = 1;
                ALUSrc     = 1;
                // ALUControl = ADD (address calc)
                ALUControl = 2'b00;
            end
            7'b1100011: begin  // beq
                Branch     = 1;
                ALUSrc     = 0;
                // ALUControl = SUB (compare)
                ALUControl = 2'b01;
            end
            7'b0110011: begin  // R-type (add, sub, and, or)
                RegWrite = 1;
                ALUSrc   = 0;
                case ({funct7_5, funct3})
                    4'b0000: ALUControl = 2'b00; // ADD  (funct7_5=0, funct3=000)
                    4'b1000: ALUControl = 2'b01; // SUB  (funct7_5=1, funct3=000)
                    4'b0111: ALUControl = 2'b10; // AND  (funct7_5=0, funct3=111)
                    4'b0110: ALUControl = 2'b11; // OR   (funct7_5=0, funct3=110)
                    default: ALUControl = 2'b00;
                endcase
            end
            7'b0010011: begin  // addi
                RegWrite = 1;
                ALUSrc   = 1;
                // ALUControl = ADD (immediate)
                ALUControl = 2'b00;
            end
        endcase
    end
endmodule
