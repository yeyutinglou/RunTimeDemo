//
//  People+height.h
//  RunTime
//
//  Created by jyd on 16/4/15.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import "People.h"

typedef void(^CodingCallBack)();

@interface People (height)

@property (nonatomic, strong) NSNumber *heightValue;
@property (nonatomic, copy) CodingCallBack heightCallBack;

@end
