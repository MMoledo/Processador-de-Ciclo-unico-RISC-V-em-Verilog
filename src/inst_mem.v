module inst_mem #(
    parameter ADDR_WIDTH = 8,            
    parameter DATA_WIDTH = 32,             
    parameter MEM_FILE   = "instructions.mem"
) (
    input  wire [ADDR_WIDTH-1:0] addr,      
    output reg  [DATA_WIDTH-1:0] instr     
);

    // 256 palavras de 32 bits
    reg [DATA_WIDTH-1:0] mem[0 : (1<<ADDR_WIDTH)-1];

    // carrega o programa no início da simulação
    initial begin
        $readmemh(MEM_FILE, mem);
    end

    // leitura combinacional
    always @(*) begin
        instr = mem[addr];
    end

endmodule
