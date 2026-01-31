module status_register#(parameter size = 16)(
input mc_done_in,hc_clr_in,hc_sreg_en,
output [size-1:0] sreg_out
);
reg[size-1:0] sreg;
always@(mc_done_in or hc_clr_in) begin
if(hc_clr_in) 
sreg=0;
else if(mc_done_in)
sreg={mc_done_in,{size-1{1'b0}}};
end
assign sreg_out=hc_sreg_en?sreg:{size{1'bz}};
endmodule
