# 更新日志

> 版本号唯一来源是 `src/common/version.h`；发布时 `version.h` / git tag / `dist/version.json` 三处同源。
> 命名规则见 `docs/37-版本命名规范.md`（测试版 `1.0 beta.N` / RC `1.0 RCN` / 内部四段继续递增）。

## 1.0 RC5 移除第三方装机脚本目录名诊断项（2026-11-22，内部 `1.0.1.1`）
- 用户确认该名称未参与本程序工作后要求清除。全仓检索结论：没有该第三方的
  源码、二进制、脚本、许可证或调用链；唯一现役引用是 `selfdiag` 的只读第三方
  工具清单（仅探测目录名并打印 diag，不创建/删除/执行）。
- 修改：`src/app/selfdiag.cpp` 删除该清单项及注释中的名称；`docs/25` PIT-139
  改为泛化描述；`docs/老旧文档暂存`、`archive/SysRecover`、`temp/scratch` 的
  文本副本一并泛化替换，未删除文件。
- 验证：`make check` 285 用例 / 2817 断言 / 0 失败；成品
  `SysRecover.exe` / `SysRecoverUI.exe` 中该字符串的 UTF-16LE/UTF-8 计数均为 0；
  `SHA256SUMS` 78 文件、`check-dist`、`check-icons`、两个单文件 smoke 均通过。
- 成品：`D:\九转大还原1.0.1.1.exe`（44,529,022 字节，SHA256
  `D64CE4016F93507186F732E54C9521E4C4A8BF2D720A6E14D03DA5D1937FC79A`）；
  `dist\SysRecover-Portable-CLI.exe`（44,287,358 字节，SHA256
  `6B535B33A8F6961F98A3DF7359402DD07293FE2748801FEF3A66D1E202381D78`）。
- 未验：`diag` 输出在真实精简系统上的显示需实机核；历史证据 zip 内可能仍有
  旧字符串，未解包改写。

## 1.0 RC5 版本号改为内部构建号（2026-11-18，内部 `1.0.1.0`）
- 用户定稿：界面暂时继续显示 `1.0 RC5`；内部四段从 `1.0.0.104` 切到 `1.0.1.0`，
  第四段改为每次出包 +1 的构建号（`SYSRECOVER_BUILD`）。这样既不越过 1.0，
  也不会出现 `0.x` 相对旧 RC 的“版本倒退”（`1.0.1.0` > `1.0.0.104`）。
- 规则：`docs/37` 重写；`SYSRECOVER_BETA` → `SYSRECOVER_BUILD`；
  `tools/version.py` 的 `--bump` 递增构建号，`--rc N` 设显示号，
  `--patch N` 开新批次，`--release` 清 RC，移除 `--beta`；
  文件名始终为内部四段（`九转大还原1.0.1.0.exe`）。
- 测试：`tests/test_version.py` 重写（23 断言）；历史号 `1.0.0.99`–`1.0.0.104`
  不改、不重打。
- 工具/门禁（同日）：
  - AGENTS 新增 §0.3「固定命令与独立工具」；用户同意暂时把 AGENTS 35,000 字节
    硬上限放宽到 50,000，下一轮清理后恢复。
  - `temp/scratch/pe-icon-check.ps1` 固化为 `tools/check-icons.ps1`：
    新增 `make icons`，`make check` 核对已存在的 dist exe，`make portable` 结束
    自动 `-RequirePortable` 复核。
  - `tests/test_menu_text.py` 接入 `make check`（菜单改名/点号/导出提示契约）。
- 验证：`make check` 285 用例 / 2817 断言 / 0 失败；图标检查 15 个 exe PASS；
  docs/i18n（1185 键）/宽度/shell/config/版本属性全 PASS；
  `SHA256SUMS` 78 文件 + `check-dist: PASS`；GUI/CLI 单文件 smoke 均 PASS。
- 成品：`D:\九转大还原1.0.1.0.exe`（44,529,235 字节，SHA256
  `7A15C6B0F5AD36685086703557243452D6A4355AB16AB02357FD697AE0A1F75F`）；
  `dist\SysRecover-Portable-CLI.exe`（44,287,571 字节，SHA256
  `705FEE715187E239E4C5BA972235576D8559309887591FAC151E7E64027E5AF4`）；
  两者 `version` 均为 `1.0.1.0`。
- 未验：仅版本串/文件名与工具链变化，产品行为与 `.104` 相同；GUI 实机外观、
  真实固件 NVRAM 清理、Win7/PE 仍按 docs/42 §34 的未验边界保留。
  `1.0.0.104` 及更早中间包不再分发。

## 1.0 RC4 文案口径与「更多功能」整理（2026-11-18，内部 `1.0.0.104`）
- 用户逐条裁定后的实施（定稿文案见 docs/ui-design §20，记录见 docs/41 §34）：
  - 动作术语统一「还原」：主按钮 `开始还原`、第二步提示、ESP tooltip、还原确认框、
    暂存预检错误、CLI 帮助全部改口径；`恢复环境/恢复分区/恢复密钥/无法恢复/
    启动状态已恢复` 是固定概念，保留。
  - 需要重启的三选改为 `先解压再重启` / `重启后清空还原`（原「还原后重启 /
    重启后还原」）；勾选项、异机还原置灰提示与 CLI 提示同步；A 引擎的格式化
    勾选改为 `先格式化目标分区（不勾选则保留文件系统、只清空内容）`。
  - 「静默」tooltip 按模式分别说明，并写明会跳过 BitLocker/磁盘健康提醒。
  - 保存格式下拉的收起框直接显示当前格式，不再固定写「类型」。
  - 右下角 `讨论` → `反馈`（快捷键 F），tooltip 显示真实网址（仍只在
    `main_form_notice.cpp::kSiteUrl` 一处维护）。
  - 单实例对话框改为 `「九转还原」已在运行` / `切回已打开窗口` / `使用本次启动` /
    `退出本次启动`；旧实例忙时同时说明原因，不再只把按钮置灰。
  - ISO 提取确认框删掉「会校验镜像」；打开对话框的菜单项统一以 `…` 结尾；
    `更多功能` tooltip 改为能力概览。
  - 随包 `README.txt` 同步新文案。
- 功能：
  - `打包成单文件…` 与 `解压到文件夹…` 按本次是否单文件启动互斥置灰
    （`IsPortableRuntime()`；流程入口再兜底，不靠菜单状态）。
  - `从 ISO 中提取 ESD/WIM 文件…` 移到两模式公共菜单（cmd 不变），备份页也能用。
  - 单文件版「导出驱动」改为提示先「把本程序解压到文件夹…」（2026-11-18 用户定稿）：
    驱动要导出到程序目录的 `Drivers` 文件夹，单文件版是临时解包到
    `%LOCALAPPDATA%` 的，不能当永久家。提示框可直接开始解压；取消不改状态。
    导出完成后可再「把本程序打包成单文件…」。原「导出后重打包
    `<用户名>加驱动.exe`」路径（PIT-212）已移除；`DriversRoot()` 与包内
    `Drivers` 预扫口径保留。
  - 「更多功能」改名与点号统一：`把本程序打包成单文件…`、`把本程序解压到文件夹…`；
    点后还会弹下一步（确认/选择/文件对话框/密码框）的项加 `…`，立即执行或纯开关的
    项不加。`打包日志`、`显示 USB 设备`、`还原前完整校验镜像` 不带点号。
  - `整理启动菜单（只保留本系统）` → `整理启动菜单（本程序与固件残留）`；
    `清除启动中还原菜单` → `移除启动还原菜单`，所有提示/确认/结果同步。
  - 新增固件启动对象清理（等价于自用的「删除BCD和NVRAM无效固件对象.bat」，
    但无 CMD 黑框）：只删未被启动顺序引用的孤儿、或与已引用项完全等价的重复项；
    `{bootmgr}`/`{fwbootmgr}`/`{default}`/`{current}`、bootmgfw 加载器、
    Windows Boot Manager 描述对象永不删除；删除后重新 `/enum FIRMWARE` 回读确认，
    退出码 0 不算成功；有待执行的暂存还原时跳过（保护临时救援项）。
  - 实现：`src/boot/bcd_parse.cpp` 纯解析 + 单测，
    `src/boot/bcd.cpp::BcdCleanupFirmwareOrphans` 调 `bcdedit`（`RunProcess`
    带 `CREATE_NO_WINDOW`），`src/app/ops_boot.cpp::ConsolidateBootMenuNow` 接入。
- 验证：`make check` 285 用例 / 2814 断言 / 0 失败；i18n 1185 键、宽度 0 WARN、
  docs/shell/layers/config/foreground/secrets/brand/版本属性全 PASS；
  `SHA256SUMS` 78 文件 + `check-dist: PASS`；GUI/CLI 两个单文件
  `smoke-portable` 与 `smoke-bootstrap-safety` 通过。
- 成品：`D:\九转大还原1.0.0.104.exe`（44,528,305 字节，SHA256
  `B917DB550E4DAF73357BD1662C0559ED1F61A918EF44A3A0FF0183715824F9AF`）；
  `dist\SysRecover-Portable-CLI.exe`（44,286,641 字节，SHA256
  `F949177FEE3E6943D9ADF7A261A05EFD9CA8904A327772797D12A6CEBBA8AF6A`）。
- 未验：真实 UEFI 固件 NVRAM 清理（需实机）、GUI 实际点击/截图与英文按钮宽度、
  Win7/PE 实机、单文件版导出驱动提示与菜单点号的实际外观。同轮
  `1.0.0.100`/`1.0.0.101`/`1.0.0.102`/`1.0.0.103` 为内部迭代构建
  （README / 确认框折行 / 导出驱动流程 / 菜单改名前），字节与最终包不同，
  已由 .104 取代，不要再分发。

## 1.0 RC4 图标收敛：文件夹只留入口带图标，单文件保留图标（2026-11-16，内部 `1.0.0.99`）
- 用户定稿（两次澄清后）：**文件夹里**带品牌图标的可执行文件只有根目录
  `SysRecoverUI.exe`（x86 通用 GUI 入口）与 `x64\SysRecoverUI.exe`（在子目录里，
  不与根目录入口混淆）；**单文件成品是唯一交付物，必须保留图标**。两者不冲突。
  此前 `SysRecoverUI_x86.exe` 也带同一个图标，用户反馈"看到多个一样的图标，
  分不清该点哪个"。
