//
//  LXRoundView.m
//  RoundItmes
//
//  Created by XiaoleiLi on 16/8/5.
//  Copyright © 2016年 leehyoley. All rights reserved.
//

#import "LXRoundView.h"
#import "LXRoundLayout.h"

#define ITEM_COUNT    9 //条目数
#define REPEAT_TIMES  60//重复次数(60倍时，每条数据重复60次)
/*
 *模仿空格效果，使用collectionView实现，因为有头和尾，原生的collectionView无法像目标效果一样无限循环,
 *故应当加大dataSource，使里面的文件多重复几遍，让用户一次无法滑动到结尾，
 *当停止滑动动画后，再选择到中间位置的一样的图片，达到可以无限左右滑动假象，（因为collectionView自带重用机制，实测效果很好，不会因为多了几组重复数据地址影响性能）
 */


@interface LXRoundView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView*collectionView;
@property (nonatomic, strong) LXRoundLayout *roundLayout;
@property (nonatomic,strong) NSMutableArray *showArray;
@property (nonatomic,assign) NSInteger currentItem;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation LXRoundView
-(instancetype)initWithFrame:(CGRect)frame{
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width*100/375.0);
    if (self= [super initWithFrame:frame]) {
        self.roundLayout =[[LXRoundLayout alloc]init];
        self.roundStyle = LXRoundStyle_Circle;
        _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:self.roundLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alpha = 1;
        _collectionView.clipsToBounds = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"JARoundCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"JARoundCell"];
        //        _collectionView.decelerationRate = 0.95;
        [self addSubview:_collectionView];
        //        [self setClipsToBounds:YES];
        self.backgroundColor = [UIColor clearColor];
        [self setHidden:YES];
        
        __weak typeof(self) weakSelf = self;
        [self.roundLayout setDidScrollAt:^(NSInteger index) {
            weakSelf.currentItem = index%ITEM_COUNT;
            if ([weakSelf.delegate respondsToSelector:@selector(roundView:didShowItemAtIndex:)]) {
                [weakSelf.delegate roundView:weakSelf didShowItemAtIndex:index%ITEM_COUNT];
            }
        }];
    }
    return self;
}

-(void)setDelegate:(id<LXRoundViewDelegate>)delegate{
    _delegate = delegate;
    
}

-(void)setDataSource:(NSArray<NSString *> *)dataSource{
    _dataSource = dataSource;
    
    for (int i = 0; i<dataSource.count; i++) {
        NSString *str = dataSource[i];
        
        for (int j = 0; j<REPEAT_TIMES; j++) {
            self.showArray[j*ITEM_COUNT+i] = str;
        }
        
    }
    
    [self.collectionView reloadData];
    
    NSInteger centerItem = ITEM_COUNT*REPEAT_TIMES/2+self.dataSource.count/2;
    
    NSIndexPath *index = [NSIndexPath indexPathForItem:centerItem inSection:0];
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    [self setHidden:NO];
    
}

-(NSMutableArray *)showArray{
    if (!_showArray) {
        _showArray = [NSMutableArray array];
        for (int i = 0; i<ITEM_COUNT*REPEAT_TIMES; i++) {
            [_showArray addObject:@""];
        }
    }
    return _showArray;
}

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JARoundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JARoundCell" forIndexPath:indexPath];
    cell.holderName = self.imageHolderName;
    cell.imageName = self.showArray[indexPath.row];
    [cell makeStyle:self.roundStyle Corner:self.bounds.size.height/2];
    return cell;
}
#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    //取消之前可能未执行的timer
    [self.timer invalidate];
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    //选择条目0.5s后动画已经播完，不使用动画以实现无缝回滚到中间对应条目
    NSIndexPath *index = [NSIndexPath indexPathForItem:indexPath.item%ITEM_COUNT+(REPEAT_TIMES*ITEM_COUNT)/2 inSection:0];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(jumpToTargetItem) userInfo:index repeats:NO];
}

-(void)jumpToTargetItem{
    [self.collectionView scrollToItemAtIndexPath:self.timer.userInfo atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.timer invalidate];
    self.timer = nil;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //滑动结束时调用，不使用动画以实现无缝回滚到中间对应条目
    NSIndexPath *index = [NSIndexPath indexPathForItem:self.currentItem+(REPEAT_TIMES*ITEM_COUNT)/2 inSection:0];
    NSLog(@"index%d",index.row);
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

@end
