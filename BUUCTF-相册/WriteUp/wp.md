
不会，第一次见，记一下

![alt text](image-2.png)

根据提示搜索字符串`mail`

![alt text](image-1.png)
再定位到C2
![alt text](image-3.png)

![alt text](image-4.png)

System.loadLibrary代码就是加载so文件，

就是说，这个数据在so文件里面，

找到so文件，在reources/lib/armeabi目录里面

把apk改为zip解压，得到资源文件，然后找到lib资源就行

在，so文件里查找字符串是直接显示在下面

![alt text](image.png)