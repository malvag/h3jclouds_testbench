# H3jclouds_testbench
H3jclouds_testbench provides a simple testbench that includes JClouds-H3,H3 and s3proxy, all-together built in a docker image. 
[Jclouds-H3](https://github.com/malvag/Jclouds-H3) is a [Jclouds](https://github.com/apache/jclouds) API provider for [H3](https://github.com/CARV-ICS-FORTH/H3/) object store.
Provides a minimal but functional storage API for jclouds-compatible technologies(i.e. [s3proxy](https://github.com/gaul/s3proxy)). 

## Getting Started
Detailed instructions on how to install, configure, and get the project running.
```bash
# downloads and configures all submodules
./INIT.sh

#builds the docker image
make s3proxy-docker

#run s3proxy with H3Jclouds and H3
docker run -t malvag/s3proxy
```
