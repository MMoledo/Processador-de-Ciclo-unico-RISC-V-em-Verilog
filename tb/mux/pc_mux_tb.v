// pc_mux_tb.v
`timescale 1ns/1ps

module pc_mux_tb;
    reg  [31:0] pc_plus4, branch_target;
    reg         sel;
    wire [31:0] pc_next;

    // instancia o mux de PC
    pc_mux uut (
        .pc_plus4     (pc_plus4),
        .branch_target(branch_target),
        .sel          (sel),
        .pc_next      (pc_next)
    );

    initial begin
        $dumpfile("pc_mux_tb.vcd");
        $dumpvars(0, pc_mux_tb);

        // cenário 1: sel=0 → usa pc_plus4
        pc_plus4      = 32'h00000004;
        branch_target = 32'h00000010;
        sel           = 1'b0;
        #10 $display("sel=0 → pc_next = 0x%08h (esperado 0x00000004)", pc_next);

        // cenário 2: sel=1 → usa branch_target
        sel = 1'b1;
        #10 $display("sel=1 → pc_next = 0x%08h (esperado 0x00000010)", pc_next);

        #10 $finish;
    end
endmodule
