#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      admin
#
# Created:     16.04.2021
# Copyright:   (c) admin 2021
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import time

fpne = r'D:\yxs\1.txt'

def main():
    open(fpne, 'w').close()
    fx = open(fpne, 'a')  # , encoding='cp1251'
    for i in range(5):
        time.sleep(5)
        print('.', file=fx, flush=True)
#        fx.write('.')
        print(i)
    for i in range(10, 20):
        time.sleep(5)
        print(i)
    for i in range(30, 35):
        time.sleep(5)
        print('.', file=fx, flush=True)
#        fx.write('.')
        print(i)
    fx.close()

if __name__ == '__main__':
    main()