- 实现：`src/gui/SysRecoverUI.rc` 的图标改条件嵌入（`ARCH=x86` 用
  `-DZJ_GUI_NO_ICON` 编同一份 rc）；GUI 单文件的 worker/stub（`$(PORTABLE_RC)`）
  保留图标，CLI 单文件保持 CLI 语义不带图标；`make package` 把
  `resources\SysRecover.ico`（120,230 字节）复制到 `dist\resources\`。
- 顺带修：GUI「更多功能 → 打包成单文件」原来取控制台 stub，打出的单文件既没有
  图标、双击还会闪控制台；改为优先 `bootfiles\portable-stub-gui.exe`
  （与「导出驱动 → 重新打包」一致），没有才退回控制台 stub。
- 窗口/任务栏图标改为运行时三级回退：内嵌资源 id=1（老包与用户自打包仍带）→
  `<AppDir>\resources\SysRecover.ico` → `IDI_APPLICATION`。所以 x86 真程序去掉
  内嵌图标不影响窗口外观；删掉 `resources\SysRecover.ico` 才会退回系统默认。
- 实测（直接解析 PE 资源目录）：`dist` 里带 RT_GROUP_ICON 的是
  `SysRecoverUI.exe`（455,680）、`x64\SysRecoverUI.exe`（4,634,112）、
  `SysRecover-Portable.exe`（单文件，44,506,396）与 `bootfiles\portable-stub-gui.exe`
  （单文件的头部，图标就是从这里来的）；`SysRecoverUI_x86.exe`、CLI、Check、
  `portable-stub.exe`、`SysRecover-Portable-CLI.exe` 均无图标。
- 回归：`283 用例 / 2778 断言 / 0 失败`；i18n（1174 键）、宽度、docs、layers、
  配置、shell（initramfs 戳随 .99 重建，17,452,737 字节）、版本属性、dist-check 全 PASS。
- 本地交付：内部 `1.0.0.99`（仍 `1.0 RC4`）；`D:\九转大还原1.0.0.99.exe`
  = `dist\SysRecover-Portable.exe`，44,506,396 字节，SHA256
  `EEDFDF3B92EC03F161E987B068605921042EF56A65CB46C79E14895C3D86E363`；
  `dist\SysRecover-Portable-CLI.exe` 44,264,732 字节，SHA256
  `FC779798B3EAD10AADFB9A5E8321CB9B58D2A76329AF4693A891B0C5673A0113`。未公开发布。
  同轮生成的 `1.0.0.98` 单文件漏了图标，**已作废，勿用**。
- 未验：GUI 标题栏/任务栏/Alt+Tab 的实际图标外观（需实机截图，本机未点）；
  Win7/PE 实机。

## 1.0 RC4 内置只读 UDF 解析（2026-11-16，内部 `1.0.0.97`）
- 用户实机反馈：`C:\Windows_Server_2008_r2_sp1_617396.iso` 在 Win10 上仍提示
  UDF 区。确认这不是系统版本问题：该 ISO 的 ISO9660 根目录只有 112 字节
  README，`sources\install.wim`（2,952,626,175 字节）只在 UDF 区；Win10 挂载
  可见，但第一版提取器不解析 UDF。按用户选择实施 B 方案。
- 新增 `src/disk/udf.*` 只读 UDF 解析：AVDP/主备 VDS、Partition Descriptor、
  Logical Volume Descriptor、type 1 partition map、FSD、File Entry /
  Extended File Entry、short_ad/long_ad、稀疏段、OSTA 8/16 位名称。不挂载、
  不调外部工具，Win7/PE 可用。
- `ops_iso` 改为 ISO9660 优先、未找到候选时用内置 UDF 再读一次；
  `IsoImageCandidate.format` 传入 `IsoExtractPlan`，提取阶段选择正确读取器。
  Server 2008 R2 ISO 现在直接得到 `install.wim` 候选。
- 真实验证：生产 `ExtractIsoImage` 从该 ISO 完整提取 `install.wim`，与 Win10
  挂载后的文件 SHA256 完全一致
  （`1B852E1B7B08F53E12590486E5564C76789213BBEF3F6777FAE353D152A06030`）；
  `SysRecover.exe images` 列出 8 个 Server 2008 R2 子镜像。
- 回归：新增 `tests/test_udf.cpp`（正常读取、扫描+提取、EFE、type 2 map
  拒绝、损坏 AVDP 拒绝）；当前 `283 用例 / 2778 断言 / 0 失败`。完整 `make check`
  待最终出包前复跑。
- 边界：UDF 2.50 metadata partition、VAT、sparing、extended_ad、indirect entry、
  allocation extent（type 3）仍不支持，返回明确提示“布局暂不支持”，不产出坏文件；
  真实 Windows 10/11 安装 ISO、Win7/PE 实机和 GUI 点击仍待验。
- 本地交付：内部 `1.0.0.97`（仍 RC4）；`D:\九转大还原1.0.0.97.exe`
  = `dist\SysRecover-Portable.exe`，44,628,109 字节，SHA256
  `77E1583AA6336C05017089D0EF9FAAA7FFBFB9F3531C62B1B4D044C3F8718C6E`；
  `make check`/package/portable/dist-check 通过，未公开发布。单文件比 .96
  增加 33,866 字节（约 33 KB）。

## 1.0 RC4 从 ISO 中提取 ESD/WIM（2026-11-15，内部 `1.0.0.96`）
- 更多功能新增「从 ISO 中提取 ESD/WIM 文件」：选 ISO → 解析 `sources\install.esd|
  install.wim|install.swm` → 带百分比进度拷贝到硬盘 → wimlib 校验并列索引 →
  自动填入主界面镜像框。不改还原主流程、跨层契约和引导。
- 新增自研只读 ISO9660 解析（不挂载、不调外部工具，Win7 可用）：主卷/Joliet
  回退、multi-extent 多段拼接、目录项越界/截断失败；UDF 只识别并明确提示
  “请用 Win8+ 挂载或先解出”，第一版不实现 UDF。
- 目标目录按源介质：固定硬盘默认同目录；光驱/U盘/网络默认空间最大的可写固定盘
  （优先非还原目标盘），对话框始终显示「源介质 → 建议保存位置」，可改；没有
  可用固定盘时明确拒绝。按镜像大小 + 2% + 256MB 余量提前检查空间。
- 输出名 = ISO 主名 + 原扩展名（`Win10_22H2_x64.iso` → `Win10_22H2_x64.esd`）；
  已存在提供取消/改名/覆盖，不静默覆盖；先写 `.part`，全部写完并 Flush 后才
  `MoveFileEx` 发布；取消/失败删除本次 `.part`。SWM 分卷按 `name.swm`、
  `name2.swm` 约定一起提取。
- 进度窗为 modeless，按钮/ESC/关闭进度窗都走主窗 `m_cancel`；主窗收到关闭请求
  也转为取消（不让提取与嵌套模态关闭流程互卡）。
- 回归：`build/tests.exe` 278 用例 / 2750 断言 / 0 失败；新增 ISO 夹具覆盖正常
  sources、无 sources、损坏目录项、multi-extent、UDF、SWM 分组、取消不留 `.part`、
  覆盖/改名命名；真实 WIM 嵌入 ISO 后经生产 `ExtractIsoImage` + `ProbeExtractedIsoImage`
  提取、大小与索引核对通过。完整 `make check` 全绿。
- 未验：GUI 点击/截图、Win7 实机（含无 UDF 的 Win7/8 安装 ISO）、真实 Windows
  安装 ISO 的 install.esd/wim 树、UDF-only 安装介质、SWM 多分卷实机还原链；
  这些不因自动回归通过而视为已验。
- 本地交付：内部 `1.0.0.96`（仍 RC4）；`D:\九转大还原1.0.0.96.exe`
  = `dist\SysRecover-Portable.exe`，44,594,243 字节，SHA256
  `7EEE80AD34FA510C3AE0BB3AE615D7B499A26DC235A3BB9F71FD1CF6CCA002E5`；
  `make check`/package/portable/dist-check 通过，未公开发布。

## 1.0 RC4 救援层死循环止损（2026-11-15，内部 `1.0.0.92`）

- 现场：Win7 x64 + A 引擎（还原后重启）反复进救援层；B 引擎与 PE 就地还原正常；
  与是否勾选改机器名无关。`.91` 支持包证明：MBR 标准、C:/D: VBR 均
  `NTFS BOOTMGR`、BCD 仅 Windows 一项，`menu.lst` 只有一条救援内核。
- 根因：`bootfiles/alpine/init` 的“没有还原任务”分支无条件 `reboot_now`，只要启动
  链把控制交给救援层就永远回不到 Windows。
- 修复：无任务退场前先跑 `zjrestore-lite.sh zz-boot-guard <目标设备>`——在目标根写
  `.zj-rescue-boot-count`、把 `menu.lst`/`grldr`/`grldr.mbr`/`bootmgr`/`Boot\BCD`
  的存在与大小写进救援日志；**计数 ≥3 就停到提示界面**，不再重启。
  不写 PBR/MBR、不改第三方引导文件。
- 回归：`make check` 全绿（含 `check-shell` 载荷一致性）。
- 未做（下一版）：把自己 `menu.lst` 第一条改成 `chainloader /bootmgr` 自动回退；
  救援层现场取证落盘（`boot-evidence\`）。

## 1.0 RC4 支持包补引导链证据（2026-11-15，内部 `1.0.0.91`）

- 用户要求：日志包要能直接分析“进不去 Windows / 反复进 Linux”这类问题，不能再靠
  用户手工 `bcdedit`、手工拷 `menu.lst`。
- 新增 `logs\collected\boot\`（`selfdiag_cleanup.cpp::CollectBootEvidence`）：
  `bcd-live.txt`（`bcdedit /enum all /v`）、`bcd-store-<X>.txt`（每个固定盘
  `\Boot\BCD` 离线枚举）、`mbr-disk<N>.txt` / `vbr-<X>.txt`（首扇区 hex+ASCII+
  启发式：55AA、jmp、GRUB/NTFS/BOOTMGR/NTLDR）、`root-<X>.txt`（bootmgr、
  `Boot\BCD`、grldr、grldr.mbr、menu.lst、winload 的大小/属性）、
  `menu-lst-<X>.txt`（原文）。
- 只读采集：不改文件属性、不动 BCD；PE 下以 `bcd-store-*` 为准（`bcd-live` 是 PE 自己）。
- 回归：`make check` 全绿。未验：真实 PE/正常系统各跑一次打包，确认文件齐全。

## 1.0 RC4 PE 就地还原改机器名 F4 修复（2026-11-15，内部 `1.0.0.90`）

- 用户实机：光盘引导进 PE（程序在 D 盘），默认参数（格式化还原 + 改机器名）装
  Win7 x64 万能镜像，重启滚动条后 F4；取消改机器名即正常。
- 根因：`.84`/PIT-211 只改了 A 引擎（还原后重启）的改名路径，PE/就地还原仍在
  `RestoreInPlace` 里用 `SetComputerNameOffline` 离线修改新系统 `SYSTEM` 库。
- 修复：就地还原也改为写 `ProgramData\...\StartUp\zj-firstboot-rename.cmd`，
  首次登录执行；任何引擎都不再离线改目标 SYSTEM 做改名。
- 待查：A 引擎后反复进 Linux。已确认盘根 `menu.lst` 只有一条救援内核
  （`timeout 0`/`default 0`），需 `bcdedit /enum all` 核对默认项与 `bootsequence`。
- 回归：`make check` 全绿（268 用例 / 2683 断言）。未验：Win7 PE 复测。

## 1.0 RC4 返回旧系统后的误报与入口简化（2026-11-15，内部 `1.0.0.89`）

- 用户实机：返回旧系统后立刻开软件，弹“暂时无法确认待执行任务可以安全运行：
  target-root restore-task.conf unreadable (kept): open staged evidence err=2”。
  根因：上一代 `pending-restore.txt` 残留，而目标根契约**明确不存在**被当成
  “读不了”。改为：明确不存在 → 无待执行任务并清掉残留标记；只有真读失败才保留。
- 更多功能「还原到装机前的旧系统」只有 `~OLD` 一项时，不再让用户多选一次，
  直接进下一步确认。
- 回归：`make check` 全绿。未验：返回旧系统后首启不再误报（需实机复测）。

## 1.0 RC4 已保留旧系统时的“返回上一代”修正（2026-11-15，内部 `1.0.0.88`）

- 用户实机：盘上系统1 在 `~old`、当前系统2，A 引擎装系统3。勾选/不勾选
  “保存较早期的系统”结果相同，「返回上一次旧系统」总回系统1；按 2026-11-15 定稿，
  不勾选时应回系统2。
- 根因：`ops_staged.cpp` 把“已有 `~old` 且未勾选保留”也判成 `keep_existing`，
  于是上一代留在 `~old`、当前系统进 `~discard` 被删；且 `keep_existing` 强制
  `keepOld=false`，首启清理还会按“删 `~old`”生成脚本。
- 修复：新增 `DecideOldDisposition()`（暂存与单测共用）——有上一代时
  `keep_existing` 只给“明确保留以前的”，其余一律 `replace`（上一代先改名
  `~delete-*`，失败即时中止/回滚，当前系统进 `~old`）；有上一代时 `keepOld=true`，
  首启清理只删 `~discard` / `~delete-*`。就地还原路径清掉 `m_keepExistingOld`。
- 勾选“保存较早期的系统”时的行为不变（上一代留在 `~old`，返回上一代）。
- 回归：`build/tests.exe` 268 用例 / 2683 断言 / 0 失败；新增两个
  `old_disposition_*` 用例；`make check` 全绿。
- 未验：系统1→系统2→系统3 三系统链路的实机返回点击与首启清理删除。

## 1.0 RC4 A 引擎 OOBE 根因修复：救援层不再删旧树（2026-11-15，内部 `1.0.0.87`）

- 用户实机定位（PIT-292）：A 引擎首启必弹“Windows 无法完成系统配置”，与镜像 /
  机器名 / RunOnce 无关。`setup.etl` 每次停在
  `Failed to process reparse point [ID=0x100000001258e]: [<path unavailable>]`，
  `setupcl.exe` 枚举 `$Extend\$Reparse` 撞到孤儿索引项 → `c000000d` 放弃 specialize。
- 根因：救援层（Linux ntfs3）用 `rm -rf` 递归删除旧树（`~discard` / `~delete-*` /
  上一代 `~old`）会漏删并把重解析点索引项留成孤儿；新系统首启因此永远进不了 OOBE。
  进救援层前 `chkdsk` 干净、交换后 `chkdsk /f` 能查出 22 条孤儿，可作现场判据。
- 修复：救援层不再递归删除旧系统树，只改名让位；`~discard` / `~delete-*` / `~old`
  由新系统首启的 `zj-swap-cleanup.cmd` 用 `rd /s` + 夺权重试 + 开机任务安全删除。
  卷级项（回收站 / 系统卷信息 / 页文件）原样保留；`~new` 清理改为删单文件 + `rmdir`。
- 已被旧版破坏的卷需要一次性 `chkdsk /f`（本次用户现场手工修复后 A 引擎完整装完）。
- 回归：`build/tests.exe` 266 用例 / 2671 断言 / 0 失败；`test_zjswap` 22 例、
  `test_zjswap_undo` 12 例；`make check` 全绿（含 rescue-payload 重建）。
- 未验：.87 的完整“暂存 → 重启 → 首启 OOBE → 登录清理”闭环与 `~discard` 删除重试，
  需新虚拟机重跑；`keep_existing` 强制清 `~old` 的问题按用户要求暂缓。

## 1.0 RC4 A 引擎 OOBE 修复与旧系统对话框（2026-11-15，内部 `1.0.0.86`）

- 用户现场：有 `~OLD` 时用默认“保留以前的旧系统”+“还原后重启”，新系统在
  Windows 再次重启时停在“Windows 无法完成系统配置”，多个镜像相同。
- 定位：A 引擎为“首启自动运行本程序 / 改名 / 恢复 timeout / 清理”向新系统
  离线写 `SOFTWARE` 的 RunOnce。精简镜像的 OOBE/windeploy 会因这批 RunOnce
  报“无法完成系统配置”；B 引擎不写这些键，所以正常。
- 修复：A 引擎全部首启动作改写到
  `<新系统>\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\` 脚本
  （程序启动、改名、timeout 恢复、旧系统清理），脚本执行完自删；不再离线修改
  目标 SOFTWARE/SYSTEM。
- 旧系统处理对话框按用户定稿：去掉“保留并做标记后不再提示”勾选框，按钮改为
  「保留并不再提示 / 返回旧系统 / 删除旧系统 / 删旧系统并自删除」，ESC/关闭 = 取消。
  选“保留并不再提示”写 `KeepSilent`，更多功能仍可返回旧系统。
- 保留 `.85` 的 timeout 规则：还原前记录用户原值，暂存/新系统首启期间为 0，
  首次登录后恢复原值；B 引擎直接写模板 BCD。
- 回归：`build/tests.exe` 264 用例 / 2658 断言 / 0 失败；i18n 1086 键。

## 1.0 RC4 A 引擎改机器名蓝屏修复（2026-11-15，内部 `1.0.0.84`）

- 用户对照确认：同一批镜像，图形界面默认勾选“改机器名”时“还原后重启”必蓝屏；
  取消勾选即正常，而“重启后还原”始终正常。根因是 A 引擎在还原阶段离线加载并
  修改新系统 `~new\Windows\System32\config\SYSTEM`（运行中的旧系统仍在用同一卷），
  换位后新系统无法加载该库。
- 修复：A 引擎不再离线改目标 SYSTEM；改为把改名脚本 `zj-firstboot-rename.cmd`
  写进新系统，并只向 SOFTWARE 的 RunOnce 注入一次。新系统首次登录后用
  `wmic`/`Rename-Computer` 改名，结果写 `.zj-rename-state`。PE/就地还原仍走原
  离线改名（不在运行中的旧系统里改）。
- 修复“还原后开机等 30 秒”：一次性暂存的 BIOS/UEFI `{bootmgr}` 与镜像自带
  `\Boot\BCD` 均设 `timeout 0`、删除 `displaybootmenu`。
- 修复重试被旧菜单拦住：`menu.lst` 识别旧品牌头
  `# SysRecover GRUB4DOS menu`，旧版失败留下的文件可刷新；第三方文件仍不覆盖。
- 回归：`build/tests.exe` 264 用例 / 2658 断言 / 0 失败；虚拟机里 A 引擎（带
  `--computer-name`）能完成暂存并生成首启改名脚本；干净虚拟机上的首启效果待复测。
- 说明：本次虚拟机测试环境反复在 OOBE 上叠加还原，出现过“Windows 无法完成系统
  配置”，不作为干净环境的结论；真实复测仍以用户的新建虚拟机为准。

## 1.0 RC4 程序副本探针修复（2026-11-15，内部 `1.0.0.83`）

- 修复：候选盘探针路径用 `swprintf` 的 `%s` 传宽串（MinGW C99 按窄串处理），
  路径被截成单字符，所有候选盘都报“找不到路径(3)”被跳过；SettleHome 因此
  永远认为“没有其它固定分区”。改用纯宽串 `BuildSettleProbeFile()`，并补
  候选跳过日志与回归 `settle_probe_file_path_is_full_wide_path`。
- 虚拟机验证：Windows 10 单盘 C:/E:，修复后 `settle: copying app tree + logs
  to D:\ZJRESTORE`、`A-engine: extract to C:\~new`，暂存成功；同一镜像
  index 2 的 A 引擎（保留/不保留旧系统）均进入 OOBE，未复现蓝屏。
- 回归：`build/tests.exe` 264 用例 / 2658 断言 / 0 失败；完整 check 与打包见 docs/42。
- 未决：用户报告的“A 引擎一定蓝屏”尚未在本次虚拟机镜像上复现，需其提供
  具体镜像/索引/选项与转储；OOBE 在该精简镜像上会重启回区域设置，属镜像行为。

## 1.0 RC4 单盘程序副本误报修复（2026-11-15，内部 `1.0.0.82`）

- 修复：单盘 C:/D: 机器上程序副本被误判“没有其它固定分区”。现场为单文件放在
  D:、自解压缓存在 C:、还原目标 C:，.81 直接拒绝且提示 “need 0.4GB free”。
- 正确规则：单文件本体不在目标分区时，缓存是可再生目录，不强制搬迁；
  安装版/缓存确实在目标分区时，只排除目标分区本身，**同盘其它分区可以放副本**。
- 回归：新增 `settle_candidate_drive_rules`、`portable_source_outside_target_rule`；
  `build/tests.exe` 263 用例 / 2656 断言 / 0 失败。
- 未复测：真实虚拟机上的“解压后还原/重启后还原”；未公开与发布。

## 1.0 RC4 VM 反馈第二批（2026-11-14，内部 `1.0.0.81`）

- 初心Win10x64 失败根因（`.80` 现场）：ESP BCD 同时有 `{fwbootmgr}` 与 `{bootmgr}`，
  旧解析在全文范围找字段，把第二处误判为“重复”返回 false 且不写日志 →
  “补建标准 Windows 启动项”报错冒号后为空。改为按 `{bootmgr}` 对象块取字段，
  同块内重复仍拒绝，静默分支补日志；3 个新用例（含真实 UEFI 结构夹具）。
- BIOS10SATAx64 日志显示 `need 44332KB, avail 3699416KB` 却判“RAM 不足”：
  `du -sk` 的 KB 被再乘 1024 当字节比较，导致每次 BIOS 还原丢弃 `ZJRESTORE`
  引导载荷。统一按 KB（余量 64MB），新增 `tests/test_boot_stash.sh` 4 例并挂入 check。
