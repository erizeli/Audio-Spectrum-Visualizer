module load_new_heights (
    input  logic clk, reset, update,
	input logic [9:0] sel,
    output logic [8:0] freq_buffer [0:15],
    output logic loaded
);

    // State machine definitions
    enum logic [1:0] {IDLE, LOAD, DONE} ps, ns;

	assign loaded = (ps == DONE);

    logic [3:0] load_index;
    logic [12:0] addr;
    logic [8:0] rom_data [0:10];
    logic [8:0] data_in;

    always_comb begin
        case (sel) 
            1: data_in = rom_data[0];
            2: data_in = rom_data[1];
            4: data_in = rom_data[2];
            8: data_in = rom_data[3];
            16: data_in = rom_data[4];
            32: data_in = rom_data[5];
            64: data_in = rom_data[6];
            128: data_in = rom_data[7];
            256: data_in = rom_data[8];
            512: data_in = rom_data[9];
			default: data_in = rom_data[10];
        endcase
    end
	
    // Instance of the ROM modules
	static0_rom s0 (.address(addr), .clock(clk), .q(rom_data[0]));
	static1_rom s1 (.address(addr), .clock(clk), .q(rom_data[1]));
	static2_rom s2 (.address(addr), .clock(clk), .q(rom_data[2]));
	static3_rom s3 (.address(addr), .clock(clk), .q(rom_data[3]));
	static4_rom s4 (.address(addr), .clock(clk), .q(rom_data[4]));
	static5_rom s5 (.address(addr), .clock(clk), .q(rom_data[5]));
	static6_rom s6 (.address(addr), .clock(clk), .q(rom_data[6]));
	static7_rom s7 (.address(addr), .clock(clk), .q(rom_data[7]));
	static8_rom s8 (.address(addr), .clock(clk), .q(rom_data[8]));
	static9_rom s9 (.address(addr), .clock(clk), .q(rom_data[9]));
    oscillate_rom osc (.address(addr), .clock(clk), .q(rom_data[10]));
	
    // Combinational next-state logic
    always_comb begin
        ns = ps;
        case (ps)
            IDLE: begin
                if (update)
                    ns = LOAD;
            end
            LOAD: begin
                if (load_index == 4'd15)
                    ns = DONE;
            end
            DONE: begin
                ns = IDLE;
            end
        endcase
    end

    // Sequential logic for state, counters, and registers
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            ps         <= IDLE;
            addr       <= 0;
            load_index <= 0;
        end else begin
            ps <= ns;
            case (ps)
                IDLE: begin
                    load_index <= 0;
                end
                LOAD: begin
                    freq_buffer[load_index] <= data_in;
                    load_index <= load_index + 1;
                    addr       <= (addr == 13'd4991) ? 0 : addr + 1;
                end
            endcase
        end
    end

endmodule