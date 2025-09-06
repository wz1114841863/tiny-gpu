## 环境安装
```
1. sudo apt install iverilog
2. 从https://github.com/zachjs/sv2v/releases下载sv2v-Linux.zip, 需要的glibc版本>2.31, 重新编译
3. git clone https://github.com/zachjs/sv2v.git
5. 安装stack工具链, https://docs.haskellstack.org/en/stable/, curl -sSL https://get.haskellstack.org/ | sh
4. cd sv2v
6. make
7. 添加执行文件路径到PATH， 验证sv2v --version
8. uv venv --python 3.12
9. uv pip install cocotb
# 进行验证
10. make ttest_matadd 验证通过
11. make test_matmul  验证通过
```
