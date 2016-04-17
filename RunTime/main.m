//
//  main.m
//  RunTime
//
//  Created by jyd on 16/4/12.
//  Copyright © 2016年 jyd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "People.h"
#import "People+height.h"
#import "Model.h"
#import "Bird.h"
#import "MyClass.h"
#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

void sayFunction(id self, SEL _cmd, id some)
{
    NSLog(@"%@的%@叫%@",object_getIvar(self, class_getInstanceVariable([self class], "_age")),[self valueForKey:@"name"],some);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //动态创建类对象
        Class Animal = objc_allocateClassPair([NSObject class], "Animal", 0);
        //添加一个 NSstring *_name 的成员变量
        class_addIvar(Animal, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        //添加一个 NSInterger _age 的成员变量
        class_addIvar(Animal, "_age", sizeof(NSInteger), sizeof(NSInteger), @encode(NSInteger));
        //注册方法名为say的方法
        SEL s = sel_registerName("say:");
        //为该类添加名为say的方法
        class_addMethod(Animal, s, (IMP)sayFunction, "@:@");
        //注册该类
        objc_registerClassPair(Animal);
        //创建类的实例
        id peopleInstance = [[Animal alloc] init];
        [peopleInstance setValue:@"dog" forKey:@"name"];
        //从类中取出成员变量
        Ivar ageIvar = class_getInstanceVariable(Animal, "_age");
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
        objc_msgSend(peopleInstance, s, @"汪汪汪!");
       ((void (*)(id, SEL, id))objc_msgSend)(peopleInstance, s, @"汪汪汪");
        //先销毁实例对象，才能销毁类对象
        peopleInstance = nil;
        //销毁类
        objc_disposeClassPair(Animal);
        
        People *dyw = [[People alloc] init];
        dyw.name = @"dyw";
        dyw.age = 24;
        [dyw setValue:@"programmer" forKey:@"job"];
        dyw.heightValue = @(178);
        dyw.heightCallBack = ^(){
            NSLog(@"write");
        };
        dyw.heightCallBack();
        
        NSDictionary *propertyResultDic = [dyw allPropertier];
        for (NSString *propertyName in propertyResultDic) {
            NSLog(@"propertyName:%@, propertyValue:%@",propertyName,propertyResultDic[propertyName]);
        }
        
        NSDictionary *ivarResultDic = [dyw allIvars];
        for (NSString *ivarName in ivarResultDic) {
            NSLog(@"ivarName:%@, ivarValue:%@",ivarName,ivarResultDic[ivarName]);
        }
        
        NSDictionary *methodResultDic = [dyw allMethods];
        for (NSString *methodName in methodResultDic) {
            NSLog(@"methodName:%@, argumentsCount:%@",methodName,methodResultDic[methodName]);
        }
        
        
        //model
        NSDictionary *dic = @{@"name": @"dyw",
                              @"job" : @"programmer",
                              };
        Model *model = [[Model alloc] initWithDictionary:dic];
        NSDictionary *covertedDic = [model covertToDictionary];
        NSLog(@"%@",covertedDic);
        [model sing];
        
        //bird
        Bird *bird = [[Bird alloc] init];
        bird.name = @"bird";
        ((void(*)(id, SEL))objc_msgSend)((id)bird, @selector(sing));
        
        //myClass
        MyClass *myClass = [[MyClass alloc] init];
        unsigned int outCout = 0;
        Class cls = myClass.class;
        
        //类名
        NSLog(@"class name: %s",class_getName(cls));
        //父类
        NSLog(@"super class name: %s",class_getName(class_getSuperclass(cls)));
        //是否有元素
        NSLog(@"myClass is %@ a meta-class",class_isMetaClass(cls) ? @"" : @"not");
        Class meta_class = objc_getMetaClass(class_getName(cls));
        NSLog(@"%s's meta-class is %s",class_getName(cls),class_getName(meta_class));
        //变量实例大小
        NSLog(@"instance size: %zu",class_getInstanceSize(cls));
        //成员变量
        Ivar *ivars = class_copyIvarList(cls, &outCout);
        for (int i = 0; i < outCout; i++) {
            Ivar ivar = ivars[i];
            NSLog(@"instance variable's name: %s at index: %d",ivar_getName(ivar),i);
        }
        free(ivars);
        
        Ivar string = class_getInstanceVariable(cls, "string");
        if (string != NULL) {
            NSLog(@"instance variable's name: %s",ivar_getName(string));
        }
        
        //属性
        objc_property_t *properties = class_copyPropertyList(cls, &outCout);
        for (int i = 0; i < outCout; i++) {
            objc_property_t property = properties[i];
            NSLog(@"property's name: %s at index: %d",property_getName(property),i);
        }
        free(properties);
        
        objc_property_t array = class_getProperty(cls, "array");
        if (array != NULL) {
            NSLog(@"property's name: %s",property_getName(array));
        }
        
        //方法
        Method *methods = class_copyMethodList(cls, &outCout);
        for (int i = 0; i < outCout; i++) {
            Method method = methods[i];
            NSLog(@"method's name: %p",method_getName(method));
        }
        free(methods);
        //实例方法
        Method method = class_getInstanceMethod(cls, @selector(method));
        if (method != NULL) {
            NSLog(@"method %p",method_getName(method));
        }
        //类方法
        Method classMethod = class_getClassMethod(cls, @selector(classMethod));
        if (classMethod != NULL) {
            NSLog(@"classMethod: %p",method_getName(classMethod));
        }
        //协议
        Protocol *__unsafe_unretained *protocols = class_copyProtocolList(cls, &outCout);
        Protocol *protocol;
        for (int i = 0; i < outCout; i++) {
            protocol = protocols[i];
            NSLog(@"protocol's name: %s",protocol_getName(protocol));
        }
        
        NSLog(@"my class is %@ responsed to protocol%s",class_conformsToProtocol(cls, protocol) ? @"" : @"not",protocol_getName(protocol));
    }
    return 0;
}
