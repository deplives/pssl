#!/bin/bash
echo " ================================================== "
echo "|             此脚本生成自签名证证书               |"
echo "|        可用于 Quantumult/Surge 等 MITM           |"
echo " ================================================== "

read -p "输入CA证书名称(*): " CA_NAME
if [ -z $CA_NAME ]
then
	echo "输入为空！"
	exit
fi
openssl genrsa -out ${CA_NAME}.key 2048

echo "生成CA证书..."
read -p "国家或地区(*): " C
read -p "省/市/自治区(*): " ST
read -p "所在地(*): " L
read -p "组织(*): " O
read -p "组织单位(*): " OU
read -p "通用名称(*): " CN
read -p "电子邮件地址(*): " EMAIL
read -p "有效期/天(*): " DAYS

openssl req -x509 -new -nodes -key ${CA_NAME}.key -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN/emailAddress=$EMAIL" -days $DAYS -out ${CA_NAME}.crt

read -p "输入p12密码(*): " PASS
openssl pkcs12 -export -clcerts -in ${CA_NAME}.crt -inkey ${CA_NAME}.key -out ${CA_NAME}.p12 -password pass:$PASS

base64 -w 0 ${CA_NAME}.p12 > ${CA_NAME}.txt
