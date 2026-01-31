module address_register#(parameter size=16)(
input hc_adreg_in,
input [size-1:0]addr_in,
output [size-1:0]addreg_out);
reg[size-1:0]addr_reg;
always@(addr_in)
addr_reg=addr_in;
assign addreg_out=hc_adreg_in?addr_reg:{size{1'bz}};
endmodule