- 第 1 条：程序副本落点穷举所有有盘符的固定分区并按剩余空间选择；一个都放不下
  就停止并提示，不格式化、不暂存、不进 Linux（纯选择函数有单测）。
- 第 3 条：「更多功能」新增「整理启动菜单（只保留本系统）」：只删本程序条目和
  同一个 `C:\Windows` 的标准重复项，第三方/自定义菜单与磁盘启动文件保留；
  displayorder/default 回读，`bootsequence` 引用项不删。
- 第 4 条：普通“删除旧系统并自删”只删桌面快捷方式（程序在桌面才删目录），
  Program Files/日志/U 盘副本保留；「更多功能」提供最强自删与删除日志；
  日志总量 32MB（含 crash）超限按最旧清理。
- 第 5 条：格式化/清空、写 BCD、搬旧树前各再核一次目标身份
  （ASCII GUID/偏移/卷名，忽略大小写，不比较中文描述）。
- 第 7 条：确认框重要警告只加红色、不加粗（含「以前的旧系统」勾选项）。
- 第 8-10 条：Linux 首屏去掉 120 秒三选一；能继续就继续，只有交换中断证据才
  报错并自动回滚旧系统，回滚被拒不循环。
- 回归：`build/tests.exe` 261 用例 / 2641 断言 / 0 失败；`test_rescue_triage` 12 例、
  `test_boot_stash` 4 例、`test_zjswap` 22 例；i18n 1085 键；救援 initramfs 重建。
- 本地成品 `D:\九转大还原1.0.0.81.exe`：44,444,444 字节，SHA256
  `34187730B97E385D299B7DE5F03972ABB796544C99D1A472778BDFC0D4698DCC`（与 dist 一致）。
- 真实 UEFI/BIOS 固件、GUI 点击、自删 ACL、Win7 0xF4（无 dump）与观察期未验；
  未公开与发布。

## 1.0 RC4 确认框旧系统选项文字精简（2026-11-14，内部 `1.0.0.80`）

- “确认还原”里目标已有 `~OLD` 时的勾选项改为
  `还原后重启时保留以前的旧系统，取消则把当前系统保留成旧系统`，
  修正原长文案在 420 宽对话框里被截断的问题。
- 其中 `以前的旧系统` 用警示红+粗体显示；`GlyphCheck` 新增行内高亮，
  并在文字仍放不下时按 13→12→11→10px 自动缩一号，避免尾部再被裁。
- 英文键同步（`the previous old system`），i18n 1044 键；`make check`
  252 用例 / 2576 断言 / 0 失败；救援 initramfs 重建；真实 GUI 点击仍未验。

## 1.0 RC4 旧系统二选一与 A 引擎 `~discard`（2026-11-14，内部 `1.0.0.79`）

- 目标已有 `~OLD` 时，“解压后还原”确认框提供二选一（默认保留以前的旧系统）：
  `保留以前的旧系统` = 当前系统不备份，交换时进 `~discard`，成功后删除；
  `当前系统保留成旧系统` = 以前的 `~OLD` 先改名 `~delete-PID`，当前系统进 `~old`，
  成功后删除 `~delete`；两条路径都有失败回搬用例。
- 任务契约新增增量键 `old_disposition=keep_existing|replace`，不改 `contract_version`；
  Linux `zjrestore-lite.sh` 透传，`zjswap.sh` 增加 A/B 分支；`test_zjswap` 22 例通过。
- GUI 默认：有 `~OLD` 时勾选“保留以前的旧系统”；取消则保留当前系统。无 `~OLD` 时
  沿用原“是否保留当前系统”勾选。CLI 增加 `--keep-existing-old`；`--keep-old` 表示
  目标已有 `~OLD` 时替换旧系统、保留当前系统。
- 确认框说明同步：`~OLD` 在“还原后重启”可二选一；“重启后还原”会清空目标（含 `~OLD`）。
- 回归：x64 `make check` 252 用例 / 2576 断言 / 0 失败；`test_zjswap` 22 例、
  `test_zjswap_undo` 12 例、`test_rescue_triage` 12 例；i18n 1043 键；救援 initramfs 重建。
- 真实单盘 A/B 交换、Win7/PE/GUI 点击与固件仍未验；未公开发布。

## 1.0 RC4 真机测试反馈修补（2026-11-14，内部 `1.0.0.78`）

- 单分区/单盘机器「返回旧系统」不再被 `no safe drive found` 硬拦：没有其它固定盘时，
  把程序副本保留到 `<目标>:\ZJRESTORE\_app`（反向交换不搬/不删 ZJRESTORE），并从该副本继续；
  强制重试不再复用同一进程里已失败的 settle 结论。
- 有合法 `NineRestore.txt` 记录的 `~old` 不再被救援层当成「上次任务未确认」：读
  `record_version=1` 的 state（pending/keep/keep-no-prompt/delete/delete-and-self-delete）
  直接放行；无记录/真中断仍保留三选一。回归 `test_rescue_triage` 12 例通过。
- Windows 还原确认框在目标已有 `~OLD` 时提前说明「本次移入 .zj-rollback（不直接删除）」；
  归档列表补上 `~OLD`（.76 只列 .zj-rollback/.zj-trash），并修正“返回旧系统只使用 ~OLD”
  的说明矛盾；盘根身份读不到时只记 WARN，不再静默隐藏整盘归档。
- 部署 `menu.lst` 前识别本程序生成头；已有第三方 `menu.lst` 拒绝覆盖并报失败，
  不把第三方启动菜单当作自己的文件重写。
- 「改机器名」在暂存/就地两个确认框默认勾选，用户仍可取消。
- 本包同时带入 .76 后已修未交付的：不格式化清空普通文件、部分应用回退不拆散旧树、
  返回旧系统搬移失败不删 `~new/~old`（保留 ZJRESTORE）、归档 `~old`、无关日志只读清理等。
- 回归：x64 `make check` **252 用例 / 2576 断言 / 0 失败**；救援 initramfs 已重建，
  shell/宽度/i18n/版本/品牌门禁通过。真实 Win7/PE/GUI、固件与重启仍待验；未公开发布。
- .77 为中间包；补 `InstallBootLayer` 在第三方 `menu.lst` 时先中止（不再建指向别人的
  BCD 项）后，新字节递增为 .78。

## 1.0 RC4 剩余项集中修补与复查（2026-11-14，内部 `1.0.0.76`）

- 晚取消说明真实结果：已提交任务保留、停止自动重启；系统已写入时不冒称撤销。普通取消不加弹窗。
- 一键重试保留已写入未完成/取消结果与历史记录，原契约目标身份和卷映射贯通长镜像预检。
- 卸载仅清当前绑定的唯一目标及同代契约、来源选项匹配的解压目录；旧系统及其它任务保留。
- task_id同包增量兼容旧成对任务；空软件绑定可安全解绑，空日志保留而不误挡本代清理。
- 清理后再核同代日志和根契约，避免新日志出现时误报成功；其它代次新日志不误拦清理。
- 启动对象缺失改用完整对象集合核对，不依赖中英文错误词表，异常枚举仍不删载荷。
- 删除始终隐藏的旧格式标签与死译文，不挪可见控件；随包许可说明沿用已核正源清单。
- .75为本轮中间包，留档后修正最终回读遗漏，新字节递增为.76；双架构及实际成品核验见docs/42 §20。
- 本地出包不等于公开发布；真实GUI、Win7/PE、权限及实际重启和观察期仍待验。

## 1.0 RC4 总体约定统一与卸载收口（2026-11-14，内部 `1.0.0.74`）

- 统一当前文件布局、双架构入口和翻译操作说明；保留中文软件目录，救援部署迁移仍是待讨论方案。
- 清菜单失败不再继续删暂存及任务绑定；自删采用同一编排，清理未完成不删程序。
- 卸载只清自身单次启动引用，保留第三方安排和顺序；未知对象回复不当不存在。
- 特殊启动项/同卷其它系统目录保留，普通目标完整匹配后复用，正常元数据不造成重复项。
- 绑定删除只请求所需权限，只读时针对同文件追加属性权限；真实权限/GUI/重启仍待验。

## 1.0 RC4 完整操作链修补（2026-11-14，内部 `1.0.0.73`）

- 消除技能/文档的PE测试、未知身份、十秒强杀、实际库备份和源码基线歧义；不额外增加正常确认。
- ESP候选及修引导写前核对实际强身份；未知继续寻找可靠候选，不按盘号猜测。仅卸载本轮临时映射。
- BCD不可读项保留，标准项完整身份及启动设置去重；就地/暂存/修引导在清理后复核目标仍存在。
- 固件清理保护单次/当前启动引用；救援入口删除先处理本项单次引用，引用未解除不继续删载荷。
- 固件目录/条目读取失败不再当“没有启动项”；只在单次引用中出现的本项也纳入删除核对。.71中间包留档。
- 取消区分原子备份与关键写入，安全边界停后续操作；完成后不重试、不自动重启、不误清前次备份路径。
- 完成结果与临时清理所有权分开；保留“打开镜像位置/用于还原”的实际输出路径，纠正.72过早清空路径的回归。
- 本地回归与真实成品验证分别登记；真实Win7/PE/GUI/权限/固件启动和观察期仍待验。

## 1.0 RC4 自查遗漏与易用性修补（2026-11-14，内部 `1.0.0.70`）

- BIOS 救援项保留正确路径；其他默认系统暂时无法确认时，不再阻止补建独立目标入口。
- 待执行及返回旧系统核对加载器、内核和 SYSTEM 的实际内容；异常时保留原目录供处理。
- 修引导先确认系统目标，支持磁盘 0，多候选不猜；重试固定目标，写入前再次核对。
- BIOS/UEFI 重建先保存实际启动库；PBR、MBR 或固件未完成时不再显示全部成功。
- Windows 固件入口限定同一 ESP、完整路径和启用状态；写后复核，不误用别盘入口。
- 明确删除后可有限修复同代只读标志，再保存删除状态；失败仍不删，不递归改 Users。
- 确认框切换选项使用后台预检缓存，取消不重复读取镜像；执行前仍真实复核。
- RC4 文件名不变；实际 Win7/PE/GUI/NTFS 权限/固件启动与观察期仍待验。

## 1.0 RC4 Trae 复审追加修补（2026-11-13，内部 `1.0.0.60`）

- 就地还原不再对当前系统/PE 的启动库重复改名；暂存改名显式选目标库，完整匹配卷身份。
- 保留可用默认系统及菜单顺序，新目标仅追加；共享库不重定向其它系统启动项，不改自定义名称。
- 当前运行系统的 SYSTEM 文件被占用时核对活动注册表，不因此误拒绝；离线系统检查不放宽。
- 32 位进程核对当前 64 位系统文件使用 Sysnative，避免误读 SysWOW64 后判不可用。
- 系统已经写入但引导/异机准备未完成时单独记录与提示，仍返回失败，不自动重复还原。
- 补齐 GUI 线程创建失败日志；单文件打包后自动刷新 SHA256 并运行成品校验。
- RC4 文件名不变；真实 PE/多系统启动/Win7/权限与七天观察仍需验收。

## 1.0 RC4 历史问题统一修补（2026-11-13，内部 `1.0.0.53`）

- BCD 用真实 GUID 查询对象；分别核对 device/osdevice、完整加载器路径和系统目录，
  不把第三方引用、默认别名或菜单不可见当作对象身份。保留第三方菜单。
- 固件启动项按目标 ESP 复用并透传实际编号；新写入完整回读，继续任务也核对路径、
  内核参数和 ESP。初次暂存/返回失败补偿本轮启动变量，不覆盖其他程序的修改；
  已确认载荷失效的入口不复活。BCD 默认项、显示顺序和菜单字段同样逐项补偿，
  不覆盖其他程序的变化；交接文件强制刷新和回读。
- 重试保留处理方式、机器名、异机驱动选项；旧版可信准备记录可恢复缺项。
  重试仍不保留旧系统，确认页明确说明；确实缺乏准备记录时引导回正常流程。
- 契约、引导、待执行标记完成后才记暂存成功。长镜像路径不截断，写入失败中止。
  BCD 修改前备份实际库并验证，备份不重名覆盖；缺旧库与备份失败分开。
- 首启保留必须保存成功，自删日志须最终确认。更多功能可查看旧系统归档，
  取回文件/用资源管理器显式管理，不自动删除保护目录。外层错误输出补 UTF-8 防御。
- 生产接口隔离回归不替代真实 Win7、GUI、ACL、固件及 Windows 可启动性验收。

## 1.0 RC4 旧系统首启状态（2026-11-12，内部 `1.0.0.45`）

- ~OLD 生成时写用户指定的 NineRestore.txt，包含状态、生成/处理版本及中英说明。
  无标志旧版先询问、默认删除；ESC/关闭取消，保留时补标志，不再提示仅针对本代。
- 更多功能可主动返回装机前旧系统；标志不代替关键文件可读检查。
  受保护/未分类旧树后续交换只移入 .zj-rollback，Users 残留不伪造 Windows。
- GUI 首启、权限任务和真实返回启动仍待原 VM 验收；本次没有关闭后续七类引导待办。

## 1.0 RC4 无序列号 MBR 还原修复（2026-11-12，内部 `1.0.0.44`）

- 修复 Win7 x64 VMware 的无序列号 MBR 目标在确认后被误拒绝：读取现有 MBR 磁盘
  签名，结合精确分区偏移/大小唯一定位。不修改硬盘签名，不要求用户改虚拟机配置。
- Windows 确认/暂存/返回旧系统与 Linux 发现/写前复核同用 `mbr:XXXXXXXX` 身份；
  GPT GUID、旧 MBR 序列号任务仍支持。重复、变化或不可读身份不放行，不按盘符猜目标。
- 真正缺身份与重复克隆分别说明原因；准备/就地两条路径共用检查。新增独立 MBR
  字节与生产选择器回归，实际内核验证和验收边界见 docs/42、PIT-281。

## 1.0 RC4 单文件压缩更新（2026-11-12，内部 `1.0.0.43`）

- 单文件载荷改为自带 LZMA SDK C 子集（Public domain）的 ZJF4 格式；旧 ZJF1/2/3
  继续可读，CRT-free Win7 入口、运行库、全部功能和救援驱动均保留。
- 解压限制属性/内存/输出大小并检查原长、输入消费和结束标记；损坏升级不覆盖旧缓存、
  日志与待执行任务。官方成品打包与 dist-check 以严格 `<50,000,000` 字节为体积门禁。
- 独立 LZMA 样本、新旧格式、失败保留、真实升级和自打包摘要核验；本机通过不替代干净
  Win7/GUI 与真实重启验收。详见 docs/42、PIT-280。

## 1.0 RC4 使用流程整改（2026-11-12，内部 `1.0.0.42`）

- 已解压系统分层核对并提供复用/重新解压；完整目录不再仅因账龄丢弃。显式复用
  复核失败保留目录，确认后不静默换执行方式或目标；增加目标身份/卷映射回查。
- 风险、空间、驱动准备先后台预检，主要还原提示集中确认；长正文可滚动阅读。
  普通/静默模式默认均不保留旧系统，普通模式可明确选择保留。
  保留标记写失败时停止交换，不把“承诺保留”降成下次启动自动清理。
- Users 权限残留无跟随夺权/DACL 处理后重试；其它错误留实际原因，共享硬链接
  不改 ACL/属性。开机清理绑定具体目录代次，SYSTEM runtime 隔离保护，登记前
  运行版本自检；旧代任务不能删新代，执行失败不承诺必删。真实 ACL/任务仍待验。
- 继续待任务取消/写入失败补偿原单次启动；保留多项 bootsequence，不覆盖其它
  writer 的变化；补偿失败不冒充取消成功。镜像复制竞争/取消不覆盖或删除旧备份。
- 增量追加取消整包临时空间要求，补生产 Capture/Append/Verify/Apply 的隔离
  回归到 make check；写回调取消后原有镜像仍可读，基准文件摘要一致。
