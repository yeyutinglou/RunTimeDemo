//
//  Bird.m
//  RunTime
//
//  Created by jyd on 16/4/15.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import "Bird.h"
#import "Model.h"
@implementation Bird

//不动态加载方法，进入下一步
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    return NO;
}
//不指定对象响应方法
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

//返回方法选择器
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"sing"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

//修改响应对象

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    Model *model = [[Model alloc] init];
    model.name = @"dyw";
    [anInvocation invokeWithTarget:model];
}
//若forwardInvocation没有实现，则会调用此方法
-(void)doesNotRecognizeSelector:(SEL)aSelector
{
    
}

@end
