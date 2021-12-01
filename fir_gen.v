//*********************************************************
// IEEE STD 1364-2001 Verilog file: fir_gen.v 
// Author-EMAIL: Uwe.Meyer-Baese@ieee.org
//*********************************************************
// This is a generic FIR filter generator 
// It uses W1 bit data/coefficients bits
module fir_gen 
#(parameter W1 = 9,    // Input bit width
            W2 = 18,   // Multiplier bit width 2*W1
            W3 = 19,   // Adder width = W2+log2(L)-1
            W4 = 11,   // Output bit width
            L  = 15)    // Filter length 
  (input clk,                     // System clock
   input reset,                   // Asynchronous reset 
   input Load_x,                  // Load/run switch
   input signed [W1-1:0] x_in,    // System input
   input signed [W1-1:0] c_in,    // Coefficient data input   
   output signed [W4-1:0] y_out); // System output
// -------------------------------------------------------- 
  reg signed [W1-1:0]  x;
  wire signed [W3-1:0]  y;
// 1D array types i.e. memories supported by Quartus
// in Verilog 2001; first bit then vector size
  reg  signed [W1-1:0] c [0:14]; // Coefficient array 
  wire signed [W2-1:0] p [0:14]; // Product array
  reg  signed [W3-1:0] a [0:14]; // Adder array
                                                
//----> Load Data or Coefficient
  always @(posedge clk or posedge reset) 
    begin: Load
    integer k;    // loop variable  
    if (reset) begin         // Asynchronous clear
      for (k=0; k<=L-1; k=k+1) c[k] <= 0;
      x <= 0;
    end else if (! Load_x) begin
      c[14] <= c_in;  // Store coefficient in register 
      c[13] <= c[14]; // Coefficients shift one 
      c[12] <= c[13];
      c[11] <= c[12];
      c[10] <= c[11];
      c[9]  <= c[10];
      c[8]  <= c[9];
      c[7]  <= c[8];
      c[6]  <= c[7];
      c[5]  <= c[6];
      c[4]  <= c[5];
      c[3]  <= c[4];
      c[2]  <= c[3];
      c[1]  <= c[2];
      c[0]  <= c[1];
    end else
      x <= x_in; // Get one data sample at a time
  end

//----> Compute sum-of-products
  always @(posedge clk or posedge reset) 
  begin: SOP
  // Compute the transposed filter additions
    integer k;    // loop variable 
    if (reset)         // Asynchronous clear
      for (k=0; k<=3; k=k+1) a[k] <= 0;
    else begin  
      a[0]  <= p[0]  + a[1];
      a[1]  <= p[1]  + a[2];
      a[2]  <= p[2]  + a[3];
      a[3]  <= p[3]  + a[4];
      a[4]  <= p[4]  + a[5];
      a[5]  <= p[5]  + a[6];
      a[6]  <= p[6]  + a[7];
      a[7]  <= p[7]  + a[8];
      a[8]  <= p[8]  + a[9];
      a[9]  <= p[9]  + a[10];
      a[10] <= p[10] + a[11];
      a[11] <= p[11] + a[12];
      a[12] <= p[12] + a[13];
      a[13] <= p[13] + a[14];
      a[14] <= p[14];  // First TAP has only a register
    end
  end
  assign y = a[0];

  genvar I; //Define loop variable for generate statement
  generate
    for (I=0; I<L; I=I+1) begin : MulGen
    // Instantiate L multipliers
      assign p[I] = x * c[I];
    end
  endgenerate

  assign y_out = y[W3-1:W3-W4];

endmodule
