//
//  People.m
//  RunTime
//
//  Created by jyd on 16/4/13.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import "People.h"
#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif
@implementation People


-(NSDictionary *)allPropertier{
    unsigned int count = 0;
    //获取类的所有属性，如果没有属性 count就为0
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *resultDic = [@{} mutableCopy];
    
    for (NSUInteger i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:name];
        if (propertyValue) {
            resultDic[name] = propertyValue;
        }else{
            resultDic[name] = @"key 对应的 value 不能为空";
        }
    }
    //释放内存
    free(properties);
    return resultDic;
}

-(NSDictionary *)allIvars{
    unsigned int count = 0;
    NSMutableDictionary *resultDic = [@{} mutableCopy];
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (NSUInteger i = 0; i < count; i++) {
        //成员变量名称
        const char *varName = ivar_getName(ivars[i]);
        NSString *name = [NSString stringWithUTF8String:varName];
        id varValue = [self valueForKey:name];
        if (varValue) {
            resultDic[name] = varValue;
        }else{
            resultDic[name] = @"不能为空";
        }
    }
    
    free(ivars);
    
    return  resultDic;
}

-(NSDictionary *)allMethods{
    unsigned int count = 0;
    NSMutableDictionary *resultDic = [@{} mutableCopy];
    Method *methods = class_copyMethodList([self class], &count);
    
    for (NSUInteger i = 0; i < count; i++) {
        //获取方法名称
        SEL methodSEL = method_getName(methods[i]);
        const char *methodName = sel_getName(methodSEL);
        NSString *name = [NSString stringWithUTF8String:methodName];
        
        //获取方法参数列表
        int arguments = method_getNumberOfArguments(methods[i]);
        
        resultDic[name] = @(arguments - 2);
        
    }
    
    free(methods);
    
    return resultDic;
}




@end
