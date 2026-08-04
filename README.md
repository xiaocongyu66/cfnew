# CFnew - 终端 v2.9.9

**语言:** [中文](README.md) | [فارسی](فارسی.md)

[Telegram 交流群](https://t.me/+ft-zI76oovgwNmRh)

## 主要功能

- 多协议支持：VLESS、Trojan、xhttp，可以同时启用多个
- 自定义路径：不用UUID当路径了，可以自己设置，支持多级路径
- 延迟测试：内置测试工具，测IP延迟，自动获取机场码
- 订阅转换：可以自定义转换服务地址
- 图形化管理：用KV存配置，改完立即生效，不用重新部署
- API管理：支持通过API动态添加/删除优选IP
- 多客户端：支持 CLASH、SURGE、SING-BOX、LOON、QUANTUMULT X、V2RAY、Shadowrocket、STASH、NEKORAY、V2RAYNG
- 应用唤醒：点按钮自动打开对应客户端
- 自动识别：根据User-Agent自动返回对应格式
- 多语言：支持中文和波斯语，根据浏览器语言自动切换

## v2.9.9 更新

- 出站代理支持 HTTP / HTTPS：`s` 变量按前缀区分协议，不写前缀仍是 SOCKS5，老配置不受影响
  - `http://user:pass@host:port` 明文连代理后建立隧道
  - `https://user:pass@host:port` 连代理这一跳走 TLS
  - 认证走 Basic，由 Worker 自动生成；`http` / `https` 可省略端口，默认 80 / 443
  - 节点 path 里的 `s=` 写法一致
- 出站方式改为三选一（`qj`），并把语义正过来
  - 留空：优先走代理（与旧版默认行为一致）
  - `no`：优先直连，失败再走代理（与旧版 `qj=no` 一致）
  - `only`：**只走代理，连不上直接断开**，不回落直连或备用地址，避免出口 IP 泄漏
  - 面板标签由「降级控制」改为「出站方式」，选项文案重写
- 详见「[出站代理](#出站代理)」

## v2.9.8c 更新

- 订阅转换内部实现：Clash / Stash / Sing-box / Surge / Loon / Quantumult X 配置全部由 Worker 直接生成，不再依赖任何外部 sub-converter
  - 完整规则集：Clash 使用 Loyalsoldier `rule-providers`；Sing-box 使用 MetaCubeX SRS；Surge / Loon / QuanX 使用 ACL4SSR / blackmatrix7 远端规则
  - 各策略分组均包含「策略组 + 全部节点」，可直接切换具体节点；多节点时提供「自动测速」url-test 组
  - 不再按 Worker 地区优先筛选或排序，订阅保留所有来源节点；Clash/Mihomo 与 sing-box 额外提供 GPT、Google、X/Twitter、xAI 站点可用性测速组
  - 修复 Clash IPv6 节点 `server` 被解析为数组、代理组 `🎯 全球直连` ↔ `🚀 节点选择` 循环引用等问题
- 传输优化：参考 GrainTCP 思路优化 WebSocket/TCP 转发，上行小包队列合并、下行小包聚合、大包直发，并优化 VLESS 解析热路径
- 节点测速：Clash/Mihomo 与 sing-box 订阅默认生成「自动测速」组，客户端会选择延迟较低的节点
- 传输参数可调：可通过 KV 配置 `packetUp`、`packetDown`、`packetQueue`、`packetTail`、`packetDelay`、`connectRace`、`firstByteTimeout`，数值会自动限制在安全范围
- 协议边界：当前 Worker 支持 VLESS、Trojan、xhttp；不支持 Hysteria2（hy2 需要 QUIC/UDP 服务端，Cloudflare Worker 的 `cloudflare:sockets` 只能建立 TCP/TLS 出站连接）
- 图形化 ALPN：新增 `alpn` 下拉选项，留空时不写 `alpn`，也可选择 `h3`、`h2`、`http/1.1` 或组合值
- 节点别名简化：域名统一为 `优选域名-序号`，IPv6 统一为 `IPv6优选-序号`，IPv4 使用 `isp-colo-序号`
- KV 配置缓存：30s 短窗口 + 跨 isolate 版本键 `c_ver`，保存后无需刷新两次
- SOCKS5 降级超时：直连 3.5s 无数据自动走 fallback
- 标签：「启用 GitHub 默认优选」改为「启用自定义优选」
- 页面特效开关：`FX: ON / OFF`，选择 localStorage 持久化
- 提供混淆版本 `少年你相信光吗`，逻辑与 `明文源吗` 完全一致

## v2.9.7 更新

- 悬浮保存按钮：右下角常驻「保存全部」按钮，支持 `Ctrl+S` / `Cmd+S` 快捷键
  - 编辑任意字段后按钮自动进入「未保存」提示状态
  - 保存中 / 刷新中有进度反馈
- 通知体验优化：所有阻塞式弹窗替换为右上角浮动消息，自动消失、可悬停暂停、支持手动关闭
  - 4 种语义：success / info / warn / error
- 操作按钮整合：将分散在各区块的 4 个保存按钮合并为统一的悬浮操作组
- 提供混淆版本 `少年你相信光吗`，逻辑与 `明文源吗` 完全一致

## v2.9.6 更新

- 兼容 Xray-core v26.3.27
- 新增香港 (HK) ProxyIP 备用地址
- KV 读取性能优化：5 小时内存缓存，减少 99% 以上的 KV 读取量
- 无效请求拦截：非法路径直接返回 404，不再触发 KV 读取
- 修复优选列表保存时 SOCKS5 配置 key 错误的问题

## v2.9.5 更新

- GitHub 默认优选地址默认关闭，需自行配置优选IP来源URL
- 新增「启用原生地址」开关，可在管理面板中控制是否生成原生地址节点（默认关闭）
- 兼容日期设置为 `2026-01-20`

## v2.9.4 更新

- 支持客户端通过 WebSocket path 参数覆盖连接级变量（`p`、`s`）
  - 无需为每个节点单独部署 Worker，在分享链接的 path 里直接写参数即可
  - 优先级：path 参数 > KV/环境变量全局配置
  - 详见下方「[客户端 path 参数](#客户端-path-参数)」说明

## v2.9.3 更新

- 新增图形化自定义DNS和ECH域名功能
  - 可在界面中自定义DNS服务器地址（DoH格式）
  - 可在界面中自定义ECH域名
  - 支持动态更改，保存后立即生效
  - Clash配置中的ech-opts增加query-server-name参数，与v2ray保持一致

## v2.9.2 更新

- 修复 Clash 配置生成问题

## v2.9.1 更新

- ECH支持：新增 Encrypted Client Hello (ECH) 功能
  - 每次刷新订阅时自动获取最新的 ECH 配置
  - 启用 ECH 时自动启用"仅 TLS"模式，避免 80 端口干扰
  - 图形界面可一键开启/关闭 ECH 功能


## v2.9 更新

- 地区筛选：可以按地区筛选优选结果，支持多选
- 延迟筛选：新增"只显示最快的10个"选项
- 追加/替换模式：添加优选结果时可以追加或替换整个列表
- 结果展示优化：显示地区标签，按延迟排序
- 其他细节优化

---

### 相关工具

- 优选工具：https://github.com/byJoey/yx-tools/releases
- 文字教程：https://joeyblog.net/yuanchuang/1146.html
- Workers视频教程：https://www.youtube.com/watch?v=aYzTr8FafN4
- Pages视频教程：https://www.youtube.com/watch?v=JhVxJChDL-E
- Snippets视频教程：https://www.youtube.com/watch?v=xeFeH3Akcu8

### 部署

订阅每15分钟自动优选一次

#### Pages 打包

`.github/workflows/obfuscate.yml` 会在源码变更后自动生成混淆版 `_worker.js` 和 `Pages.zip`。`Pages.zip` 只包含部署文件，不包含 UUID、D1/KV 配置或环境变量；提交完成后可直接下载仓库中的压缩包上传到 Cloudflare Pages。

#### 基础配置
| 变量名 | 值 | 说明 |
| :--- | :--- | :--- |
| `u` | 你的 UUID | 必需，用于访问订阅和配置界面 |
| `p` | proxyip | 可选，自定义ProxyIP地址和端口，支持 IPv4/IPv6/域名。也可在节点 path 里单独指定 |
| `s` | 出站代理地址 | 可选。支持 SOCKS5 和 HTTP/HTTPS 代理，见下方「[出站代理](#出站代理)」。也可在节点 path 里单独指定 |
| `d` | 自定义路径 | 可选，如 `/mypath` 或 `/path/to/sub`，不填用UUID路径。路径没 `/` 开头会自动补上 |

#### 协议配置

| 变量名 | 值 | 说明 |
| :--- | :--- | :--- |
| `ev` | yes/no | 可选，启用VLESS（默认启用） |
| `et` | yes/no | 可选，启用Trojan（默认禁用） |
| `ex` | yes/no | 可选，启用xhttp（默认禁用） |
| `tp` | 自定义密码 | 可选，Trojan密码，留空用UUID |
| `ech` | yes/no | 可选，启用ECH功能（默认禁用） |
| `alpn` | ALPN列表 | 可选，TLS节点ALPN参数。留空不写，由客户端协商；可选 `h3`、`h2`、`http/1.1`、`h3,h2`、`h2,http/1.1`、`h3,h2,http/1.1` |

#### 图形化配置（推荐）

1. 在Workers中创建KV命名空间，绑定环境变量 `C`
2. 部署后访问 `/admin` 登录管理面板
3. 在「传输调节」页修改包大小、队列、竞速和超时参数
4. 改完配置立即生效，不用重新部署

#### 高级控制
| 变量名 | 值 | 说明 |
| :--- | :--- | :--- |
| `yx` | 自定义优选IP/域名 | 可选，支持命名，格式：`1.1.1.1:443#香港节点,8.8.8.8:53#Google DNS` |
| `yxURL` | 优选IP来源URL | 可选，自定义IP列表来源，留空用默认 |
| `scu` | 订阅转换地址 | 可选，默认：`https://url.v1.mk/sub` |
| `epd` | yes/no | 可选，启用优选域名（默认启用） |
| `epi` | yes/no | 可选，启用优选IP（默认启用） |
| `egi` | yes/no | 可选，启用GitHub默认优选（默认启用） |
| `qj` | no / only | 可选，出站方式。留空=优先走代理，`no`=优先直连、失败再走代理，`only`=只走代理不回落。见「[出站代理](#出站代理)」 |
| `dkby` | yes | 可选，设为`yes`只生成TLS节点 |
| `ech` | yes/no | 可选，启用ECH功能（默认禁用，启用后自动开启仅TLS模式） |
| `alpn` | ALPN列表 | 可选，只写入TLS节点链接参数，留空则不写 |
| `yxby` | yes | 可选，设为`yes`关闭所有优选功能 |
| `ae` | yes | 可选，设为`yes`允许API管理（默认关闭） |

#### 传输速度参数（KV）

这些参数通过管理 API 保存到 KV 后立即生效，单位可写字节或 `K/KB/M/MB`：

| 参数 | 默认值 | 有效范围 | 作用 |
| :--- | ---: | ---: | :--- |
| `packetUp` | `32K` | `8K-128K` | 上行小包合并大小 |
| `packetDown` | `32K` | `8K-128K` | 下行聚合大小 |
| `packetQueue` | `512K` | `64K-2M` | 上行待发送队列上限 |
| `packetTail` | `512` | `128-4096` | 下行尾包阈值（字节） |
| `packetDelay` | `0` | `0-20` | 下行聚合等待时间（毫秒） |
| `connectRace` | `2` | `1-3` | 同一目标并发竞速连接数 |
| `firstByteTimeout` | `3500` | `1000-10000` | 首字节超时（毫秒），超时后触发回退 |

通常保持默认值即可；高带宽场景可适当增大 `packetUp`/`packetDown`，高延迟场景可保持 `connectRace=2`。

#### 节点可用性分类

订阅会展示所有来源节点，不再按 Worker 所在地区隐藏节点。Clash/Mihomo 和 sing-box 会在客户端本地为每个站点建立测速组：

- `✅ GPT 可用`：`https://chatgpt.com/`
- `✅ Google 可用`：`https://www.google.com/generate_204`
- `✅ X/Twitter 可用`：`https://x.com/`
- `✅ xAI 可用`：`https://x.ai/`

这些组由客户端从节点出口实际探测，能通过探测的节点会被自动选中；「🚀 节点选择」仍保留全部节点，方便手动检查。Worker 无法从边缘侧准确判断某个节点出口是否被 GPT、Google、X 或 xAI 封锁，因此不会在服务端武断标记「IP 好/脏」。

#### KV存储设置（推荐）

1. 在Cloudflare Workers中创建KV命名空间
2. 在Workers设置中绑定KV，变量名设为 `C`
3. 重新部署
4. 访问 `/admin` 登录后使用「传输调节」和 Key 管理

#### API使用
1. 下载优选软件：https://github.com/byJoey/yx-tools/releases
2. 开启API：访问 `/{UUID}` 或 `/{自定义路径}`，找到"允许API管理"，开启后保存
3. 添加单个IP：
```bash
# 使用UUID路径
curl -X POST "https://your-worker.workers.dev/{UUID}/api/preferred-ips" \
  -H "Content-Type: application/json" \
  -d '{"ip": "1.2.3.4", "port": 443, "name": "香港节点"}'

# 使用自定义路径（如果设置了d变量）
curl -X POST "https://your-worker.workers.dev/{自定义路径}/api/preferred-ips" \
  -H "Content-Type: application/json" \
  -d '{"ip": "1.2.3.4", "port": 443, "name": "香港节点"}'
```
4. 批量添加IP：
```bash
curl -X POST "https://your-worker.workers.dev/{UUID或自定义路径}/api/preferred-ips" \
  -H "Content-Type: application/json" \
  -d '[
    {"ip": "1.2.3.4", "port": 443, "name": "节点1"},
    {"ip": "5.6.7.8", "port": 8443, "name": "节点2"}
  ]'
```
5. 清空所有IP：
```bash
curl -X DELETE "https://your-worker.workers.dev/{UUID或自定义路径}/api/preferred-ips" \
  -H "Content-Type: application/json" \
  -d '{"all": true}'
```

### 功能说明

#### 延迟测试

v2.7开始提供，v2.9增强了筛选功能

- 内置测试工具，不用装其他软件，直接在配置页面测IP延迟
- IP来源：
  - 手动输入：直接输IP或域名，支持批量（逗号分隔）
  - CF随机IP：从Cloudflare IP段随机生成
  - URL获取：从远程URL获取IP列表
- 支持1-50线程并发测试，默认5线程
- 自动获取机场码（如SJC、LAX）
- 自动映射中文机场名（SJC→圣何塞）
- 自动扣除DNS+TLS握手时间，显示真实延迟
- 设置自动保存到浏览器
- 支持按地区筛选
- 支持只显示最快的10个
- 支持追加或替换模式

#### 多协议支持

- VLESS：默认启用
- Trojan：支持Trojan-WS-TLS，可以自定义密码，不填就用UUID
- xhttp：基于HTTP POST的伪装协议
- 可以同时启用多个协议，客户端会自动识别
- 图形界面一键开关
- 协议配置有独立保存按钮

#### ECH 功能 (Encrypted Client Hello)

- 支持 Encrypted Client Hello (ECH) 加密客户端握手
- 自动获取：每次刷新订阅时自动从 DoH 获取最新的 ECH 配置
- 优先使用 Google DNS，失败时自动尝试 Cloudflare DNS
- 智能模式：启用 ECH 时自动启用"仅 TLS"模式，避免 80 端口干扰
- 图形界面：可在协议配置区域一键开启/关闭
- 调试信息：在浏览器开发者工具的响应头中可查看详细的 ECH 获取过程
- 响应头信息：
  - `X-ECH-Status`: SUCCESS 或 FAILED
  - `X-ECH-Debug`: 详细的调试信息
  - `X-ECH-Config-Length`: ECH 配置长度（成功时）

#### 出站代理

`s` 变量用来指定出站代理，所有出站流量都会从它走。支持两类协议，靠前缀区分：

| 写法 | 走的协议 | 说明 |
| :--- | :--- | :--- |
| `host:port` | SOCKS5 | 不写前缀就是 SOCKS5，和以前一样 |
| `socks5://host:port` | SOCKS5 | 显式写法，等价于上面 |
| `http://host:port` | HTTP | 明文连代理，再发建隧请求 |
| `https://host:port` | HTTPS | 连代理这一跳走 TLS，适合代理本身要求加密的场景 |

带认证就在前面加 `用户名:密码@`：

```
user:pass@1.2.3.4:1080
socks5://user:pass@1.2.3.4:1080
http://user:pass@1.2.3.4:8080
https://user:pass@proxy.example.com:8443
```

说明几点：

- HTTP/HTTPS 代理的认证走 Basic，由 Worker 自动生成，不用自己拼。
- 只有 `http://` 和 `https://` 可以省略端口，分别默认 80 和 443；SOCKS5 必须写端口。
- 地址后面多写的路径会被忽略，`http://1.2.3.4:8080/xxx` 等同于 `http://1.2.3.4:8080`。
- 代理必须支持隧道转发（也就是能代理任意 TCP）。只能转发网页请求的代理用不了。
- 在节点 path 里单独指定时写法完全一样，如 `s=http://user:pass@host:8080`。

**出站方式（`qj`）**

配好 `s` 之后，用 `qj` 决定流量怎么走。面板里对应「出站方式」下拉框：

| `qj` | 行为 | 什么时候用 |
| :--- | :--- | :--- |
| 留空（默认） | 优先走代理，代理不通再回落 | 想走代理，但断了也别断网 |
| `no` | 优先直连，失败再走代理 | 只把代理当备用线路 |
| `only` | 只走代理，连不上直接断开 | 要求出口 IP 固定，不接受回落 |

`only` 和默认的区别在**失败时**：默认会回落到备用地址或直连，这时出口就变成 Worker
自己的 IP 了；`only` 宁可断开也不回落，出口 IP 不会漏。

没填 `s` 时三个选项都一样，都是直连。

#### 自定义路径（d变量）

- 可以使用自定义路径作为主订阅入口
- 支持多级路径，如 `/path/to/sub`
- 路径没 `/` 开头会自动补上
- 启用 D1 多 Key 后，各个已启用 UUID 仍可直接作为独立订阅入口
- 可以随时在图形界面改路径

#### 图形化配置

- 用Cloudflare KV存配置
- 访问 `/{你的UUID}` 或 `/{自定义路径}` 就能用
- 改完立即生效，不用重新部署
- 优先级：KV配置 > 环境变量 > 默认值

#### 多语言支持

- 根据浏览器语言自动选择中文或波斯语
- 右上角可以手动切换
- 语言选择会保存到浏览器
- 波斯语自动启用RTL布局

#### 订阅转换控制

- 可以自定义转换服务URL
- 可以单独控制优选域名、优选IP、GitHub优选
- 默认全部启用
- 改完立即生效

#### API管理

- 通过RESTful API管理优选IP，不用改代码
- 支持批量添加
- 支持清空所有IP
- 默认关闭，需要在图形界面开启
- API添加的IP和手动配置的yx变量会自动合并
- API端点：
  - `GET /{UUID或路径}/api/preferred-ips` - 查询列表
  - `POST /{UUID或路径}/api/preferred-ips` - 添加（单个/批量）
  - `DELETE /{UUID或路径}/api/preferred-ips` - 删除（单个/全部）

#### 客户端 path 参数

v2.9.4 新增。在 VLESS/Trojan 分享链接的 `path` 字段里追加查询参数，即可为**单个节点**单独指定连接级配置，无需额外部署 Worker。

| 参数 | 作用 | 示例 |
| :--- | :--- | :--- |
| `p` | 覆盖 ProxyIP（支持带端口） | `p=1.1.1.1` 或 `p=1.2.3.4:8443` |
| `s` | 覆盖出站代理 | `s=user:pass@host:1080`、`s=http://user:pass@host:8080` |

**优先级：path 参数 > KV/环境变量**

path 示例：
```
# 指定 ProxyIP
/?ed=2048&p=1.1.1.1
/?ed=2048&p=proxy.example.com:443
/?ed=2048&p=[2001:db8::1]:443

# 指定出站代理
/?ed=2048&s=user:pass@proxy.host:1080
/?ed=2048&s=http://user:pass@proxy.host:8080
```

> 不在上表中的变量（如 `ev`、`et`、`yx` 等）属于订阅生成级配置，在 WebSocket 握手阶段已过路由，放在 path 里无效，仍需在环境变量或 KV 中设置。

#### 优选节点命名

- 订阅别名默认使用短名称，不再追加端口、协议、TLS/WS 等信息
- 域名节点：`优选域名-01`、`优选域名-02`
- IPv6节点：`IPv6优选-01`、`IPv6优选-02`
- IPv4节点：优先使用 `isp-colo-序号`，缺少运营商信息时回退为 `IPv4优选-序号`

#### 系统状态

- 显示 Worker、ProxyIP 和节点可用性状态
- 订阅不再按地区筛选，所有来源节点都会保留

#### 高级控制

- `qj=no` 优先直连，失败再走代理；`qj=only` 只走代理，连不上直接断开
- `dkby=yes` 只生成TLS节点
- `ech=yes` 启用ECH功能（启用后自动开启仅TLS模式）
- `alpn=h3,h2` 指定TLS节点ALPN，留空则不写
- `yxby=yes` 关闭所有优选功能

#### 多客户端支持

支持10种客户端：CLASH、SURGE、SING-BOX、LOON、QUANTUMULT X、V2RAY、Shadowrocket、STASH、NEKORAY、V2RAYNG

- 根据客户端类型自动生成配置
- 图形界面一键生成订阅链接
- 点按钮自动打开对应客户端
- 根据User-Agent自动识别并返回对应格式
- 不同客户端自动适配最佳协议组合
- TLS 链接默认不写 `alpn`，可在图形界面或通过 `alpn` 配置指定

#### 性能优化

- 每15分钟自动优选一次
- 多重备用方案
- 智能缓存，减少重复计算

### 致谢

- 基于 [zizifn/edgetunnel](https://github.com/zizifn/edgetunnel) 修改
- ProxyIP部分来自 [cmliu](https://github.com/cmliu)
- 反代IP来自 [qwer-search](https://github.com/qwer-search)
- 在线优选接口来自 [白嫖哥](https://t.me/bestcfipas)


## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=byJoey/cfnew&type=Timeline)](https://www.star-history.com/#byJoey/cfnew&Timeline&LogScale)
