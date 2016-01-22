#!/bin/bash

USAGE="Usage: ./zhConvert.sh zh_CN zh"

# 参数校验;
if [ "$#" -lt 1 ] ; then
	echo $USAGE
	exit 1
fi

# 清空繁体目录;
rm ${2}/*

# 遍历中文目录;
file_list=`ls ${1} | grep _zh-CN`
for file in ${file_list}
do
	if [ ! -d ${file} ]; then
		src_file="${1}/${file}";
		dest_file="${2}/${file//_zh-CN/_zh}";
		# 简转繁;
		cconv -f utf-8 -t utf8-tw ${src_file} -o ${dest_file}

		echo -e "convert file:\e[1;32m${src_file}\e[0m to file:\e[1;32m${dest_file}\e[0m"
	fi
done
