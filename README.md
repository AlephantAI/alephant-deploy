# Alephant 一键部署

```bash
cd alephant-docker/
bash start.sh
```

自动完成：
1. 生成随机密码和密钥
2. 填充所有环境变量文件
3. 从 S3 下载业务镜像
4. 拉取中间件（postgres、clickhouse、valkey、qdrant）
5. 启动全部 11 个服务

## 服务

| 服务 | 说明 | 端口 |
|---|---|---|
| **saas-app** | SaaS 前端 | **80** |
| **saas-service** | SaaS 后端 API | 8081 |
| **policy-service** | 策略后端 | 8090 |
| **ai-gateway** | AI 网关 | 8080 |
| **logs-collector** | 日志收集 | 8585 |
| **postgres** | 数据库 | 5432 |
| **clickhouse** | OLAP 分析 | 8123 / 9000 |
| **valkey** | 缓存 | 6379 |
| **qdrant** | 向量数据库 | 6333 / 6334 |

## 常用命令

```bash
docker compose ps                    # 查看状态
docker compose logs -f <service>     # 查看日志
docker compose restart <service>     # 重启服务
docker compose down                  # 停止
bash start.sh                        # 重新部署
```

## .env 文件说明

脚本生成的密码记录在终端输出中，也可直接查看文件：

```bash
cat infra.env          # 基础设施密码
cat saas-service.env   # SaaS 后端配置
```
