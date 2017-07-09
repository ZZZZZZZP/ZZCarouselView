# ZZCarouselView
超轻量级图片轮播工具类

//导入头文件
#import "ZZCarouselView.h"
//遵守协议
<ZZCarouselViewDelegate>

1.初始化对象

NSArray *imgNames = @[@"img_1",@"img_2",@"img_3"];
//or
NSArray *images  = @[[UIImage imageNamed:@"img_1"],
                     [UIImage imageNamed:@"img_2"],
                     [UIImage imageNamed:@"img_3"]];

ZZCarouselView *carousel = [ZZCarouselView carouselWithImages:imgNames];
//or
ZZCarouselView *carousel = [ZZCarouselView carouselWithImages:images];

2.使用对象

//设置Frame
carousel.frame = CGRectMake(0, 0, self.view.width, 200);
//设置代理(需实现点击图片代理方法)
carousel.delegate = self;
//设置轮播间隔时间(默认为2秒)
carousel.carouselTimeInterval = 2;
//添加到父控件
[self.view addSubview:carousel];

3.监听图片点击(需设置代理)
- (void)carouselView:(ZZCarouselView *)carouselView clickImage:(UIImage *)image index:(NSInteger)index
{
    //do somethings
}



