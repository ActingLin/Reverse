# list = [
#     0x66, 0x0A, 0x6B, 0x0C, 0x77, 0x26, 0x4F, 0x2E, 0x40, 0x11,
#     0x78, 0x0D, 0x5A, 0x3B, 0x55, 0x11, 0x70, 0x19, 0x46, 0x1F,
#     0x76, 0x22, 0x4D, 0x23, 0x44, 0x0E, 0x67, 0x06, 0x68, 0x0F,
#     0x47, 0x32, 0x4F, 0x00]
#
# # flag{xxxxxx}
# flag = chr(list[0])
# # 从第i位开始，与i-1异或, i>=1
# i = 1
# while True:
#     if i < len(list):
#         flag += chr(list[i] ^ list[i - 1])
#         i += 1
#     else:
#         break
# print(flag)

#
# str1 = [81, 115, 119, 51, 115, 106, 95, 108, 122, 52, 95, 85, 106, 119, 64, 108]
# flag = ""
# str2 = "abcdefghijklmnopqrstuvwxyz"
# str3 = str2.upper()
#
# for i in str1:
#     if 64 < i <= 90:
#         flag += str3[i - 14 - 65]
#     elif 96 < i <= 122:
#         flag += str2[i - 18 - 97]
#     else:
#         flag += chr(i)
# print('flag{' + flag + '}')
#
# key = "Qsw3sj_lz4_Ujw@l"
# flag = ""
#
# for c in key:
#     if 'a' <= c <= 'z':
#         flag += chr((ord(c) - 18 - 97) % 26 + 97)
#     elif 'A' <= c <= 'Z':
#         flag += chr((ord(c) - 14 - 65) % 26 + 65)
#     else:
#         flag += c
#
# print(flag)
#
# ##原始数据加减移位值，-97或者是-65然后%26变为索引值，再加上97或者是65变为asiic码
#
#
# c = [
#     198,
#     232,
#     816,
#     200,
#     1536,
#     300,
#     6144,
#     984,
#     51200,
#     570,
#     92160,
#     1200,
#     565248,
#     756,
#     1474560,
#     800,
#     6291456,
#     1782,
#     65536000
# ]
# flag = ""
# for i in range(1, len(c) + 1):
#     if (i & 1) != 0:
#         flag += chr(c[i - 1] >> i)
#     else:
#         flag += chr(c[i - 1] // i)
#
# print(flag)

# key = [198, 232, 816, 200, 1536, 300, 6144, 984, 51200,
#        570, 92160, 1200, 565248, 756, 1474560, 800, 6291456,
#        1782, 65536000]
# for i in range(1, 20):
#     if i % 2 == 0:
#         print(chr(key[i - 1] // i), end='')
#     else:
#         print(chr(key[i - 1] >> i), end='')
#
#
# a = 123
# a = a >> 1
# print(a)
# a = a << 1
# print(a)


flag = ''
flag += chr(166163712 // 1629056)
flag += chr(731332800 // 6771600)
flag += chr(357245568 // 3682944)
flag += chr(1074393000 // 10431000)
flag += chr(489211344 // 3977328)
flag += chr(518971936 // 5138336)
flag += chr(406741500 // 7532250)
flag += chr(294236496 // 5551632)
flag += chr(177305856 // 3409728)
flag += chr(650683500 // 13013670)
flag += chr(298351053 // 6088797)
flag += chr(386348487 // 7884663)
flag += chr(438258597 // 8944053)
flag += chr(249527520 // 5198490)
flag += chr(445362764 // 4544518)
flag += chr(981182160 // 10115280)
flag += chr(174988800 // 3645600)
flag += chr(493042704 // 9667504)
flag += chr(257493600 // 5364450)
flag += chr(767478780 // 13464540)
flag += chr(312840624 // 5488432)
flag += chr(1404511500 // 14479500)
flag += chr(316139670 // 6451830)
flag += chr(619005024 // 6252576)
flag += chr(372641472 // 7763364)
flag += chr(373693320 // 7327320)
flag += chr(498266640 // 8741520)
flag += chr(452465676 // 8871876)
flag += chr(208422720 // 4086720)
flag += chr(515592000 // 9374400)
flag += chr(719890500 // 5759124)
for i in range(1, 10):
    flag1 = flag[:6] + str(i) + flag[6:]
    print(flag1)


