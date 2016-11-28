# CrazyRuning
修改苹果手机的健康信息，让你足不出户却能日行数万步，总多好友，qq运动步数，谁与争锋！哈哈

如何使用
点击开启暴走模式，点击一下，步数➕10000步。

今天凌晨1点，苹果推送了iOS10，于是一上班就迅速升级了iOS10，然后坑就这样开始了。。。

##问题1
首先是xcode的问题，发现xcode升级到8才能真机运行，于是先了解了下iOS10的适配。
有这个[iOS10适配总结](http://www.jianshu.com/p/c2bb07786fd1)，还有这个[iOS10适配问题收集](http://www.jianshu.com/p/43579787db43),还有这个[iOS10适配](http://www.jianshu.com/p/c531d185ebab),还有很多其他的。

![屏幕快照 2016-09-14 上午11.57.07.png](http://upload-images.jianshu.io/upload_images/2030399-ec1f03811191c3a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这个好办，取消**nullabl**关键字就好。
然后另一个蛋疼的问题来了
##问题二，编译不过的问题

![屏幕快照 2016-09-14 上午11.59.23.png](http://upload-images.jianshu.io/upload_images/2030399-1bc7f3dc5a00a37c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
蛋疼的clang报错le..

这个是详细的信息，一堆莫名其妙的东西出来了。
![0B783C14-7FA1-4D16-A1AA-15C9E823A726.png](http://upload-images.jianshu.io/upload_images/2030399-e9b143ccddbf76ff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

隐隐约约感觉是**WGS84T0GCJ02.o**这个实现文件的问题，然后进行删除，在run，居然成功了。
所以原因暂定为对一些c函数的支持不好。
如果发现项目奔溃的，该去检查老旧模块的一些老文件。没有什么好的解决办法，去排查警告下的那些类吧。
##问题三，适配问题（如何解决）
用iOS10的同学都看到了适配的问题，因为iOS10更换了系统字体，之前有看到文章说在原来的基础上加5个像素的宽度，其实这个是不够准确详细的，在Xcode8的xib下测了一下不同长度需要的宽度。以下以15号字体为例：




> Xcode8下完全展示15号字体所需的frame最小宽度

| 个数 | lable 宽度 | 
| ---- |:-------------:| 
| 1 |15 | 
| 2 | 15*2 ＋ 1 = 31| 
| 3 | 15*3 ＋ 1 ＝ 46| 
| 5 | 15*5 ＋ 2 ＝ 77 | 
| 10 | 15*10 ＋ 3 ＝ 153 | 
| 15 | 15*15 ＋ 5 ＝ 230  | 
| 20 | 15*20 ＋ 6 ＝ 306 | 
字数超过20后，加5也不能满足了。
写了个方法，调用**NSStringDrawing**框架下获取文字宽带的方法，结果发现
```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"testLab width = %f",_testLab.frame.size.width);
    
    [self getStringWidth:@"一一一一一一一一一一" front:[UIFont systemFontOfSize:10]];
}

- (void)getStringWidth:(NSString *)str front:(UIFont *)strFront
{
    NSDictionary *attributes =[NSDictionary dictionaryWithObjectsAndKeys:strFront, NSFontAttributeName, nil];
    
    CGSize stringSize = [str sizeWithAttributes:attributes];// 规定字符字体获取字符串Size，再获取其宽度。
    CGFloat width = stringSize.width;
    NSLog(@" width= %f",width);
} ```
xcode7下是这样的（托一个小伙伴运行了下）
![A2E9B39F90A5FD36E17E3ED8CD9AEB1E.jpg](http://upload-images.jianshu.io/upload_images/2030399-ab6419de8523db7b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
但是xcode8下是这样的

![5ADC7F82-490E-4A22-9B67-8CF969146808.png](http://upload-images.jianshu.io/upload_images/2030399-090fd0ace034d391.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**sizeWithAttributes**这个方法不会撒谎，所以调这个方法的基本都没问题。
但是如果简单的根据字体个数来算lable的宽度，font * 字数，那就可以根据字数适当加几个坐标。

| font | 一个字占宽 | 
|: ---- :|:-------------:| 
| 10 |10.220 | 
| 11 | 11.242| 
| 12 | 12.252| 
|13 | 13.260 | 
| 14 | 14.288 | 
| 15 | 15.300 | 
| 20 | 20.380 | 

![屏幕快照 2016-09-14 下午6.17.09.png](http://upload-images.jianshu.io/upload_images/2030399-e0a79a85fb761b22.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
so,手写frame的时候注意多给一点点空间。
