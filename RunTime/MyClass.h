//
//  MyClass.h
//  RunTime
//
//  Created by jyd on 16/4/17.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *string;

-(void)method;

+(void)classMethod;
@end
