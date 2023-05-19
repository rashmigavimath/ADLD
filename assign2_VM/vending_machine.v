module vending_machine(a,b,clk,product,change,z);
input a; //no. of 5 rupee coins
input b; //no. of 10 rupee coins
//input x=4'b0101;
//input y=4'b1010;
input clk;
input [1:0]product;

output reg [3:0]change;
output reg z; //if z==1 the product is given z==0 the product is not given;

parameter A=2'b00 ,B=2'b01 ,C=2'b10 ,D=2'b11;
reg [2:0]state, next_state;

always @(posedge clk)
begin
if(product==2'b00)
state <= A;

else if(product==2'b01)
state <= B;

else if(product==2'b10)
state <= C;

else if(product==2'b11)
state <= D;



end

always @(*)
begin
case(state)
A : begin 
	if(a==1)
	begin
	z=2'b00;
	//next_state <= B;
	end
	
	else if(b==1)
	begin
	change = 4'b0101;
	z=2'b00;
	//next_state <=B;
	end

	
    end

B : begin 
	if(a==2)
	begin
	z=2'b01;
	//next_state <=C;
	end
	
	else if(b==1)
	begin
	z=2'b01;
	//next_state <= C;
	end

	
    end

C : begin 
	if(a==3)
	begin
	z=2'b10;
	//next_state <= D;
	end
	
	else if(b==1)
	begin
	
	if(a==1)
	begin
	z=2'b10;
	//next_state <= D;
	end
	end

	else if(b==2)
	
	begin
	change = 4'b0101;
	z=2'b10;
	//next_state <= D;
	end
	

	
    end

D : begin 
	if(a==4)
	begin
	z=2'b11;
	//next_state <=A ;
	end
	
	else if(b==2)
	
	begin
	z=2'b11;
	//next_state <= A;
	end
	

	else if(b==1)
	begin
	
	if(a==2)
	begin
	
	z=2'b11;
	//next_state <= A;
	end
	end
	

	
    end

default:next_state<= A;

endcase
end 
endmodule




	          
