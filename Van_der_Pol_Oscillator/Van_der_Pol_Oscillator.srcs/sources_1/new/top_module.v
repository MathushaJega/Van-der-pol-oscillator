module top_module (
    input clk,
    input reset,
    output [31:0] x_val // This output is critical for the TB
);
    wire [17:0] control_word;
    wire c_out;

    control_unit cu (
        .clk(clk),
        .reset(reset),
        .c_in(c_out),
        .control_word(control_word)
    );

    datapath dp (
        .clk(clk),
        .reset(reset),
        .control_word(control_word),
        .x_val(x_val),
        .c_out(c_out)
    );
endmodule