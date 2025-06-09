module data_path (
    input  wire        clk,
    input  wire        rst,      
    output wire [31:0] pc_out     
);

    // PC  
    reg [31:0] PC;
    wire [31:0] pc_plus4 = PC + 32'd4;
    wire [31:0] pc_branch;     
    wire [31:0] next_pc;

    // Fetch 
    wire [31:0] instr;
    inst_mem #(.MEM_FILE("instructions.mem")) IM (
        .addr  (PC[7:0]),
        .instr (instr)
    );

    // Decode  
    wire [6:0] opcode = instr[6:0];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire       funct7_5 = instr[30];

    // Sinais de controle
    wire RegWrite, MemRead, MemWrite, Branch, ALUSrc, MemToReg;
    wire [1:0] ALUControl;
    control CU (
        .opcode     (opcode),
        .funct3     (funct3),
        .funct7_5   (funct7_5),
        .RegWrite   (RegWrite),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .Branch     (Branch),
        .ALUSrc     (ALUSrc),
        .MemToReg   (MemToReg),
        .ALUControl (ALUControl)
    );

    // Register File 
    wire [31:0] reg_rd1, reg_rd2;
    regfile RF (
        .clk        (clk),
        .RegWrite   (RegWrite),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .write_data ( (MemToReg) ? data_rd : alu_res ),
        .read_data1 (reg_rd1),
        .read_data2 (reg_rd2)
    );

    // ImmGen 
    wire [31:0] imm_ext;
    wire [1:0]  imm_sel = (opcode==7'b0100011) ? 2'b01 :   
                          (opcode==7'b1100011) ? 2'b10 :   
                                                  2'b00;    
    imm_gen IG (
        .instr   (instr),
        .sel     (imm_sel),
        .imm_out (imm_ext)
    );

    // ALU  
    wire [31:0] alu_in2, alu_res;
    wire        zero;
    alu_src_mux M1 (
        .reg_data2(reg_rd2),
        .imm_ext  (imm_ext),
        .sel      (ALUSrc),
        .alu_in2  (alu_in2)
    );
    ula ALU (
        .op_a    (reg_rd1),
        .op_b    (alu_in2),
        .control (ALUControl),
        .result  (alu_res),
        .zero    (zero)
    );

    // Data Memory  
    wire [31:0] data_rd;
    data_mem DM (
        .clk        (clk),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .addr       (alu_res[9:0]),
        .write_data (reg_rd2),
        .read_data  (data_rd)
    );

    // ** PC update **  
    assign pc_branch = PC + imm_ext;
    pc_mux M2 (
        .pc_plus4     (pc_plus4),
        .branch_target(pc_branch),
        .sel           (Branch & zero),
        .pc_next       (next_pc)
    );

    // PC register  
    always @(posedge clk) begin
        if (rst)
            PC <= 32'd0;
        else
            PC <= next_pc;
    end

    assign pc_out = PC;

endmodule
