// data_mem_tb.v
`timescale 1ns/1ps

module data_mem_tb;
    reg         clk;
    reg         MemRead, MemWrite;
    reg  [9:0]  addr;
    reg  [31:0] write_data;
    wire [31:0] read_data;

    data_mem #(.ADDR_WIDTH(10), .DATA_WIDTH(32)) uut (
        .clk        (clk),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .addr       (addr),
        .write_data (write_data),
        .read_data  (read_data)
    );

    initial begin
        $dumpfile("data_mem_tb.vcd");
        $dumpvars(0, data_mem_tb);
        clk = 0;
        MemRead = 0; MemWrite = 0;
        addr = 0; write_data = 0;

        // 1) Escreve 123 em endereço 5
        #5; addr = 10'd5; write_data = 32'd123; MemWrite = 1;
        #10; MemWrite = 0;

        // 2) Lê do endereço 5
        #5; addr = 10'd5; MemRead = 1;
        #5; $display("read_data @5 = %0d", read_data);

        // 3) Lê de um endereço não escrito
        #5; addr = 10'd10; MemRead = 1;
        #5; $display("read_data @10 = %0d", read_data);

        // 4) Testa Overwrite: escreve 77 em 5 e lê
        #5; addr = 10'd5; write_data = 32'd77; MemWrite = 1; MemRead = 0;
        #10; MemWrite = 0;
        #5; addr = 10'd5; MemRead = 1;
        #5; $display("read_data @5 = %0d", read_data);

        #10 $finish;
    end
    
    always #5 clk = ~clk;
endmodule
