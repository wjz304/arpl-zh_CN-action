#!/usr/bin/env bash
#
# Copyright (C) 2022 Ing <https://github.com/wjz304>
# 
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

echo "zh_CN"

curl -skL "https://raw.githubusercontent.com/zhmars/cjktty-patches/master/v5.x/cjktty-5.15.patch" -o "files/board/arpl/cjktty-5.15.patch"

echo '# zh_CN' >> files/configs/arpl_defconfig
echo 'BR2_ENABLE_LOCALE_WHITELIST="C ar ca de el es es_MX eu_ES fr hu it ja_JP ko nb_NO nl nn_NO oc_FR.UTF-8 pl pt_PT pt_BR ru_RU uk_UA sv_SE tr zh_CN zh_TW"' >> files/configs/arpl_defconfig
echo 'BR2_GENERATE_LOCALE="en_US.UTF-8 ar_YE.UTF-8 ca_ES.UTF-8 de_DE.UTF-8 el_GR.UTF-8 es_ES.UTF-8 es_MX.UTF-8 eu_ES.UTF-8 fr_FR.UTF-8 hu_HU.UTF-8 it_IT.UTF-8 ja_JP.UTF-8 ko_KR.UTF-8 nb_NO.UTF-8 nl_NL.UTF-8 nn_NO.UTF-8 oc_FR.UTF-8 pl_PL.UTF-8 pt_BR.UTF-8 pt_PT.UTF-8 ru_RU.UTF-8 uk_UA.UTF-8 sv_SE.UTF-8 tr_TR.UTF-8 zh_CN.UTF-8 zh_TW.UTF-8"' >> files/configs/arpl_defconfig
echo 'BR2_SYSTEM_ENABLE_NLS=y' >> files/configs/arpl_defconfig
echo 'BR2_LINUX_KERNEL_PATCH="board/arpl/cjktty-5.15.patch"' >> files/configs/arpl_defconfig
echo 'BR2_PACKAGE_NCURSES_WCHAR=y' >> files/configs/arpl_defconfig
echo 'BR2_PACKAGE_NANO_TINY=y' >> files/configs/arpl_defconfig

echo "### arpl_defconfig ###"
cat files/configs/arpl_defconfig



#sed -i 's/.*CONFIG_LOCALE_SUPPORT.*/CONFIG_LOCALE_SUPPORT=y/' files/board/arpl/busybox_defconfig
#sed -i 's/.*CONFIG_UNICODE_SUPPORT.*/CONFIG_UNICODE_SUPPORT=y/' files/board/arpl/busybox_defconfig
#sed -i 's/.*CONFIG_FEATURE_CHECK_UNICODE_IN_ENV.*/CONFIG_FEATURE_CHECK_UNICODE_IN_ENV=y/' files/board/arpl/busybox_defconfig
#sed -i 's/.*CONFIG_SUBST_WCHAR.*/CONFIG_SUBST_WCHAR=63/' files/board/arpl/busybox_defconfig
#sed -i 's/.*CONFIG_LAST_SUPPORTED_WCHAR.*/CONFIG_LAST_SUPPORTED_WCHAR=767/' files/board/arpl/busybox_defconfig
#sed -i 's/.*CONFIG_UNICODE_COMBINING_WCHARS.*/CONFIG_UNICODE_COMBINING_WCHARS=y/' files/board/arpl/busybox_defconfig
#sed -i 's/.*CONFIG_UNICODE_WIDE_WCHARS.*/CONFIG_UNICODE_WIDE_WCHARS=y/' files/board/arpl/busybox_defconfig
#
#echo "### busybox_defconfig ###"
#cat files/board/arpl/busybox_defconfig



sed -i "N;$(sed -n '/^export/=' files/board/arpl/overlayfs/root/.bashrc | tail -n1)a\export LANG=zh_CN.UTF-8" files/board/arpl/overlayfs/root/.bashrc
cp files/board/arpl/overlayfs/opt/arpl/menu.sh files/board/arpl/overlayfs/opt/arpl/menu_en.sh

sed -i 's|BACKTITLE="ARPL ${ARPL_VERSION}"|BACKTITLE="ARPL-zh_CN ${ARPL_VERSION}"|g' files/board/arpl/overlayfs/opt/arpl/menu.sh
sed -i 's|Automated Redpill Loader|Automated Redpill Loader zh_CN|g' files/board/arpl/overlayfs/opt/arpl/init.sh
sed -i 's|Automated Redpill Loader|Automated Redpill Loader zh_CN|g' files/board/arpl/overlayfs/opt/arpl/boot.sh

