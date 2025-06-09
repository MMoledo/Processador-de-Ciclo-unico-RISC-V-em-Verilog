// regfile_tb.v
`timescale 1ns/1ps

module RegfileTb;
    reg         clk;
    reg         RegWrite;
    reg  [4:0]  rs1, rs2, rd;
    reg  [31:0] write_data;
    wire [31:0] read_data1, read_data2;

    regfile uut (
        .clk        (clk),
        .RegWrite   (RegWrite),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .write_data (write_data),
        .read_data1 (read_data1),
        .read_data2 (read_data2)
    );

    initial begin
        $dumpfile("regfile_tb.vcd");
        $dumpvars(0, RegfileTb);
        clk = 0;
        RegWrite = 0;
        rs1 = 0; rs2 = 0; rd = 0; write_data = 0;

        #5; rd = 5'd5; write_data = 32'd42; RegWrite = 1;
        #10; RegWrite = 0;

        #5; rs1 = 5'd5; rs2 = 5'd0;
        #5; $display("x5 = %0d, x0 = %0d", read_data1, read_data2);

        #5; rd = 5'd0; write_data = 32'd99; RegWrite = 1;
        #10; RegWrite = 0;

        #5; rs1 = 5'd0; rs2 = 5'd5;
        #5; $display("x0 = %0d, x5 = %0d", read_data1, read_data2);

        #10 $finish;
    end

    always #5 clk = ~clk;
endmodule
