//
//  Model.h
//  RunTime
//
//  Created by jyd on 16/4/15.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *job;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

-(NSDictionary *)covertToDictionary;


-(void)sing;
@end
