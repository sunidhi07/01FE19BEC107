# Cadence Genus(TM) Synthesis Solution, Version 17.22-s017_1, built Apr  1 2018

# Date: Fri Dec 03 17:06:07 2021
# Host: VLSI43 (x86_64 w/Linux 2.6.32-754.el6.x86_64) (4cores*8cpus*1physical cpu*Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz 8192KB)
# OS:   Red Hat Enterprise Linux Client release 6.10 (Santiago)

read_hdl upcounter.v
read_libs /cad_area/cad/FOUNDRY/digital/180nm/dig/lib/slow.lib
elaborate upcounter
syn_gen
syn_map
syn_opt
write_hdl > upcounter_netlist.v
report_gates > gates_upcounter.v
report_power > power_upcounter.v
exit
