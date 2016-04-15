//
//  People+height.m
//  RunTime
//
//  Created by jyd on 16/4/15.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import "People+height.h"
#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif
@implementation People (height)

-(void)setHeightValue:(NSNumber *)heightValue
{
    //设置关联对象
    /*
     * OBJC_ASSOCIATION_ASSIGN  弱引用
     * OBJC_ASSOCIATION_RETAIN_NONATOMIC 非原子性 强引用
     * OBJC_ASSOCIATION_COPY_NONATOMIC 非原子性 copy
     * OBJC_ASSOCIATION_RETAIN 原子性 强引用
     * OBJC_ASSOCIATION_COPY 原子性 copy
     */
    objc_setAssociatedObject(self, @selector(heightValue), heightValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)heightValue
{
    //得到关联对象
    return objc_getAssociatedObject(self, @selector(heightValue));
}

-(void)setHeightCallBack:(CodingCallBack)heightCallBack
{
    objc_setAssociatedObject(self, @selector(heightCallBack), heightCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(CodingCallBack)heightCallBack
{
    return objc_getAssociatedObject(self, @selector(heightCallBack));
}



@end
