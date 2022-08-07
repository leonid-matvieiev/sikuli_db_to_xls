0<1# :: ^
""" Со след строки bat-код до последнего :: и тройных кавычек
@setlocal enabledelayedexpansion & py -3 -x "%~f0" %*
@(IF !ERRORLEVEL! NEQ 0 echo ERRORLEVEL !ERRORLEVEL! & pause)
@exit /b !ERRORLEVEL! :: Со след строки py-код """

# print(dir())
ps_ = '__cached__' not in dir() or not __doc__
import sys
ps_ = bool(*filter(lambda d: '\\PyScripter\\' in d, sys.path))

from os.path import getsize, exists
import time, os

fpne = r'D:\yxs\1.txt'

def beeps(n=1):
    for i in range(n):
        print('\a')
        time.sleep(0.75)

def main():
    z0 = None
    os.system(f'del /q {fpne}')
    if exists(fpne) :
        z0 = getsize(fpne)
    t0 = time.time()
    while True:
        time.sleep(0.95)
        t1 = time.time()
        dt = int(t1 - t0)
        if not exists(fpne) :
            t0 = t1
            continue
        z1 = getsize(fpne)
        if z0 is None:
            z0 = z1
            continue
        dz = z1 - z0
        z0 = z1
        print(end="\b" * 5 + f'{dt}', flush=True)
        if dz:
            t0 = t1
            print(f'\t{dz}')
        if dt == 30:
            beeps(2)
        elif dt == 40:
            beeps(3)
        elif dt > 40 and dt % 20 == 0:
            beeps()

# ----------------------------------------------------------------------------

# ============================================================================
if __name__ == '__main__':
    main()
    print('\nОперації завершені')
    if not (ps_ or '--waitendno' in sys.argv):
#        os.system('pause')
        os.system('timeout /t 15')
# ----------------------------------------------------------------------------
