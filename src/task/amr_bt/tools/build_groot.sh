#!/bin/bash
# Groot 1(BehaviorTree.CPP v3용)을 gui 컨테이너 안에 빌드한다. 이미지에 Groot이 없고 Humble apt 패키지도 없다.
#   docker compose --profile gui exec gui bash /ros2_ws/src/task/amr_bt/tools/build_groot.sh
# 컨테이너를 내리면 지워진다 (/tmp/groot_ws). Qt 개발 패키지 설치 + 빌드로 디스크 약 1–2 GB를 쓴다.
# 실행: source /tmp/groot_ws/install/setup.bash && ros2 run groot Groot
set -e
source /opt/ros/humble/setup.bash
WS=/tmp/groot_ws
if [ -x "$WS/install/groot/lib/groot/Groot" ]; then
  echo "이미 빌드됨: source $WS/install/setup.bash && ros2 run groot Groot"
  exit 0
fi
apt-get update
apt-get install -y --no-install-recommends qtbase5-dev libqt5svg5-dev libzmq3-dev libdw-dev git
mkdir -p "$WS/src"
[ -d "$WS/src/Groot" ] || git clone --depth 1 --recurse-submodules https://github.com/BehaviorTree/Groot.git "$WS/src/Groot"
cd "$WS"
# 메모리가 작은 PC에서 Qt 컴파일이 멈추지 않게 병렬 2개로 묶는다
MAKEFLAGS=-j2 colcon build --packages-select groot --cmake-args -DCMAKE_BUILD_TYPE=Release
echo "완료: source $WS/install/setup.bash && ros2 run groot Groot"
