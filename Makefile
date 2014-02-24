publish: build upload

build:
	nico build

upload:
	rsync -av --del deploy/ kaizi@96.126.122.58:/home/kaizi/blog
	@echo "Done..."
