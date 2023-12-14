all: \
	linux linux_install linux_headers jailhouse\
	cmd-examples cmd-examples_install	\
	qt-examples qt-examples_install \
	sdcard

clean: linux_clean  qt-examples_clean cmd-examples_clean

# Kernel build targets
linux:  
	@echo =================================
	@echo     Building the Linux Kernel
	@echo =================================
	$(MAKE) -j $(MAKE_JOBS) -C $(LINUXKERNEL_INSTALL_DIR) $(LINUX_DEFCONFIG) LDFLAGS=
	$(MAKE) -j $(MAKE_JOBS) -C $(LINUXKERNEL_INSTALL_DIR) LDFLAGS=
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/Image $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-dcss-mipi7.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-lcdif-mipi7.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-dcss-lt8912.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-lcdif-lt8912.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-dual-hdmi-lt8912.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-dual-hdmi-mipi7.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-rpmsg.dtb $(SDK_PATH)/images/boot
	@if [ -e $(SDK_PATH)/images/boot.img ];then \
		rm $(SDK_PATH)/images/boot.img ; \
	fi
	mkfs.vfat -n "Boot imx8mqevk" -S 512 -C $(SDK_PATH)/images/boot.img 65536
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/Image ::/Image
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/logo.bmp ::/logo.bmp
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/ok8mq-evk.dtb ::/ok8mq-evk.dtb
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/ok8mq-evk-dcss-mipi7.dtb ::/ok8mq-evk-dcss-mipi7.dtb
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/ok8mq-evk-lcdif-mipi7.dtb ::/ok8mq-evk-lcdif-mipi7.dtb
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/ok8mq-evk-dcss-lt8912.dtb ::/ok8mq-evk-dcss-lt8912.dtb
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/ok8mq-evk-lcdif-lt8912.dtb ::/ok8mq-evk-lcdif-lt8912.dtb
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/ok8mq-evk-dual-hdmi-lt8912.dtb ::/ok8mq-evk-dual-hdmi-lt8912.dtb
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/ok8mq-evk-dual-hdmi-mipi7.dtb ::/ok8mq-evk-dual-hdmi-mipi7.dtb
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/boot/ok8mq-evk-rpmsg.dtb ::/ok8mq-evk-rpmsg.dtb
	mcopy -i $(SDK_PATH)/images/boot.img -s $(SDK_PATH)/images/m4 ::/

dtbs:
	@echo ==========================================
	@echo     Building and Copy the Device Tree
	@echo ==========================================
	$(MAKE) -j $(MAKE_JOBS) -C $(LINUXKERNEL_INSTALL_DIR) $(LINUX_DEFCONFIG) LDFLAGS=
	$(MAKE) -j $(MAKE_JOBS) -C $(LINUXKERNEL_INSTALL_DIR) LDFLAGS= dtbs
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-dcss-mipi7.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-lcdif-mipi7.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-dcss-lt8912.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-lcdif-lt8912.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-dual-hdmi-lt8912.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-dual-hdmi-mipi7.dtb $(SDK_PATH)/images/boot
	install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/freescale/ok8mq-evk-rpmsg.dtb $(SDK_PATH)/images/boot
  
jailhouse:
	@echo ======================================
	@echo     Building and Copy the Jailhouse
	@echo ======================================
	cd imx-jailhouse && make ARCH=arm64 KDIR=$(SDK_PATH)/OK8MQ-linux-kernel CROSS_COMPILE=aarch64-poky-linux- CC="aarch64-poky-linux-gcc --sysroot=/opt/fsl-imx-xwayland/5.4-zeus/sysroots/aarch64-poky-linux" && cd .. && cp -rf imx-jailhouse $(DESTDIR)/home/root/imx_jailhouse && cp $(SDK_PATH)/OK8MQ-linux-kernel/arch/arm64/boot/dts/freescale/imx8mq-evk-inmate.dtb $(DESTDIR)/home/root 

linux_headers:
	@echo =========================================
	@echo     Building the Linux Kernel Headers
	@echo =========================================
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) $(LINUX_DEFCONFIG) LDFLAGS=
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) LDFLAGS=
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) LDFLAGS= headers_install INSTALL_HDR_PATH=$(DESTDIR)/usr

