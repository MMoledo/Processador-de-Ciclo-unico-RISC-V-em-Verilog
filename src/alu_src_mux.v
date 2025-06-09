module alu_src_mux (
    input  wire [31:0] reg_data2,  
    input  wire [31:0] imm_ext,    
    input  wire        sel,        
    output reg  [31:0] alu_in2     
);

    always @(*) begin
        if (sel)
            alu_in2 = imm_ext;
        else
            alu_in2 = reg_data2;
    end
endmodule
