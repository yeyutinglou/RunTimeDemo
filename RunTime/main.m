//
//  main.m
//  RunTime
//
//  Created by jyd on 16/4/12.
//  Copyright © 2016年 jyd. All rights reserved.
//


#import <Foundation/Foundation.h>
#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

void sayFunction(id self, SEL _cmd, id some)
{
    NSLog(@"%@的%@说%@",object_getIvar(self, class_getInstanceVariable([self class], "_age")),[self valueForKey:@"name"],some);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //动态创建类对象
        Class People = objc_allocateClassPair([NSObject class], "People", 0);
        //添加一个 NSstring *_name 的成员变量
        class_addIvar(People, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        //添加一个 NSInterger _age 的成员变量
        class_addIvar(People, "_age", sizeof(NSInteger), sizeof(NSInteger), @encode(NSInteger));
        //注册方法名为say的方法
        SEL s = sel_registerName("say:");
        //为该类添加名为say的方法
        class_addMethod(People, s, (IMP)sayFunction, "@:@");
        //注册该类
        objc_registerClassPair(People);
        //创建类的实例
        id peopleInstance = [[People alloc] init];
        [peopleInstance setValue:@"小明" forKey:@"name"];
        //从类中取出成员变量
        Ivar ageIvar = class_getInstanceVariable(People, "_age");
        //为成员变量赋值
        object_setIvar(peopleInstance, ageIvar, @18);
        //调用s方法
       /* 
        objc_msgSend(peopleInstance, s, @"大家好!");
        默认会出现以下错误：
        objc_msgSend()报错Too many arguments to function call ,expected 0,have3
        直接通过objc_msgSend(self, setter, value)是报错，说参数过多。
        请这样解决：
        Build Setting–> Apple LLVM 7.0 – Preprocessing–> Enable Strict Checking of objc_msgSend Calls 改为 NO
        */
        
        /*
        ((void (*)(id, SEL, id))objc_msgSend)(peopleInstance, s, @"大家好");
        强制转换objc_msgSend函数类型为带三个参数且返回值为void函数，然后才能传三个参数
         */
        objc_msgSend(peopleInstance, s, @"大家好!");
       ((void (*)(id, SEL, id))objc_msgSend)(peopleInstance, s, @"大家好");
        //先销毁实例对象，才能销毁类对象
        peopleInstance = nil;
        //销毁类
        objc_disposeClassPair(People);
        
    }
    return 0;
}
