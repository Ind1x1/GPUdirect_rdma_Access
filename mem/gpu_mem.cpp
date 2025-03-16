/*
Copyright 2022
DLlock Project (a) 2024 Leyi Ye
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include "gpu_mem_util.h"

namespace py = pybind11;

PYBIND11_MODULE(gpu_mem_util, m) {
    m.doc() = "pybind11 plugin for GPU memory allocation and free";

    #ifdef HAVE_CUDA
    
    m.def("print_gpu_devices_info", &print_gpu_devices_info, "Print GPU devices information");
    m.def("get_gpu_device_id_from_bdf", &get_gpu_device_id_from_bdf, "Get GPU device ID from BDF");
    m.def("init_gpu", &init_gpu, "Initialize GPU memory");
    m.def("free_gpu", &free_gpu, "Free GPU memory");
    
    #endif //HAVE_CUDA

    m.def("work_buffer_alloc", &work_buffer_alloc, "Memory allocation on CPU or GPU according to HAVE_CUDA pre-compile option and use_cuda flag");
    m.def("work_buffer_free", &work_buffer_free, "CPU or GPU memory free, according to HAVE_CUDA pre-compile option and use_cuda flag");
}