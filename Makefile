.PHONY: test compile

export LIBPYTHON_LOC=$(shell cocotb-config --libpython)

test_%:
	make compile  # 编译
	iverilog -o build/sim.vvp -s gpu -g2012 build/gpu.v  # 生成仿真文件
	# MODULE=test.test_$* 变成 MODULE=test.test_matadd
	# vvp 是 Icarus Verilog 的仿真器,它会加载 cocotb 的 VPI 模块
	MODULE=test.test_$* vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus build/sim.vvp  # 运行仿真测试


compile:
	make compile_alu  # 转换ALU文件
	sv2v -I src/* -w build/gpu.v # 转换其他 SystemVerilog 文件
	echo "" >> build/gpu.v  # 添加一个空行防止文件末尾没有换行符
	cat build/alu.v >> build/gpu.v  # 将alu模块添加到gpu模块后面
	echo '`timescale 1ns/1ns' > build/temp.v  # 添加时间尺度
	cat build/gpu.v >> build/temp.v
	mv build/temp.v build/gpu.v  # 最终生成gpu.vcd

compile_%:
	sv2v -w build/$*.v src/$*.sv  # 转换单个 .sv 文件到 .v

# TODO: Get gtkwave visualizaiton

show_%: %.vcd %.gtkw
	gtkwave $^