linux_install: 
	@echo ===================================
	@echo     Installing the Linux Kernel
	@echo ===================================
	@if [ ! -d $(DESTDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi

	@if [ -d $(DESTDIR)/lib/modules ] ; then \
		rm -fr $(DESTDIR)/lib/modules ;\
	fi

	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) LDFLAGS= INSTALL_MOD_PATH=$(DESTDIR) INSTALL_MOD_STRIP=$(INSTALL_MOD_STRIP) modules_install
linux_package: linux linux_install
	@echo ===================================
	@echo     packaging the Linux Kernel
	@echo ===================================
	@cd $(DESTDIR) && tar jcvf module.tar.bz2 ./lib/modules	&& mv module.tar.bz2  $(SDK_PATH)/images/

linux_clean:
	@echo =================================
	@echo     Cleaning the Linux Kernel
	@echo =================================
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) mrproper

u-boot: 
	@echo ===================================
	@echo    Building U-boot
	@echo ===================================
	$(MAKE) -C $(UBOOT_INSTALL_DIR) $(UBOOT_DEFCONFIG)
	$(MAKE) -j $(MAKE_JOBS) -C $(UBOOT_INSTALL_DIR)
	install $(UBOOT_INSTALL_DIR)/u-boot-nodtb.bin $(SDK_PATH)/images/u-boot
	install $(UBOOT_INSTALL_DIR)/spl/u-boot-spl.bin $(SDK_PATH)/images/u-boot
	make -C $(SDK_PATH)/tools/imx-boot-tools clean
	make -C $(SDK_PATH)/tools/imx-boot-tools flash_ddr4_val SOC=iMX8MQ

u-boot_clean:
	@echo ===================================
	@echo    Cleaining U-boot
	@echo ===================================
	$(MAKE) -C $(UBOOT_INSTALL_DIR) CROSS_COMPILE=$(CROSS_COMPILE) distclean
	make -C $(SDK_PATH)/tools/imx-boot-tools clean

sdcard:
	@echo ===================================
	@echo    Building rootfs
	@echo ===================================
	fakeroot -- $(SDK_PATH)/tools/fakeroot.fs
### qt example ############################

qt-examples:
	@echo =====================================
	@echo     Building the Qt Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "qt"`; qmake; make -j $(MAKE_JOBS)

qt-examples_install:
	@echo =======================================
	@echo     Installing the Qt Examples
	@echo =======================================
	@if [ ! -d $(DESTDIR) ] ; then \
                echo "The extracted target filesystem directory doesn't exist."; \
                echo "Please run setup.sh in the SDK's root directory and then try again."; \
                exit 1; \
        fi
	cd `find . -name "appsrc"`; cd `find . -name "qt"`; make install

qt-examples_clean:
	@echo =======================================
	@echo     Cleaning the Qt Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "qt"`; make distclean

# CMD 
cmd-examples: \
	shooter-examples \
	keytest-examples \
	watchdog-examples \
	watchdogrestart-examples \
	uarttest-examples \
	spitest-examples \
	opencv-examples \
	gpiotest-examples \
	net_reconectd-examples \
	tvincamera_time-examples \
	quectel-CM
	

cmd-examples_install: \
	shooter-examples_install \
	keytest-examples_install \
	watchdog-examples_install \
	watchdogrestart-examples_install \
	uarttest-examples_install \
	spitest-examples_install \
	opencv-examples_install \
	gpiotest-examples_install \
	net_reconectd-examples_install \
	tvincamera_time-examples_install \
	quectel-CM_install
	
cmd-examples_clean: \
	shooter-examples_clean \
	keytest-examples_clean \
	watchdog-examples_clean \
	watchdogrestart-examples_clean \
	uarttest-examples_clean \
	spitest-examples_clean \
	opencv-examples_clean \
	gpiotest-examples_clean \
	net_reconectd-examples_clean \
	tvincamera_time-examples_clean \
	quectel-CM_clean


# Screen shooter
shooter-examples:
	@echo =====================================
	@echo     Building the Shooter Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "screenshooter"`; make 

shooter-examples_install:
	@echo =======================================
	@echo     Installing the Shooter Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "screenshooter"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

shooter-examples_clean:
	@echo =======================================
	@echo     Cleaning the Shooter Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "screenshooter"`; make clean

