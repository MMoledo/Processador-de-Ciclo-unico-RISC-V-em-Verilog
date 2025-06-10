# Projeto Final – Arquitetura de Processadores

Implementação de um processador RISC‑V RV32I em arquitetura single‑cycle, desenvolvido em Verilog.

## Integrantes

- Adrielle Valascvijus Fernandes | RA: 9333671
- Alec Emil Meier | RA: 1420906
- Lavínia Lopes de Lana | RA: 1373644
- Matheus Moledo Fonseca Vasconcelos | RA: 6225772
- Michael Douglas Santos Costa | RA: 9683205
- Raquel Nazaré Belfort Costa | RA: 1016513

---

## Estrutura de Repositório

```
project_root/
├── src/                   # Fontes Verilog
│   ├── ula.v              # ULA (add, sub, and, or + flag zero)
│   ├── control.v          # Unidade de Controle (gera sinais de controle)
│   ├── regfile.v          # Banco de Registradores (32 × 32 bits)
│   ├── inst_mem.v         # Memória de Instruções (ROM via $readmemh)
│   ├── data_mem.v         # Memória de Dados (RAM síncrona)
│   ├── imm_gen.v          # Gerador de Imediatos (I, S e B types)
│   ├── alu_src_mux.v      # Mux ALUSrc (reg_data2 ou imediato)
│   ├── pc_mux.v           # Mux PCSrc (PC+4 ou PC+imm)
│   └── datapath.v         # Top-Level: integra todos os blocos
└── tb/                    # Testbenches por componente e integrado
    ├── alu_src_mux/       # TB do Mux ALUSrc
    ├── control/           # TB da Unidade de Controle
    ├── regfile/           # TB do Banco de Registradores
    ├── inst_mem/          # TB da Memória de Instruções
    ├── data_mem/          # TB da Memória de Dados
    ├── imm_gen/           # TB do Gerador de Imediatos
    ├── pc_mux/            # TB do Mux de PC
    ├── ula/               # TB da ULA
    └── datapath/          # TB integrado do datapath
```

---

## Visão Geral dos Componentes

Para cada bloco abaixo, há um módulo em `src/` e um testbench em `tb/`.

### 1. ULA (Arithmetic Logic Unit)

Processa dois operandos de 32 bits e gera resultado + flag zero para branches.

```verilog
always @(*) begin
  case (control)
    2'b00: result = op_a + op_b;  // ADD
    2'b01: result = op_a - op_b;  // SUB
    2'b10: result = op_a & op_b;  // AND
    2'b11: result = op_a | op_b;  // OR
  endcase
end
assign zero = (result == 0);
```

### 2. Unidade de Controle (Control Unit)

Decodifica opcode/funct3/funct7 e gera sinais de controle:
`RegWrite`, `MemRead`, `MemWrite`, `Branch`, `ALUSrc`, `MemToReg`, `ALUControl`.

```verilog
case (opcode)
  7'b0000011: begin // LW
    RegWrite=1; MemRead=1; ALUSrc=1; MemToReg=1; ALUControl=2'b00;
  end
  7'b0110011: begin // R-type
    RegWrite=1; ALUSrc=0;
    case ({funct7_5, funct3})
      4'b0000: ALUControl=2'b00; // ADD
      4'b1000: ALUControl=2'b01; // SUB
      4'b0111: ALUControl=2'b10; // AND
      4'b0110: ALUControl=2'b11; // OR
    endcase
  end
  // ... outros casos ...
endcase
```

### 3. Banco de Registradores (Register File)

32 registradores de 32 bits com `x0` fixo em zero, leitura combinacional e escrita síncrona.

```verilog
assign read_data1 = (rs1==0) ? 0 : regs[rs1];
assign read_data2 = (rs2==0) ? 0 : regs[rs2];
always @(posedge clk)
  if (RegWrite && rd!=0)
    regs[rd] <= write_data;
```

### 4. Memória de Instruções (Instruction Memory)

ROM de 256 × 32 bits que carrega programas via `$readmemh`:

```verilog
initial $readmemh("instructions.mem", mem);
always @(*) instr = mem[addr];
```

### 5. Memória de Dados (Data Memory)

RAM de 1024 × 32 bits, escrita síncrona e leitura combinacional:

```verilog
always @(posedge clk)
  if (MemWrite) mem[addr] <= write_data;
always @(*)
  read_data = (MemRead) ? mem[addr] : 0;
```

### 6. Gerador de Imediatos (Immediate Generator)

Extrai e sign-extend de imediato para I-type, S-type e B-type:

```verilog
wire [11:0] imm_i = instr[31:20];
imm_out = {{20{imm_i[11]}}, imm_i}; // I-type
```

### 7. Multiplexadores

* **ALUSrc Mux**: escolhe `reg_rd2` ou `imm_ext` para ALU.
* **PCSrc Mux**: escolhe `pc_plus4` ou `pc_branch` com base em `Branch & zero`.

```verilog
alu_in2 = (ALUSrc) ? imm_ext : reg_rd2;
pc_next = (Branch & zero) ? pc_branch : pc_plus4;
```

### 8. Datapath Completo (Top-Level)

Integra todos os blocos e atualiza `PC` com reset síncrono:

```verilog
always @(posedge clk) begin
  if (rst) PC <= 0;
  else     PC <= next_pc;
end
assign pc_out = PC;
```

---

## Programa de Exemplo

Arquivo `instructions.mem`:

```
00500093  // addi x1, x0, 5
00100013  // addi x2, x0, 1
002081b3  // add  x3, x1, x2
00310223  // sw   x3, 0(x2)
00010103  // lw   x2, 0(x2)
```

---

## Como Compilar e Simular

```bash
# Compilar módulos + testbench integrado
iverilog -o datapath_tb \
  src/ula.v src/control.v src/regfile.v \
  src/inst_mem.v src/data_mem.v src/imm_gen.v \
  src/alu_src_mux.v src/pc_mux.v src/datapath.v \
  tb/datapath_tb.v

# Simular e visualizar
vvp datapath_tb
gtkwave datapath_tb.vcd
```

---

## Dependências

* Icarus Verilog
* GTKWave

