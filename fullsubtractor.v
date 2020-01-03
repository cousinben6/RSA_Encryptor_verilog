//////////////////////////////////////////////////////////////
// Description: non-pipelined full subtractor helper module
//
// Benjamin Ryle
// Sept 11
// Built with Modelsim INTEL FPGA Starter Edition 10.5b
//////////////////////////////////////////////////////////////

module fullsubtractor
(
input wire [63:0] x,
input wire [63:0] y,
output wire [63:0] o
);
assign o=x-y;
endmodule