module data_register#(parameter size=16)(input mc_dreg_en, hc_dreg_en,
input[size-1:0] dreg_in,
output[size-1:0] dreg_out
);
reg[size-1:0] dreg;
always@(mc_dreg_en or dreg_in) begin
if(mc_dreg_en)
dreg=dreg_in;
end
assign dreg_out=hc_dreg_en?dreg:{size{1'bz}};
endmodule
