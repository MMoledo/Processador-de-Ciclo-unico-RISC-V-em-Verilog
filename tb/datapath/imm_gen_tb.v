// imm_gen_tb.v
`timescale 1ns/1ps

module imm_gen_tb;
    reg  [31:0] instr;
    reg  [1:0]  sel;
    wire [31:0] imm_out;

    // Instancia o gerador de imediato
    imm_gen uut (
        .instr   (instr),
        .sel     (sel),
        .imm_out (imm_out)
    );

    initial begin
        $dumpfile("imm_gen_tb.vcd");
        $dumpvars(0, imm_gen_tb);

        // 1) I-type positivo: addi x1, x0, 7 → imm = +7
        instr = 32'h00700093; sel = 2'b00; #10;
        $display("I-pos: instr=0x%08h sel=%b -> imm=%0d", instr, sel, imm_out);

        // 2) I-type negativo: addi x1, x0, -1 → imm = -1
        instr = 32'hFFF00093; sel = 2'b00; #10;
        $display("I-neg: instr=0x%08h sel=%b -> imm=%0d", instr, sel, $signed(imm_out));


        // 3) S-type: sw x10, 4(x0) → imm = +4
        instr = 32'h00A00223; sel = 2'b01; #10;
        $display("S-pos: instr=0x%08h sel=%b -> imm=%0d", instr, sel, imm_out);

        // 4) B-type: beq x1, x2, 4 → imm = +4
        instr = 32'h00208263; sel = 2'b10; #10;
        $display("B-pos: instr=0x%08h sel=%b -> imm=%0d", instr, sel, imm_out);

        #10 $finish;
    end

endmodule