sed -i 's|fbelavenuto/arpl/releases/|wjz304/arpl-zh_CN/releases/|g' files/board/arpl/overlayfs/opt/arpl/menu.sh

sed -i 's|global.download.synology.com|cndl.synology.cn|g' files/board/arpl/overlayfs/opt/arpl/menu.sh
sed -i 's|global.download.synology.com|cndl.synology.cn|g' `find files/board/arpl/overlayfs/opt/arpl/model-configs/ -type f`  # -name '*.yml'
sed -i 's|fbelavenuto/arpl|wjz304/arpl-zh_CN|g' `find files/board/arpl/overlayfs/opt/arpl/model-configs/ -type f`  # -name '*.yml'

sed -i 's|https://github.com|https://ghproxy.com/https://github.com|g' files/board/arpl/overlayfs/opt/arpl/menu.sh
#sed -i 's|https://api.github.com|https://ghproxy.com/https://api.github.com|g' files/board/arpl/overlayfs/opt/arpl/menu.sh

[ -z "$(grep "inetd" files/board/arpl/overlayfs/opt/arpl/ramdisk-patch.sh)" ] && sed -i '/# Build modules dependencies/i\# Enable Telnet\necho "inetd" >> "${RAMDISK_PATH}/addons/addons.sh"\n' files/board/arpl/overlayfs/opt/arpl/ramdisk-patch.sh

BOOT_SH=files/board/arpl/overlayfs/opt/arpl/boot.sh
sed -i '/poweroff/i\for T in `w | grep -v "TTY" | awk -F" " "{printf " "$2}"`' ${BOOT_SH}
sed -i '/poweroff/i\do' ${BOOT_SH}
sed -i '/poweroff/i\  echo -e "\\n\\033[1;43m[该界面已不可操作, 请通过 http:\/\/find.synology.com\/ 查找DSM并链接.]\\033[0m\\n" > "\/dev\/${T}" 2>\/dev\/null' ${BOOT_SH}
sed -i '/poweroff/i\done' ${BOOT_SH}
                 

