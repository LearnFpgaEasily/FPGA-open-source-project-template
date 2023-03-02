synthesis: src/hdl/top.v
	docker run -v $(PWD):/project/ -w="/project/" yosys /bin/bash -c "yosys ./src/synth/synth.ys > ./build/logs/syn_log.txt 2>&1"

pnr: build/artifacts/syn/synth.json
	docker run -v $(PWD):/project/ -w="/project/" nextpnr /bin/bash -c "./src/pnr/pnr.sh > ./build/logs/pnr_log.txt 2>&1"

bitstream: build/artifacts/pnr/top.asc
	docker run -v $(PWD):/project/ -w="/project/" icestorm /bin/bash -c "./src/bitgen/bitgen.sh > ./build/logs/bitgen_log.txt 2>&1"

load: build/artifacts/bitstream/bitstream.bin
	docker run --privileged -v $(PWD):/project/ -w="/project/" icestorm /bin/bash -c "./src/load/load.sh > ./build/logs/load_log.txt 2>&1"

all: build_tree synthesis pnr bitstream load

clean:
	rm -rf build/

build_tree:
	mkdir build
	mkdir build/artifacts
	mkdir build/artifacts/syn/
	mkdir build/artifacts/pnr/
	mkdir build/artifacts/bitstream/
	mkdir build/logs/