VERSION=0.010

REMOTE_HOST=server.local      # -- edit once you installed it on a 2nd machine

all::
	@echo "make install tests clean" 

install::
	cp rrcloud *.cloud ~/bin/
	#sudo cp rrcloud *.cloud /usr/local/bin/

deinstall::
	rm -f ~/bin/rrcloud ~/bin/*.cloud
	#sudo rm -f /usr/local/bin/rrcloud /usr/local/bin/*.cloud

tests::
	rm -rf tmp; mkdir tmp
	./rrcloud echo tests/test.txt
	./rrcloud openscad tests/cube.scad
	./rrcloud slic3r tests/cube.stl
	#./rrcloud povray tests/scene.pov
	./rrcloud --s=$(REMOTE_HOST) echo tests/test.txt
	./rrcloud --s=$(REMOTE_HOST) openscad tests/cube.scad
	./rrcloud --s=$(REMOTE_HOST) slic3r tests/cube.stl
	#./rrcloud openscad+slic3r tests/cube.scad
	./rrcloud info
	./openscad.cloud tests/cube.scad -otmp/cube.stl
	./slic3r.cloud --load=tests/slic3r.conf tmp/cube.stl --output=tmp/cube.gcode

clean::
	rm -rf tasks

# --- developers only below

dist::	clean
	cd ..; tar cfz Backup/rrcloud-${VERSION}.tar.gz "--exclude=*.git/*" RepRapCloud/

backup::	clean
	scp ../Backup/rrcloud-${VERSION}.tar.gz the-labs.com:Backup/

edit::
	dee4 rrcloud Makefile README.md www/style.css services/*
