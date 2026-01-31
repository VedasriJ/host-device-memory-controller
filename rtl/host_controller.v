module host_controller#(parameter size=16)(
input clk,rst,cs, read, sreg, dreg, done,
output reg hc_dreg_out,hc_sreg_out,hc_start_out,hc_adreg_out,hc_clr_out,intr);
reg [3:0]ps,ns;

localparam idle = 4'd0,
waits=4'd1,
sregen=4'd2,
sregclr=4'd3,
dregen=4'd4,
adregen=4'd5,
start=4'd6,
waitdone=4'd7,
interrupt=4'd8;

//comb
always @(ps or done or cs or read or sreg or dreg) begin
case(ps)
idle: begin
if(cs)
ns=idle;
else
ns=waits;
end

waits:begin
if(read) begin 
if(sreg)
ns=sregen;
else if(dreg)
ns=dregen;
else
ns=adregen;
end
else 
ns=waits;
end

sregen: begin 
if(read)
ns=sregen;
else
ns=sregclr;
end

sregclr: ns=idle;

dregen: begin
if(read)
ns=dregen;
else
ns=idle;
end

adregen: ns=start;

start: ns=waitdone;

waitdone: begin
if(done) 
ns=interrupt;
else
ns=waitdone;
end

interrupt:ns=idle;
endcase
end

//seq
always @(posedge clk or posedge rst) begin
if(rst==1'b1)begin
ps<=idle;
hc_dreg_out<=0;
hc_sreg_out<=0;
hc_adreg_out<=0;
hc_start_out<=0;
hc_clr_out<=0;
intr<=0;
end
else if(clk==1'b1) begin
ps<=ns;

case(ns)
idle: begin
hc_sreg_out<=0;
hc_dreg_out<=0;
hc_adreg_out<=0;
hc_clr_out<=0;
hc_start_out<=0;
intr<=0;
end

sregen: hc_sreg_out<=1;
sregclr: begin 
hc_clr_out<=1;
hc_sreg_out<=0;
end
dregen: hc_dreg_out<=1;
adregen: hc_adreg_out<=1;
start: hc_start_out<=1;
interrupt: intr<=1;
endcase
end
end
endmodule
