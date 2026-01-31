module simple_memory_controller#(parameter size =16)(
input clk,rst,cs,read,sreg,dreg,mem_ready,
input[size-1:0] mem_data_bus,host_addr_bus,
output [size-1:0] host_data_bus, mem_addr_bus,
output intr,mem_cs,mem_read);
wire mc_dreg_en,hc_dreg_en, hc_adreg_in,mc_done_in,hc_clr_in,hc_sreg_en,hc_start_en;
data_register#(size) datareg(mc_dreg_en, hc_dreg_en,mem_data_bus,host_data_bus);
status_register#(size) streg(mc_done_in,hc_clr_in,hc_sreg_en,host_data_bus);
address_register#(size) adreg(hc_adreg_in,host_addr_bus,mem_addr_bus);
host_controller#(size) hostfsm(clk,rst,cs,read,sreg,dreg,mc_done_in,
hc_dreg_en,hc_sreg_en,hc_start_en,hc_adreg_in,hc_clr_in,intr);
device_controller#(size) devicefsm(clk,rst,hc_start_en,mem_ready,mem_cs,mem_read,mc_dreg_en,mc_done_in);
endmodule    
