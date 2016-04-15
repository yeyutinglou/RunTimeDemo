//
//  Model.m
//  RunTime
//
//  Created by jyd on 16/4/15.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import "Model.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@implementation Model

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        for (NSString *key in dic.allKeys) {
            id value = dic[key];
            SEL setter = [self propertySetterByKey:key];
            if (setter) {
                ((void (*)(id, SEL, id))objc_msgSend)(self, setter, value);
            }
            
        }
    }
    return self;
}

-(NSDictionary *)covertToDictionary
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (count != 0) {
        NSMutableDictionary *resultDic = [@{} mutableCopy];
        for (NSUInteger i = 0; i < count; i++) {
            const char *propertyName = property_getName(properties[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            SEL getter = [self propertyGetterByKey:name];
            if (getter) {
                id  value = ((id(*)(id, SEL))(objc_msgSend))(self, getter);
                if (value) {
                    resultDic[name] = value;
                }else{
                    resultDic[name] = @"nil";
                }
            }
        }
        free(properties);
        return resultDic;
    }
    free(properties);
    return nil;
}

#pragma mark - private


-(SEL)propertySetterByKey:(NSString *)key{
    NSString *propertySetterName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];
    SEL setter = NSSelectorFromString(propertySetterName);
    if ([self respondsToSelector:setter]) {
        return setter;
    }
    return nil;
}

-(SEL)propertyGetterByKey:(NSString *)key
{
    SEL getter = NSSelectorFromString(key);
    if ([self respondsToSelector:getter]) {
        return getter;
    }
    return nil;
}

#pragma mark - 动态加载方法
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([NSStringFromSelector(sel) isEqualToString:@"sing"]) {
        class_addMethod(self, sel, (IMP) otherSing, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void otherSing(id self, SEL cmd)
{
    NSLog(@"%@",((Model *)self).name);
}

@end
