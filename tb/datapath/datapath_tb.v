`timescale 1ns/1ps

module datapath_tb;
    reg        clk = 0;
    reg        rst = 1;
    wire [31:0] pc_out;

    data_path uut (
        .clk    (clk),
        .rst    (rst),
        .pc_out (pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, datapath_tb);

        #12 rst = 0;

        #200 $finish;
    end

    // cabeçalho do print
    initial begin
        $display("Time(ns)\tPC");
    end

    // a cada borda de subida do clock, depois do reset, imprime PC
    always @(posedge clk) begin
        if (!rst) begin
            $display("%0d\t\t%0d", $time, pc_out);
        end
    end

endmodule
