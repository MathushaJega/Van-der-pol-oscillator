module vdp_tb;
    reg clk, reset;
    wire [31:0] x_val;
    integer file;

    // Instantiate Top Module
    top_module uut ( 
        .clk(clk), 
        .reset(reset), 
        .x_val(x_val) 
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns Period
    end

    // Simulation Control
    initial begin
        file = $fopen("results.txt", "w");
        reset = 1;
        #20 reset = 0;
        
        $display("Starting Simulation for Full Cycle...");
        
        // Run for 10ms (10,000,000 ns) to capture full oscillation
        #10000000; 
        
        $display("Simulation Finished.");
        $fclose(file);
        $finish;
    end

    // Data Logging: Triggered purely by output change
    always @(x_val) begin
        if (!reset) begin
            $fdisplay(file, "%d", $signed(x_val));
        end
    end
endmodule