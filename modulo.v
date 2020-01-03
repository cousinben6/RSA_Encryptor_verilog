//////////////////////////////////////////////////////////////
// Description: Pipelined Modulo Calculator
// 
// Benjamin Ryle
// Sept 11
// Built with Modelsim INTEL FPGA Starter Edition 10.5b
//////////////////////////////////////////////////////////////

module modulo(clk,rst, ld, A, B, O, Done);
input clk, rst, ld;//enable
input [63:0]A;
input [63:0]B;
output reg[63:0]O;//output
reg [1:0]select;
output reg Done;
reg [63:0] a; //starting number
reg [63:0] b;//number im 'dividing by'
reg [63:0] o;
wire [63:0] subtracted;
fullsubtractor adding(.x(o),.y(b),.o(subtracted));
always @(posedge clk or posedge rst)
begin
if(rst)
 begin
 O<=16'b0;
 select<=0;
 end
else
 begin
	case(select)
	0:begin
	    Done=0;
	    if(ld==1)
		begin
		a=A;
		b=B;
		o=A;
		select=1;
		end
	    else begin
		select=0;
		end
	  end
	1:begin
		O=o;
		if(o<b)
		select=3;
	    else
		select=2;
		end
	2:begin
	    //fullsubtractor (a, b, O);
	    o=subtracted;
		select=1;
	  end
	3:begin
	    Done=1;
	    select=0;
	  end
	endcase
 end
end
endmodule