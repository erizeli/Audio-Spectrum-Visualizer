module VGA_Driver_tb;
    logic clk, new_data;
    logic [9:0] x;
    logic [8:0] y;
    logic [7:0] r, g, b;
    logic [8:0] heights [0:15];

    // Clock generation
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // 100 MHz clock
    end

    VGA_Driver dut (.*);
    initial begin
        // Initialize the heights with some test values
        heights[0] = 30'd400;
        heights[1] = 30'd400;
        heights[2] = 30'd400;
        heights[3] = 30'd400;
        heights[4] = 30'd400;
        heights[5] = 30'd400;
        heights[6] = 30'd400;
        heights[7] = 30'd400;
        heights[8] = 30'd400;
        heights[9] = 30'd400;
        heights[10] = 30'd400;
        heights[11] = 30'd400;
        heights[12] = 30'd400;
        heights[13] = 30'd400;
        heights[14] = 30'd400;
        heights[15] = 30'd400;

        new_data = 1;
        @ (posedge clk);
        new_data = 0;
        @ (posedge clk); 
        // Test the VGA driver with different x and y coordinates
        for (int i = 0; i < 640; i++) begin
            for (int j = 0; j < 240; j++) begin
                x = i;
                y = j;
                @ (posedge clk);
            end
        end

        heights[0] = 30'd200;
        heights[1] = 30'd200;
        heights[2] = 30'd200;
        heights[3] = 30'd200;
        heights[4] = 30'd200;
        heights[5] = 30'd200;
        heights[6] = 30'd200;
        heights[7] = 30'd200;
        heights[8] = 30'd200;
        heights[9] = 30'd200;
        heights[10] = 30'd200;
        heights[11] = 30'd200;
        heights[12] = 30'd200;
        heights[13] = 30'd200;
        heights[14] = 30'd200;
        heights[15] = 30'd200;
        @ (posedge clk); 

        for (int i = 0; i < 640; i++) begin
            for (int j = 240; j < 480; j++) begin
                x = i;
                y = j;
                @ (posedge clk);
            end
        end
        
    
        $stop; // End the simulation
    end
endmodule