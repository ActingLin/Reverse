**查壳，upx并脱壳**

<img src="./image.png" alt="示例图片" style="zoom:40%;"/>
<img src="./image-1.png" alt="示例图片" style="zoom:40%;"/>

---

<img src="./image-5.png" alt="示例图片" style="zoom:40%;"/>



输入的flag，（即Source）
<img src="./image-2.png" alt="示例图片" style="zoom:40%;"/>

此处是加密后的flag,即Destination

<img src="./image-3.png" alt="示例图片" style="zoom:40%;"/>
<img src="./image-6.png" alt="示例图片" style="zoom:40%;"/>

按`X`,交叉引用，看看Source在哪被加密

<img src="./image-8.png" alt="示例图片" style="zoom:40%;"/>

![alt text](image-9.png)
![alt text](image-10.png)
```python
en_flag = "TOiZiZtOrYaToUwPnToBsOaOapsyS"
a2 = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm
flag=''

for i in range(len(en_flag)):
    if i % 2 == 0:
        flag += en_flag[i]
        continue
    for j,k in enumerate(a2):
        if en_flag[i] == k:
            if chr(j+38).isupper():
                flag += chr(j+38)
            else:
                flag += chr(j+96)

print flag

```