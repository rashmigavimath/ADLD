module tb_pipeline();
parameter N=10;
reg [N-1:0]A,B,C,D;
reg clk;
wire [N-1:0]F;

pipeline p(F, A, B, C, D, clk);
initial clk=0;

always #10 clk=~clk;

initial 
   	begin
	#5 A=10; B=12; C=11; D=3;
	#20 A=10; B=9; C=29; D=8;
    	end

initial 
	begin
	$monitor("TIME : %d, F=%d", $time, F);
	#100 $finish;
	end
endmodule





module pipeline(F, A, B, C, D, clk);
parameter N=10;
input [N-1:0]A,B,C,D;
input clk;
output [N-1:0]F;
reg [N-1:0]L12_X1, L12_X2, L12_D, L23_X3, L23_D, L34_F;

assign F=L34_F;

always @(posedge clk)
 begin
	L12_X1<= #4 A+B;
	L12_X2<= #4 C-D;
	L12_D<= D; // STAGE1
	
	L23_X3<= #4 L12_X1+L12_X2;
	L23_D<=L12_D;

	L34_F<=#6 L23_X3 * L23_D;
 end
endmodule
