//////////////////////////////////////////////////////////////
// Description: Non-Pipelined full adder helper module
//
// Benjamin Ryle
// Sept 11
// Built with Modelsim INTEL FPGA Starter Edition 10.5b
//////////////////////////////////////////////////////////////
module fulladder
(
input [63:0] x,
input [63:0] y,
output [63:0] o
);
assign o=y+x;
endmodule