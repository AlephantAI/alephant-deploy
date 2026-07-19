# Alephant 项目独立部署文档


> 文档状态：持续整理中
>
> 本文档根据实际部署操作记录整理，命令、配置项和截图说明以现场操作结果为准。


## 1. 文档说明


### 1.1 适用范围


本文档用于记录 Alephant 项目的独立部署流程。


### 1.2 部署目标


指导完成 Alephant 独立部署操作流程，确保项目按照实施规范部署，避免关键步骤遗漏或顺序错乱，保障系统部署后的正常使用和用户体验。


### 1.3 部署环境


| 项目 | 内容 |
| --- | --- |
| 操作系统 | Linux（推荐 Ubuntu 22.04+ / Debian 12+）或 macOS |
| CPU | ≥ 4 核 |
| 内存 | ≥ 12 GB，满足 12 个服务合计运行需求 |
| 磁盘空间 | ≥ 50 GB 可用空间，包含业务镜像约 2 GB 及各中间件数据卷 |
| 网络 | 能够访问业务镜像下载地址和 Docker Hub |

网络访问要求：

- 中间件镜像来源：Docker Hub（`docker.io`）

### 1.4 部署依赖

| 依赖 | 版本要求 | 说明 |
| --- | --- | --- |
| Docker | `≥ 24.x` | 容器运行时，需包含 Compose plugin，支持 `docker compose` 命令 |
| `openssl` | 任意版本 | 用于生成随机密码和密钥 |
| `curl` 或 `wget` | 任意版本 | 用于从 S3 下载业务镜像 |
| `bash` | `≥ 4.x` | 用于运行部署脚本；macOS 需要通过 Homebrew 安装或升级 Bash |

## 2. 部署前准备

### 2.1 检查是否有 JWT 密钥文件

 检查是否有 JWT 密钥文件，供后续执行 `start-compose.sh` 时输入。如果没有请联系Alephant团队获取 (dev@alephant.io)

### 2.2 安装 Docker 并登录镜像仓库

在部署服务器上安装符合要求的 Docker 环境，并确认已包含 Compose plugin，可执行 `docker compose` 命令。

登录 Alephant 业务镜像仓库：
登录命令随jwt授权文件邮件下发，若遗漏请联系Alephant团队获取 (dev@alephant.io)

### 2.3 准备访问入口

确认80，81，82端口未被占用，若要修改端口请更新`compose/config/nginx/nginx.conf`

建议使用访问域名作为 Alephant 的外部访问入口，并根据实际域名配置前端、网关 和 日志地址。
测试阶段可以直接通过80，81，82端口访问
具体域名或端口应在部署前确定，并同步配置`compose/app.env`。

### 2.5 准备检查清单

- [ ] 已获取 JWT 密钥文件和 Alephant 业务镜像仓库登录命令
- [ ] 已安装 Docker，版本满足要求
- [ ] `docker compose` 命令可正常执行
- [ ] 已准备访问域名，或已规划三个外部访问端口

## 3. 独立部署流程

### 3.1 步骤 1：从 GitHub 拉取部署项目

#### 操作目的
获取 Alephant 项目的独立部署代码，为后续部署操作准备项目文件。

#### 操作内容

从 GitHub 拉取以下项目：

