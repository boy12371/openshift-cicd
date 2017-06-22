#!/bin/bash
# ReadinessProbe是用来检查你的应用程序是否可以为通信服务。这跟LivenessProbe有些的不同。
# 如果应用的ReadinessProbe运行失败，那么pod就会从组成service的端点被删除。默认情况下
# ReadinessProbe在第一次检测之前初始化值为Failure，如果pod没有提供ReadinessProbe，
# 则也认为是Success。

STATUSCODE=$(curl -L --silent --output /dev/null --write-out "%{http_code}" 127.0.0.1:8080)

if test $STATUSCODE -ne 200; then
    echo "FAILURE"
    exit 1
else
    echo "SUCCESS"
    exit 0
fi
