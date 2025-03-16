cmake_minimum_required(VERSION 3.12)
project(gpu_mem_util)

# 创建 HAVE_CUDA 选项，默认为开启
option(HAVE_CUDA "Enable CUDA support" ON)

# 如果启用了 CUDA，查找 CUDA 库
if (HAVE_CUDA)
    # 显式指定 CUDA 工具包的路径（可选，如果环境变量未配置）
    set(CMAKE_CUDA_INCLUDE_DIRS "/usr/local/cuda/include")
    set(CMAKE_CUDA_LIBRARY_DIRS "/usr/local/cuda/lib64")
    set(CMAKE_CUDA_COMPILER "/usr/local/cuda/bin/nvcc")

    find_package(CUDAToolkit REQUIRED)  # 明确查找 cudart 库
    message(STATUS "CUDA enabled (version: ${CUDAToolkit_VERSION})")
else()
    message(STATUS "CUDA not enabled")
endif()

# 找到 pybind11
find_package(pybind11 REQUIRED)

# 设置 C++ 标准
set(CMAKE_CXX_STANDARD 14)

# 添加 Python 扩展模块
pybind11_add_module(gpu_mem_util gpu_mem.cpp gpu_mem_util.c)  # 确保包含 CUDA 代码文件

# 根据是否启用 CUDA，添加宏定义
if (HAVE_CUDA)
    add_definitions(-DHAVE_CUDA)
endif()

# 如果启用了 CUDA，链接 cudart 库（而不是 CUDA::CUDA）
if (HAVE_CUDA)
    target_link_libraries(gpu_mem_util PRIVATE CUDA::cudart CUDA::cuda_driver)
endif()