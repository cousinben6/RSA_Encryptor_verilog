//////////////////////////////////////////////////////////////
// Description:
//
// Benjamin Ryle
// Sept 11
// Built with Modelsim INTEL FPGA Starter Edition 10.5b
//////////////////////////////////////////////////////////////

module exponent(clk,rst, ld, A, B, O, Done);//O=A^B
input clk, rst, ld;//enable
input [63:0]A;
input [63:0]B;
output reg[63:0]O;//output and running total
output reg Done;
reg [5:0]C;//counter (for adding n onto n n times (n*n))
reg [5:0]C_exp; //counter (for multiplying n*n n times (n^n))
reg [2:0]select;
reg [63:0] a;//
reg [63:0] original_a;
reg [63:0] b;//bottom of the two being multiplied
reg [63:0] o;//
wire [63:0] shifted, added;//shifter and adder outputs
shifter shifting(.in(a),.n(C),.o(shifted));
fulladder adding(.x(o),.y(O),.o(added));
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
		a=A;//multiply A*A
		original_a=A;
		b=B*B;//b is how we tell if we've multiplied enough.
		C=0;
		C_exp=0;
		select=1;
		end
	    else begin
		select=0;
		end
	  end
	1:begin
	    if(a[C]==1)
		begin
		//O and A go to Full adder/shifter
		//shifter (a,C,o);
		//full_adder (o==shifted a,O,added);
		o=shifted;
		C=C+1;
	   	select=2;
		end
	    else
		begin
		//O and zero to fulladder
		//full_adder (o==0,O,added);
		o=0;
		C=C+1;
	  	 select=2;
		end
          end
	2:begin
	    //fulladder (a, b, O);
	    O=added;

	    if(C==Done)//done adding
		select=3;
	    else
		select=1;
	  end
	3:begin //increment multiplier.  
	    C_exp=C_exp+1;
		C=0;
		//a=O;
		if (C_exp==b)
		select=4;
		else
		select=1;
		end
	4:begin//have i multiplied A by A B times?
		Done=1;
		select=0;
		end
	endcase
	end
end
endmodule