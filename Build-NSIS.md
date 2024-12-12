## 源码构建 NSIS strlen 版本
> 目前生成的程序拷贝到`NSIS`安装目录使用会报错，暂时没有解决。`建议直接从 GitHub Releases 直接下载可以用的版本`

## 构建所需依赖
- [Zlib](https://nsis.sourceforge.io/Zlib)

```
pip install scons
scons NSIS_MAX_STRLEN=8192 PREFIX=C:\CommandLineTools\SourceInstall\nsis ZLIB_W32="C:\CommandLineTools\Zlib-1.2.8-win64-AMD64" TARGET_ARCH=amd64 install-compiler install-stubs
```