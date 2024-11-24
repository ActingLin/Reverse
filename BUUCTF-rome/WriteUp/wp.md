![alt text](image.png)
![alt text](image-1.png)
```python
key="Qsw3sj_lz4_Ujw@l"
flag=""
 
for c in key:
    if c>='a' and c<='z':
        flag+=chr((ord(c)-18-97)%26+97) 
    elif c>='A' and c<='Z':
        flag+=chr((ord(c)-14-65)%26+65)
    else:
        flag+=c
 
print(flag)
 
##原始数据加减移位值，-97或者是-65然后%26变为索引值，再加上97或者是65变为asiic码

```

```python
str1 = [81, 115, 119, 51, 115, 106, 95, 108, 122, 52, 95, 85, 106, 119, 64, 108]
flag = ""
str2 = "abcdefghijklmnopqrstuvwxyz"
str3 = str2.upper()

for i in str1:
    if 64 < i <= 90:
        flag += str3[i - 14 - 65]
    elif 96 < i <= 122:
        flag += str2[i - 18 - 97]
    else:
        flag += chr(i)
print('flag{' + flag + '}')

```
[z3（z3-solver）约束求解器在ctf中的运用](https://www.bilibili.com/video/BV1TP4y1N7jJ/?spm_id_from=333.1007.top_right_bar_window_custom_collection.content.click&vd_source=2c4148ac928a1b2447f3d8c80156c3c4)
```python
import z3
key = 'Qsw3sj_lz4_Ujw@l'
solver = z3.Solver()
varNames = []
for i in key:
    o = ord(i)
    if 64 < o <= 90:
        x = z3.Int('v%d' % o)
        solver.add(x > 64)
        solver.add(x <= 90)
        solver.add(((x - 51) % 26 + 65) == o)
        varNames.append(x)
    elif 96 < o <= 122:
        x = z3.Int('v%d' % o)
        solver.add(x > 96)
        solver.add(x <= 122)
        solver.add(((x - 79) % 26 + 97) == o)
        varNames.append(x)
    else:
        x = z3.Int('v%d' % o)
        solver.add(x == o)
        varNames.append(x)

if solver.check() == z3.sat:
    model = solver.model()
    for i in varNames:
        print(chr(model[i].as_long()), end='')
```