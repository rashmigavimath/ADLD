module ram(addr, data, clk, rd, wr, cs);
input [9:0] addr:
input clk, rd,wr,cs;
input [7:0] data;

reg [7:0] mem[1023:0];
reg [7:0] d_out;

assign data = (cs && rd) ? d_out:8'bz;

always @(posedge clk)
 if(cs && wr && !rd) mem[addr]=data;
 begin
	assign addr= addr+1;
 end
always @(posedge clk)
 if(cs && rd && !wd)
 d_out=mem[addr];

endmodule
