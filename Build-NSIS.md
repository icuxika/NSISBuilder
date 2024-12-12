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
> [Zlib-1.2.8-win64-AMD64.zip](https://nsis.sourceforge.io/mediawiki/images/b/bb/Zlib-1.2.8-win64-AMD64.zip)

在`Developer PowerShell for VS 2022`下执行以下步骤

```
pip install scons
```

### 1. 修改`C:\Users\icuxika\miniconda3\Lib\site-packages\SCons\Tool\masm.py`相关部分
```
    env['AS']        = 'ml'
    if env.get('TARGET_ARCH')=='amd64':
        env['AS']   = 'ml64'
```

### 2. 修改`.\Contrib\System\SConscript`相关部分
```
files = Split("""
        Source/Buffers.c
        Source/Plugin.c
        Source/System.c
        Source/Call-amd64.S
""")
```

### 3. 编译
> 上面两步用于解决`System.obj : error LNK2019: unresolved external symbol CallProc2 referenced in function Call`
```
scons NSIS_MAX_STRLEN=8192 PREFIX=C:\CommandLineTools\SourceInstall\nsis ZLIB_W32="C:\CommandLineTools\Zlib-1.2.8-win64-AMD64" TARGET_ARCH=amd64 install
```

