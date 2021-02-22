#Makefile
.PHONY: s3proxy-docker H3-docker

H3_dir=H3/
s3proxy_dir=s3proxy/

H3Dockerfile=$(H3_dir)Dockerfile

H3-docker: $(H3Dockerfile)
	docker build --rm -t malvag/h3 $(H3_dir)

s3proxy-docker: H3-docker Dockerfile
	docker build --rm -t malvag/s3proxy $(s3proxy_dir)	