- 本轮不公开发布；GUI 点击、干净 Win7、真实 ACL/Task Scheduler/BCD/NVRAM 和
  重启矩阵仍待隔离测试机验收。详见 docs/41、docs/42、PIT-276～279。

## 1.0 RC4 后续验收整改（2026-11-12，内部 `1.0.0.35`）

- 单文件改为 CRT-free x86 外层：只调用 Win7 系统 API，嵌入随包 x86 UCRT 和原事务
  worker，先提取到独立启动目录再委托缓存引擎，退出清理本次文件；不更换 GCC 14.2。
  首进程导入表严格门禁，禁止未解出的运行库成为外层前置依赖（PIT-273）。
- 新包用 Win7 原生 LZNT1（ZJF3），明确保留 ZJF2 旧 Huffman 读取；实际包通过首次
  解包/复用/并发/重解析点与路径越界回归。代价：单文件约 50.3 MiB（原约 43 MiB）。
  干净 Win7 x86/x64 仍需实测，不以本机通过替代（PIT-274）。
- 补实际 QMP 热移除与 GPT 同 GUID 不同序列号测试；删除事件与失败留证均核验，
  非目标分区及镜像摘要不变（PIT-275）。CLI 包结构错误不再弹模态框。
- GUI computer-use 入口本会话未提供；干净 Win7、真实 ACL/BCD/固件矩阵和七天观察未完成。

## 1.0 RC4 全计划续作（2026-11-11，内部 `1.0.0.31`）

- 单文件缓存完整解包后事务切换，支持失败回滚、中断恢复、并发互斥和运行租约；
  迁移日志/待执行任务，拒绝越界及重复文件，保留 LGPL 动态库替换能力（PIT-268）。
- conf-only 与提示目标均要求唯一强身份，写盘前复核；Windows 暂存自检和重试同步
  使用唯一选择器，同布局双盘、目标掉线、克隆 GUID 不误选（PIT-269）。
- 确认摘要显示镜像索引/真实目标，说明按字体宽度换行；更多功能提供原任务检查/继续，
  成功备份可开目录或选为还原镜像，默认与静默规则保留（PIT-270）。
- 固定 RC 文件名以内部版本及哈希核验升级，拒绝降级/同号不同内容；历史硬链接不改。
- 修复真实打包器结束标记与新解析器不一致，兼容历史四字节格式；发布前实际运行
  成品 version/help、首次解包与缓存复用，不用合成容器测试替代整条链（PIT-271）。
- 实际双盘 VM 暴露 SATA/SCSI 不提供 device/serial：增加严格解析内核 VPD 0x80
  序列号，发现与写前校验共用；身份不可读仍拒绝，不用型号/位置替代（PIT-272）。
- GUI 实操、真实 VM 掉盘及真机/7 天观察仍待验收，见 docs/42；本轮不公开发布。

## 1.0 RC4 可靠性整改（2026-11-11，内部 `1.0.0.25`）

本轮落实代码与用户流程审查中的首批修复，详细计划和验收记录见
[docs/41](docs/41-可靠性整改与易用性计划.md)。这是本地测试构建，不自动公开发布。

- 受保护的旧系统移入独立 `.zj-rollback`，正反交换及自动清理都保留；
  兼容保留旧版垃圾容器中的 `old-*`，停用整容器开机删除任务（PIT-259）。
- 暂存复用绑定真实镜像文件身份、索引和准备选项；目录联接、相对路径按实际卷
  判断，未知身份不放行（PIT-260）。
- 暂存自检区分 swap/block/returnold，不混淆压缩量与展开量；只读检测不再撤销
  未执行任务。根契约写失败不再报成功（PIT-261）。
- 无盘符备份不再回退 C 盘；分区向导完整传递已验证计划；就地还原统一保留旧系统
  语义，禁止格式化且预检空间；密码错误允许重新选择后重输（PIT-262）。
- CLI 选项与值分开解析，补 `--allow-skipped`；还原有进度和取消；
  只读/诊断命令不做启动清理，日志及崩溃文本不记录明文口令（PIT-263）。
- 测试完整跟踪头文件依赖，CI 立即传播失败；翻译生成器与门禁统一扫描
  全部模块，防止拆分后丢译文（PIT-264）。
- `~old` 只剩 Users/空壳时不再冒充可返回旧系统；提供立即删除与 SYSTEM 开机清理，
  并显示任务登记状态，避免残留继续干扰下一次还原（PIT-265）。
- 保留第三方 BCD 菜单的同时，外科式补建固定 GUID 的标准 Windows loader；
  写后验证 default/device/path，KeepExistingBcd 分支也执行统一收口（PIT-266）。
- 救援 initramfs 先写 `temp/scratch`，完成后原子替换正式载荷并重试瞬时文件锁；
  避免 `OSError 22` 和半写文件破坏上一份可用载荷（PIT-267）。

仍待后续：单文件缓存事务升级、conf-only 多盘故障验证、操作摘要/任务卡片及
Win7/10/11/PE 真机矩阵。本轮测试不替代这些验收。

## 1.0 RC4（2026-11-10，内部 `1.0.0.20` ↔ 对外 `1.0 RC4`）

> 文件名 `九转大还原1.0-rc.4.exe`；界面 `1.0 RC4`；内部四段 `1.0.0.20`。
> 本版主线是"**镜像在重启后一定读得到**"，并补掉一轮代码评审确认的真缺陷。
> 版本号规则（用户 2026-11-10）：**每次出包第四段 +1，对外 RC 号不变**。

### 1. 光盘/U 盘/网络镜像：先复制到本地再还原（用户 2026-11-09 需求）

- 现象：镜像在光盘/U 盘/共享上时，暂存成功、重启进救援层却 `image not found` —
  救援环境没有网络栈，光驱/U 盘也可能不在。
- 修法：开始还原前判定介质（`ImageNeedsLocalCopy`），命中就弹「复制镜像」询问，
  写明"镜像位于光盘/U盘/网络"和目标目录；确认后复制到本地固定盘再继续，
  选"否"则明确中止（状态栏"已取消：镜像不在本地盘，重启后无法读取"）。
- 落点规则：安装版 → `<软件目录>\images`（软件目录安全时）或 `<数据盘>\SysRecover\images`；
  **单文件版 → 单文件所在目录本身**（不建 images 子目录，不落 %LOCALAPPDATA%）。
  同名不覆盖，自动 `name_1.ext`。

### 2. 软件/镜像在系统盘或目标盘：先搬到别的盘（用户 2026-11-09 需求）

- 安装版装在系统盘且要暂存还原 → `SettleHome(force)` 整包复制到非目标固定盘，
  界面不额外打扰；`exeOnTgt`（程序就在要被格式化的分区上）**始终**搬。
- 就地还原且程序只在系统盘时**不再白搬**（评审 R7，见第 4 条）。

### 3. 日志"隔空判案"

- 新增 `placement:` 系列日志：镜像/软件位置、介质判定、是否在目标/系统盘、
  单文件版识别、复制决策与结果、用户拒绝。
- 修复救援层 `image not found` 分支只写诊断不落盘的问题（`persist_log` 补在 `exit 1` 前），
  现场日志现在能拿到 `image rel / mount_fail / scan-dev / optical` 四行。

### 4. 评审修复（2026-11-10，逐条已核实为真）

- **PIT-253**：`zjswap.sh` 删 `~old` 前先判"根里有没有 Windows"和 `.zj-keepold`，
  命中只改名进 `.zj-trash`，不再删掉用户唯一可启动的旧系统（P0 数据安全）。
- **PIT-254**：复制镜像后的副本路径改由 `WM_IMAGE_PATH_UPD` 回 UI 线程，500ms 兜底
  定时器在 `m_busy` 期间不回读，避免路径被冲回光盘。
- **PIT-255**：CLI 暂存外部镜像时明确拒绝并给出做法，不再"暂存成功、重启必失败"。
- **PIT-256**：就地还原不再白搬整包；开机清理脚本改用 `GetTempPathW`，非 C: 系统盘可用。
- **PIT-257**：修正"保留 = 还原前会被拦截"的失真文案。
- **PIT-258**：跨大版本还原（如 Win10 ⇄ Win11）后，BCD 菜单仍显示旧版本名。
  根因是还原时 BCD "已有效"就跳过 bcdboot（避免抹掉第三方启动项），条目
  description 保留旧值。双保险修正：① **重启前**按 `~new` / 目标分区的
  `ntoskrnl.exe` 版本，把指向目标分区的条目直接改名（第一次开机菜单就对）；
  ② 新系统启动后再按 `{current}` 兜底自愈。只改"标准 Windows 版本名写错"的
  条目，用户自定义名字不动。

### 5. 验证

- `make check` 全绿：单元 113 例 / 796 断言；`test_zjswap` 12 例（新增 K/L 两条数据安全用例）；
  i18n 932 键闭环；pack hygiene、docs、shell 基线全过。
- QEMU 救援演练 `DRILL: PASS`（ESP + ZJEA + 主镜像全链路）。
- x64 / x86 双架构 `-Wall -Wextra -Werror` 零告警。

## 1.0 RC2（2026-11-08，内部 `1.0.0.16` ↔ 对外 `1.0 RC2`）

> 本版只修 RC1 真机（GPT + MBR 各一轮）报告的 4 项缺陷，不加功能、不改已通过的流程。
> 文件名 `九转大还原1.0-rc.2.exe`；界面 `1.0 RC2`；内部四段 `1.0.0.16`
> （version.json / rescue-build.txt / initramfs 内戳 / exe 资源四处一致）。
> 每项都写**根因代码位置**，不是"改了就好"。

### 1. GPT 上分区列表顺序错 + 推荐系统盘选中数据盘（P0，PIT-245）

- 真机：GPT 盘（DiskGenius 删 C 后重建）里 C 显示「硬盘的分区 0/4」、PE 的 D 显示「0/1」
  并被默认推荐；同一盘改回 MBR 后恢复「C 在前、推荐 C」。
- 根因一：`EnumerateDisks` 把 `IOCTL_DISK_GET_DRIVE_LAYOUT_EX` 的 `PartitionList` **原样入列、
  不排序**，而那是**分区表槽位顺序**（GPT 的 `PartitionNumber` 即槽位号），不是物理顺序；
  UI 又直接显示 `partNumber`。重建分区只占空槽——老 D 保持槽位 1，新 ESP/MSR/C 落 2/3/4
  → D 显示 `0/1`、C 显示 `0/4`。
- 根因二：`PopulatePartitions` 按 `isSystem` 选默认行、没有就退回第 0 行；PE 里
  `%SystemRoot%=X:` → 所有分区 `isSystem` 恒假 → 推荐第 0 行 = D。
- 修法：枚举后按 `StartingOffset` 升序 `stable_sort` 并赋物理 `ordinal`（1-based，含 ESP/MSR），
  UI 只显示它；`partNumber` 保留给暂存契约/引导定位。推荐改为**内容评分**：
  isSystem 1000 > `winload.exe/.efi` 900 > `config\SYSTEM` 800 > `ntoskrnl` 700 >
  `\Boot\BCD` 600 > `\Windows` 500，卷标 +5；同分比 `config\SYSTEM` LastWriteTime，
  再退 ordinal；全不像退第 0 行。判据与分区号无关，GPT/MBR 都得「C 在前、C 被推荐」。
- 共用性：枚举只有 `disk.cpp` 一份、界面只有 `main_form_image.cpp` 一套，BIOS/UEFI/PE/Windows
  全走同一段，**只改一处**。无需用户再跑真机取证（结论由代码 + 报告的槽位号互证）。

### 2. BIOS 路径中文仍是白底问号（UEFI 正常，PIT-247）

- 机制（为什么 UEFI 好、BIOS 坏）：UEFI 有 efifb/simpledrm → fbcon，接受 PSF1 mode 0x03
  （512 字形 + Unicode 表），PUA 码点映射到槽 256+，内核按表找字形；BIOS 是 **vgacon**
  （VGA 文本模式、8bit 字符格、无 framebuffer），`setfont` 返回 0 只证明字体文件被接受，
  **不证明 PUA 可寻址** → 内核逐字画白底 `?`。RC1 只看覆盖表，没区分控制台后端。
- 修法：新增 `zj_fbcon()`（`/sys/class/graphics/fb0` 存在才为真，`ZJ_FBCON` 可覆盖供测试）；
  vgacon → `ZJ_FONT_RC=7`、不启用中文；`zj_console_cjk` 追加 `zj_fbcon || return 1`
  （双保险）；`say/say2` 无中文能力时只出英文/ASCII，**不再出现问号**。
  `FONT:` 状态行仍上屏并进日志（`state=skip rc=7 reason=vgacon…`），不静默。
- 门禁：`check-shell.py` 新增 **C9**：PRODUCT 脚本非注释行含非 ASCII 且直接 `echo/printf/cat`
  或写 `/dev/tty*` 即失败（必须走 say），并静态钉住 `zj_fbcon`/`rc=7` 分支；
  `test_say_wrap.sh` 第 ⑫ 例（`ZJ_FBCON=0` → 不启用中文、只出英文）。

### 3. 还原完成后再进救援：没有任务却弹中文 1/2/3（PIT-248）

- 根因：`init` 把"存在上次任务契约（`restore-task.conf` / `~old`）"一律当成"上次任务未确认
  完成"进 triage；成功还原后契约已消费（`_ran=0`），常驻菜单却在 → 三选一。语义被扩大。
- 事实：一次成功还原后**不会留下可直接重放的任务**；UEFI↔MBR 互转还会换掉菜单环境。
  "没有任务"是正确状态，错的是收场方式。
- 修法：`_ran=0` 改为 `hand_back_bootorder` → `say2 "没有还原任务,正在重启"` →
  `sleep 5` → 重启，用户无感回 Windows；`_ran=1`（上次任务真未确认）**保留** triage。
  有任务路径（Windows 侧刚指定完）不变。

### 4. 启动项命名统一为 `NineRestore`（PIT-246）

- 溯源：`NineRestore` 由 **beta.14（PIT-239）** 起生成，三条路径同源 `bootnames.h`
  （UEFI `Boot####` desc / BIOS BCD desc / GRUB `menu.lst` title）；`SysRecover` 是 beta.13
  及更早的旧名。RC1 的 BCD 描述还是 `NineRestore Recovery Environment`，被 bootmgr 截成
  "NineRestore Recover Ev.."。
