build/usr/bin/start_apd: build/etc/start_apd build/usr/libexec/start_apd/generate_conf build/usr/lib/systemd/system/start_apd.service
	mkdir -p build/usr/bin
	cp source/start_apd.sh build/usr/bin/start_apd

build/etc/start_apd:
	mkdir -p build/etc/start_apd
	cp source/*.conf build/etc/start_apd/

build/usr/libexec/start_apd/generate_conf:
	mkdir -p build/usr/libexec/start_apd
	g++ source/generate_conf.cpp -o build/usr/libexec/start_apd/generate_conf

build/usr/lib/systemd/system/start_apd.service:
	mkdir -p build/usr/lib/systemd/system
	cp source/start_apd.service build/usr/lib/systemd/system/
