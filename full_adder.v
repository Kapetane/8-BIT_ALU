module full_adder (
	input a,
	input b,
	input cin,
	output sum,
	output cout,
	output p
);

assign p = a ^ b;
assign sum = p ^ cin;
assign cout = (a & b) | (cin & p);

endmodule
