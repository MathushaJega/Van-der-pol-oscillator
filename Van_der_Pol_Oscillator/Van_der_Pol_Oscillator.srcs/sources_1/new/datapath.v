module datapath (
    input clk,
    input reset,
    input [17:0] control_word,
    output reg [31:0] x_val,
    output c_out
);
    // R1:dt, R2:x^2, R3:(1-x^2), R4:damping, R5:mu, R6:x, R7:t, R8:a, R9:u
    reg signed [31:0] R1, R2, R3, R4, R5, R6, R7, R8, R9;

    always @(*) x_val = R6; 
    
    // LOGIC FIX: Check if time R7 is less than limit R8
    assign c_out = (R7 < R8); 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            R1 <= 32'd102;    // dt = 0.1
            R5 <= 32'd1024;   // mu = 1.0
            R6 <= 32'd1024;   // x_init = 1.0
            R7 <= 32'd0;      // t = 0
            R8 <= 32'd500000; // FIX: Massive limit (~500 units) to guarantee full cycle
            R9 <= 32'd0;      // u = 0
            R2 <= 0; R3 <= 0; R4 <= 0;
        end else begin
            // State S1: Calculate x^2
            if (control_word[0]) R2 <= (R6 * R6) / 1024; 

            // State S2: Calculate Damping (with precision fix)
            if (control_word[1]) begin
                R3 <= (32'd1024 - R2); 
                R4 <= (R5 * R3 / 1024 * R9) / 1024; 
            end

            // State S3: Update Velocity 'u'
            if (control_word[2]) begin
                R9 <= R9 + ((R4 - R6) * R1 / 1024); 
                R7 <= R7 + R1; 
            end

            // State S4: Update Position 'x'
            if (control_word[3]) begin
                R6 <= R6 + (R9 * R1 / 1024); 
            end
        end
    end
endmodule