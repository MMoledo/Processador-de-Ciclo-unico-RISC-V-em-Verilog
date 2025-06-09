module pc_mux (
    input  wire [31:0] pc_plus4,    
    input  wire [31:0] branch_target, 
    input  wire        sel,           
    output reg  [31:0] pc_next       
);

    always @(*) begin
        if (sel)
            pc_next = branch_target;
        else
            pc_next = pc_plus4;
    end

endmodule
