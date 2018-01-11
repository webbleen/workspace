#! /usr/bin/env python
#coding=utf-8

###################################
# Created by PhpStorm.
# User: Webb Lee
# Date: 2018-01-10
# Time: 15:42:21
###################################
import hashlib
import random
import os,sys
import argparse
import json
import traceback


#想混淆的变量/方法名
raw_name_list = []

#混淆后的变量/方法名
new_name_list = []

#随机可选的字母表
alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',]

#生成新的变量名
def create_new_name():
    m = hashlib.md5()
    #生成随机变量名
    for raw_name in raw_name_list:
        m.update(raw_name)
        #生成一个16位字符串
        temp_name = m.hexdigest()[0:16]
        #合法名称校验
        #强制以字母作为变量/方法名的开头
        if temp_name[0].isdigit():
            initial = random.choice(alphabet)
            temp_name = initial + temp_name
            temp_name = temp_name[0:16]

        #不能重名
        while(1):
            if temp_name in new_name_list:
                initial = random.choice(alphabet)
                temp_name = initial + temp_name
                temp_name = temp_name[0:16]
            else:
                new_name_list.append(temp_name)
                break

#混淆文件
def confuse_file(full_file_name):
    file_content = ""
    #读取文件内容
    f = file(full_file_name)
    while(True):
        line = f.readline()
        if len(line) == 0: #Zero length indicates EOF
            break
        #混淆
        name_index = 0
        for raw_name in raw_name_list:
            the_new_name = new_name_list[name_index]
            line = line.replace(raw_name, the_new_name)
            name_index += 1
        file_content += line
    f.close()
    #重写文件
    f = file(full_file_name, 'w')
    f.write(file_content)
    f.close()

#遍历指定目录下所有指定后缀的文件名
def confuse_all(path, file_ext):
    for root, dirs, file_name in os.walk(path):
        for file in file_name:
            full_file_name = os.path.join(root, file)
            if full_file_name.endswith(file_ext):
                confuse_file(full_file_name)


#获取指定目录下所有指定后缀的文件名
def get_file_name(path, file_ext):
    global raw_name_list
    f_list = os.listdir(path)

    #装载
    for i in f_list:
        file_path = os.path.join(path, i)
        if os.path.isdir(file_path):
            get_file_name(file_path, file_ext)
        else:
            if os.path.splitext(i)[1] == file_ext:
                raw_name_list.append(os.path.splitext(i)[0])

#获取配置
def load_json(jsonFile):
    return json.load(open(jsonFile))

def load_config(config_path):
    print "config_path:", config_path
    try:
        config = load_json(config_path)
    except Exception as e:
        traceback.print_exc()
        print("混淆配置config.json错误: \n%s"%e)
        sys.exit(-1)

    confuse_list = []
    if 'confuse_list' in config:
        confuse_list = config['confuse_list']

    for one_confuse in confuse_list:
        if 'class_name' in one_confuse:
            raw_name_list.append(one_confuse['class_name'].encode('utf-8'))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(sys.argv[0])
    parser.add_argument('codepath', help=u"代码目录")

    parser.add_argument('-c', '--configpath', help=u"混淆的配置文件")
    parser.add_argument('-s', '--splitext', help=u"需要混淆的文件后缀，默认为.cs")

    args = parser.parse_args()
    if args.codepath.endswith("/"):
        args.codepath = os.path.dirname(args.codepath)

    if args.configpath == None:
        args.configpath = os.path.join(os.getcwd(), "config.json")


    if args.splitext == None:
        args.splitext = ".cs"

    print "Confuse Start......"
    #get_file_name(args.codepath, args.splitext)
    load_config(args.configpath)
    create_new_name()
    confuse_all(args.codepath, args.splitext)

    print "Confuse Complete!"
