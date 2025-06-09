# Single-Cycle RISC-V Processor

Este projeto implementa um processador RISC-V RV32I em arquitetura single-cycle, seguindo os requisitos do enunciado. A organização está dividida em duas pastas principais:

## Estrutura de Diretórios

```
project_root/
├── src/            # Código-fonte dos módulos
│   ├── alu.v
│   ├── alu_src_mux.v
│   ├── control.v
│   ├── datapath.v
│   ├── data_mem.v
│   ├── imm_gen.v
│   ├── inst_mem.v
│   ├── pc_mux.v
│   ├── regfile.v
│   └── ula.v
└── tb/             # Testbenches organizados por módulo
    └── datapath/   # Testbench integrado do datapath
        └── datapath_tb.v
```

## Como executar o Testbench do Datapath

1. Abra um terminal na pasta `src/`.
2. Compile todos os módulos e o testbench com o comando:

   ```bash
   iverilog -o datapath.vvp datapath.v inst_mem.v data_mem.v regfile.v control.v imm_gen.v alu_src_mux.v pc_mux.v ula.v datapath_tb.v
   ```
3. Execute a simulação:

   ```bash
   vvp datapath.vvp
   ```
4. Abra a forma de onda no GTKWave:

   ```bash
   gtkwave datapath_tb.vcd
   ```

Após esses passos, você poderá inspecionar sinais como o PC (`pc_out`), instruções buscadas, sinais de controle e resultados da ULA para verificar o comportamento completo do processador em cada ciclo de clock.z
