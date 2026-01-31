module tb_simple_memory_controller();
parameter size=16;
reg clk,rst,cs,read,sreg,dreg,mem_ready;
reg[size-1:0]mem_data_bus,host_addr_bus;
wire[size-1:0]host_data_bus, mem_addr_bus;
wire intr,mem_read,mem_cs; 

reg[size-1:0] random_address[0:9];
reg[size-1:0] random_data[0:9];
integer i,j;

task normal_read(input [size-1:0] address);
@(posedge clk) begin
#5;
sreg<=0;
dreg<=0;
host_addr_bus<=address;
read<=1'b1;
repeat(5) @(posedge clk);
$display("Normal Read attempted| address = %0h | time=%0t",address,$time);
#5;
read<=1'b0;
end
endtask

task sreg_read();
@(posedge clk) begin
#5;
sreg<=1;
read<=1;
dreg<=0;
repeat(2) @(posedge clk);
$display("Status register read attempted|time=%0t",$time);
#5;
read<=0;
end 
endtask

task dreg_read();
@(posedge clk) begin
#5;
read<=1;
sreg<=0;
dreg<=1;
repeat(2) @(posedge clk);
$display("Data register read attempted|time=%0t",$time);
#5;
read<=0;
end
endtask

always@(mem_read) begin 
for ( j = 0; j<10; j = j+1)begin 
if(random_address[j] == mem_addr_bus)begin 
mem_data_bus <= random_data[j]; 
end
end
@(posedge clk) begin
#5
mem_ready <= 1; 
end
@(posedge clk) begin
#5;
mem_ready <= 0; 
end
end 

initial begin
rst=1'b0;
cs=1'b0;
read=1'b0;
sreg=1'd0;
dreg=1'd0;
mem_ready=0;
mem_data_bus=0;
host_addr_bus=0;
for(i=0;i<10;i=i+1) begin
random_address[i]=$urandom_range(0,255);
random_data[i]=$urandom_range(0,65535);
end
#10;
rst=1'b1;
#100;
rst=1'b0;

@(posedge clk)
normal_read(random_address[4]);

@(posedge intr);

@(posedge clk) begin
#5;
sreg_read();
end

@(posedge clk) begin
#5;
cs<=1'b1;
end

@(posedge clk) begin
#5;
cs<=1'b0;
end

@(posedge clk) begin
#5;
dreg_read(); 
end

@(posedge clk) begin
#5;
cs<=1'b1;
end

@(posedge clk) begin
#5;
cs<=1'b0;
end
end

always begin
clk<=1'b0;
#10;
clk<=1'b1;
#10;
end

simple_memory_controller smc(clk,rst,cs,read,sreg,dreg,mem_ready,mem_data_bus,host_addr_bus,host_data_bus,mem_addr_bus,intr,mem_cs,mem_read);

endmodule
