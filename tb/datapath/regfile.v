// regfile.v
module regfile (
    input  wire        clk,       
    input  wire        RegWrite,   
    input  wire [4:0]  rs1,        
    input  wire [4:0]  rs2,        
    input  wire [4:0]  rd,        
    input  wire [31:0] write_data, 
    output wire [31:0] read_data1,
    output wire [31:0] read_data2  
);

    reg [31:0] regs [0:31];

    assign read_data1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign read_data2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

    always @(posedge clk) begin
        if (RegWrite && (rd != 5'd0)) begin
            regs[rd] <= write_data;
        end
    end

    // (Opcional) inicializa todos em zero na simulação
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) regs[i] = 32'd0;
    end

endmodule
