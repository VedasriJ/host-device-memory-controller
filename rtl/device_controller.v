module device_controller#(parameter size=16)(input clk,rst,start_en,mem_ready,
output reg dc_cs_out,dc_rd_out,dc_dregen_out,dc_done_out
);
reg [3:0] ps,ns;
localparam idle=4'd0,
cs=4'd1,
rd=4'd2,
dregen=4'd3,
done=4'd4;

//seq
always@(posedge clk or posedge rst) begin
if(rst==1'b1) begin
ps<=idle;
dc_cs_out<=1;
dc_rd_out<=0;
dc_dregen_out<=0;
dc_done_out<=0;
end
else if(clk==1'b1) begin
ps<=ns;
case(ns)
idle: begin
dc_cs_out<=1;
dc_rd_out<=0;
dc_dregen_out<=0;
dc_done_out<=0;
end
cs: dc_cs_out<=0;
rd: begin 
dc_rd_out<=1;
end
dregen: begin
dc_dregen_out<=1;
dc_rd_out<=0;
dc_cs_out<=1;
end
done: begin
dc_done_out<=1;
end
endcase
end
end
//comb
always@(ps or start_en or mem_ready) begin
case(ps)
idle: begin
if(start_en)
ns=cs;
else
ns=idle;
end
cs: ns=rd;
rd: begin
if(mem_ready)
ns=dregen;
else
ns=rd;
end
dregen: ns=done;
done: ns=idle;
endcase
end
endmodule
