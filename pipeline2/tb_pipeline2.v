module tb_pipeline2();
wire [15:0] zout;
reg [3:0] rs1, rs2, rd, func;
reg [7:0] addr;
reg clk1, clk2;
integer k;

pipeline2 P(zout, rs1, rs2, rd, func, addr, clk1, clk2);

initial begin
	clk1=0;
	clk2=0;
	repeat(20)
	begin
	#5 clk1=1; #5 clk1=0; //generation of clock
	#5 clk2=1; #5 clk2=0;
	end
	end

initial

for(k=0; k<16; k=k+1)
P.regbank[k] = k;  // initialize registers

initial
begin
#5 rs1= 3; rs2 = 5; rd = 10; func = 0; addr = 125; //ADD
#20 rs1= 8; rs2 = 6; rd = 11; func = 2; addr = 126; //MUL
#20 rs1= 10; rs2 = 4; rd = 12; func = 1; addr = 127; //SUB
#20 rs1= 6; rs2 = 7; rd = 13; func = 13; addr = 128; //SLA

#60  for(k=125 ; k<129; k=k+1)
     $display( "mem[%3d] = %3d", k, P.mem[k]);
end

initial 
begin
//$dumpfile ("pipeline2.vod");
//$dumpvars(0, tb_pipeline2);
$monitor("Time: %3d, F = %3d", $time, zout);
#600 $finish;
end

endmodule








module pipeline2(zout, rs1, rs2, rd, func, addr, clk1, clk2);

input [3:0] rs1, rs2, rd, func;
input [7:0] addr;
input clk1, clk2; //two phase clock;

output [15:0] zout;

reg [15:0] L12_A, L12_B, L23_z, L34_z;
reg [3:0] L12_rd, L12_func, L23_rd;
reg [7:0] L12_addr, L23_addr, L34_addr;

reg [15:0] regbank [0:15]; //register bank
reg [15:0] mem [0:255]; //256 x 16 memory

assign zout= L34_z;

always @(posedge clk1)
begin
	L12_A <= #2 regbank[rs1];
	L12_B <= #2 regbank[rs2];
	L12_rd <= #2 rd;
	L12_func<= #2 func;
	L12_addr <= #2 addr; //stage1
end

always @(negedge clk2)
begin 
  case(func)
	0: L23_z <= #2 L12_A + L12_B;
	1: L23_z <= #2 L12_A - L12_B;
	2: L23_z <= #2 L12_A * L12_B;
	3: L23_z <= #2 L12_A;
	4: L23_z <= #2 L12_B;
	5: L23_z <= #2 L12_A & L12_B;
	6: L23_z <= #2 L12_A | L12_B;
	7: L23_z <= #2 L12_A ^ L12_B;
	8: L23_z <= #2 -L12_A;
	9: L23_z <= #2 -L12_B;
	10: L23_z <= #2 L12_A >> 1;
	11: L23_z <= #2 L12_A << 1;
	default: L23_z <= #2 16 'hxxxx; //stage2
endcase

L23_rd <= #2 L12_rd;
L23_addr<= #2 L12_addr;
end

always @(posedge clk1)
begin
 	regbank[L23_rd] <= #2 L23_z;
	L34_z <= #2 L23_z;
	L34_addr <= #2 L23_addr; //stage3
end

always @(negedge clk2)
begin 
	mem[L34_addr] <= #2 L34_z;//stage4
end

endmodule
	