# keytest
keytest-examples:
	@echo =====================================
	@echo     Building the keytest Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "keytest"`; make 

keytest-examples_install:
	@echo =======================================
	@echo     Installing the keytest Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "keytest"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

keytest-examples_clean:
	@echo =======================================
	@echo     Cleaning the keytest Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "keytest"`; make clean

# watchdog
watchdog-examples:
	@echo =====================================
	@echo     Building the keytest Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "watchdog"`; make 

watchdog-examples_install:
	@echo =======================================
	@echo     Installing the watchdog Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "watchdog"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

watchdog-examples_clean:
	@echo =======================================
	@echo     Cleaning the watchdog Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "watchdog"`; make clean

# watchdogrestart
watchdogrestart-examples:
	@echo =====================================
	@echo     Building the watchdogrestart Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "watchdogrestart"`; make 

watchdogrestart-examples_install:
	@echo =======================================
	@echo     Installing the Shooter Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "watchdogrestart"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

watchdogrestart-examples_clean:
	@echo =======================================
	@echo     Cleaning the Shooter Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "watchdogrestart"`; make clean

# uarttest
uarttest-examples:
	@echo =====================================
	@echo     Building the uarttest Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "uarttest"`; make 

uarttest-examples_install:
	@echo =======================================
	@echo     Installing the uarttest Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "uarttest"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

uarttest-examples_clean:
	@echo =======================================
	@echo     Cleaning the uarttest Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "uarttest"`; make clean

# spitest
spitest-examples:
	@echo =====================================
	@echo     Building the spitest Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "spitest"`; make 

spitest-examples_install:
	@echo =======================================
	@echo     Installing the spitest Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "spitest"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

spitest-examples_clean:
	@echo =======================================
	@echo     Cleaning the spitest Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "spitest"`; make clean

# opencvtest
opencv-examples:
	@echo =====================================
	@echo     Building the opencv Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "opencv"`; make 

opencv-examples_install:
	@echo =======================================
	@echo     Installing the opencv Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "opencv"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

opencv-examples_clean:
	@echo =======================================
	@echo     Cleaning the opencv Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "opencv"`; make clean

# quectel-CM
quectel-CM:
	@echo =====================================
	@echo     Building the quectel-CM Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "quectel-CM"`; make 

quectel-CM_install:
	@echo =======================================
	@echo     Installing the quectel-CM Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "quectel-CM"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

quectel-CM_clean:
	@echo =======================================
	@echo     Cleaning the quectel-CM Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "quectel-CM"`; make clean


# gpiotest
gpiotest-examples:
	@echo =====================================
	@echo     Building the gpiotest Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "gpiotest"`; make 

gpiotest-examples_install:
	@echo =======================================
	@echo     Installing the gpiotest Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "gpiotest"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

gpiotest-examples_clean:
	@echo =======================================
	@echo     Cleaning the gpiotest Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "gpiotest"`; make clean

# net_reconectd
net_reconectd-examples:
	@echo =====================================
	@echo     Building the net_reconectd Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "net_reconectd"`; make 

net_reconectd-examples_install:
	@echo =======================================
	@echo     Installing the net_reconectd Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "net_reconectd"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

net_reconectd-examples_clean:
	@echo =======================================
	@echo     Cleaning the net_reconectd Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "net_reconectd"`; make clean

# tvincamera_time
tvincamera_time-examples:
	@echo =====================================
	@echo     Building the tvincamera_time Examples
	@echo =====================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "tvincamera_time"`; make 

tvincamera_time-examples_install:
	@echo =======================================
	@echo     Installing the tvincamera_time Examples
	@echo =======================================
	@if [ ! -d $(CMDBINDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "tvincamera_time"`; \
	for example in `find . -executable -not \( -type d -o -iname 'make*' \)`; do \
		install -m 755 $${example} $(CMDBINDIR)/$${example} ; \
	done

tvincamera_time-examples_clean:
	@echo =======================================
	@echo     Cleaning the tvincamera_time Examples
	@echo =======================================
	@cd `find . -name "appsrc"`; cd `find . -name "cmd"`; cd `find . -name "tvincamera_time"`; make clean

