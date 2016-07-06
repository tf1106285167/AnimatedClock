//
//  ViewController.m
//  表盘
//
//  Created by 玉女峰峰主 on 15-11-23.
//  Copyright (c) 2015年 玉女峰峰主. All rights reserved.
//

#import "ViewController.h"

#define KSCreenWidth [UIScreen mainScreen].bounds.size.width
#define KSCreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property(nonatomic,strong)UIImageView *clockImage;//时钟图片
@property(nonatomic,strong)CALayer *secondLayer;//秒钟
@property(nonatomic,strong)CALayer *minuteLayer;//分钟
@property(nonatomic,strong)CALayer *hourseLayer;//时钟

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //此处右边是调用懒加载，所以要用self,而不能用下划线_
    [self.view addSubview:self.clockImage];
    //将时分秒的图层添加到时钟图片上
    [_clockImage.layer addSublayer:self.secondLayer];
    [_clockImage.layer addSublayer:self.minuteLayer];
    [_clockImage.layer addSublayer:self.hourseLayer];
    
    [self timeChange];//一加载出来就能显示
    
    //每秒调用60次，更精确，用CADisplayLink可以实现不停重绘。
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeChange)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}

-(void)timeChange{
    
    CGFloat secondAngle = M_PI * 2 / 60.0; //一秒钟的角度
    CGFloat minuteAngle = M_PI * 2 / 60.0; //一分钟的角度
    CGFloat hourseAngle = M_PI * 2 / 12.0; //一小时的角度
    
    CGFloat angleSecond = [[NSCalendar currentCalendar]component:NSCalendarUnitSecond fromDate:[NSDate date]] * secondAngle; //当前秒数*每秒的角度
    CGFloat angleMinute = [[NSCalendar currentCalendar]component:NSCalendarUnitMinute fromDate:[NSDate date]] * minuteAngle + angleSecond / 60.0; //当前分钟数 * 每分的角度 + 秒钟数/60.0（每秒一个刻度）
    CGFloat angleHourse = [[NSCalendar currentCalendar]component:NSCalendarUnitHour fromDate:[NSDate date]] * hourseAngle + angleMinute / 12.0; //当前时针数 * 每小时的角度 + 分钟数/12(每12分种一个刻度)
    //1:绕z轴旋转angleSecond角度
    _secondLayer.transform = CATransform3DMakeRotation(angleSecond, 0, 0, 1);
    _minuteLayer.transform = CATransform3DMakeRotation(angleMinute, 0, 0, 1);
    _hourseLayer.transform = CATransform3DMakeRotation(angleHourse, 0, 0, 1);
    
}

//懒加载
-(UIImageView *)clockImage{
    
    if(_clockImage == nil){
        
        _clockImage = [[UIImageView alloc]initWithFrame:CGRectMake(KSCreenWidth/2-100, KSCreenHeight/2-150, 200, 200)];
        _clockImage.image = [UIImage imageNamed:@"钟表"];
    }
    return _clockImage;
}

-(CALayer *)secondLayer{
    
    if(_secondLayer == nil){
        
        _secondLayer= [CALayer layer];
        _secondLayer.bounds = CGRectMake(0, 0, 2, 80);
        _secondLayer.backgroundColor = [UIColor redColor].CGColor;
        _secondLayer.position = CGPointMake(_clockImage.bounds.size.width / 2, _clockImage.bounds.size.height / 2);//设置位置
        _secondLayer.anchorPoint = CGPointMake(.5, 1);//设置锚点
    }
    return _secondLayer;
}

-(CALayer *)minuteLayer{
    
    if(_minuteLayer == nil){
        _minuteLayer = [CALayer layer];
        _minuteLayer.bounds = (CGRect){0, 0, 4, 60};
        _minuteLayer.backgroundColor = [UIColor blackColor].CGColor;
        _minuteLayer.position = (CGPoint){_clockImage.bounds.size.width / 2, _clockImage.bounds.size.height / 2};
        _minuteLayer.anchorPoint = (CGPoint){.5, 1};
    }
    return _minuteLayer;
}

-(CALayer *)hourseLayer{
    
    if(_hourseLayer == nil){
        _hourseLayer = [CALayer layer];
        _hourseLayer.bounds = (CGRect){0, 0, 4, 40};
        _hourseLayer.backgroundColor = [UIColor blackColor].CGColor;
        _hourseLayer.position = (CGPoint){_clockImage.bounds.size.width / 2, _clockImage.bounds.size.height / 2};
        _hourseLayer.anchorPoint = (CGPoint){.5, 1};
    }
    return _hourseLayer;
}

@end
