netlist: src/chisel/main.scala
	docker run -v $(PWD)/src/chisel/build.sbt:/project/build.sbt                        \
	           -v $(PWD)/src/chisel/main.scala:/project/src/main/scala/main.scala       \
			   -v $(PWD)/build/artifacts/netlist:/project/build/artifacts/netlist       \
			   -v $(PWD)/build/logs/:/project/build/logs                                \
			   -w="/project/"                                                           \
			   chisel /bin/bash -c "sbt run > ./build/logs/netlist_log.txt 2>&1"

synthesis: build/artifacts/netlist/AlchitryCUTop.v
	docker run -v $(PWD):/project/ -w="/project/" yosys /bin/bash -c "yosys ./src/synth/synth.ys > ./build/logs/syn_log.txt 2>&1"

pnr: build/artifacts/syn/synth.json
	docker run -v $(PWD):/project/ -w="/project/" nextpnr /bin/bash -c "./src/pnr/pnr.sh > ./build/logs/pnr_log.txt 2>&1"

bitstream: build/artifacts/pnr/top.asc
	docker run -v $(PWD):/project/ -w="/project/" icestorm /bin/bash -c "./src/bitgen/bitgen.sh > ./build/logs/bitgen_log.txt 2>&1"

load: build/artifacts/bitstream/bitstream.bin
	docker run --privileged -v $(PWD):/project/ -w="/project/" icestorm /bin/bash -c "./src/load/load.sh > ./build/logs/load_log.txt 2>&1"

all: clean build_tree netlist synthesis pnr bitstream load

clean:
	rm -rf build/

build_tree:
	mkdir build
	mkdir build/artifacts
	mkdir build/artifacts/syn/
	mkdir build/artifacts/pnr/
	mkdir build/artifacts/bitstream/
	mkdir build/artifacts/netlist/
	mkdir build/logs/
