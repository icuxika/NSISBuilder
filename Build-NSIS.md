## 源码构建 NSIS strlen 版本
> `GitHub Releases` 提供直接下载可以用的版本。

> [https://sourceforge.net/projects/nsis/files/NSIS%203/3.10/](https://sourceforge.net/projects/nsis/files/NSIS%203/3.10/) 有提供构建好的`x86`版本，但是编写此文档的时候，`nsis-3.10.zip`，`nsis-3.10-setup.exe`，`nsis-3.10-src.tar.bz2`可以正常下载，但是`nsis-3.10-strlen_8192.zip`始终无法下载。

> 下方构建使用`nsis-3.10-src.tar.bz2`解压得到的源码

## 构建所需依赖
- [Zlib](https://nsis.sourceforge.io/Zlib) `需要根据构建平台和是否64位下载不同的版本`


## x86
> [Zlib-1.2.7-win32-x86.zip](https://nsis.sourceforge.io/mediawiki/images/c/ca/Zlib-1.2.7-win32-x86.zip)
```
pip install scons
scons NSIS_MAX_STRLEN=8192 PREFIX=C:\CommandLineTools\SourceInstall\nsis ZLIB_W32="C:\CommandLineTools\Zlib-1.2.7-win32-x86" install-compiler install-stubs
```
编译完成后构建结果覆盖到`NSIS`安装目录（`nsis-3.10.zip`解压目录或`nsis-3.10-setup.exe`安装目录）同名文件

## x64
需要完整的构建`x64`版本的`NSIS`，但是比较复杂还没有尝试，也因此下方的命令虽然能构建出`x64`的`strlen`版本`NSIS`组件，但是无法使用，如果能够完整的构建`x64`版本的`NSIS`，也不需要下方单独构建`strlen`版本的`NSIS`组件了

> [Zlib-1.2.8-win64-AMD64.zip](https://nsis.sourceforge.io/mediawiki/images/b/bb/Zlib-1.2.8-win64-AMD64.zip)
```
pip install scons
scons NSIS_MAX_STRLEN=8192 PREFIX=C:\CommandLineTools\SourceInstall\nsis ZLIB_W32="C:\CommandLineTools\Zlib-1.2.8-win64-AMD64" TARGET_ARCH=amd64 install-compiler install-stubs
```
