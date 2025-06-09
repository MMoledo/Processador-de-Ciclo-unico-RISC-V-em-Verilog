// control_tb.v
`timescale 1ns/1ps

module control_tb;
    reg  [6:0] opcode;
    reg  [2:0] funct3;
    reg        funct7_5;
    wire       RegWrite, MemRead, MemWrite, Branch, ALUSrc, MemToReg;
    wire [1:0] ALUControl;

    control uut (
        .opcode     (opcode),
        .funct3     (funct3),
        .funct7_5   (funct7_5),
        .RegWrite   (RegWrite),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .Branch     (Branch),
        .ALUSrc     (ALUSrc),
        .MemToReg   (MemToReg),
        .ALUControl (ALUControl)
    );

    initial begin
        $dumpfile("control_tb.vcd");
        $dumpvars(0, control_tb);

        // Teste lw
        opcode   = 7'b0000011; funct3 = 3'b010; funct7_5 = 1'b0; #10;
        $display("lw -> RegWrite=%b, MemRead=%b, ALUSrc=%b, MemToReg=%b, ALUControl=%b",
                 RegWrite, MemRead, ALUSrc, MemToReg, ALUControl);

        // Teste sw
        opcode   = 7'b0100011; funct3 = 3'b010; funct7_5 = 1'b0; #10;
        $display("sw -> MemWrite=%b, ALUSrc=%b, ALUControl=%b",
                 MemWrite, ALUSrc, ALUControl);

        // Teste beq
        opcode   = 7'b1100011; funct3 = 3'b000; funct7_5 = 1'b0; #10;
        $display("beq -> Branch=%b, ALUSrc=%b, ALUControl=%b",
                 Branch, ALUSrc, ALUControl);

        // Teste add 
        opcode   = 7'b0110011; funct3 = 3'b000; funct7_5 = 1'b0; #10;
        $display("add -> RegWrite=%b, ALUSrc=%b, ALUControl=%b",
                 RegWrite, ALUSrc, ALUControl);

        // Test sub 
        opcode   = 7'b0110011; funct3 = 3'b000; funct7_5 = 1'b1; #10;
        $display("sub -> RegWrite=%b, ALUSrc=%b, ALUControl=%b",
                 RegWrite, ALUSrc, ALUControl);

        // Test and 
        opcode   = 7'b0110011; funct3 = 3'b111; funct7_5 = 1'b0; #10;
        $display("and -> ALUControl=%b", ALUControl);

        // Test or 
        opcode   = 7'b0110011; funct3 = 3'b110; funct7_5 = 1'b0; #10;
        $display("or  -> ALUControl=%b", ALUControl);

        // Test addi
        opcode   = 7'b0010011; funct3 = 3'b000; funct7_5 = 1'b0; #10;
        $display("addi -> RegWrite=%b, ALUSrc=%b, ALUControl=%b",
                 RegWrite, ALUSrc, ALUControl);

        #10 $finish;
    end
endmodule
