curr_dir:=$(shell pwd)

build-local:
	docker build -t myblog:latest .
start-local:
	# or use image manhdaovan/myblog:latest
	docker run -v ${curr_dir}/:/blog -p 4000:4000 myblog:latest
