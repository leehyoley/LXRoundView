//
//  LXRoundView.h
//  RoundItmes
//
//  Created by XiaoleiLi on 16/8/5.
//  Copyright © 2016年 leehyoley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JARoundCell.h"
@class LXRoundView;
@protocol LXRoundViewDelegate <NSObject>
-(void)roundView:(LXRoundView*)roundView didShowItemAtIndex:(NSInteger)itemIndex;
@end

@interface LXRoundView : UIView
@property (nonatomic,strong) NSArray<NSString*> *dataSource;//图片urlString或者imagename
@property (nonatomic,copy) NSString *imageHolderName;
@property (nonatomic,weak) id<LXRoundViewDelegate> delegate;
@property (nonatomic,assign) LXRoundStyle roundStyle;
@end
