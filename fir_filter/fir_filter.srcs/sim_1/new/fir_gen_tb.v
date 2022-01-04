`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2021 12:44:10 PM
// Module Name: fir_gen_tb
// Project Name: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module fir_gen_tb();
  parameter W1 = 9;
  parameter W2 = 18;
  parameter W3 = 19;
  parameter W4 = 11;
  parameter L  = 15;

  reg x_in [W1-1:0];
  reg c_in [W1-1:0];

  reg clk;
  reg reset;
  reg load_x;

  wire y_out;

  FIR fir_gen(
    .clk(clk),
    .reset(reset),
    .Load_x(Load_x),                  // Load/run switch
    .x_in(x_in),         // System input
    .c_in(c_in),       // Coefficient data input   
    .y_out(y_out)    // System output
  );

  integer i;
  initial begin

    forever begin
      for(i=0; i<(W1**2-1); i=i+1)
        assign x = i;
    end
  end

endmodule
