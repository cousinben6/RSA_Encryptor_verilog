//////////////////////////////////////////////////////////////
// Description: This is a testbench for an RSA encrypter/decrypter module
//
// Benjamin Ryle
// Sept 11
// Built with Modelsim INTEL FPGA Starter Edition 10.5b
//////////////////////////////////////////////////////////////
//testbench

module proj2_tb;	
	reg 		clk;		// System clock
	reg 		rst;		// Autonomous Reset signal
	wire 		cal_done;	// Done Calculating exponent
	reg 		start;		// Module startup
	reg  [63:0]	private_key;// 
	reg  [63:0]	public_key;	// 
	reg  [63:0]	message_val;// 
	wire [63:0]	cal_val;	// 
RSA_Encryptor dut(
.private_key	(private_key), 
.public_key		(public_key), 
.message_val	(message_val), 
.clk			(clk), 
.start			(start), 
.rst			(rst), 
.cal_done		(cal_done), 
.cal_val		(cal_val)
);
always@(dut.state) 
begin
	case (dut.state)

		0: $display($time," Capture_state");
		1: $display($time," Exp_1");
		2: $display($time," Exp_2");
		3: $display($time," Exp_3");
		4: $display($time," Mod_1");
		5: $display($time," Mod_2");
		6: $display($time," Mod_3");
		7: $display($time," Cal_1");
		8: $display($time," Cal_2");
		9: $display($time," Cal_3");

		default: $display($time," Unrecognized reg_state");

	endcase 
end

always 
begin
      #5  clk = !clk;
end
		

initial
 begin
 clk=0;
 rst=1'b0;
 start=1'b0;
 #4 rst = 1'b1;
 #6 rst = 1'b0;
 start=1'b1;
 private_key=3;
 public_key=33;
 message_val=9;
 #10 start=0;
#20000 $display ("Encryption: Private Key = %d, Public Key = %d, message value = %d, calculated value = %d",private_key, public_key, message_val, cal_val);

 #4 rst = 1'b1;
 #6 rst = 1'b0;
 private_key=7;
 public_key=33;
 message_val=9;
 #100 start=1;
 #10 start=0;
#100000 $display ("Decryption: Private Key = %d, Public Key = %d, message value = %d, calculated value = %d",private_key, public_key, message_val, cal_val);

	$finish;
end  
endmodule