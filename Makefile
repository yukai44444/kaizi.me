publish: build upload

build:
	liquidluck

upload:
	rsync -av --del deploy/ kaizi@ssh.kaizi.me:/home/kaizi/blog
	@echo "Done..."