- 并存根因：UEFI `FindOurEntry` **只按当前描述名**匹配 → 升级后旧名条目找不到 → 新建一条，
  清理也只删一条；新旧条目指向**同一份** `\EFI\ZJRESTORE\` 载荷（同一内容）。
- 修法：`EntryKindOf` 认当前名 + 历史名，`IsOurs` 再要求路径含 `ZJRESTORE`；安装时复用并
  删同 kind 重复项（`removed duplicate Boot%04X`），卸载循环删净；
  `CleanupStaleUefiEntries` 不再要求 `desc == 当前名`；一次项统一 `NineRestore Temporary Restore`，
  `init` 同时识别新旧名（UTF-16LE / ASCII 两种 hex），升级后能 disarm。
- 门禁：新增 `tools/check-brand.py`（B1–B4，已进 `make check`）：三处同名、GRUB 必须引用
  常量、src/bootfiles/lang/README 不得出现旧可见名（历史名只允许 `bootnames.h` LEGACY 列表与
  带 LEGACY 注释的识别代码）、init 新/旧临时项判据齐备。
- **保留的 `SysRecover` 实体（说明）**：exe 文件名、`%LOCALAPPDATA%\SysRecover`、
  `ProgramData\SysRecover`、`SYSRECOVER_NAME` 程序内名 —— 是代码/资源实体，不是引导项显示名。

### 5. 还原后菜单消失是否符合设计（回答真机第 7、8 条）

- MBR/BIOS 菜单文件（`grldr`、`grldr.mbr`、`menu.lst`、`ZJRESTORE\`）位于系统盘根目录，
  整盘替换 C: 必然被镜像覆盖 → 菜单消失；UEFI 菜单在 ESP，还原不动 ESP → 菜单保留。
  这解释了两种形态的差异，**不是"设计上撤掉菜单"**。
- 补偿沿用 PIT-243：擦盘前 RAM 暂存 → 还原后写回新系统根 + `menu-redeploy.txt`（`bcd=pending`）
  → **本程序下次启动时** `EnsureMenuAfterRestore()` 重装。因此消失只发生在"还原后到下次
  启动本程序"之间；若用户不再运行本程序，需手动点一次「安装到启动」
  （完成页/README 已写明，属已知限制）。

### 6. 验证状态

- **已验**：`make check` 全绿（含新增 `check-brand`、`check-shell` C9、`test_say_wrap` 12 例、
  `gen-rescue-font --check`）；`payload-gate`；x64/x86 编译通过；版本四处一致；
  `check-dist`。
- **待真机确认**（清单 `docs/35` §O）：GPT 下 C 在前且默认推荐（PE 与 Windows 各一次）；
  BIOS 下 `FONT: rc=7` 且不再出现白底问号；二次进菜单一句话自动回 Windows；固件菜单只剩一条
  `NineRestore`。

## 1.0 RC1（2026-11-08，内部 `1.0.0.15` ↔ 对外 `1.0 RC1`）

> 首个 RC。本版只修**真机实测缺陷**，不加功能、不改已通过的渲染路径与安装流程。
> 文件名 `九转大还原1.0-rc.1.exe`；界面 `1.0 RC1`；内部四段 `1.0.0.15`
> （version.json / rescue-build.txt / initramfs 内戳 / exe 资源四处一致）。
> 内部号自此**只增不减**（下一包 1.0.0.16 ↔ 对外 RC2）。

### 1. 汉字白底方块：根因是**字模覆盖范围**，不是字体没装上（PIT-238，P0）

- 真机决定性证据（ThinkPad）：镜像名「不忘初心」里「不」在部分位置正常，
  「忘」「初」「心」始终白底方块 —— 若是 `setfont` 失败，四个字会一起坏。
- 根因：字模只收**自有提示**用到的 151 个汉字（「不」在库内）；用户数据
  （镜像名/卷标/路径/机型/分区根文件名）里的任意汉字没有字形。
  虚拟机只验自有文案，撞不到这个坑。
- 主修法：**救援屏不渲染用户中文**。镜像屏只给类型/大小/盘符设备，完整文件名只落
  日志；失败屏（`image not found`）、分区根列表、wimlib 输出、`~new` 残留列表
  一律走占位符，原文进日志。
- 兜底：`say()` 映射后逐字符判覆盖（`zj_has_unmapped`，PUA 之外的非 ASCII 前导
  字节即"无字形"）→ 整行压 ASCII，连续库外串换成一个 **`.`**（绝不是问号/豆腐块）；
  日志记 `screen: omitted N unmapped char(s); raw: …`。
- 可校验：`gen-rescue-font.py --check` 增加 `check_dynamic_samples`（真机样例
  `C:\images\不忘初心\win10.wim`），并静态要求 `zjlog.sh` 占位符为 `.`；
  `SAY_RE` 扩到 `say2`。回归 `tests/test_say_wrap.sh` 11 例全绿。
- `FONT: loaded … / FAILED rc=N reason=…` 仍打屏并进日志（降为防御性可观测）。

### 2. 启动菜单名与提示文案统一（PIT-239）

- 旧 `SysRecovery Environment` / 「SysRecover」全部改为 **`NineRestore`**（标题、BCD 描述、
  提示、状态栏、Tooltip、`en.lang`）；旧条目按同 GUID 刷新，不并存两份。
- BIOS 提示补上进入方式：**开机时连续按 ↑/↓ 进入选单**（原来只说"在启动菜单选"）。
- 救援层自身文案（首行标题、`AUTO-RECOVER`、恢复菜单、上次任务未确认）里的
  「SysRecover」一并改为 **NineRestore**；`boot hand-back` 提示不再写死 ESP（MBR 机器也适用）。
- 升级自愈：`RefreshBootLayerNames()` 在启动时只重写小文本（menu.lst 标题/内核参数 +
  BCD 描述），没装过则完全不写盘。

### 3. 不再改写用户启动等待时间（PIT-240）

- 删除 `ops_staged.cpp` 里把 `{bootmgr} timeout` 补成 1 秒的整段逻辑；0 或缺失都保持原样。

### 4. 清除启动菜单时清理 `~new`（PIT-241）

- 新增 `CleanupMenuStaging()`：只删带 `.zj-done` / `.zj-undo-phase` /
  `.zj-universal-failed` 标记的 `~new`；无标记保留并弹窗告知；`~old` 永不触碰。
- 接在"清除菜单"和"删除旧系统自删"两条路径上。

### 5. 压掉进救援前的内核噪声（PIT-242）

- BIOS `menu.lst` / UEFI `grub.cfg` 内核行加 `quiet loglevel=3`（保留 `nvme_core.io_timeout=1`）；
  `say_dmesg` 改为只进日志。用户第一眼看到的是我们的 `SR:` 行，不是内核行。

### 6. 还原后自动重建启动载荷与菜单（PIT-243）

- 现象：还原替换 C: 后 `ZJRESTORE\`、`grldr`、`grldr.mbr` 与 BCD 条目全被镜像覆盖，
  连续两次开机**静默回落 Windows**，用户进不了救援且无提示。
- 这是整盘替换的必然结果（设计如此），因此做三层处置：
  1. **擦盘/交换前**把载荷收进 RAM（含 RAM 余量检查，空间不足则明确告警）；
  2. 还原成功、boot 文件补齐后**写回新系统根**（`ZJRESTORE` + `grldr/mbr/menu.lst`）；
  3. BCD 条目 Linux 改不了 → 落 `<系统盘>\ZJRESTORE\menu-redeploy.txt`
     （`bcd=pending`）；Windows 侧启动时 `EnsureMenuAfterRestore()` 重装，
     成功改 `bcd=done`、失败保留 pending 并写日志（下次启动重试）。
- 完成页新增 `MENU:` 行（payload-ok / no-payload / WARN 三态），不再静默。
- **已知限制**：若新系统里没有九转还原（或不在数据盘），BCD 条目需用户打开程序点
  「安装到启动」一次；完成页 WARN 行已写明。

### 7. 图标替换

- `resources/SysRecover.ico`（120,230 B，SHA256 `5335ffc8…44d8`）替换为重新绘制版：
  16/24/32/48/64/128/256 七帧齐全，小尺寸下"9"轮廓更清晰；`icon-source.ico` 同步。

### 8. 真机已确认通过（不动）

- MBR/BIOS 双盘：U 盘勾选后出现、取消后消失；分区列表完整；扫描后安装与解压后安装均正常。
- GPT 转换后 UEFI 装菜单、检查后安装、解压后安装均成功；ThinkPad 热键 `F12 / Fn+F12` 正确。

## 1.0 beta.13（2026-11-08，内部 `1.0.0.13`）

> 测试版（Beta）。beta.12 的清点屏**渲染已通过**（每行 72–76 列、续行全带 `SR: `），
> 本版只修测试台顺带看到的**两处内容错误**：设备路径拼前缀、空值占位。
> **渲染层（`zjlog.sh` / `say` / 折行 / 进度）一行未动**，避免把已通过的项打回去。
> 不提交 git、不做 GitHub 推送准备。

### 1. 设备路径统一归一化，杜绝 `/dev/dev/sdb1`（PIT-237）

- 现象（beta.12 清点屏）：`PROBE` 行出现 `/dev/dev/sdb1` —— 设备名已带 `/dev/` 前缀，
  某处又拼了一次。
- 排查结论（如实记录）：**beta.12 源码与包内 initramfs 对 `/dev/dev` 均为 0 命中**，
  现有 `list_parts` 都是 `basename` 后拼 `/dev/`，当前形态下无法复现该字面量。
  但它属于典型的"上游已传完整路径、下游又加前缀"的错误，只要允许两种形态混用就会复发。
- 处置：新增单点归一化 `zj_dev()` / `zj_devname()`（`bootfiles/alpine/init` 与
  `bootfiles/zjrestore-lite.sh` 各一份，规则相同）：
  - **对外一律用完整路径 `/dev/<name>`**；拼 `/sys/class/block/*` 一律用裸名。
  - 裸名、`/dev/sda1`、误拼的 `/dev/dev/sda1` 三种输入都归一到 `/dev/sda1`。
  - 所有原先手拼 `"/dev/$x"` 的位置改为走归一化：init 的 `list_parts`（3 处）、
    `mnt_dev` 入口、`dev_offset_sectors`、sysfs `size`；lite 的 `list_parts`（3 处）、
    `mnt_dev` 入口、`dev_size`、`bb_part_removable`、`dev_offset`（含 `_disk`）、
    `TARGET_DEV` 读入。`/proc/partitions` 兜底仍在 awk 里拼（第 4 列必为裸名）。
  - 回归：`tests/test_dev_path.sh` 断言两个脚本不再手拼、且三种输入归一正确。

### 2. 清点屏空值显式化，不留 `?` 与空白

- `off=?` 根因（已复现）：`blkid -s PART_ENTRY_OFFSET -o value` 在部分 **vfat/MBR
  分区上返回空**（beta.12 演练日志 `PROBE … off=?` 可复现）。不是变量名拼错。
  - 改法：**sysfs `start`×512 为主来源**（GPT/MBR/EBR 逻辑盘全准），blkid 仅作后备
    并换算成字节（与契约 `target_part_offset` 同单位）。
  - 都拿不到时输出 `off=n/a(no-sysfs-start,no-blkid-offset)`。
- `root=` 空白：挂载点为空目录时输出 `root=n/a(empty-dir)`，有内容仍输出 `root=[…]`。
- 同类空值一并显式化：
  - `size=n/a(no-sysfs-size)`、`fs=n/a(no-signature)`、`err=n/a(no-stderr)`。
  - `dmi:` 任一字段读不到 → `n/a(no-sysfs-value)`（不再出现 `dmi:  |  |  | bios` 空白）。
  - `cmdline:`、`nvme dmesg: n/a(no-nvme-pcie-lines)`、`block devs: n/a(no-block-devices)`、
    `partitions: n/a(no-partitions)`、控制器 `n/a(no-storage-usb-controllers)` /
    PCI ID `n/a(no-pci-ids)`。
  - 两个救援脚本里所有 `${x:-?}` / `unknown` 占位替换为 `n/a(原因)`：
    `found log` 的 size、身份不符的 serial/guid、`target_by_offset` 的 size/want、
    `bb_mount` 的 fs、reparse 的 size/rc/entries、`TARGET_FS`、apply fs、
    `RESULT` 的 rc/STEP。

### 3. 门禁与实测

- **渲染层未改动**：`bootfiles/zjlog.sh`、`say`、`zj_fold`、进度渲染在本版零 diff。
- 新增 `tests/test_dev_path.sh`（**4 例**，进 `make check`）：归一化函数静态存在性、
  `list_parts` 已归一、无 `${x:-?}`、无字面 `dev=/dev/`、三形态归一实测、空值文案完整。
- `make check` 全绿（含 shell C8、`test_say_wrap` 7 例、`test_dev_path` 4 例）。
- QEMU（beta.13 initramfs，重建演练盘）：
  - swap 完整还原 **PASS**（13 项）；日志 `rescue build 1.0.0.13`。
  - 清点屏 `PROBE` 全为完整路径：`dev=/dev/sda1`、`/dev/sda2`、`/dev/sda3`、`/dev/sr0`；
    **0 处 `/dev/dev`**。
  - `off=` 实测 `1048576` / `105906176` / `822706176`；`sr0`（整盘/无分区）输出
    `off=n/a(no-sysfs-start,no-blkid-offset)`、`fs=n/a(no-signature)`、`err=no-filesystem`。
  - `root=[…]` 全部有内容；`dmi:` 的 QEMU 空 board_name 显示 `n/a(no-sysfs-value)`。
  - SR 前缀行最大 **76 列、0 行超 76**，续行仍带 `SR: `（渲染未回退）。
- 四点版本一致 `1.0.0.13`；包 **41,855,809 B** /
  `58A4C416A4FBE839E018185E12E666E84CF60A171DD7DFE3ADA31953E13B9245`；
  initramfs **17,424,728 B** /
  `6AB92D79D13692C06317168B3C096A8FE5C273995E55B35B703B8909A94166C5`；
  包内 `zjfont.psf` 10,014 B / `93A51D67…DFA8E1424` 未变；载荷 74 项；`check-dist: PASS`。
- 历史包 beta.1–beta.12 未改动。测试台将用 beta.13 复验第 6/7/8 项。

## 1.0 beta.12（2026-11-08，内部 `1.0.0.12`）

> 测试版（Beta）。本版 = beta.11 的两件（**进度单行原地刷新**、**求助邮箱
> `ms_w@qq.com`**）+ 测试台批次 1 报的**长行硬折行**修复。不提交 git、不做
> GitHub 推送准备，直接真机验证。

### 1. 屏幕行宽统一 ≤76 列，续行带前缀（PIT-236）

- 现象（beta.10 清点屏）：`partitions:` / `block devs:` 正常，但 `dmi:`、
  `PROBE … root=[...]` 等长行在 80 列终端硬折成 2–3 行，**续行没有 `SR: ` 前缀、
  从第 0 列起排**，左边缘错乱。
- 根因：与 PIT-234 同类——行宽超过终端列数，靠终端自动折行；续行不会继承前缀。
- 改法（单点收口，不只治一屏）：`say` 输出前统一压到 **76 列**（与进度条同口径）。
  - 纯 ASCII 行超宽时按词/字段边界折行（空格、`,`、`|`、`/`、`;`、`=`），
    **每条续行重复 `<PREFIX>: `**；找不到分隔符才硬切。
  - 覆盖 `partitions:`、`block devs:`、`dmi:`、`PROBE`、分区/卷标列表、
    镜像路径、日志路径等所有走 `say` 的拼接行。
  - 静态行不额外加 `\n`：只把一条超宽行拆成多条带前缀的行，不刷屏。
- 日志完整：`say` 仍把**原始整行**写入 `$LOG` / probe 文件，屏幕压缩不丢原文；
  折行只发生在控制台分支。
- 中文：中文行不参与 ASCII 折行（构建期 C8 门禁保证字面量 ≤78 列，实测最宽 63）。
  **如实说明残留边界**：运行期"中文 + 超长 ASCII 字段"混拼的行，busybox 无法按
  显示列宽稳定切分，仍可能超宽；清点屏等实际长行均为 ASCII，已被覆盖。
- 回归门禁：新增 `tests/test_say_wrap.sh`（**7 例**，已进 `make check`）——
  PROBE 长行、block devs 多盘多分区、无分隔符长 token、短行不变、日志原文保留、
  中文行不拆、口径 76 静态断言；断言每行 ≤76 且每条续行有前缀。
  运行期拼串本身无法静态扫描，这一点用测试断言渲染函数来兜。

### 2. beta.11 两件（随本版一起发）

- 进度单行原地刷新（PIT-234）：屏幕一行 `ZJ: [####…] NN% apply`、76 列内 `\r`
  覆写；原始行与每级进日志；串口/非 tty/重定向降级每 10% 一行。
- 求助邮箱 `ms_2@qq.com` → `ms_w@qq.com`；`grep ms_2@qq.com` 0 命中；字模未变
  （10,014 B / `93A51D67…DFA8E1424`，`--check` 36 条 / 151 汉字 / 397-512 / 最宽 63 列）。

### 3. 门禁与包

- `make check` 全绿（含新 `test_say_wrap`，摘要见 `docs/34` §20）。
- 实测（QEMU，beta.12 initramfs）：
  - swap 完整还原 **PASS**（13 项）；两段串口日志里 ASCII 前缀行共 **121 + 53 行**，
    **最大 76 列、0 行超 76**；`PROBE … root=[EFI,…]` 折行后每行都带 `SR: `。
  - 块引擎清点屏日志 **369 行** ASCII 前缀行，**最大 76 列、0 行超 76**；
    `dmi:` 60 列、`partitions:` 55 列、`block devs:` 39 列（VM 单盘；多盘多分区
    形态由 `test_say_wrap` ② 覆盖）。
- 四点版本一致 `1.0.0.12`；包 **41,852,918 B** /
  `1FE021FE1EEC34033B579E4835B0C533A39C74026A0555C191F5ABDD558105CA`；
  initramfs **17,422,143 B** /
  `D98CA26D3E137E7DD3EC41361454944D31AADB240E6DCD9D0094A2085B3E56C2`；
  包内 `zjfont.psf` 10,014 B / `93A51D67…DFA8E1424` 与仓库逐字节一致；载荷 74 项。
- 历史包 beta.1–beta.11 未改动。

## 1.0 beta.11（2026-11-08，内部 `1.0.0.11`）

> 测试版（Beta）。本批两件事：**救援层进度改单行原地刷新**（PIT-234）、
> **求助邮箱更正 `ms_2@qq.com` → `ms_w@qq.com`**。进度行/诊断行仍为英文（用户确认不做
> 第二批中文化）。按用户要求**本版不提交 git、不做 GitHub 推送准备**，直接出包真机验证。

### 1. 进度改为单行原地刷新（PIT-234）

- 根因（真机 VM 复现）：旧 `wim_progress` 把 wimlib 原始行（如
  `Extracting file data: 12.3 MiB of 129.4 MiB (9%) done`）整段拼在 `ZJ: [####----] 9%`
  后面，实测样例 **83 列** > 80 → 控制台折行；`\r` 只能回到折行后的最后一行行首，
  于是每个百分比各占一行往下滚。行尾不清空 → 还会留残影。
- 改法：屏幕只渲染**一行** `ZJ: [####…] NN% <stage>`，补空格到 **76 列**后 `\r` 覆写；
  百分比、进度条、阶段名都在这一行内更新。原始 wimlib 行进 `/tmp/apply.out`，
  每个百分比进 `/tmp/apply.progress.log` 与 `$LOG`（日志不被覆写吃掉）；结束时补一个
  换行，**留一行最终结果**，无半行/残影。
- 降级（注释已写明条件）：仅当 stderr 是 tty **且** `/sys/class/tty/console/active`
  为本地 VT（`tty0`…）才原地刷新；串口（`ttyS*`/`ttyUSB*`）、非 tty、active 为空
  → **每 10% 一行**稀疏打印，不刷屏。QEMU `-nographic` 走的就是这条降级路径。
- 验证（2026-11-08）：
  - 真实 awk 实测（直接抽脚本里的 awk 程序）：101 级输入 → 原地模式 **101 个 `\r`、
    3 个换行（2 个头行 + 1 个结尾行，中间无新增）**、最大行宽 **76**；降级模式
    **10 行**（10%…100%）。
  - 日志完整性：101 个百分比 **101 行、0..100 无缺级**。
  - QEMU swap 完整还原（`run-swap-drill.ps1`）：**13 项检查全部 PASS**（含 `-u` 无 rc=2
    中断），无残留半行。
  - QEMU 块引擎大镜像（120 MiB）：wimlib 原始进度 **129 行** → 进度日志 **129 行**
    （1:1，101 个不同百分比，无丢级）；串口屏 **10 行**（降级符合预期）。
- 顺带修（演练暴露，非产品行为变更）：兜底日志窝选盘（`pick_bb_home_devs`）用到的
  `dev_size` 定义晚于 `zz-blackbox` 分支 → `dev_size: not found`，函数移到前面
  （PIT-235）；`mk-drill.py` 的契约改放 `ZJRESTORE/restore-task.conf`（真机落点），
  否则 init 的可信度规则会把它当 stale copy 拒掉、swap 演练退化成 no-task。

### 2. 求助邮箱更正

- `ms_2@qq.com` → **`ms_w@qq.com`**（下划线后是字母 `w`），QQ 群 `1128237828` 不变。
- 覆盖：救援层 `bootfiles/alpine/init`（1）、`lang/en.lang` 中英键值（4）、
  `tools/i18n-en.py`（4）、GUI `src/gui/main_form_notice.cpp`（2）、
  `README.md` / `README.en.md`（各 1）、`docs/33`（3）、`docs/34` / `docs/35` /
  `docs/HANDOVER.md`（1/1/2）、`temp` 内旧快照（12）；`dist/lang/en.lang` 重建后 4。
- 自查：`grep -rn "ms_2@qq.com"` **0 命中**；`ms_w@qq.com` 仓库 **32 处** + dist **4 处**。
- 字模：`w` 是 ASCII（0x77），`gen-rescue-font.py --check` 复跑仍
  **36 条中文提示 / 151 汉字 / 397-512 字形 / 最宽 63 列**，`zjfont.psf` 哈希未变。

### 3. 门禁与包

- `make check` 全绿（摘要见 `docs/34` §19）。
- 四点版本一致 `1.0.0.11`：`dist/bootfiles/rescue-build.txt` / `dist/version.json` /
  initramfs 内 `zjrescue-version` / exe 资源；文件名 `九转大还原1.0-beta.11.exe`。
- 包 **41,850,929 B** / `0ECE0EE396D3AA3252719B0909484905AE1CC908CA14B2DA40F6D1A6F791527C`；
  initramfs **17,420,963 B** / `A4A0CF8A50A7B34BCFEC2385B33C1DA48CD62948FF9FB7658708B5D9C7A586E3`；
  initramfs 内 `zjfont.psf` 10,014 B / `93A51D67…DFA8E1424` 与仓库逐字节一致；
  载荷 74 项；历史包 beta.1–beta.10 未改动。
- VM 逐项复验清单见 `docs/35` §L。

## 1.0 beta.10（2026-11-08，内部 `1.0.0.10`）

> 测试版（Beta）。本批**只含救援层中文化/字模**（提交 `1021d83`，父提交为 beta.9 的
> `2c38ad9`），不掺功能改动。beta.9 的救援界面已中文化，但字模由 freetype + 本机
> SimSun 取模：别人复现不出同样字节、SimSun 也无随产品分发许可；本版定源
> GNU Unifont 18.0.01（SIL OFL 1.1）。

### 1. 字模定源：GNU Unifont 18.0.01（SIL OFL 1.1）

- 生成器去掉 freetype/SimSun 依赖，改为纯 `.hex` 点阵解析；`--from-unifont` 导出子集
  （95 ASCII + 151 汉字，文件头记上游内容 SHA-256），`--check`/`--verify` 逐字节复现（PIT-233）。
- `bootfiles/zjfont.psf` **10,014 B** / `93A51D67E1A9188BCB84E36D053C176276FA8ED5A46D89A5DDFE7D5DFA8E1424`；
  `bootfiles/zjzhmap.sed` 内容未变。
- 151 个汉字中 **149 个与 beta.9 逐像素相同**（"回"/"失"两字有差异）；ASCII 换为 Unifont 外观。
- 既有约束不变：PSF1-512 / 8×16、汉字左右切半 + PUA 双码位拼 16×16、ASCII 锁 0x20..0x7E、
  单行 ≤78 列（`check-shell.py` C8）。

### 2. 许可与文档口径

- `THIRD_PARTY_LICENSES.txt` 补齐 Unifont 五项（名称与版本 / 上游 URL / 内容 SHA-256 /
  OFL-1.1 全文 / 修改声明）；`docs/06` 的字源门禁转为**已通过**。
- `docs/03`、`docs/04`、`docs/25`（PIT-061 尾注、PIT-222 口径）、`docs/33` 的"屏幕只能
  ASCII"表述同步改为"可含中文 + 字模覆盖 + 无全角标点 + ≤78 列"（PIT-233）。

### 3. 已知未完成（本版不动，先说明再出包）

- `zjrestore-lite.sh` 的 apply/执行进度/诊断行仍为**英文**；交互屏（首屏、回滚/失败菜单、
  确认、求助）已为中文。属下一版范围，不阻塞本版。
- 当前无超过 78 列的 `say` 文案（C8 全部通过）；新增中文提示仍须先补字模。

### 4. 门禁与包

- `make check` 全绿（摘要见 `docs/34` §18）。
- 四点版本一致 `1.0.0.10`：`dist/bootfiles/rescue-build.txt` / `dist/version.json` /
  initramfs 内 `zjrescue-version` / exe 资源；文件名 `九转大还原1.0-beta.10.exe`。
- 包 41,847,963 B / `B75D160C6F602A86A69E0151EBED993CC51FF601D3951BAC2471C47B4F68991E`；
  initramfs 17,419,427 B / `FCA37139E4598841388CFCFBC60402318942934D6F8FB56D6EA7DBFCA950F846`；
  initramfs 内 `zjfont.psf` 与仓库源文件逐字节一致；载荷 74 项，无运行产物。
- 历史包 beta.1–beta.9 未改动。VM 逐屏复验项见 `docs/35` §K。

## 1.0 beta.9（2026-11-08，内部 `1.0.0.9`）

> 测试版（Beta）。beta.8 复验 A2/A3/A4 通过、A1 失败、A5 缺条件；本版修 A1 的结构性
> 问题，清掉语言文件里的 F10 字面量，并补一条"运行产物不许进包"的门禁。

### 1. "两处回执"在现有结构下不可能发生（高，A1）

- 现场：returnold 后软件目录 `F:\ZJ8\logs\ZJRESTORE-status.txt` 有，兜底
  `D:\ZJRESTORE-logs\` 完全不存在，救援日志也没有 `fallback log home` 行。
- 根因：`claim_bb_home` 一旦 `find_soft_dir` 成功就 `return 0`，`BB_HOME` 恒为空；
  `write_success_receipt` 因此只能写软件目录一处 —— 与 beta.8 修的问题 1 互补后可见，
  两处回执从来没有同时存在过。
- 修复：`claim_bb_home` 在软件目录可用时**继续**认领兜底窝（规则仍走
  `pick_bb_home_devs`，A2 小盘排除、A3 落点稳定性不变）；抽 `bb_home_claim_on()`
  便于回归，只有**同卷同路径**才显式去重并记
  `fallback log home: skipped (same volume+path as software dir: …)`。
  没有第二个可用卷时退到软件目录同卷、不同路径的 `ZJRESTORE-logs`，仍写两处。
  日志新增 `fallback log home: … (separate volume/same volume…)` 与
  `receipt: …` 两行；只写一处会报 `WARN: status receipt N/2 written`。
- 回归：`tests/test_dual_receipt.sh` 6 条（双卷、同卷不同路径、同卷同路径去重、
  软件目录缺失、两处写入静态断言、不再提前 return）。

### 2. `lang/en.lang` 残留 F10 字面量（低）

- 虚拟机分支运行时不引用该串，但英文词典里仍有 `F10`，属"有人又把键写死"的隐患。
- 修复：热键串改为运行时占位 `%ls`（`swprintf` 填 `BootMenuKeyHint()`），
  中英文同步；`check-i18n` 新增 **C6**——UI 文案出现 `F10` 直接失败。

### 3. 打包卫生：运行产物混进交付目录（中）

- 现场：beta.8 解包目录里有 08:36 的陈旧 `restore-task.conf`。
- 核查：beta.8 载荷清单逐条 74 项，**没有** `restore-task.conf`；该文件来自
  `%LOCALAPPDATA%\SysRecover\app` 上一次运行残留（解包只覆盖同名条目，不清理目录）。
  同时 `dist\x64\logs`（11-04 的 `ZJRESTORE-status.txt`）确实会被打进包。
- 修复：新增 `tools/check-pack-hygiene.py`（`restore-task.conf/json`、`_zjresy*.log`、
  `ZJRESTORE-*.txt/log`、`pending-restore.txt`、任意层级 `logs/`、`*.tmp`、`*.dmp`）：
  `make package` 结束前 `--clean`；`portable-pack.py` 打包前扫描，命中即
  `REFUSE`；`check-dist.py` 复用同一规则。单文件换版本解包时清掉 AppDir 里的
  旧运行产物（`logs\` 是用户日志，不动）。
- 回归：`tests/test_pack_hygiene.sh` 6 条。

### 4. 门禁与包

- `make check` 全绿（含新增 `test_dual_receipt` 6 + `test_pack_hygiene` 6）。
- 版本三元 `1.0.0.9` / `1.0 beta.9` / `九转大还原1.0-beta.9.exe`；历史包 beta.1–beta.8 未动。

## 1.0 beta.8（2026-11-08，内部 `1.0.0.8`）

> 测试版（Beta）。beta.7 的 4 项复验全通过；本版处理测试台提的两条"用户会碰到"的
> 体验/一致性问题，并改 VMware 虚拟机的进固件提示。

### 1. returnold 的 software_dir 在目标卷上，软件目录回执必然写不到（中）

- 根因：`ops_returnold.cpp` 只判 `fixedDisk` 就把 `software_dir` 设成 `exeDir`；
  程序放在目标盘（最常见的 C:）时，该目录随还原/回退消失（apply 会格式化，
  returnold 的 `L5` 会把根下所有条目搬进 `~new` 再删除），救援层 `softscan`
  又只扫非目标卷 → 两条 `dir=no`，两处回执只有兜底窝一处生效。
- 修复：与 `ops_staged` 同规则——程序在目标盘时 `software_dir` 落到
  `<数据盘>\ZJRESTORE`，救援层能按非目标卷找到，回执两处都真实生效。
  找不到数据盘（单盘整盘为目标）时保留 `exeDir` 兜底并记
  `software dir unusable for logs (on target/removable)`。
- 评估过"换盘前只读挂目标卷解析软件目录"：**不采用**。目录解析得出来也活不过
  交换（`L5` 整树搬家后 `L7` 删除），只读挂载只是多一次挂/卸（NTFS 脏卷还可能
  RO 挂失败），收益为零、风险非零。理由写入 `docs/25` PIT-227。

### 2. 兜底日志窝落点不稳定（中）

- 根因：`claim_bb_home` / 晚到兜底原来按 `list_parts` **设备枚举顺序**抓第一个能挂
  的分区：1.0.0.7 同版本先后落到 `C:\ZJRESTORE-logs`、2GB 小盘、Data 卷。
- 修复：新增 `pick_bb_home_devs()`，规则固定且与枚举顺序无关：
  跳过目标/循环/内存/光驱/软驱/已挂载 → **容量 < 2GiB 不认领** → **内置优先于
  可移动**（`/sys/class/block/<disk>/removable`）→ 容量降序 → 设备名升序。
  结论 = "内置盘中最大的可用分区"；`claim_bb_home` 与晚到 `bb_home_drop` 共用。
  Windows 侧收集器本来就遍历 C..Z（`CollectDeployArtifacts`），不依赖固定盘符。
- 新增 `tests/test_log_home_rule.sh`（7 条，已进 `make check`）：内置优先、容量降序、
  同容量设备名升序、跳过目标、拒绝 2GB 小盘、两处共用、staged/returnold 同规则。

### 3. VMware 虚拟机进固件的提示（体验）

- `common/bioskey` 新增 `IsVmwareGuest()` / `LooksLikeVmware()`（只读注册表
  `HARDWARE\DESCRIPTION\System\BIOS` 的 SMBIOS 标识，含 "VMWARE" 即判定；纯函数有单测）。
- VMware 客户机没有"开机按键窗口"：所有 UEFI 分支的"开机按 <热键>"改为
  "关机，然后用「电源 → 打开电源时进入固件」选 SysRecover"：
  `main_form_bootmenu.cpp` 的已安装悬浮提示、安装确认、安装完成状态，
  以及 `main_form_notice.cpp` 的"还原菜单未执行"正确操作与失败兜底两句。
- 非 VMware 保持原有动态热键（`BootMenuKeyHint()`，不写死 F10/F12）。
- 中英文同步：`tools/i18n-en.py` 新增 5 条，`lang/en.lang` 由 `i18n-wrap.py --gen-lang`
  重新生成。

## 1.0 beta.7（2026-11-08，内部 `1.0.0.7`）

> 测试版（Beta）。修 beta.6 复验未过的 2 项（P1-b 陈旧契约 / P3a returnold 回执），
> 其余 5 项保持通过。

### 1. P1-b（高）陈旧契约被当成"有任务"

- 根因：救援层兜底搜索 `find "$ZJ_M" -maxdepth 4 -name restore-task.conf | head -1`
  只看**第一个命中**，不看来历。测试台留 `~old`（无暂存任务）时，先抓到
  `~old\restore-task.conf`、后抓到 `Program Files\SysRecover\logs\restore-task.conf`，
  根目录确认无 conf 仍被抓 → `_ran=1` → 无人值守 120s 自动选 `[2]`（应为 `[3]`）。
- 修复：新增 `conf_is_credible()`，候选逐个过可信度，只认"写者会写的位置"：
  - 目录里有 `SysRecover.exe` / `SysRecoverUI.exe`（程序目录），或目录名就是
    `ZJRESTORE`（exeDir 不可写时的备用写点）；
  - `action` 必须是 `restore` / `returnold`，且带 `target_offset` 或 `target_guid`；
  - 明确排除 `~old` / `~new` 交换残留与 `logs` 日志归档子目录；
  - 有主契约 `_zjresy*.log` 时，再核对 `target_offset`/`target_guid` 一致。
  搜索循环改为"收集候选 → 逐个过滤 → 第一个可信才 `cp`"；全部不可信时明确
  `ignored N conf candidate(s)`，不再静默拿陈旧副本当任务。
- 其它分支核查：`scan_for_log` 只在分区根匹配 `_zjresy*.log`（不递归），主契约 conf
  就在同一日志分区根；`~new` / `zjswap.sh` / `zjswap-undo.sh` 均把契约文件排除在
  交换外。无同类漏洞。
- 新增 `tests/test_conf_credible.sh`（12 条，已进 `make check`）：`~old`/`~new`/`logs`
  拒绝、程序目录/`ZJRESTORE` 接受、无锚点/非法 action/缺目标身份/身份不一致拒绝、
  以及"禁止退回 `head -1`"的静态断言。

### 2. P3a（中）returnold 成功无回执

- 根因：`zjrestore-lite.sh` 置 `RESULT=OK; STEP=done` 后只 `persist_log` 就 `exit 0`；
  EXIT trap 的 OK 分支只写软件目录 + ESP。BIOS 机器没有 ESP、软件目录又可能因挂载点
  变化写不到 → 状态只活在内存里；`init` 又因 `/tmp/zj-bb-final` 存在跳过兜底 →
  C:/D:/F: 根都没有 `ZJRESTORE-status.txt`。
- 修复：新增 `write_success_receipt()`（软件目录 `logs\` + 兜底窝 `ZJRESTORE-logs\`，
  两处都失败才 `WARN`），apply 成功与 returnold 成功共用同一 helper；returnold 成功后
  依次 `persist_log` → `write_success_receipt` → `bb_esp_drop` → `sync` → `exit 0`。
  `result=OK` / `step=done` 可被外部读到。
- 新增 `tests/test_success_receipt.sh`（5 条，已进 `make check`）：两处直写点、仅兜底窝、
  全失败 `WARN`、静态断言 returnold 成功块调用 helper、apply/returnold 共用同一实现。

## 1.0 beta.6（2026-11-08，内部 `1.0.0.6`）

> 测试版（Beta）。修测试台实测的 4 个缺陷（P1 无人值守死循环优先），并把打包/共享
> 改成"复制 + 原子替换"，保证历史版本不可变。

### 1. P1（高）「返回旧系统」无人值守死循环

- 根因：救援首屏「上次任务未确认完成」三选一在 `read` 超时后**自动选 [1]**（回滚）；
  回滚分支还要人工输大写 `YES` → 无人值守再次超时 → "未确认，返回菜单" → 重印菜单
  → 又自动 [1]，无限循环。已暂存的 `action=returnold` 反而被这个守卫挡在菜单外。
- 修复：
  - 读到 `restore-task.conf` 的 `action=returnold` 时 triage **直接放行**，沿既定动作继续；
  - 无人值守绝不自动选 [1]：有可续任务 → [2]，无任务 → [3]；
  - 人工选 [1] 但 `YES` 连续两次未确认 → 明确放弃（继续暂存任务或重启），不再循环；
  - `reboot_now` 两次 `reboot -f` 仍未生效 → 关机/停机并留结论，不返回菜单。
- 新增 `tests/test_rescue_triage.sh`（4 条，已进 `make check`）：抽取 `triage_previous()`
  本体 + stub 磁盘，钉住"returnold 放行 / 自动不选 [1] / 只重启一次 / YES 超时收场"。
- 行为变化：无人值守从"死循环"变为"沿暂存动作继续或重启一次"；有人值守路径不变。

### 2. P2（中）救援控制台中文不显示

- 根因：initramfs 没有 CJK 控制台字库，`say` 里的中文只剩方块/问号；首屏实测只剩
  `[1][2][3]`。
- 处置：**不塞字库**（ESP 寸土寸金，控制台字体链路也只在部分固件可靠），改为
  **屏幕消息纯 ASCII**（中文只留在 `.sh` 注释与落盘日志）。首屏、回滚确认、重启兜底、
  求助渠道全部改成可读英文。
- 新门禁 `check-shell.py` C8：救援脚本 `say "..."` 里出现 CJK 直接失败。

### 3. P3（中）状态文件与实际结果不一致

- 3a `returnold` 成功后 `ZJRESTORE-status.txt` 仍写 `result=FAILED/step=interrupted`：
  救援脚本 EXIT trap 已写好 `OK/done`，init 又因 `/tmp/zj-bb.done` 为空做了一次
  `zz-blackbox interrupted` 全盘扫，把状态覆盖。修复：脚本收尾写 `/tmp/zj-bb-final`
  （`RESULT != UNKNOWN` 才写），init 只在该标记不存在时兜底；每轮开跑前清标记。
- 3b `rmdir err=145` 记 `fail=1` 但界面报成功：`~old` 里只剩 `.zj-keepold` 时 rmdir
  必然 145；检查标记用的扩展路径多了一个反斜杠（`\\.zj-keepold`），标记删不掉 →
  计数留下；随后补删成功、目录消失，计数没有回落。修复路径并新增纯函数
  `NormalizeDeleteFail(fail, dirStillThere)`：目录消失 → `fail=0`，目录仍在 → `fail>=1`；
  单测 `swapleft_fail_counter_matches_disk`（5 条断言）。

### 4. P4（低，复核为合理约束）程序在目标分区上被拒

- 结论：**保留拒绝**。返回旧系统会把目标分区整棵新系统树（含程序所在目录）改名到
  `~new` 后丢弃；继续执行会把用户唯一的入口悄悄删掉。程序已先自动尝试 `SettleHome`
  复制到其他分区，失败才拒绝。
- 改动只在提示：写清"为什么会被拒 + 自动复制失败原因（`sr.detail`）"，并给出两条
  可行路径（复制到别的分区 / 从 U 盘或 PE 运行）。

### 5. 打包/共享：复制而非硬链接，历史版本不可变

- 根因：测试台把 `share\b3.exe` 做成指向 `dist\SysRecover-Portable.exe` 的硬链接；
  打包 `pack-self` 直接原地写同一输出文件 → 同一 inode 被截断重写，共享端旧版本
  （`1.0.0.3`）一起被改掉。
- 修复：`tools/portable-pack.py` 改为"打包到临时名 → `os.replace` 原子替换"，发布
  复制也走临时名 + 原子替换；绝不在已存在的输出上原地重写。同版本号撞名仍拒绝。
- 已把 `share\b3.exe` 用 `D:\九转大还原1.0-beta.3.exe` 重新复制还原（先断链再复制）。

### 门禁

`make check` 全绿：unit **109 cases / 753 checks**（新增 1 case / 5 checks）、
`test_version` 18、check-docs / i18n / widths / shell（含 C8）/ config / layers /
foreground / secrets / versioninfo、boot-region 17/0、zjswap A–D、
**test_rescue_triage 4 条**。x64 / x86 编译零告警。

## 1.0 beta.5（2026-11-08，内部 `1.0.0.5`）

> 测试版（Beta）。相对 beta.4 只做**代码质量三项**，产品行为不变：拆过大源文件、
> 统一错误语义（部分成功必须显式）、自有代码告警清零。

### 1. 过大源文件按职责拆分（纯搬移，行为不变）

| 原文件 | 拆分后 |
|---|---|
| `src/gui/main_form.cpp` 3616 行 | 8 个单元：窗口/消息泵、提示与事件路由、启动菜单、工具入口、分区与镜像、还原、备份、UI 状态（273–805 行/个） |
| `src/app/selfdiag.cpp` 1668 行 | `selfdiag.cpp`（诊断报告/采集）+ `selfdiag_cleanup.cpp`（菜单回执/散落日志清理/部署痕迹/EA 扫描） |
| `src/app/ops_staged.cpp` 2056 行 | `ops_staged.cpp`（暂存还原阶段）+ `ops_staged_menu.cpp`（菜单绑定契约/陈旧任务清理/一键重试） |
| `src/boot/uefi.cpp` 1638 行 | **不拆**：单一域，载荷部署集中在 `InstallUefiBootEntry` 内部，硬切只会扩大失败面（1.0 稳定优先） |

- 跨 TU 共用的 4 个小工具（`FormatGb` / `TimestampName` / `TimestampDate` / `StageCn`）
  改为 `CMainForm` 私有静态成员；其余单文件工具留在各自分段，不引入新的公共头。
- 门禁工具同步：`check-widths.py` 改为扫全部 `main_form*.cpp`（否则拆分后覆盖检查会静默变弱），
  `i18n-wrap.py` 白名单补 7 个新文件。

### 2. 错误语义：部分成功必须是显式状态

- `WimEngine::Capture` / `Append` 在 `skipFileErrors=true` 下跳过不可读文件后**不再返回 0**
  （0.9.x 会让脚本 `&&` 与"只看 rc"的调用方把不完整备份当完全成功），改为显式
  `kWimPartialSkipped = 1001`：镜像照常可用、非致命、不与 wimlib 错误码重叠。
- `RunBackup` 据此放行主镜像；ESP / EA 子镜像里的文件被跳过时不再把整个备份判失败，
  统一进 `skippedList` → GUI「备份不完整」弹窗、CLI 退出码 7（显式 `--allow-skipped` 才归 0）。
- 失败回滚逐处核对：`ops_preserve`（部分搬迁先回滚再失败）、`ops_returnold` / `ops_staged`
  （契约回滚守卫）、`ops_backup`（ESP 失败有意不回滚主镜像，注释已注明 A 方案语义）——
  未发现"失败仍返回成功且不留痕迹"的路径。
- 新增单测 `wim_partial_skipped_is_explicit_nonzero`，钉住"部分成功非零、且不与对外退出码撞车"。

### 3. 告警：自有代码全部 `-Werror`

- 核实所有自研编译规则（app / cli / gui / launcher / bootfiles / 单测 / 便携包 stub）均带
  `-Wall -Wextra -Werror`；第三方 duilib 保持 `-w`，GUI 的 `-fpermissive` 只放宽 duilib 头解析，
  已在 Makefile 注明"不抑制告警、自研代码仍告警即失败"。
- x64 / x86 两条链编译零告警。

### 门禁

`make check` 全绿：unit **108 cases / 748 checks**（新增 1 case / 5 checks）、`test_version` 18、
check-docs / i18n / widths / shell / config / layers / foreground / secrets / versioninfo、
boot-region 17/0、zjswap A–D。

## 1.0 beta.4（2026-11-08，内部 `1.0.0.4`）

> 测试版（Beta）。相对 beta.3 的改动**只在测试台脚本与文档**，产品代码零改动；
> 出包是为了让"发布号 → 包"一一对应（同号不覆盖）。

### 测试台 `mc.bat`：从"静默退出"改成"会明确失败"

- **问题**：guest 里跑 `mc.bat`，窗口一片空白、几十秒不动，看着像卡死。查清是三件事叠加：
  ① `@echo off` + 每行输出都重定向进 `C:\mc.txt`，控制台按设计就没有任何输出（实测 0 字节）；
  ② 上传用 `-InFile 'C:\mc.txt'`，读的正是 cmd 用 `>>` 占着写句柄的同一个文件 →
     `being used by another process`（连跑 5 次 5/5 命中），外面套裸 `catch{}`，失败被吞、退出码仍 0；
  ③ `Invoke-WebRequest` 没有 `-TimeoutSec`，收集端不可达时每次固定卡 21 秒（实测），四个调用就 84 秒黑窗。
- **修复**：`mc.bat` 收进仓库（`tools/vmtest/mc.bat`，原来只在测试台 share 里，改坏了没人发现）：
  控制台打进度；上传前先 `copy` 出快照再传（结构上避开共享冲突）；每个上传 `-TimeoutSec 10`；
  失败写 `PUT-FAIL: <label> : <原因>` 并 `exit 1`；轮次标签必填（缺则 `exit /b 2`）；
  退出码 0 全成功 / 1 有步骤失败 / 2 参数错误；`wmic` 缺失降级为 WARN（Win11 24H2 已移除）。
  文件保持纯 ASCII（UTF-8 中文 `rem` 行在代码页不匹配时会被 cmd 当成命令执行，实测）。
- 详见 `docs/25-PIT坑位册.md` PIT-218、`docs/34-发布门禁总表.md` §12。

## 1.0 beta.3（2026-11-07，内部 `1.0.0.3`）

> 测试版（Beta）。相对 beta.2 的核心改动：**Linux 救援侧 PBR 判据收紧到与 Windows 侧等价**。

### BIOS/MBR：保留原 NTFS 时不再"扇区 1 非零即完好"

- **问题**：`zjrestore-lite.sh` 在 `KEPT_FS=1`（保留原 NTFS）分支只看分区**扇区 1 是否有任意非零字节**，
  命中就报 `boot region kept intact`。即使 `0x54` 处的代码指纹已被写坏，仍会被判成完好
  → 屏幕"修好了"、实际起不来。
- **新判据（与 Windows 侧 `EnsureNtfsBootRegion` 等价）**：
  1. 分区 offset `0x54` 的 4 字节必须等于 `FA 33 C0 8E`（主判据）；
  2. 扇区 1 起续段非全零（保留，降级为辅助条件）；
  3. 任一不满足 → 用内置 `ntfs-boot-code.bin`（426 B @ `0x54`）+ `ntfs-boot-cont.bin`（4096 B @ 扇区 1）
     重写，并按现有逻辑同步卷末尾备份引导扇区。
- **日志三态**（不再出现含糊的 `kept intact` 单独成句）：
  `boot region ok (0x54=fa33c08e)` / `boot region rewritten` / `ERROR: boot region rewrite failed (0x54=...)`。
- **实现**：抽出纯 shell 函数 `zj_repair_boot_region <dev> <code> <cont> <total_sectors>`，
  由 `tests/test_boot_region.sh`（17 检查）覆盖：判据命中跳过且字节不变、`0x54` 错误重写、
  续段全零重写、缺内置 blob 时报错返回 1、给出总扇区数时末尾备份扇区同步、脚本内不得再出现 `kept intact`。
- 写入路径的 `dd` 去掉 `2>/dev/null`（B 类不消音），探测性读取保留（A 类），
  见 `docs/25-PIT坑位册.md` PIT-217。
- 救援载荷按 `1.0.0.3` 重新构建（`bootfiles/initramfs-zjrestore.cpio.gz` 17,408,065 B，
  内戳 `rescue build stamp: 1.0.0.3`），`version.json` / `rescue-build.txt` / initramfs 内戳三元一致。

## 1.0 beta.2（2026-11-07，内部 `1.0.0.2`）

> 测试版（Beta）。相对 beta.1 的核心改动：**ESP 救援载荷不再备份**。

### ESP 载荷：无备份、先删后写、失败摘启动项

- **取消写前备份**：不再把旧载荷整目录复制到 `EFI\ZJRESTORE\backup-<stamp>\`
  （每份约 17.4MB，ESP 寸土寸金）。旧固件本身即待替换对象，没有保留价值。
- **顺序固定**：检测（版本戳 + 文件大小快路径，不一致才深查 CRC）→ **删除旧载荷** →
  写入新载荷 → 校验字节数与 CRC32 → 进入启动/安装流程。
  先删旧再写新，避免 ESP 剩余空间不足以同时容纳两份载荷。
- **写失败 fail-closed**：旧载荷已删时写新失败，提示「救援载荷写入失败，请重试或更换介质。」，
  并**摘掉指向残骸的 UEFI 启动项**（不留 `Boot####` 让人撞）。纯逻辑单测
  `rescue_payload_deploy_order_is_delete_then_write` / `rescue_write_failure_removes_entry_after_old_payload_deleted` 锁定。
- **清理历史遗留备份**：启动时扫描 `EFI\ZJRESTORE\backup-*`，删除并记日志
  （`legacy payload backup removed: <name> (x.x MB)` / `cleanup freed x.x MB`），只删本程序创建的前缀，
  不碰用户文件、不碰 Secure Boot 文件、不删当前在用载荷。
- NVRAM 侧小文本（`Boot<num>.pre.bak`、`bootorder.pre.bak`、`firmware-boot.txt`）保留不动。
- **旧说法作废**：beta.1 记录里的「写前备份 `backup-pre-rewrite-<stamp>` 并被保护不被 stale 清理」
  是已废弃行为，对应单测 `rescue_backup_dir_survives_stale_cleanup` 已删除/重定义。

### 版本命名

- 第三位 = 正式版之后的修 bug 号（beta 期间固定 0）；beta 号在**第四段**；
  文件名 `九转大还原1.0-beta.N.exe`（不带空格），同版本不覆盖旧包；
  新增 `make release` 一步出包（递增 beta → 双架构构建 → 打包 → SHA256）。

## 1.0 beta.1（2026-11-06；旧写法 `1.0.0-beta.1`，内部 `1.0.0.1`）

> **这是测试版（Beta），不是正式版。** 二进制未做代码签名，也未在实机上跑通完整备份/还原闭环；
> 面向真实磁盘使用前请先在不重要的机器或虚拟机上验证。内部版本串 `1.0.0-beta.1`，
> 界面显示名「1.0.0 测试版」（英文界面显示 `1.0.0 Beta`）。

基线：SysRecover **0.9.96**（commit `8401cdab`）。本版是「九转还原」工程化重构 + P0/P1 整改，
不改变产品定位与磁盘格式（镜像仍是 WIM/ESD，加密镜像仍是 ZJENC1）。

### 未发布修正（2026-11-07，N17 实测）

- **ESP 写前备份目录被 stale 清理误删**（`src/boot/uefi.cpp` `InstallUefiBootEntry`）：
  旧载荷重写时刚建好的 `backup-pre-rewrite-<时间戳>` 被"定点清 stale"判为非本次文件集而删除
  （日志 `stale dir removed: backup-pre-rewrite-…`），备份形同虚设。现在 `backup-*` 不参与
  stale 清理，且只保留**最新一份**（更早的备份仍清理，避免多份 ~17MB 载荷塞满 ESP）；
  纯逻辑抽到 `rescue_guard.h::IsRescueBackupDirName` / `NewestRescueBackupName`，
  单测 `rescue_backup_dir_survives_stale_cleanup` 锁定。
- 0.9.93 旧载荷 → 新版接管实测记录、客户"扫描后安装"失败链条，见
  `docs/34-发布门禁总表.md` C.4。

### 未发布修正（2026-11-07，装菜单→重启→救援全链路实测）

- **图标**：改用用户定稿的 `NineRestore_小尺寸增强.ico`（16/24 小尺寸增强帧），
  覆盖 `resources/SysRecover.ico`，GUI/CLI/检查器/便携壳统一随构建嵌入；
  `ProductName` 仍为「九转还原」，未改品牌文案。
- **实测结论（写入门禁表 C.4 §7）**：`fb21851` 之后重造 0.9.93 旧载荷现场，再走
  「安装到启动 → 扫描后安装」：日志判 stale → 重写，`backup-pre-rewrite-20261107-205701` 落盘且
  **不再被 stale 清理**；ESP initramfs 17,407,298 B、SHA256 与 `bootfiles/` 一致。
  同一轮重启进救援（VMware UEFI，`bootsequence` 免热键）：
  `entry-started.txt` = `entry=menu` / `build=1.0.0-beta.1`，
  `ZJRESTORE-status.txt` = `result=OK` / `step=done` / `entry=menu` / `build=1.0.0-beta.1`。
- **未判定**：首启三选一（N20）的屏幕行为本轮未取证（还原后系统来自 ESD、无 VMware Tools，
  无法截图送键），见 C.4 §8。

### 数据安全（P0）

- **H1 暂存交换 fail-closed**：`zjswap.sh` 任一 `move` 失败即非零退出（退出码 4），
  回滚已搬走的旧项、保留 `~new`、不留 `~old`、新树不泄漏到根；交换后校验新树关键文件（缺 `winload` → 5，保留现场）。
- **H2 引导修复降级**：救援层修引导失败不再报 `result=OK`，改为 `result=OK_BOOT_UNFIXED`；
  Windows 侧判定抽成纯函数 `RescueStatusIsOk`，`OK_BOOT_UNFIXED` / `FAILED` / 带前缀一律不当成功，并加单测。
- **H3 旧系统保留失败回滚**：`PreserveOldSystem` 部分移动失败时先回滚再返回失败，不再留下"半旧系统"。
- **H4 校验契约**：格式化目标分区前强制执行**毫秒级快速结构预检**；全量校验改为显式入口
  （GUI 勾选 / CLI `--verify-image`，默认关），跳过时在日志与结果页写明"镜像未校验"；
  旧系统兜底保留在 `~old`，可回退。
- **H5 空间与残留**（原"临时文件替换"建议经复核撤回）：追加前按"临时文件≈镜像大小"做空间预检；
  写入失败后清理本轮残留临时文件，不采用 `.bak` 双份替换。
- **H6 救援侧启动项清理**：按 marker 精确删除 `Boot####`，从 `bootorder.bak` 恢复 BootOrder，
  全部成功才删除标记（失败保留标记等下次重试）。
- **H7 单实例锁**：暂存还原入口改用 RAII 操作锁，移镜像、解压、格式化、写引导全部纳入锁内，
  避免并发实例互踩。
- **H8 救援层缺字段 fail-closed**：`zjrestore-lite.sh` 缺 `image_index` 不再默认 1；
  只有 `_zjresy*.log`、没有 `restore-task.conf` 时不再"接着跑"；`target_offset` /
  `target_size` / `pt_type` / `repair_boot` / `keep_old` 缺一即失败
  （`STEP=no-image-index` / `no-contract` / `contract-incomplete`）。
  **语义变更**：契约不全时由「静默推测默认值继续」改为「显式失败、不碰目标分区」
  （黑匣子模式除外：它只收集日志、不执行写入）。

### 备份 / 还原可靠性（P1）

- **M1 子镜像配对**：ESP / ZJEA 子镜像按"大于系统索引的最近一个"配对，遇到下一个系统镜像即停止，
  不再把别的系统镜像错配上。
- **M2 / M3 / M4 keep 模式与清理范围**：keep 模式清空不完整 → 在任何写入前中止
  （`result=FAILED` + `step=wipe-incomplete`）；目标卷挂不上 → `wipe-not-mountable`，不回退去格式化；
  引导文件清理只删带本工具特征（`$ZJRDIR` / `grldr.mbr` 含 `ZJRESTORE`）的文件；
  ESP 优先同盘，无法判断时仅接受唯一候选，否则拒绝。
- **M5 救援层身份校验**：候选目标盘同时校验磁盘序列号与分区 GUID（来自 `restore-task.conf`），
  不匹配则跳过并报错，降低挑错盘风险。
- **M6 镜像不静默覆盖**：搬移/落盘不再用 `MOVEFILE_REPLACE_EXISTING`；同名文件自动改名 `name_1.wim`。
- **M7 备份前预检**：FAT32 单文件 4GB 上限与目标空间预检，不足时以 `ADV_SPACE` 明确失败。
- **M8 格式化可靠性**：先探测 `diskpart` 可用性，缺失时回退到内置流程；脚本改为按卷选择，
  失败返回明确错误码。
- **M9 长路径**：清单声明 `longPathAware`，`DeleteTreeRec` 等全程使用 `\\?\` 长路径前缀（幂等，支持 UNC）。
- **M10 加密备份明文清扫**：持单实例锁后清理上次崩溃遗留的 `dest.plain.tmp` / `.stage` 文件。
- **M11 备份完整性退出码**：有文件读不到时 CLI 返回 **7**（备份不完整）；显式 `--allow-skipped` 才归 0。
- **M12 磁盘枚举**：默认仍隐藏 USB；USB 固定盘可用菜单「显示 USB 设备（谨慎选择）」显式打开，
  列表标注"（USB 设备）"；磁盘上限 16→128；`ERROR_MORE_DATA` 时倍增 extent 缓冲重试（上限 64）。
- **M13 提权工作目录**：UAC 提权后保留调用方工作目录，相对路径参数不再失效。
- **M14 契约/日志写读**：改 `std::string` 拼接，去掉 8192 截断风险；写后回读校验
  `contract_version` / `keep_old` / `target_guid` / `target_disk_serial`。
- **M15 ESP 暂存失败**：加密镜像的 ESP 子镜像暂存失败时返回错误码 5，不再只告警继续。

### 修正（L 系列）

- **L1**：12 处把翻译串当 `snprintf` 格式串的写法改为固定格式串 + 数值单独格式化；
  门禁新增"译文占位符必须与键一致"检查。
- **L4**：修正 `SysRecover.manifest` 注释与实现不一致。
- **L5**：UEFI 启动项删除改为"描述 + 设备路径"双条件匹配，避免误删同名条目；
  写 NVRAM（`WriteVar` / `DeleteVar` / `BootNext`）失败时返回非零，不再假装清理成功。
- **L6**：wimlib 线程上限 8，避免高核数机器在 PE 下峰值内存过高；实际线程数写入日志。
- **L7**：删除 `formatTarget` 分支内恒为 false 的 `oldPreserved` 回滚死代码。
- **L3**：`ops.cpp`（4705 行单体）已拆为 13 个 `ops_*.cpp`（阶段 2，函数集合 67/67 一致，行为不变）。

### 界面 / 版本呈现（beta.1 新增）

- 「**异机还原**」改为还原模式第三步的常驻勾选框（原「使用异机还原」藏在下拉菜单里）；
  「**打包日志**」移到「更多功能>>」菜单第一项（原为常驻按钮）。控件声明顺序与视觉从左到右
  一致，Tab 焦点不走样；菜单命令用常量 id，不依赖索引。
- 英文文案同步：`异机还原=Universal`、`打包日志=Package log`、新增 `测试版=Beta`；
  删除 4 个随改动失效的旧键（`使用异机还原` / `已关闭异机还原` / `已启用异机还原（…）` / `异机`）。
- **「重启进/出安全模式」保留为「一次性 + 可恢复」**（2026-11-06 修正误删）：该入口在
  「打包日志」完成后的结果框里，不是独立功能页。选择后先提示 BitLocker 恢复密钥与双系统
  `{current}` 可能指向另一系统；设置 safeboot 前会武装「下一次登录自动清除」，武装失败即
  拒绝设置（宁可不进，也不把机器锁在安全模式）；启动时若发现 safeboot 仍被置位，会提示并
  可一键退出并重启。此语义正常，不应被描述为「删除安全模式功能」。
- 版本显示名由 `src/gui/ui_skin.cpp::VersionDisplay()` 从 `version.h` 派生：
  `1.0.0-beta.N` → 「1.0.0 测试版」，`1.0.0-rc.N` → 「1.0.0 RC」，正式版原样；不另写第二份数字。
- **Windows VERSIONINFO**：`tools/gen-versioninfo.py` 从 `version.h` 生成 `.rc`（公司名/版权
  集中在 `SYSRECOVER_COMPANY` / `SYSRECOVER_COPYRIGHT` 两个宏），按架构用自己的 `windres`
  编译并链接。GUI/CLI/Check、三个启动器、`zj-ea-apply`、`zj-restore-boot`、两个单文件 stub
  全部带资源；单文件先给 stub 加资源、再追加载荷，所以外层 exe 在「属性 → 详细信息」里
  直接能看到 `九转还原` / `1.0.0-beta.1` / `DreamGrain` / MIT 版权。
- `make check` 与 `make dist-check` 都加了 PowerShell 断言（`(Get-Item exe).VersionInfo`
  必须与 `version.h` 同值），缺资源或不一致直接失败。
- `tools/version.py` / `tools/check-docs.py` 支持 SemVer 预发布后缀；`bump()` 会把
  `1.0.0-beta.1` 提升到 `1.0.1`（丢弃后缀）。

### 工程 / 发布

- **L2**：CI 增加 x86 32 位单测与冒烟、修正 x86 产物路径；新增 release job：
  双工具链 `package` → `sha256` → `dist-check`，上传完整 `dist`（含 `SHA256SUMS.txt`）。
- `make check` 现为 **80 用例 / 636 断言**，含 H1 交换回归（`tests/test_zjswap.sh`）、
  回执判定、WIM 结构预检等纯逻辑测试。
- 双架构构建（GCC 14.2.0 MinGW-w64 x64/x86）与全部门禁（docs/i18n/宽度/shell/config/layers/secrets）通过。

### 文档

- 新增 `docs/ARCHITECTURE.md`（拆分表、模块边界、构建与门禁实操）。
- 新增 `docs/BUILD-REPORT.md`（阶段 1~4 实测证据；含 H1 "改前失败 / 改后通过"）。
- `docs/07-测试矩阵与回归记录.md` 增补 1.0 回归项（追加中途失败、keep 清空不完整中止）。
- 新增 `docs/33-已知问题与限制（1.0）.md`。

## 版本策略（1.0，2026-11-07 定稿）

完整规则见 `docs/37-版本命名规范.md`。摘要：

| 阶段 | 文件名 | 界面显示 | 内部四段 |
|---|---|---|---|
| 测试版 | `九转大还原1.0-beta.N.exe` | `1.0 beta.N` | `1.0.0.N` |
| 正式版 | `九转大还原1.0.0.exe` | `1.0.0` | `1.0.0.0` |
| 正式版之后 | `九转大还原1.0.1.exe` 起 | `1.0.1` | `1.0.1.0` |

- 主/次版本由人指定；第三位只用于**正式版之后**的修 bug 递增（beta 期间固定 0）；
  beta 号在**第四段**，每发一版 +1，正式版归零。
- 文件名不带空格；beta 只是渠道标记，不进数字段。
- 同版本号不覆盖旧包（`tools/portable-pack.py` 存在即拒绝），`make release` 一步出包。
- 衔接：`0.9.96 → 1.0 beta.1`；已打出的旧包 `D:\九转大还原1.0.0-beta.1.exe` 记为
  `1.0 beta.1`，只规范文件名，不重新构建（其内部版本资源串仍是旧写法 `1.0.0-beta.1`）。
- **已知副作用**：正式版四段 `1.0.0.0` 小于最后一个 beta（如 `1.0.0.8`），属性页看似"变旧"；
  仅影响观感，产品无自动更新，版本判定按文件名与渠道字段，不靠数字大小。
- 跨层契约版本单独计（`SYSRECOVER_CONTRACT_VERSION`），只有改字段才递增。
- 发布物：`dist/` 目录版 + `dist/SHA256SUMS.txt`；单文件版由 `make portable` 生成并发布到 `D:\`。
- **签名顺序约束**：若以后做代码签名，必须**先打包、再签名** —— 单文件是"stub + 追加载荷"，
  签名之后再往 PE 末尾追加数据会让签名失效。
