# NSIS 制作 Windows 安装包
> 支持多语言、支持为单个用户安装或为所有用户安装

## TODO
`MultiUser.nsh`不支持在当选择为所有用户安装时才弹UAC，目前安装程序启动时就会弹UAC，之后无论选择为单个用户还是所有用户安装不再弹UAC。

## 说明
### 需要配置的变量
- `PRODUCT_RESOURCE` 指向存放应用程序资源的目录
- `PRODUCT_NAME` 产品名称
- `PRODUCT_FILE` 启动程序名称，不需要`.exe`后缀
- `PRODUCT_URI_SCHEME` 用于浏览器唤起应用程序的`URI Scheme`名称

## 不修改`nsi`源文件的配置方法
### 1. 将相关变量的值以占位符的形式展示，如
```
!define PRODUCT_NAME "{{productName}}"
!define PRODUCT_FILE "{{productFile}}"
!define PRODUCT_URI_SCHEME "{{productUriScheme}}"
```

### 2. 编写PowerShell脚本，将占位符替换为实际值
```
param(
    [Parameter(Mandatory = $true)][string]$originalFile,
    [Parameter(Mandatory = $true)][string]$outputFile,
    [Parameter(Mandatory = $true)][string]$productName,
    [Parameter(Mandatory = $true)][string]$productFile,
    [Parameter(Mandatory = $true)][string]$productUriScheme
)

$originalFilePath = (Resolve-Path -Path $originalFile).Path
$originalContent = Get-Content -Path $originalFilePath
$newContent = $originalContent -replace '{{productName}}', $productName -replace '{{productFile}}', $productFile -replace '{{productUriScheme}}', $productUriScheme

if ((Test-Path -Path $outputFile)) {
    Remove-Item -Path $outputFile
}

Set-Content -Path $outputFile -Value $newContent
```

### 3. 调用上述脚本，假设上述PowerShell脚本名称为`replace_original.ps1`，`nsi`源文件为`installer_original.nsi`，替换后新的`nsi`文件为`installer_execute.nsi`
```
.\replace_original.ps1 -originalFile .\installer_original.nsi -outputFile installer_execute.nsi -productName NSISBuilder -productFile ComposeMultiplatformProject -productUriScheme NSISBuilder
& 'C:\Program Files (x86)\NSIS\makensis.exe' /INPUTCHARSET UTF8 .\installer_execute.nsi
```

## 参考
- [Sample installation script for an application](https://nsis.sourceforge.io/Sample_installation_script_for_an_application)
- [Multi-User Header File (MultiUser.nsh)](https://nsis.sourceforge.io/Docs/MultiUser/Readme.html)