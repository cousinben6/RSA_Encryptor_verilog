//////////////////////////////////////////////////////////////
// Description: Pipelined RSA encryptor/decryptor
//
// Benjamin Ryle
// Sept 11
// Built with Modelsim INTEL FPGA Starter Edition 10.5b
//////////////////////////////////////////////////////////////

module RSA_Encryptor(private_key, public_key, message_val, clk, start, rst, cal_done, cal_val);
	//port listing
	input 	[63:0] 	private_key;	// private key used for decryption by host
	input 	[63:0] 	public_key;		// public key used for decryption by non host.
	input 	[63:0] 	message_val;	// input message to be encrypted or decrypted
	input 			clk;			// system clock
	input 			start;			// tells module when to start
	input 			rst;			// reset module
	output 			cal_done;		// true when module is done processing (debug line, may remove)
	output	reg [63:0]	cal_val;		// output value
	
	//local instantiations
	reg 	[3:0] 	state;			//moore state machine state.
	reg 	[63:0]	loc_msg_val;	//local message value copy
	reg		[63:0] 	loc_pri_key;	//local private key copy
	reg		[63:0]	loc_pub_key;	//local public key copy
	reg		[63:0]	loc_cal_val;	//we do not want to always output our calculated value. To this extent, we can change this without outputting.
	reg				cal_done;
	
	//registers and wires interacting with exponent module
	reg load_exp;
	reg [63:0] number;
	reg [63:0] power_of;
	wire [63:0] exp_output;
	reg [63:0] exp_out_reg;
	wire exp_done;
	
	//registers interacting with modulo my_mod 
	reg load_mod;
	reg [63:0] big_mod;
	reg [63:0] small_mod;
	wire [63:0] mod_out;
	reg  [63:0] mod_out_reg;
	wire mod_done;
	//lower module ports
	
	//exp_output=number^(powerof)
	exponent my_exp(
	.clk	(clk),		//Clock
	.rst	(rst),		//exponent is only run once, so we can just pass down the reset signal
	.ld		(load_exp),
	.A		(number),
	.B		(power_of),
	.O		(exp_output),
	.Done	(exp_done)
	);
	
	//mod_out=big_mod%small_mod
	modulo my_mod(
	.clk	(clk),
	.rst	(rst), 
	.ld		(load_mod), 
	.A		(big_mod), 
	.B		(small_mod), 
	.O		(mod_out), 
	.Done	(mod_done)
	);
	
	//all states inside RSA state machine.
	parameter  Capture_state			= 	4'b0000;	//captures registers or does nothing based off start
	parameter  Exp_1		= 	4'b0001;	//feeds values to myexponent module, and raises load signal
	parameter  Exp_2		= 	4'b0010;
	parameter  Exp_3		= 	4'b0011;
	parameter  Mod_1		= 	4'b0100;
	parameter  Mod_2		= 	4'b0101;
	parameter  Mod_3		= 	4'b0110;
	parameter  Cal_1		= 	4'b0111;
	parameter  Cal_2		= 	4'b1000;
	parameter  Cal_3		= 	4'b1001;
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)//on reset signal, clear all stored registers.
		begin
			loc_pri_key	<=	64'b0;	
			loc_pub_key	<=	64'b0;
			loc_cal_val	<=	64'b0;
			state		<=	Capture_state;	//state machine will start to wait for start signal Note: we still need start to be positive on a clk posedge
			cal_done	<=	1'b0;
		end
		else//do not run state machine on rst signal.
		begin
			case(state)
			//on start we populate the registers
			Capture_state:begin
				if (start)
				begin
					loc_msg_val	=	message_val;
					loc_pri_key	=	private_key;	
					loc_pub_key	=	public_key;
					state 		=	Exp_1;
				end
				else state<=Capture_state;
			end	
			
			//feed input values into exponent calcuator module
			Exp_1:begin
				number		=	loc_msg_val;
				power_of	=	loc_pri_key;
				load_exp	=	1'b1;
				state		=	Exp_2;
			end
			// wait for output from exponent calcuator module
			Exp_2:begin
				load_exp=1'b0;
				if(exp_done)begin
					exp_out_reg	=	exp_output;
					state		=	Mod_1;
				end
				else
					state		=	Exp_2;
			end
			
			// feed input into modulo calculator module
			Mod_1:begin
				big_mod		=	exp_output;
				small_mod	=	loc_pub_key;
				load_mod	=	1'b1;
				state		=	Mod_2;
			end
			
			//wait for output from modulo calculator module
			Mod_2:begin
				load_mod	=	1'b0;
				if (mod_done)
				begin
					state		=	Cal_1;
					cal_val		=	mod_out;
				end
				else
				state		=	Mod_2;
			end
			
			// delay while output is displayed
			Cal_1:begin
			state=Cal_2;
			end
			//delay while output is displayed
			Cal_2:begin
			state=Cal_3;
			end
			//delay while output is displayed
			Cal_3:begin
			state=Capture_state;
			end
			endcase
		end
	end
endmodule