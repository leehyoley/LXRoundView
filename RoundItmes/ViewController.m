//
//  ViewController.m
//  RoundItmes
//
//  Created by XiaoleiLi on 16/8/5.
//  Copyright © 2016年 leehyoley. All rights reserved.
//

#import "ViewController.h"
#import "LXRoundView.h"
@interface ViewController ()<LXRoundViewDelegate>
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  self.view.bounds.size.width, 300)];
    self.imageView.image = [UIImage imageNamed:@"icon1"];
    [self.view addSubview:self.imageView];
    
    //样式一（使用本地图片）
    LXRoundView *view =[[LXRoundView alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 100)];
    view.dataSource = @[@"icon1",@"icon2",@"icon3",@"icon4",@"icon5",@"icon6",@"icon7",@"icon8",@"icon9"];
    view.delegate = self;
    [self.view addSubview:view];
    
    
    //样式二 (使用url图片)
    view =[[LXRoundView alloc]initWithFrame:CGRectMake(0, 350, self.view.bounds.size.width, 100)];
    view.dataSource = @[@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3637558653,1735813698&fm=58",
                        @"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3382581011,2165830761&fm=58",
                        @"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3622998656,1157983358&fm=58",
                        @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1537639143,1137876288&fm=58",
                        @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1008743001,3197757361&fm=58",
                        @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3112135857,2076472476&fm=58",
                        @"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=1844027978,262879452&fm=58",
                        @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1537639143,1137876288&fm=58",
                        @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=3595307324,1154284414&fm=85&s=4840CF180BF362900A100CCF030030E2"];
    //条目类型
    view.roundStyle = LXRoundStyle_Heart;
    view.imageHolderName = @"icon1";
    [self.view addSubview:view];
}

-(void)roundView:(LXRoundView *)roundView didShowItemAtIndex:(NSInteger)itemIndex{
    self.imageView.image = [UIImage imageNamed:roundView.dataSource[itemIndex]];
}

@end
