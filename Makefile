publish: build upload

build:
	nico build

upload:
	rsync -av --del ./ kaizi@96.126.122.58:/home/kaizi/web/www.yubingye.com
	@echo "Done..."
