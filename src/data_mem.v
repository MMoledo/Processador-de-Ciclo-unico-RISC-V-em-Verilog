// data_mem.v
module data_mem #(
    parameter ADDR_WIDTH = 10,    
    parameter DATA_WIDTH = 32
) (
    input  wire                   clk,
    input  wire                   MemRead,
    input  wire                   MemWrite,
    input  wire [ADDR_WIDTH-1:0]  addr,
    input  wire [DATA_WIDTH-1:0]  write_data,
    output reg  [DATA_WIDTH-1:0]  read_data
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    always @(posedge clk) begin
        if (MemWrite)
            mem[addr] <= write_data;
    end

    always @(*) begin
        if (MemRead)
            read_data = mem[addr];
        else
            read_data = 32'd0;
    end

endmodule
