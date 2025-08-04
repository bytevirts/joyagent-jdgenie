#!/bin/bash

# 开始启动后端程序
BASEDIR="./target/genie-backend"
CLASSPATH="$BASEDIR/conf/:$BASEDIR/lib/*"
MAIN_MODULE="com.jd.genie.GenieApplication"
LOGFILE="./genie-backend_startup.log"

# ------------------------------------

# --- 新增的、简化的动态配置逻辑 ---

# 定义最终的配置文件路径
CONFIG_FILE="$BASEDIR/conf/application.yml"

echo "================================================="
echo "开始根据环境变量动态生成后端配置文件..."
echo "目标文件: $CONFIG_FILE"
echo "================================================="

# 检查最终的配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "错误: 最终配置文件 $CONFIG_FILE 不存在! 启动失败。"
    exit 1
fi

# 使用sed命令，只替换两个API Key的占位符
# 这两个环境变量必须在Dokploy中设置，否则替换会失败
sed -i "s|DEEPSEEK_API_KEY|${GENIE_DEEPSEEK_APIKEY}|g" "$CONFIG_FILE"
sed -i "s|CLAUDE_API_KEY|${GENIE_CLAUDE_APIKEY}|g" "$CONFIG_FILE"

echo "API Key 注入完毕。最终配置文件内容如下："
echo "-------------------------------------------------"
cat "$CONFIG_FILE"
echo "-------------------------------------------------"
# --- 动态配置逻辑结束 ---

echo "starting $APP_NAME :)"
java -classpath "$CLASSPATH" -Dbasedir="$BASEDIR" -Dfile.encoding="UTF-8" ${MAIN_MODULE} > $LOGFILE 2>&1 &