- 项目仓库：[AlephantAI/alephant-deploy](https://github.com/AlephantAI/alephant-deploy.git)
- 仓库地址：`https://github.com/AlephantAI/alephant-deploy.git`

实际执行命令和目标目录待确认。

```bash
# 待确认实际执行命令
# git clone https://github.com/AlephantAI/alephant-deploy.git <目标目录>
```

#### 注意事项

- 确认部署主机可以访问 GitHub。
- 如果部署使用指定分支或标签，需要记录对应的名称和版本。
- 需要确认项目实际拉取目录，后续命令将以该目录为基础。
  
#### 常见问题

- 若部署服务器无法链接GitHub，可在其他可下载电脑下载后复制到部署服务器

### 3.2 步骤 2：启动 Alephant 部署服务

#### 操作目的

进入 Alephant 部署项目目录，执行启动脚本，启动 Docker Compose 中配置的服务。

#### 操作内容

执行以下命令：

```bash
cd alephant-deploy
bash start-compose.sh
```

#### 操作结果

启动脚本执行后进入交互式配置流程，界面显示前置检查通过，并生成以下环境配置文件：

- `infra.env`
- `.env`
- `saas-service.env`
- `policy-service.env`
- `ai-gateway.env`
- `logs-collector.env`
- `app.env`

随后按照提示完成 License 激活：

1. 输入超级管理员邮箱，按回车确认。
2. 按提示输入 Alephant 管理端生成的 JWT 文件内容。
3. JWT 文件内容输入完成后，连续按两次 `Ctrl+D`，确认保存。
   
#### 截图

![alt text](image-1.png)

#### 注意事项

- 执行脚本前，确认当前目录的上级目录中存在 `alephant-deploy` 项目目录。
- 启动前确认 Docker、Docker Compose 以及相关依赖服务可用。
- 输入 JWT 文件内容时，应确保内容来自 Alephant 管理端生成的完整文件，避免遗漏或混入其他字符。
- `Ctrl+D` 用于结束多行 JWT 内容输入并确认保存，请按提示完成操作。

### 3.3 步骤 3：等待初始化完成并检查容器状态

#### 操作目的

确认启动脚本已完成镜像下载、容器初始化和数据库初始化，并验证各容器是否正常运行。

#### 操作内容

启动脚本在完成邮箱和 JWT 配置后，会自动执行以下操作：

1. 下载部署所需镜像。
2. 初始化并启动容器。
3. 初始化数据库。

初始化完成后，执行以下命令检查全部容器状态：

```bash
docker ps -a
```


#### 操作结果

正常情况下，容器状态应全部处于运行状态：不应出现 `Exited`、`Restarting` 或其他异常状态。

截图中的容器均处于运行状态，包括：

- `alephant-gateway`
- `alephant-app`
- `alephant-ai-gateway`
- `alephant-tikv`
- `alephant-minio`
- `alephant-valkey`
- `alephant-saas-service`
- `alephant-clickhouse`
- `alephant-pd`
- `alephant-policy-service`
- `alephant-qdrant`
- `alephant-postgres`
- `alephant-logs-collector`


#### 截图
![alt text](image-2.png)


#### 注意事项

- 如果容器状态为 `Exited` 或 `Restarting`，需要查看对应容器日志后再继续后续验证。
- 仅执行 `docker ps -a` 只能确认容器运行状态，还需结合功能测试验证业务程序是否正常运行。

#### 常见问题

- 镜像下载提示无权限，请确认是否执行随jwt授权文件提供的登录命令
- 镜像下载失败，请检查网络确认网络正常后重试

### 3.4 步骤 4：配置自定义前端 API 地址

#### 操作目的

根据实际访问路径配置前端使用的 API 地址、网关地址和 Collector 地址，确保前端能够通过正确的域名、端口和路径访问后端服务。

#### 操作内容

编辑前端环境变量文件：

```bash
vim compose/app.env
```

按照实际访问路径填写以下变量：

```dotenv
API_BASE_URL=<前端访问的 API 地址>
GATEWAY_BASE_URL=<Gateway 服务访问地址>/v1
COLLECTOR_BASE_URL=<Collector 服务访问地址>
```

本机访问例如：

```dotenv
API_BASE_URL=http://localhost
GATEWAY_BASE_URL=http://localhost:81/v1
COLLECTOR_BASE_URL=http://localhost:82
```

如果使用生产域名，应根据实际部署域名进行替换，例如：

```dotenv
API_BASE_URL=https://your-domain.com
GATEWAY_BASE_URL=https://your-domain.com/v1
COLLECTOR_BASE_URL=https://analytics.your-domain.com
```

如果使用ip访问，应根据ip和端口进行替换，例如：
```dotenv
API_BASE_URL=http://your-ip:your-api-port
GATEWAY_BASE_URL=https://your-ip:your-gateway-port/v1
COLLECTOR_BASE_URL=https://your-ip:your-logs-port
```

#### 配置说明

- `API_BASE_URL`：前端 API 基础地址。
- `GATEWAY_BASE_URL`：Gateway 服务访问地址；使用 Gateway 路径时需要注意 `/v1` 后缀。
- `COLLECTOR_BASE_URL`：数据采集服务访问地址。
- `app.env` 由启动脚本自动生成，修改后应确认后续启动或重启流程不会覆盖手工配置。
- SPA 前端会通过 `GET /_env` 获取 `API_BASE_URL` 和 `COLLECTOR_BASE_URL`。

#### 操作结果

完成 `compose/app.env` 中自定义前端 API 地址及相关服务地址的配置。


#### 截图
![alt text](image-3.png)

#### 注意事项

- 地址必须按照用户实际访问路径填写，不能直接照抄示例中的 `localhost` 或示例域名。
- 如果前端和后端不在同一主机或端口，需要填写外部可访问的地址，而不是容器内部地址。
- 生产环境使用 HTTPS 时，相关地址的协议应统一使用 `https://`。
- 配置 Gateway 地址时，确认是否需要保留 `/v1` 路径后缀。

### 3.5 步骤 5：按需修改项目环境变量配置（可选）

#### 操作目的

根据实际部署需求，对项目对应的环境变量进行个性化配置。

#### 操作内容

根据需要修改对应项目的 `.env` 配置文件：

```bash
# 进入对应项目目录后，根据实际文件位置编辑
vim <项目目录>/.env
```

仅修改当前部署需求涉及的配置项，并按照配置文件中的注释确认变量用途和填写方式。

#### 单点登录 (saas-service.env)
google 单点登录配置
```
# 注意回调地址填写：{API_BASE_URL}/api/v1/auth/oauth/google/callback
OAUTH_GOOGLE_CLIENT_ID=
OAUTH_GOOGLE_CLIENT_SECRET=${OAUTH_GOOGLE_CLIENT_SECRET}
```

github 单点登录配置
```
# 注意回调地址填写： {API_BASE_URL}/auth/callback/github

OAUTH_GITHUB_CLIENT_ID=
OAUTH_GITHUB_CLIENT_SECRET=${OAUTH_GITHUB_CLIENT_SECRET}
OAUTH_GITHUB_ALLOWED_REDIRECT_URIS=http://localhost:8081/auth/github/callback

```

#### 操作结果

完成项目对应 `.env` 文件的可选配置修改。
如果当前部署没有额外需求，可跳过本步骤。

#### 注意事项

- 修改前确认 `.env` 文件属于目标项目，避免修改错误模块的配置。
- 修改环境变量后，需要确认对应服务是否需要重新创建或重启容器才能生效。
- 密码、Token、JWT、API Key 等敏感信息不要提交到代码仓库或写入公开文档。
- 不确定变量含义时，应先参考配置文件注释或项目说明，再进行修改。

### 3.6 步骤 6：重新生成容器

#### 操作目的

使前面修改的环境变量和项目配置重新加载到容器中。

#### 操作内容

进入 Compose 配置目录，停止并移除现有容器，然后以后台模式重新创建并启动容器：

```bash
cd compose
docker compose down
docker compose up -d
```

#### 操作结果

现有容器已停止并移除，Docker Compose 根据最新配置重新创建并启动容器。

#### 注意事项

- 执行命令前确认当前目录下存在有效的 Docker Compose 配置文件。
- `docker compose down` 会停止并移除当前 Compose 项目创建的容器，但通常不会删除镜像和命名卷。
- 执行完成后，应使用 `docker ps -a` 检查容器状态，并查看日志确认服务启动正常。
- 如果配置修改未生效，应检查实际加载的 `.env` 文件、Compose 文件和环境变量覆盖关系。

### 3.8 步骤 8：注册超级管理员账号

#### 操作目的

通过 Alephant 网站的账号注册功能，使用部署时提供的超级管理员邮箱注册首个管理账号。

#### 操作内容

访问配置的API_BASE_URL，（例如本机访问：http://127.0.0.1检查是否打开页面）

1. 打开部署完成后的 Alephant 网站。
2. 在登录页面点击“免费注册”。
3. 使用部署过程中提供的超级管理员邮箱注册账号。
4. 按页面提示完成密码等注册信息填写。
5. 注册完成后，使用该邮箱和密码登录系统。

#### 操作结果

注册成功后，该账号作为 Alephant 系统的超级管理员账号使用。

#### 截图

![alt text](image-4.png)

#### 注意事项

- 注册时使用的邮箱应与部署阶段输入的超级管理员邮箱保持一致。
- 超级管理员账号的密码应妥善保管，不要写入本文档或提交到代码仓库。
- 如果页面无法访问，应先检查 Nginx 外部访问端口、`API_BASE_URL`、`GATEWAY_BASE_URL` 和 `COLLECTOR_BASE_URL` 配置。
- 当前截图仅展示注册入口，注册提交成功及超级管理员权限还需要通过实际登录结果确认。

### 3.9 步骤 9：验证部署功能


#### 操作目的

在部署完成并成功注册超级管理员账号后，对 Alephant 的核心功能进行验证，确认系统可以正常使用。

#### 操作内容

使用已注册的超级管理员账号登录 Alephant，然后按照实际业务范围验证功能，包括：

- 登录和退出登录。
- 前端页面是否能够正常加载。
- 前端 API 请求是否正常返回。
- Gateway 相关接口是否可访问。
- Collector 相关功能是否可用。
- 超级管理员账号是否具备预期管理权限。
- 页面操作产生的数据是否能够正常保存和查询。

#### 操作结果

部署工作完成，账号注册成功后进入功能验证阶段。
具体功能验证结果待根据实际测试结果补充。

#### 注意事项

- 功能验证应覆盖实际部署范围内的核心业务流程。
- 如果前端页面可以打开但接口请求失败，应重点检查 API 地址、Gateway 地址、Nginx 代理和容器日志。
- 如果账号可以登录但权限不符合预期，应检查超级管理员账号注册和权限初始化状态。
- 验证过程中不要将密码、JWT、Token 或 API Key 等敏感信息记录到文档中。

### 3.13 步骤 13：执行功能覆盖测试

#### 操作目的

通过核心业务操作验证 Alephant 独立部署后的功能完整性，确认账号、组织、Agent、策略、模型请求、统计和日志等功能均可正常使用。

#### 测试范围

1. 创建 Master Key。
2. 创建 Department。
3. 创建 Agent / Member。
4. 创建 Policy 策略。
5. 使用 VK 发起大模型请求。
6. 检查统计数据和日志。

#### 测试步骤

##### 1. 创建 Master Key
创建 Master Key，并确认创建结果及后续使用权限符合预期。
创建 Master Key，推荐使用OpenModels提供的key（https://openmodels.market/）

##### 2. 创建 Department

创建 Department，确认组织信息保存成功，并能够在相关页面或接口中查询到。

##### 3. 创建 Agent / Member

分别验证 Agent 和 Member 的创建流程，确认创建后的对象信息、归属关系和权限显示正常。

##### 4. 创建 Policy 策略


创建 Policy 策略，确认策略内容能够保存，并能够关联到对应的 Agent、Member 或请求流程。


##### 5. 使用 VK 发起大模型请求


使用 VK 发起一次大模型请求，确认请求能够正常发送并返回结果，同时验证请求是否受到已配置 Policy 策略的控制。


##### 6. 检查统计数据和日志


检查统计页面或相关接口，确认大模型请求产生的调用量、状态等统计信息能够正常记录；同时检查系统日志和请求日志，确认能够查询到对应请求记录且没有明显异常。

#### 注意事项

- 如果大模型请求失败，应结合 Policy 配置、VK 权限、Gateway 地址和服务日志进行排查。
- 统计和日志验证应使用本次测试产生的请求记录，避免误将历史数据作为测试结果。


## 4. 部署验证


### 4.1 容器状态验证

执行：

```bash
docker ps -a
```

确认所有 Alephant 相关容器均处于 `Up` 状态，配置健康检查的容器显示 `healthy`，且没有容器处于 `Exited` 或 `Restarting` 状态。

## 5. 附录

### 5.1 部署检查清单

- [ ] 部署环境确认
- [ ] 依赖服务准备完成
- [ ] Alephant 服务启动成功
- [ ] 健康检查通过
- [ ] 核心功能验证通过
- [ ] 日志无明显错误
- [ ] 超级管理员账号登录成功
- [ ] 前端页面和 API 请求正常
- [ ] Gateway、Collector 等相关功能验证通过
- [ ] Master Key 创建成功
- [ ] Department 创建成功
- [ ] Agent / Member 创建成功
- [ ] Policy 策略创建成功
- [ ] VK 大模型请求成功
- [ ] 统计数据和日志记录正常

## 6. 联系方式

- X：<https://x.com/openmodelsai>
- Discord：<https://discord.com/invite/tRQghcXhaH>
- Wechat: hong3yang
- Email：dev@alephant.io