MENU_SH=files/board/arpl/overlayfs/opt/arpl/menu.sh
sed -i 's|"Model"|"型号"|g' ${MENU_SH}
sed -i 's|"Reading models"|"读取型号"|g' ${MENU_SH}
sed -i 's|Disable flags restriction|禁用标志限制|g' ${MENU_SH}
sed -i 's|Show beta models|显示测试型号|g' ${MENU_SH}
sed -i 's|"Choose the model"|"选择型号"|g' ${MENU_SH}
sed -i 's|"Choose a build number"|"选择版本"|g' ${MENU_SH}
sed -i 's|"Build Number"|"版本"|g' ${MENU_SH}
sed -i 's|"Reconfiguring Synoinfo, Addons and Modules"|"重新配置 Syninfo, 插件和模块"|g' ${MENU_SH}
sed -i 's|"Choose a option"|"设置"|g' ${MENU_SH}
sed -i 's|"Generate a random serial number"|"生成随机SN"|g' ${MENU_SH}
sed -i 's|"Enter a serial number"|"输入SN"|g' ${MENU_SH}
sed -i 's|"Please enter a serial number "|"请输入SN "|g' ${MENU_SH}
sed -i 's|"Alert"|"警告"|g' ${MENU_SH}
sed -i 's|"Invalid serial, continue?"|"SN无效, 是否继续?"|g' ${MENU_SH}
sed -i 's|"Add an addon"|"添加插件"|g' ${MENU_SH}
sed -i 's|"Delete addon(s)"|"删除插件(s)"|g' ${MENU_SH}
sed -i 's|"Show user addons"|"显示用户插件"|g' ${MENU_SH}
sed -i 's|"Show all available addons"|"显示所有可用插件"|g' ${MENU_SH}
sed -i 's|"Download a external addon"|"下载外部插件"|g' ${MENU_SH}
sed -i 's|"Exit"|"退出"|g' ${MENU_SH}
sed -i 's|"No available addons to add"|"没有可用的插件可添加"|g' ${MENU_SH}
sed -i 's|"Select an addon"|"选择插件"|g' ${MENU_SH}
sed -i 's|"params"|"参数"|g' ${MENU_SH}
sed -i 's|"Type a opcional params to addon"|"输入插件的加载参数"|g' ${MENU_SH}
sed -i 's|"No user addons to remove"|"没有要删除的用户插件"|g' ${MENU_SH}
sed -i 's|"Select addon to remove"|"选择要删除的插件"|g' ${MENU_SH}
sed -i 's|"User addons"|"用户插件"|g' ${MENU_SH}
sed -i 's|"Available addons"|"可用插件"|g' ${MENU_SH}
sed -i 's|please enter the complete URL to download.|请输入下载URL.|g' ${MENU_SH}
sed -i 's|"Error downloading"|"下载失败"|g' ${MENU_SH}
sed -i 's|Check internet, URL or cache disk space|请检查internet, URL或磁盘空间.|g' ${MENU_SH}
sed -i 's|"Success"|"下载成功"|g' ${MENU_SH}
sed -i "s|\"Addon '\${ADDON}' added to loader\"|\"插件 '\${ADDON}' 添加到引导中.\"|g" ${MENU_SH}
sed -i 's|"Invalid addon"|"无效插件"|g' ${MENU_SH}
sed -i 's|"File format not recognized!"|"无法识别文件格式!"|g' ${MENU_SH}
sed -i 's|Add/edit a cmdline item|添加/编辑cmdline参数|g' ${MENU_SH}
sed -i 's|Delete cmdline item(s)|删除cmdline参数(s)|g' ${MENU_SH}
sed -i 's|Define a custom MAC|自定义MAC|g' ${MENU_SH}
sed -i 's|Show user cmdline|显示用户cmdline参数|g' ${MENU_SH}
sed -i 's|Show model/build cmdline|显示型号默认cmdline参数|g' ${MENU_SH}
sed -i 's|Show SATA(s) # ports and drives|显示SATA(s) # 端口和驱动器|g' ${MENU_SH}
sed -i 's|Exit|退出|g' ${MENU_SH}
sed -i 's|"User cmdline"|"用户cmdline参数"|g' ${MENU_SH}
sed -i 's|"Type a name of cmdline"|"输入参数的名称"|g' ${MENU_SH}
sed -i "s|\"Type a value of '\${NAME}' cmdline\"|\"输入 '\${NAME}' 参数的值\"|g" ${MENU_SH}
sed -i 's|"No user cmdline to remove"|"没有用户参数被删除"|g' ${MENU_SH}
sed -i 's|"Select cmdline to remove"|"选择要删除的参数"|g' ${MENU_SH}
sed -i 's|"Type a custom MAC address"|"输入自定义MAC地址"|g' ${MENU_SH}
sed -i 's|"Invalid MAC"|"无效的MAC"|g' ${MENU_SH}
sed -i 's|"Changing mac"|"修改MAC"|g' ${MENU_SH}
sed -i 's|"Renewing IP"|"刷新IP"|g' ${MENU_SH}
sed -i 's|"Model/build cmdline"|"型号默认cmdline参数"|g' ${MENU_SH}
sed -i 's|Total of ports:|端口总数:|g' ${MENU_SH}
sed -i 's|Ports with color \\Z1red\\Zn as DUMMY, color \\Z2\\Zbgreen\\Zn has drive connected.|\\Z1红色\\Zn 为模拟端口, \\Z2\\Zb绿色\\Zn 为已驱动的物理端口.|g' ${MENU_SH}
sed -i 's|Add/edit a synoinfo item|添加/编辑Synoinfo参数|g' ${MENU_SH}
sed -i 's|Delete synoinfo item(s)|删除Synoinfo参数|g' ${MENU_SH}
sed -i 's|Show synoinfo entries|显示Synoinfo参数|g' ${MENU_SH}
sed -i 's|"Synoinfo entries"|"Synoinfo参数"|g' ${MENU_SH}
sed -i 's|"Type a name of synoinfo entry"|"输入参数的名称"|g' ${MENU_SH}
sed -i "s|\"Type a value of '\${NAME}' entry\"|\"输入 '\${NAME}' 参数的值\"|g" ${MENU_SH}
sed -i 's|"No synoinfo entries to remove"|"没有Synoinfo参数被删除"|g' ${MENU_SH}
sed -i 's|"Select synoinfo entry to remove"|"选择要删除的参数"|g' ${MENU_SH}
sed -i 's|"Cleaning cache"|"清除缓存"|g' ${MENU_SH}
sed -i 's|"Downloading ${PAT_FILE}"|"下载 ${PAT_FILE} 中"|g' ${MENU_SH}
sed -i 's|"Check internet or cache disk space"|"请检查internet或磁盘空间."|g' ${MENU_SH}
sed -i 's|"Checking hash of ${PAT_FILE}: "|"检查 ${PAT_FILE} 的 hash: "|g' ${MENU_SH}
sed -i 's|"Error"|"错误"|g' ${MENU_SH}
sed -i 's|"Hash of pat not match, try again!"|"pat的Hash不匹配, 请重试!"|g' ${MENU_SH}
sed -i 's|"Disassembling ${PAT_FILE}: "|"解压 ${PAT_FILE}: "|g' ${MENU_SH}
sed -i 's|"Uncompressed tar"|"未压缩tar"|g' ${MENU_SH}
sed -i 's|"Compressed tar"|"压缩tar"|g' ${MENU_SH}
sed -i 's|"Encrypted"|"已加密"|g' ${MENU_SH}
sed -i 's|"Could not determine if pat file is encrypted or not, maybe corrupted, try again!"|"无法确定pat文件是否加密, 可能已损坏, 请重试!"|g' ${MENU_SH}
sed -i 's|"Extractor cached."|"已存在解密程序."|g' ${MENU_SH}
sed -i 's|"Downloading old pat to extract synology .pat extractor..."|"下载旧 pat, 提取 .pat 解密程序中..."|g' ${MENU_SH}
sed -i 's|"Extracting..."|"解压中..."|g' ${MENU_SH}
sed -i 's|"Checking hash of zImage: "|"检查 zImage 的 hash: "|g' ${MENU_SH}
sed -i 's|"Checking hash of ramdisk: "|"检查 ramdisk 的 hash: "|g' ${MENU_SH}
sed -i 's|"Error extracting"|"解压失败"|g' ${MENU_SH}
sed -i 's|"Hash of zImage not match, try again!"|"zImage的Hash不匹配, 请重试!"|g' ${MENU_SH}
sed -i 's|"Hash of ramdisk not match, try again!"|"ramdisk的Hash不匹配, 请重试!"|g' ${MENU_SH}
sed -i 's|"Copying files: "|"拷贝文件: "|g' ${MENU_SH}
sed -i "s|\"Addon \${ADDON} not found\!\"|\"插件 \${ADDON} 未找到\!\"|g" ${MENU_SH}
sed -i 's|"zImage not patched:|"zImage打补丁失败:|g' ${MENU_SH}
sed -i 's|"Ramdisk not patched:|"Ramdisk打补丁失败:|g' ${MENU_SH}
sed -i 's|"Ready!"|"已就绪!"|g' ${MENU_SH}
sed -i 's|Switch LKM version:|选择LKM版本:|g' ${MENU_SH}
sed -i 's|\\"Modules\\"|\\"模块\\"|g' ${MENU_SH}
sed -i 's|Switch direct boot:|切换直接启动:|g' ${MENU_SH}
sed -i 's|Edit user config file manually|编辑用户配置文件|g' ${MENU_SH}
sed -i 's|Try to recovery a DSM installed system|尝试恢复已安装DSM的系统|g' ${MENU_SH}
sed -i 's|"Advanced"|"高级"|g' ${MENU_SH}
sed -i 's|"Choose the option"|"设置"|g' ${MENU_SH}
sed -i 's|"Try recovery DSM"|"尝试恢复DSM系统"|g' ${MENU_SH}
sed -i 's|"Trying to recovery a DSM installed system"|"尝试恢复已安装的DSM系统中"|g' ${MENU_SH}
sed -i 's|"Found a installation:\\nModel: ${MODEL}\\nBuildnumber: ${BUILD}"|"找到已安装:\\n型号: ${MODEL}\\n版本: ${BUILD}"|g' ${MENU_SH}
sed -i 's|"\\nSerial:|"\\nSN:|g' ${MENU_SH}
sed -i "s|\"Unfortunately I couldn't mount the DSM partition\!\"|\"很遗憾, 我无法挂载DSM分区\!\"|g" ${MENU_SH}
sed -i 's|"Modules"|"模块"|g' ${MENU_SH}
sed -i 's|"Reading modules"|"读取模块中"|g' ${MENU_SH}
sed -i 's|"Show selected modules"|"显示已加载的模块"|g' ${MENU_SH}
sed -i 's|"Select all modules"|"选择所有模块"|g' ${MENU_SH}
sed -i 's|"Deselect all modules"|"取消所有模块"|g' ${MENU_SH}
sed -i 's|"Choose modules to include"|"选择要加载的模块"|g' ${MENU_SH}
sed -i 's|"User modules"|"模块"|g' ${MENU_SH}
sed -i 's|"Selecting all modules"|"全选所有模块"|g' ${MENU_SH}
sed -i 's|"Deselecting all modules"|"取消所有模块"|g' ${MENU_SH}
sed -i 's|"Select modules to include"|"选择要加载的插件"|g' ${MENU_SH}
sed -i 's|"Writing to user config"|"写入用户配置"|g' ${MENU_SH}
sed -i 's|"Edit with caution"|"请谨慎编辑"|g' ${MENU_SH}
sed -i 's|"Invalid YAML format"|"无效的YAML格式"|g' ${MENU_SH}
sed -i 's|"Config changed, would you like to rebuild the loader?"|"配置已更改, 是否重新编译引导?"|g' ${MENU_SH}
sed -i 's|"Choose a layout"|"选择布局"|g' ${MENU_SH}
sed -i 's|"Choice a keymap"|"选择键盘"|g' ${MENU_SH}
sed -i 's|"Update arpl"|"更新arpl"|g' ${MENU_SH}
sed -i 's|"Update addons"|"更新插件"|g' ${MENU_SH}
sed -i 's|"Update LKMs"|"更新LKMs"|g' ${MENU_SH}
sed -i 's|"Update modules"|"更新模块"|g' ${MENU_SH}
sed -i 's|"Checking last version"|"检测新版本中"|g' ${MENU_SH}
sed -i 's|"Error checking new version"|"检测新版本错误"|g' ${MENU_SH}
sed -i 's|"No new version. Actual version is ${ACTUALVERSION}\\nForce update?"|"没有新版本. 实际版本为 ${ACTUALVERSION}\\n强制更新?"|g' ${MENU_SH}
sed -i 's|"Downloading last version|"下载新版本中|g' ${MENU_SH}    # ${TAG} or null
sed -i 's|"Error downloading update file"|"下载新版本错误"|g' ${MENU_SH}
sed -i 's|"Error extracting update file"|"更新文件解压错误"|g' ${MENU_SH}
sed -i 's|"Checksum do not match!"|"Checksum不匹配!"|g' ${MENU_SH}
sed -i 's|"Installing new files"|"安装更新中"|g' ${MENU_SH}
sed -i 's|"Arpl updated with success to ${TAG}!\\nReboot?"|"Arpl更新成功 ${TAG}!\\n重启?"|g' ${MENU_SH}
sed -i 's|"Error downloading new version"|"下载新版本错误"|g' ${MENU_SH}
sed -i 's|"Extracting last version"|"解压新版本"|g' ${MENU_SH}
sed -i 's|"Installing new addons"|"安装新插件中"|g' ${MENU_SH}
sed -i 's|"Addons updated with success!"|"插件更新成功!"|g' ${MENU_SH}
sed -i 's|"Error downloading last version"|"下载新版本错误"|g' ${MENU_SH}
sed -i 's|"LKMs updated with success!"|"LKMs更新成功!"|g' ${MENU_SH}
sed -i 's|"Update Modules"|"更新模块"|g' ${MENU_SH}
sed -i 's|"Downloading ${P} modules"|"下载 ${P} 模块中"|g' ${MENU_SH}
sed -i 's|"Error downloading ${P}.tgz"|"下载 ${P}.tgz 错误"|g' ${MENU_SH}
sed -i 's|"Modules updated with success!"|"模块更新成功!"|g' ${MENU_SH}
sed -i 's|Choose a model|选择型号|g' ${MENU_SH}
sed -i 's|Choose a Build Number|选择版本|g' ${MENU_SH}
sed -i 's|Choose a serial number|选择SN|g' ${MENU_SH}
sed -i 's|\\"Addons\\"|\\"插件\\"|g' ${MENU_SH}
sed -i 's|Cmdline menu|设置Cmdline|g' ${MENU_SH}
sed -i 's|Synoinfo menu|设置Synoinfo|g' ${MENU_SH}
sed -i 's|\\"Advanced menu\\"|\\"高级设置\\"|g' ${MENU_SH}
sed -i 's|Build the loader|编译引导|g' ${MENU_SH}
sed -i 's|Boot the loader|启动|g' ${MENU_SH}
sed -i 's|Choose a keymap|选择键盘|g' ${MENU_SH}
sed -i 's|Clean disk cache|清除磁盘缓存|g' ${MENU_SH}
sed -i 's|Update menu|更新|g' ${MENU_SH}
sed -i 's|"Cleaning"|"清除中"|g' ${MENU_SH}
sed -i 's|"Call \\033\[1;32mmenu.sh\\033\[0m to return to menu"|"执行 \\033\[1;32mmenu.sh\\033\[0m 重新进入设置菜单"|g' ${MENU_SH}


[ ! -d "files/board/arpl/p3/extractor" ] && curl -k https://raw.githubusercontent.com/wjz304/arpl-zh_CN-action/main/extractor.sh | bash -s "files/board/arpl/p3/extractor"
