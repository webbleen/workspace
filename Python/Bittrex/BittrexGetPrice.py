#! /usr/bin/env python
#coding=utf-8

###################################
# Created by VSCode.
# User: Webb Leen
# Date: 2021-06-03
# Time: 22:00:00
###################################
import sys
import argparse
import json
import time
import csv

import urllib.request

# Main
if __name__ == '__main__':
    parser = argparse.ArgumentParser(sys.argv[0])
    
    parser.add_argument('-m', '--market', help=u"Symbol of market to retrieve ticker for")
    parser.add_argument('-p', '--period', help=u"Period to save csv")
    args = parser.parse_args()

    if args.market == None:
        args.market = "BTC-USD" # default: BTC-USD

    if args.period == None:
        args.period = 1 # default: 1 minute

    print(args.market)
    print(args.period)

    aheaders = {'Content-Type': 'application/json'}
    reqUrl = 'https://api.bittrex.com/v3/markets/%(marketSymbol)s/ticker' % {"marketSymbol": args.market}

    print(reqUrl)

    cur_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    csv_name = '%(time)s_%(marketSymbol)s.csv' % {"time": cur_time, "marketSymbol": args.market}
    
    f = open(csv_name,'w',encoding='utf-8')
    csv_writer = csv.writer(f)
    csv_writer.writerow(["time","lastTradeRate","bidRate","askRate"])
    f.close()

    req = urllib.request.Request(url=reqUrl, headers=aheaders)

    while True:
        rsp = urllib.request.urlopen(req)
        response = json.loads(rsp.read().decode())

        cur_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

        f = open(csv_name,'a+',encoding='utf-8')
        csv_writer = csv.writer(f)
        try:
            csv_writer.writerow([cur_time,response['lastTradeRate'],response['bidRate'],response['askRate']])
        finally:
            f.close()

        # Wait a minute
        time.sleep(60 * args.period)