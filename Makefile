build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

shell:
	docker exec -it tenda-firmware-lab bash

debug:
	docker exec -it tenda-firmware-lab gdb -q -p $$(docker exec tenda-firmware-lab pgrep httpd | head -n 1)

test:
	docker exec -it tenda-firmware-lab ./test-emulation.sh
