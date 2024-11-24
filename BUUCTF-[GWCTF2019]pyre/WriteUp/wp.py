#!/usr/bin/env python
# visit https://tool.lu/pyc/ for more information
# Version: Python 2.7

# print 'Welcome to Re World!'
# print 'Your input1 is your flag~'
# l = len(input1)
# for i in range(l):
#     num = ((input1[i] + i) % 128 + 128) % 128
#     code += num
#
# for i in range(l - 1):
#     code[i] = code[i] ^ code[i + 1]
#
# print code
code = [
    '\x1f',
    '\x12',
    '\x1d',
    '(',
    '0',
    '4',
    '\x01',
    '\x06',
    '\x14',
    '4',
    ',',
    '\x1b',
    'U',
    '?',
    'o',
    '6',
    '*',
    ':',
    '\x01',
    'D',
    ';',
    '%',
    '\x13']

i = len(code)

# a^b^b = a
# 因为加密是当前字符与后一个字符的异或，也就意味着，最后一个字符
# 是没有发生异或的，要得到抑或前的字符就需要从倒数第二个字符开
# 始，从后往前，将当前字符与后一个字符异或

for j in range(i - 2, -1, -1):
    code[j] = chr(ord(code[j]) ^ ord(code[j + 1]))  # ord（）：将字符转换为Unicode编码
    # chr():将Unicode编码转换为字符
for k in range(i):
    code[k] = chr((ord(code[k]) - k) % 128)

s = ''.join(code)  # 将列表转换为字符串输出
print(f'{s}')

# 结果：GWHT{Just_Re_1s_Ha66y!}
