import sys
import os

# 添加模块所在路径（build 目录的绝对路径）
sys.path.append(os.path.abspath("build"))

import gpu_mem_util

print("GPU memory test")


# 使用其他函数
gpu_mem_util.print_gpu_devices_info()