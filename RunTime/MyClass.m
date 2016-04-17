//
//  MyClass.m
//  RunTime
//
//  Created by jyd on 16/4/17.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import "MyClass.h"
@interface MyClass (){
    NSInteger instance1;
    NSInteger instance2;
}
@property (nonatomic, assign) NSUInteger integer;

-(void)methodWithArg1:(NSInteger)arg arg2:(NSInteger)arg;

@end

@implementation MyClass

+(void)classMethod{
    
}
@end
