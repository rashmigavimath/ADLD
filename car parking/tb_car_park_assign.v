module tb_car_park_assign();
reg  car, clk, reset;
reg [2:0]pw;
wire front_sensor,back_sensor;

car C(front_sensor, car,reset,clk,pw,back_sensor);

initial clk=0;


always #10 clk=~clk;

initial 
   	begin
	reset=0;car=0;pw=3'b000;
	#15 reset =1;#15 car=1;pw=3'b011;
	#20 reset =1;#20 car =1; pw=3'b00;#20 pw=3'b011;
	#20 reset=1;#20 car=1; pw=3'b001;#20 pw=3'b111;#20 pw=3'b011;
	
	//#10 car=1;pw=3'b000;
	
    	end

initial 
	begin
	$monitor("TIME:%6d, back_sensor=%d, front_sensor=%d, reset = %d", $time, back_sensor, front_sensor,reset);
	#200 $finish;
	end
endmodule



module car(front_sensor, car,reset,clk,pw,back_sensor);
input car, clk,reset;
input [2:0]pw;
output reg front_sensor=0, back_sensor=0;
//parameter car1=2'b00, car2=2'b01, car3=2'b10, car4=2'b11;
parameter start=2'b00, password=2'b01,park=3'b10;
reg [2:0]cur_state, next_state;
reg [2:0]p_word;
//reg [31:0]counter_wait;
always @(posedge clk)
begin
if(~reset)
cur_state <= start;
else
cur_state<= next_state;
end


always @(*)
begin
case(cur_state)
start: begin 
	back_sensor=0;
	if(car==1)
	begin
	front_sensor=1;
	
	p_word<=pw;
	next_state<= password;
	end
	else
	begin
	
	next_state<=start;
	end
	end
	
password: begin 
	if(p_word==3'b011)
	begin
	back_sensor=1;
	front_sensor=0;
	next_state <= start;
	//p_word<=0;
	end
	else
	begin
	back_sensor=0;
	//front_sensor<=0;
	next_state <= start;
	end
	end
/*park: begin
	
	next_state <= start;
	end*/
default:next_state<= start;

endcase
end 
endmodule


