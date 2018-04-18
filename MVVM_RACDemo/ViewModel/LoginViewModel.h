//
//  LoginViewModel.h
//  MVVM_RACDemo
//
//  Created by 杨虎 on 2018/4/18.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "LoginModel.h"

@interface LoginViewModel : NSObject
@property (nonatomic, strong) LoginModel *model;

@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (id)buttonIsValid;
- (void)login;
@end
