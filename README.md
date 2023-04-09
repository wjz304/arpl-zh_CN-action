# arpl-zh_CN

# Automated Redpill Loader

本库为 arpl 同步汉化:  
原版：https://github.com/fbelavenuto/arpl  
汉化：https://github.com/wjz304/arpl-zh_CN  


## 说明:  
### 本库会发布两种版本  
* release: 
  * 仅汉化和CN处理.
  * 同步上游仓库.  
* pre-release: 
  * 包含我的增强修改.
  * 不定期发布.

## 使用
* ### [命令输入方法演示](https://www.bilibili.com/video/BV1T84y1P7Kq)  https://www.bilibili.com/video/BV1T84y1P7Kq  
* 切换 arpl 任以版本: 
    ```shell
    # 下载需要的版本
    curl -kL https://github.com/fbelavenuto/arpl/releases/download/v1.1-beta2a/arpl-1.1-beta2a.img.zip -o arpl.zip
    # 解压
    unzip arpl.zip
    # 挂载 img
    losetup /dev/loop0 arpl.img
    # 复制 p1 p3 分区
    mkdir -p /mnt/loop0p1; mount /dev/loop0p1 /mnt/loop0p1; cp -r /mnt/loop0p1/* /mnt/p1/; umount /mnt/loop0p1
    mkdir -p /mnt/loop0p3; mount /dev/loop0p3 /mnt/loop0p2; cp -r /mnt/loop0p3/* /mnt/p3/; umount /mnt/loop0p3
    # 卸载 img
    losetup -d /dev/loop0
    # 如果安装的版本中无你当前安装的DSM请删除 /mnt/p1/user-config.yml 和 /mnt/p3/*-dsm
    rm /mnt/p1/user-config.yml /mnt/p3/*-dsm
    # 重启
    reboot
    ```
* arpl 备份:
    ```shell
    # 备份为 disk.img.gz, 自行导出.
    dd if=`blkid | grep 'LABEL="ARPL3"' | cut -d3 -f1` | gzip > disk.img.gz
    # 结合 transfer.sh 直接导出链接
    curl -skL --insecure -w '\n' --upload-file disk.img.gz https://transfer.sh
    ```
* arpl 持久化 /opt/arpl 目录的修改:
    ```shell
    RDXZ_PATH=/tmp/rdxz_tmp
    mkdir -p "${RDXZ_PATH}"
    (cd "${RDXZ_PATH}"; xz -dc < "/mnt/p3/initrd-arpl" | cpio -idm) >/dev/null 2>&1 || true
    rm -rf "${RDXZ_PATH}/opt/arpl"
    cp -rf "/opt/arpl" "${RDXZ_PATH}/opt"
    (cd "${RDXZ_PATH}"; find . 2>/dev/null | cpio -o -H newc -R root:root | xz --check=crc32 > "/mnt/p3/initrd-arpl") || true
    rm -rf "${RDXZ_PATH}"
    ```
* arpl 修改所有的pat下载源:
    ```shell
    sed -i 's/global.download.synology.com/cndl.synology.cn/g' /opt/arpl/menu.sh
    sed -i 's/global.download.synology.com/cndl.synology.cn/g' `find /opt/arpl/model-configs/ -type f -name '*.yml'`
    ```
* arpl 更新慢的解决办法:
    ```shell
    sed -i 's|https://.*/https://|https://|g' /opt/arpl/menu.sh 
    sed -i 's|https://github.com|https://ghproxy.homeboyc.cn/&|g' /opt/arpl/menu.sh 
    sed -i 's|https://api.github.com|http://ghproxy.homeboyc.cn/&|g' /opt/arpl/menu.sh
    ```
* arpl 去掉pat的hash校验:
    ```shell
    sed -i 's/HASH}" ]/& \&\& false/g' /opt/arpl/menu.sh
    ```
* arpl 下获取网卡驱动:
    ```shell
    for i in `ls /sys/class/net | grep -v 'lo'`; do echo $i -- `ethtool -i $i | grep driver`; done
    ```
* arpl 使用自定义的dts文件 (> v1.1-beta2a 版本):
    ```shell
    # 将dts文件放到/mnt/p1下,并重命名为model.dts. "/mnt/p1/model.dts"
    sed -i '/^.*\/addons\/disks.sh.*$/a [ -f "\/mnt\/p1\/model.dts" ] \&\& cp "\/mnt\/p1\/model.dts" "${RAMDISK_PATH}\/addons\/model.dts"' /opt/arpl/ramdisk-patch.sh
    ```
* arpl 离线安装 (> ++-v1.3):
    ```shell
    1. arpl 下
    # arpl下获取型号版本的pat下载地址( 替换以下命令中的 版本号和型号部分)
    yq eval '.builds.42218.pat.url' "/opt/arpl/model-configs/DS3622xs+.yml"
    # 将pat重命名为<型号>-<版本>.pat, 放入 /mnt/p3/dl/ 下
    # 例: /mnt/p3/dl/DS3622xs+-42218.pat

    2. pc 下
    # 通过 DG等其他软件打开arpl.img, 将pat重命名为<型号>-<版本>.pat, 放入 第3个分区的 /dl/ 下.
    ```
* arpl 增删驱动:
    ```shell
    # 1.首先你要有对应平台的驱动 比如 SA6400 7.1.1 增加 r8125
    # 略
    # 2.解包
    mkdir -p /mnt/p3/modules/epyc7002-5.10.55
    gzip -dc /mnt/p3/modules/epyc7002-5.10.55.tgz | tar xf - -C /mnt/p3/modules/epyc7002-5.10.55
    # 3.放入或删除驱动
    # 略
    # 4.打包
    tar -cf /mnt/p3/modules/epyc7002-5.10.55.tar -C /mnt/p3/modules/epyc7002-5.10.55 .
    gzip -c /mnt/p3/modules/epyc7002-5.10.55.tar > /mnt/p3/modules/epyc7002-5.10.55.tgz
    rm -rf /mnt/p3/modules/epyc7002-5.10.55.tar /mnt/p3/modules/epyc7002-5.10.55
    ```
* dsm下重启到arpl(免键盘):
    ```shell
    sudo -i  # 输入密码
    echo 1 > /proc/sys/kernel/syno_install_flag
    [ -b "/dev/synoboot1" ] && (mkdir -p /tmp/synoboot1; mount /dev/synoboot1 /tmp/synoboot1)
    [ -f "/tmp/synoboot1/grub/grubenv" ] && grub-editenv /tmp/synoboot1/grub/grubenv set next_entry="config"
    reboot
    ```
* dsm下修改sn (arpl):
    ```shell
    sudo -i  # 输入密码
    SN=VG845ZUP72CGW   # 输入你要设置的SN
    echo 1 > /proc/sys/kernel/syno_install_flag
    [ -b "/dev/synoboot1" ] && (mkdir -p /tmp/synoboot1; mount /dev/synoboot1 /tmp/synoboot1)
    [ -f "/tmp/synoboot1/user-config.yml" ] && OLD_SN=`grep '^sn:' /tmp/synoboot1/user-config.yml | sed -r 's/sn:(.*)/\1/; s/[\" ]//g'`
    [ -n "${OLD_SN}" ] && sed -i "s/${OLD_SN}/${SN}/g" /tmp/synoboot1/user-config.yml
    reboot
    ```

## 打赏一下
<img src="https://raw.githubusercontent.com/wjz304/wjz304/master/my/20220908134226.jpg" width="400">



