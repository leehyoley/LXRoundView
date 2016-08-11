//
//  LXRoundLayout.h
//  RoundItmes
//
//  Created by XiaoleiLi on 16/8/5.
//  Copyright © 2016年 leehyoley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXRoundLayout : UICollectionViewFlowLayout
@property (nonatomic,copy) void(^didScrollAt)(NSInteger index);
@end
