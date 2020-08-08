transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/Synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/Router.sv}
vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/Reg_4.sv}
vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/Control.sv}
vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/compute.sv}
vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/Register_unit.sv}
vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/Processor.sv}

vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/testbench.sv}
vlog -sv -work work +incdir+C:/Users/Erwin/Desktop/Assignments/semester4/ECE\ 385/Lab4/processor8 {C:/Users/Erwin/Desktop/Assignments/semester4/ECE 385/Lab4/processor8/testbench_8.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
