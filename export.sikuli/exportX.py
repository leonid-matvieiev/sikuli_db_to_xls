import time, os
fpne = r'D:\yxs\1.txt'
os.system('del /q %s' % fpne)
fx = open(fpne, 'a')  # , encoding='cp1251'
path = 'C:\\x\\'  # Шлях для збереження файлів
aps = (  # Букви після номеру абонента для файлов
    ('K', Pattern("1618417922390.png").targetOffset(-11,-9)),  # Контрольні показання
    ('R', "1618417987988.png"),  # Рахунки
    ('P', "1618418021585.png"),  # Платежі
    ('L', "1618418067308.png"),  # Лічильник
    ('M', "1618418113891.png"),  # Пломби
    ('Z', "1618418170275.png"),  # Завданн
)
subaps = {  # Букви після номеру абонента для файлов
    0: 'Z',  # Завданн/Завдання
    1: 'N',  # Завданн/Попередження
    2: 'I',  # Завданн/Інші роботи
}
pic_abon = Pattern("1618418529369.png").targetOffset(135,-25)  # Ознака вікна номеру абонента
pic_zaly = "1618420358611.png"  # Ознака вікон Рахунки, Платежі
# віконця підтвердження перезапису або збереження
ims = ["1618247289880-1.png",
        "1618247146138.png"]

# click(Pattern("1618166032288.png").targetOffset(-6,-1))  # закриття вікна абонента
click("1618166277022.png")
type(Key.TAB)
sleep(0.1)
type(Key.TAB)  # перехід до номера абонента
for j in range(20000):
    type(Key.ENTER)  # відкриття номера абонента
    abon = exists(pic_abon, 30)
    if not abon:
        break  # повисло скоріш за все
    click(abon)
    type("ac", Key.CTRL)  # копіювання ном абонента в буф обміну
    for k, (fn, pic) in enumerate(aps):
        click(pic)  # вибір сторінки файлів
        # очікування сторінки файлів
        if fn == 'K':
            waitVanish(pic_abon, 30)
        elif fn == 'R':
            exists(pic_zaly, 30)
        elif fn == 'L':
            waitVanish(pic_zaly, 30)
        elif fn == 'Z':
            pass
        else:
            sleep(0.5)
        # Очікування заверш пошуку іконок файлів
        for p1 in range(4):  # 4 спроби таки зберегти всі 1-3 файли
            for p2 in range(5):  # 5 спроби таки знайти всі 1-3 іконки
                icons = sorted(findAll(Pattern("1618169387135.png").similar(0.70 - p2 *0.05)
                                .targetOffset(11,1)), key=lambda m:m.y)[1:]
                if icons and (fn != 'Z' or len(icons) >= 3):
                    break  # знайдено кількість, долі продовження
                sleep(0.1)
            else:
                pass  # а раптом знайшло хоч щось
                # break
            # Перебір іконок файлів
            for i, icon in enumerate(icons):
                click(icon)
                # Очікування діалогу збереження
                if not exists("1618175056124.png", 10):
                    break  # не дочекались, повторюємо спробу з пошуку
                sleep(0.5)  # очікування курсора в полі імені файла
                if not k + i + p1:
                    # формування початку імені на першому файлі в буф обміну
                    type(path)
                    type("v", Key.CTRL)
                    type("-")
                    type("ac", Key.CTRL)
                type("v", Key.CTRL)  # початок імені з буф обміну
                # добавлення букви в кінець імені
                if fn == 'Z':
                    type("%s" % subaps.get(i, i + 1))
                elif len(icons) == 1:
                    type("%s" % fn)
                else:
                    type("%s_%s" % (fn, i + 1))
                type(Key.ENTER)  # команда зберегти з іменем

                # очікування віконця підтвердження перезапису або збереження
##                waitAny(15 , ims)
##                v = findAny(ims)
##                if v and v[0].getIndex():
##                    type(Key.ENTER)  # Підтвердження перезапису
##                    if exists(ims[0], 15):
##                        type(Key.ESC)  # закриття віконця підтв збераження
##                else:
##                    type(Key.ESC)  # закриття віконця підтв збераження

                # очікування віконця підтвердження перезапису або збереження
                for p in range(2):
                    zap = exists("1618247289880.png", 15)
                    if zap:
                        fx.write('.\n')
                        fx.flush()
                    if zap or p:
                        type(Key.ESC)  # закриття віконця підтв збераження
                        break
                    type(Key.ENTER)  # Підтвердження перезапису
            else:
                # всі іконки файлів відпрацьовані, продовжувати пере-пошук і збереження не потрібно
                break
#    sleep(0.3)
#    click(Pattern("1618166032288.png").targetOffset(-6,-1))  # закриття вікна абонента, тепер CTRL-F4
    type(Key.F4, Key.CTRL)
#    sleep(0.5)
#    click("1618166277022.png")  # тепер ще дві TAB
    type(Key.TAB)
    type(Key.TAB)
    type(Key.TAB)  # перехід до номера поточного абонента
    type(Key.TAB)
    type(Key.DOWN)  # перехід до наступного абонента
fx.close()

