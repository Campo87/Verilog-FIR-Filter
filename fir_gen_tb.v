module fir_gen_tb();
    parameter W1 = 9;
    parameter L = 15;
    reg c [W1-1:0];
    reg clk;
    reg reset;
    reg load_x;

    FIR fir_gen(
        .clk(clk),
        .reset(reset),
        .Load_x(Load_x),                  // Load/run switch
        .x_in(x_in),    // System input
        .c_in(c_in),    // Coefficient data input   
        .y_out(y_out); // System output
    );

endmodule