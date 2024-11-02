tinytapeout: tt_main.si
	silice-make.py --top tt_um_warp -s tt_main.si -b tinytapeout -t tinytapeout -p basic -o BUILD_$(subst :,_,$@) -a force-reset-init,split-inouts $(ARGS)
	cp BUILD_$(subst :,_,$@)/build.v ../project.v

verilator: tt_sim_main.si
	silice-make.py -s tt_sim_main.si -b $@ -p basic,vga -o BUILD_$(subst :,_,$@) -t shell  -a force-reset-init,split-inouts $(ARGS)

ecpix5: tt_fpga_main.si
	silice-make.py -s tt_fpga_main.si -b tinytapeout -t tt_ecpix5 -p basic -o BUILD_$(subst :,_,$@) -D ECPIX5_SIM=1 -a force-reset-init,split-inouts $(ARGS)

ulx3s: tt_fpga_main.si
	silice-make.py -s tt_fpga_main.si -b tinytapeout -t tt_ulx3s -p basic -o BUILD_$(subst :,_,$@) -D ULX3S_SIM=1 -a force-reset-init,split-inouts $(ARGS)

clean:
	rm -rf BUILD_*
