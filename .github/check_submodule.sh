#!/bin/bash

# 切换到代码仓库目录
cd .

# 获取最新的子模块代码
git submodule update --recursive --remote

# 检查子模块是否有更新
if git diff-index --quiet HEAD --; then
  echo "Submodules are up to date."
else
  echo "Submodules have changed. Triggering CI/CD..."
  # 在这里添加触发 CI/CD 流程的命令，例如：
  # github.event.client_payload 是 GitHub Actions 提供的环境变量，
  # 用于传递信息给 CI/CD 流程
  echo "::set-env name=SUBMODULE_UPDATED::true"
fi
