# ubuntu-rootfs-build

ubuntu-rootfs自动构建脚本

## 使用
```shell
$ git clone https://github.com/Jubian540/ubuntu-rootfs-build.git
$ cd ubuntu-rootfs-build
$ sudo ./build_ubuntu_rootfs.sh
```

### 修改
在general.sh中可以修改cdimage镜像源地址，在build_ubuntu_rootfs.sh中修改以下两个环境变量可以替换目标rootfs中的源

```shell
TAG_SOURCE_MIRROR="ports.ubuntu.com" #目标rootfs原本使用的源
SOURCE_MIRROR="mirrors.ustc.edu.cn" #替换后的源
```
chroot.sh为在模拟环境中执行的脚本

构建成功后在项目根目录生成rootfs目录和rootfs.img镜像文件。