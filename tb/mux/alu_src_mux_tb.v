// alu_src_mux_tb.v
`timescale 1ns/1ps

module alu_src_mux_tb;
    reg  [31:0] reg_data2, imm_ext;
    reg         sel;
    wire [31:0] alu_in2;

    alu_src_mux uut (
        .reg_data2(reg_data2),
        .imm_ext  (imm_ext),
        .sel      (sel),
        .alu_in2  (alu_in2)
    );

    initial begin
        $dumpfile("alu_src_mux_tb.vcd");
        $dumpvars(0, alu_src_mux_tb);

        // caso 1: sel=0 → escolhe reg_data2
        reg_data2 = 32'd15; imm_ext = 32'd99; sel = 1'b0;
        #10 $display("sel=0 -> alu_in2 = %0d (esperado 15)", alu_in2);

        // caso 2: sel=1 → escolhe imm_ext
        sel = 1'b1;
        #10 $display("sel=1 -> alu_in2 = %0d (esperado 99)", alu_in2);

        #10 $finish;
    end
endmodule
