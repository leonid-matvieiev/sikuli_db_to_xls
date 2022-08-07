0<1# :: ^
""" Со след строки bat-код до последнего :: и тройных кавычек
@setlocal enabledelayedexpansion & py -3 -x "%~f0" %*
@(IF !ERRORLEVEL! NEQ 0 echo ERRORLEVEL !ERRORLEVEL! & pause)
@exit /b !ERRORLEVEL! :: Со след строки py-код """

# print(dir())
ps_ = '__cached__' not in dir() or not __doc__
import sys
ps_ = bool(*filter(lambda d: '\\PyScripter\\' in d, sys.path))

from glob import glob
from os.path import join, split, splitext, exists, isdir, getmtime
import os, time
import pyexcel
# ----------------------------------------------------------------------------

# ============================================================================
def main():
    ren_dict0 = {
        'Контроль': ('K', 'control_ind'),
        'Рахунки': ('R', 'accounts'),
        'Платежі': ('P', 'payments'),
        'Лічильник': ('L', 'counter'),
        'Пломби': ('M', 'seals'),
        'Завдання': ('Z', 'tasks'),
        'Попередження': ('N', 'warnings'),
        'Інше': ('I', 'others'),
    }
    names_set = set(ren_dict0)
    ren_dict = {}
    for r, (a, b) in ren_dict0.items():
        ren_dict[a] = r
        ren_dict[b] = r

    # рабочая папка относительно скрипта
    fp_in = r'D:\x'
    fp_out = r'D:\y'
    folds0 = {split(fp)[-1] for fp in filter(isdir, glob(join(fp_out, '*')))}

    fpne_xls = glob(join(fp_out, '*.xls'))  # split(sys.argv[0])[0]  need want
    if not fpne_xls:
        print(f'Нет общего ексель-файла в папке "{fp_out}"')
        return
    if len(fpne_xls) > 1:
        print(f'В папке "{fp_out}" д.б. только один общий ексель-файл')
        return
    fpne_xls = fpne_xls[0]  # Имя ексель-файла абонентов
    fpne_txt = splitext(fpne_xls)[0] + '.txt'  # Имя txt-файла абонентов
    if not exists(fpne_txt):  # txt-файл обрабатывается быстрее
        print(f'Общий файл "{split(fpne_txt)[-1]}" сделал бы обработку быстрее')

    # перемещение файлов по абон-папкам
    fpnes = sorted(glob(join(fp_in, '*.xls')), key=getmtime)
    ss = [f'Новых файлов: {len(fpnes)}']
    print(ss[-1])
    if fpnes:
        ss.append(f'Последний: {split(fpnes[-1])[-1]}')
        print(ss[-1])
    c_move = 0
    c_replace = 0
    c_ignore = 0
    for fpne in fpnes:
        fn0 = split(splitext(fpne)[0])[-1]
        try:
            ab, fn = fn0.split('-', 1)
        except:
            a=5
            print('####', fpne)
            continue
        fpn = join(fp_out, ab)#
        fn2 = ren_dict.get(fn, fn)
        fpne2 = join(fpn, f'{ab}-{fn2}.xls')
        if not exists(fpne2):
            os.renames(fpne, fpne2)
            c_move += 1
        elif getmtime(fpne2) < getmtime(fpne):
            os.remove(fpne2)
            os.renames(fpne, fpne2)
            c_replace += 1
        else:
            os.remove(fpne)
            c_ignore += 1
    ss.append(f'Перемещено: {c_move}, заменено: {c_replace}, игнорено: {c_ignore} ')
    print(ss[-1])

    folds = {split(fp)[-1] for fp in filter(isdir, glob(join(fp_out, '*')))}
    musts = set()
    while True:
        if exists(fpne_txt):  # txt-файл обрабатывается быстрее
            with open(fpne_txt, encoding='cp1251') as fx:
                sss = [ss.split('\t', 3) for ss in fx.read().splitlines()]
        else:
            sss = pyexcel.get_array(file_name=fpne_xls)

        # Проверка признаков необходимого ексель-файла
        try:
            if (sss[0][1] != 'Особові рахунки'
             or sss[1][2] != 'Номер о/р'
             or sss[-4][1] != 'Кількість'
             or sss[-3][1] != 'Разом'
             or sss[-2][1] != 'Найменше значення'
             or sss[-1][1] != 'Найбільше значення'):
                print(f'Общий файл "{splitext(split(fpne_txt)[-1])[0]}" плохой')
                break
        except IndexError:
            print(f'Общий файл "{splitext(split(fpne_txt)[-1])[0]}" плохой')
            break
        musts = {ss[2] for ss in sss[2:-4]}  # str()  # Все абоненты
        break

    wastes = folds - musts  # Лишние не нужные
    musts -= folds  # Недостающие
    folds -= wastes  # Есть нужные
    folds0 -= wastes  # были нужные

    ss.append(f'Папок было: {len(folds0)}, добавлено: '
                f'{len(folds) - len(folds0)}, стало: {len(folds)}')
    print(ss[-1])

    if musts:
        ss.append(f'Недостающих Папок {len(musts)}:\n' +
                        ' '.join(sorted(musts)[:10]))
        print(ss[-1])
    if wastes:
        ss.append(f'Лишних Папок {len(wastes)}:\n' +
                        ' '.join(sorted(wastes)[:10]))
        print(ss[-1])

    # поиск недоукомплектованных папок
    tmp = {}
    tmp_n = 0
    for fp in folds:
        names = names_set - {splitext(split(fpne)[-1])[0].split('-', 1)[-1]
                                for fpne in glob(join(fp_out, fp, '*.xls'))}
        if names:
            tmp[fp] = names
            tmp_n += len(names)

    # формирование списка отсутствующих файлов
    if tmp_n:
        ss.append(f'Отсутствующих файлов {tmp_n}:')
        print(ss[-1])
        for fp, names in sorted(tmp.items()):
            if names:
                ss.append(f'{len(names)}')
                print(ss[-1])
                for name in names:
                    ss.append(f'\tC:\\x\\{split(fp)[-1]}-{ren_dict0[name][0]}'
                                f'\tC:\\x\\{split(fp)[-1]}-{name}')
                    print(ss[-1])

    # Сохранение отчёта
    dt = time.strftime('%Y-%m-%d_%H%M', time.localtime())
    fpne_rep = join(fp_out, f'{dt}_report.txt')
    with open(fpne_rep, 'w', encoding='cp1251') as fx:
        fx.write('\n'.join(ss))
    os.startfile(fpne_rep)
# ----------------------------------------------------------------------------

# ============================================================================
if __name__ == '__main__':
    main()
    print('\nОперації завершені')
    if not (ps_ or '--waitendno' in sys.argv):
#        os.system('pause')
        os.system('timeout /t 15')
# ----------------------------------------------------------------------------
