`timescale 1ns/1ps

module UlaTb;
    reg  [31:0] op_a;
    reg  [31:0] op_b;
    reg  [1:0]  control;
    wire [31:0] result;
    wire        zero;

    ula uut (
        .op_a    (op_a),
        .op_b    (op_b),
        .control (control),
        .result  (result),
        .zero    (zero)
    );

    initial begin
        // Gera o dump das ondas para GTKWave
        $dumpfile("ula_tb.vcd");
        $dumpvars(0, UlaTb);

        // 1) Teste ADD: 10 + 5 = 15
        op_a    = 32'd10;
        op_b    = 32'd5;
        control = 2'b00;  // ADD
        #10;
        $display("ADD:   %0d + %0d = %0d (zero=%b)", op_a, op_b, result, zero);

        // 2) Teste SUB (não zero): 10 - 3 = 7
        op_a    = 32'd10;
        op_b    = 32'd3;
        control = 2'b01;  // SUB
        #10;
        $display("SUB:   %0d - %0d = %0d (zero=%b)", op_a, op_b, result, zero);

        // 3) Teste SUB zero: 5 - 5 = 0
        op_a    = 32'd5;
        op_b    = 32'd5;
        control = 2'b01;  // SUB
        #10;
        $display("SUB0:  %0d - %0d = %0d (zero=%b)", op_a, op_b, result, zero);

        // 4) Teste AND: 
        op_a    = 32'hF0F0F0F0;
        op_b    = 32'h0FF00FF0;
        control = 2'b10;  // AND
        #10;
        $display("AND:   %h & %h = %h (zero=%b)", op_a, op_b, result, zero);

        // 5) Teste OR: 
        op_a    = 32'hF0F0F0F0;
        op_b    = 32'h0FF00FF0;
        control = 2'b11;  // OR
        #10;
        $display("OR:    %h | %h = %h (zero=%b)", op_a, op_b, result, zero);

        // Finaliza simulação
        #10;
        $finish;
    end
endmodule
