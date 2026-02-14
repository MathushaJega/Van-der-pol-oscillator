module control_unit (
    input clk,
    input reset,
    input c_in,
    output reg [17:0] control_word
);
    parameter S_IDLE = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S_DONE = 3'b101;
    reg [2:0] current_state, next_state;

    // State Transition Logic
    always @(posedge clk or posedge reset) begin
        if (reset) current_state <= S_IDLE;
        else current_state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            S_IDLE: next_state = S1;
            S1:     next_state = S2;
            S2:     next_state = S3;
            S3:     next_state = S4;
            // Loop back to S1 as long as c_in (c_out from datapath) is true
            S4:     next_state = (c_in) ? S1 : S_DONE; 
            S_DONE: next_state = S_DONE;
            default: next_state = S_IDLE;
        endcase
    end

    // Output Logic
    always @(*) begin
        control_word = 18'b0;
        case (current_state)
            S1: control_word[0] = 1'b1;
            S2: control_word[1] = 1'b1;
            S3: control_word[2] = 1'b1;
            S4: control_word[3] = 1'b1;
        endcase
    end
endmodule