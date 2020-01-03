//////////////////////////////////////////////////////////////
// Description: non-pipelined shifter helper module
//
// Benjamin Ryle
// Sept 11
// Built with Modelsim INTEL FPGA Starter Edition 10.5b
//////////////////////////////////////////////////////////////

module shifter
(
input [63:0] in,
input [5:0] n,
output [63:0] o
);
assign o = in << n;
endmodule
