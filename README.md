# GPUdirect_rdma_Access
This repository based by Mellanox/gpu_direct_rdma_access. Some errors in the code have been modified, some methods have been optimized, and some features have been added



## Build Example Code:

```sh
$ git clone git@github.com:Ind1x1/GPUdirect_rdma_Access.git
$ cd gpu_direct_rdma_access
```
On the client machines
```sh
$ make USE_CUDA=1
```
On the server machines
```sh
$ make
```

## Run Server:
```sh
$ ./server -a 172.172.1.34 -n 10000 -D 1 -s 10000000 -p 18001 &
```

## Run Client:

We want to find the GPU's which share the same PCI bridge as the ConnectX Mellanox NIC
```sh
$ ./map_pci_nic_gpu.sh
172.172.1.112 (mlx5_12) is near 0000:b7:00.0 3D controller: NVIDIA Corporation Device 1db8 (rev a1)
172.172.1.112 (mlx5_12) is near 0000:b9:00.0 3D controller: NVIDIA Corporation Device 1db8 (rev a1)
172.172.1.113 (mlx5_14) is near 0000:bc:00.0 3D controller: NVIDIA Corporation Device 1db8 (rev a1)
172.172.1.113 (mlx5_14) is near 0000:be:00.0 3D controller: NVIDIA Corporation Device 1db8 (rev a1)
172.172.1.114 (mlx5_16) is near 0000:e0:00.0 3D controller: NVIDIA Corporation Device 1db8 (rev a1)
172.172.1.114 (mlx5_16) is near 0000:e2:00.0 3D controller: NVIDIA Corporation Device 1db8 (rev a1)
```

Run client application with matching IP address and BDF from the script output (-a and -u parameters)
```sh
$ ./client -t 0 -a 172.172.1.112 172.172.1.34 -u b7:00.0 -n 10000 -D 0 -s 10000000 -p 18001 &
<output>
```
