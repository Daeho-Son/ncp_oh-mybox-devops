API_DIR="/root/oh-mybox-api"
LOGS_DIR="/root/oh-mybox-devops/logs"
JAR_FILE="oh-mybox-0.0.1-SNAPSHOT.jar"


# 실행 중인 서버 종료
CURRENT_PID=$(pgrep -f $JAR_FILE)
TIME_NOW=$(date +%c)
DEPLOY_LOG="$LOGS_DIR/deploy.log"
if [[ -z $CURRENT_PID ]]; then
  echo "$TIME_NOW > 현재 실행중인 애플리케이션이 없습니다" >> $DEPLOY_LOG
else
  echo "$TIME_NOW > 실행중인 $CURRENT_PID 애플리케이션 종료 " >> $DEPLOY_LOG
  kill -9 $CURRENT_PID
  sleep 10
fi


# 서버 빌드 & 실행
NOHYP_DIR="$LOGS_DIR/nohup"
NOHUP_STDOUT="$NOHUP_DIR/stdout.txt"
NOHUP_STDERR="$NOHUP_DIR/stderr.txt"
cd $API_DIR
git pull
./gradlew build
nohup java -jar ./build/libs/$JAR_FILE 1> $NOHUP_STDOUT 2> $NOHUP_STDERR &
