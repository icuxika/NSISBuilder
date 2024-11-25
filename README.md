# NSIS 制作 Windows 安装包
> 支持多语言、支持为单个用户安装或为所有用户安装

## TODO
`MultiUser.nsh`不支持在当选择为所有用户安装时才弹UAC，目前安装程序启动时就会弹UAC，之后无论选择为单个用户还是所有用户安装不再弹UAC。

## 说明
### 需要配置的变量
- `PRODUCT_RESOURCE` 指向存放应用程序资源的目录
- `PRODUCT_NAME` 产品名称
- `PRODUCT_FILE` 启动程序名称，不需要`.exe`后缀

## 参考
- [Sample installation script for an application](https://nsis.sourceforge.io/Sample_installation_script_for_an_application)
- [Multi-User Header File (MultiUser.nsh)](https://nsis.sourceforge.io/Docs/MultiUser/Readme.html)
- [pyapp.nsi](https://github.com/takluyver/pynsist/blob/master/nsist/pyapp.nsi)