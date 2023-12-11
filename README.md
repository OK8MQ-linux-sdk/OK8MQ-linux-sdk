# Usage

```shell
git clone git@github.com:OK8MQ-linux-sdk/OK8MQ-linux-sdk.git --recursive 
cd OK8MQ-linux-sdk
git submodule
git submodule init
git submodule update

# setup toolchain
. /opt/fsl-imx-xwayland/5.4-zeus/environment-setup-aarch64-poky-linux
# setup environment
. environment-4gddr-setup-sourcetree

# compile
make
```
