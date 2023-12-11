#!/usr/bin/expect

pwd
# 启动要执行的命令，这里假设是执行 ./install_compiler.sh
spawn ./╜╗▓ц▒р╥ы╣д╛▀/fsl-imx-xwayland-glibc-x86_64-meta-toolchain-qt5-aarch64-toolchain-5.4-zeus.sh

# 匹配脚本输出中的关键字，通常是要求输入的提示信息
expect "Enter target directory for SDK (default: /opt/fsl-imx-xwayland/5.4-zeus):"

# 发送回车
send "\r"

# 再次匹配脚本输出中的关键字，这是要求输入 "y" 的提示信息
expect "If you continue, existing files will be overwritten! Proceed [y/N]? "

# 发送 "y"
send "y"

# 等待命令执行完成
expect eof
