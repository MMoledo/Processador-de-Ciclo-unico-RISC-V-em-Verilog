`timescale 1ns/1ps

module inst_mem_tb;
    reg  [7:0]  addr;
    wire [31:0] instr;


    inst_mem #(
        .MEM_FILE("instructions.mem")
    ) uut (
        .addr (addr),
        .instr(instr)
    );

    integer i;
    initial begin
        $dumpfile("inst_mem_tb.vcd");
        $dumpvars(0, inst_mem_tb);

        for (i = 0; i < 4; i = i + 1) begin
            addr = i;
            #10;
            $display("Addr %0d: instr = 0x%08h", i, instr);
        end

        #10 $finish;
    end
endmodule
