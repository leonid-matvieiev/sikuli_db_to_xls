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

def beeps(n=1):
    for i in range(n):
        print('\a')
        time.sleep(1)

if __name__ == '__main__':
    main()
