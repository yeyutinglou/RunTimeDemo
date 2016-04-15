//
//  People.h
//  RunTime
//
//  Created by jyd on 16/4/13.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject 
{
    NSString *job;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;


///属性
-(NSDictionary *)allPropertier;
///成员变量
-(NSDictionary *)allIvars;
///方法
-(NSDictionary *)allMethods;


@end
