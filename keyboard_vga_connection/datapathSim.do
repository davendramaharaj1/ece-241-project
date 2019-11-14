# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog datapath.v

#load simulation using mux as the top level simulation module
vsim datapath

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#Initialize
force clock 0 0ns, 1 {5ns} -r 10ns

#resetn
force reset_from_controller 1
force right 1
force down 1
force ldX 0
force ldY 0
force ldClr 0
force control_colour_signal 0
run 10ns

#go right
force reset_from_controller  0
force ldX 1
force ldY 0
force ldClr 1
force right 1
force down 0
force control_colour_signal 0
run 10ns
force reset_from_controller  0
force ldX 0
force ldY 0
force ldClr 0
run 10ns

# move down 
force reset_from_controller  0
force ldX 0
force ldY 1
force ldClr 1
force right 0
force down 1
force control_colour_signal 0
run 10ns
force reset_from_controller  0
force ldX 0
force ldY 0
force ldClr 0
run 10ns

# move right
force reset_from_controller  0
force ldX 1
force ldY 0
force ldClr 1
force right 1
force down 0
force control_colour_signal 0
run 10ns
force reset_from_controller  0
force ldX 0
force ldY 0
force ldClr 0
run 10ns

