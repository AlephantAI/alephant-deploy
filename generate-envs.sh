#!/usr/bin/env bash
# =============================================================================
# generate-envs.sh — 从 shared.env + .env.tpl 生成各服务的最终 .env 文件
#
# 使用方法:
#   1. 编辑 shared.env 和 *.env.tpl 填入真实值
#   2. 运行 ./generate-envs.sh
#   3. 生成的 *.env 文件会被 docker compose 自动引用
#
# 合并规则:
#   - shared.env 在前（公共变量）
#   - .env.tpl 在后（服务特有变量，可覆盖 shared.env 中的同名变量）
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SERVICES=("saas-service" "policy-service" "ai-gateway" "logs-collector")

echo "=== Alephant 环境变量生成工具 ==="
echo ""

# 检查 shared.env 是否存在
if [ ! -f shared.env ]; then
    echo "❌ 错误: shared.env 不存在"
    echo "   请先复制 shared.env.example 为 shared.env 并填入真实值"
    exit 1
fi

# 检查 shared.env 中的占位符是否已替换
if grep -q '<请替换>' shared.env 2>/dev/null || grep -q '<数据库密码>' shared.env 2>/dev/null; then
    echo "⚠️  警告: shared.env 中仍有占位符未替换"
    echo "   建议先编辑 shared.env 填入真实值"
    echo ""
fi

GENERATED=0
for service in "${SERVICES[@]}"; do
    tpl_file="${service}.env.tpl"
    output_file="${service}.env"

    if [ ! -f "$tpl_file" ]; then
        echo "   ⚠️  跳过 ${service}: ${tpl_file} 不存在"
        continue
    fi

    # 合并 shared.env + .env.tpl → .env
    # 注意: cat 顺序决定优先级 — 后出现的变量覆盖前面的
    {
        echo "# ==============================================================================="
        echo "# ${output_file} — 由 generate-envs.sh 自动生成"
        echo "# 编辑 shared.env 和 ${tpl_file} 后重新运行此脚本即可更新"
        echo "# 最后生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "# ==============================================================================="
        echo ""
        echo "# ── 以下变量来自 shared.env ──"
        cat shared.env
        echo ""
        echo "# ── 以下变量来自 ${tpl_file} (可覆盖 shared.env) ──"
        cat "$tpl_file"
    } > "$output_file"

    echo "   ✅ 生成 ${output_file}"
    GENERATED=$((GENERATED + 1))
done

echo ""
echo "=== 完成! 共生成 ${GENERATED} 个文件 ==="
echo "运行 docker compose up -d 启动服务"
