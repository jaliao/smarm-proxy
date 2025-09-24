#!/bin/bash

# 取得版本
current_date=$(date +"%Y-%m-%d %H:%M:%S")

git add .

git commit -m "Auto commit on $current_date"

git push

git remote get-url origin

