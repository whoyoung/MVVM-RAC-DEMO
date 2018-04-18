//
//  LoginViewModel.m
//  MVVM_RACDemo
//
//  Created by 杨虎 on 2018/4/18.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "LoginViewModel.h"

@interface LoginViewModel()
@property (nonatomic, strong) RACSignal *userNameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) NSArray *requestData;
@end

@implementation LoginViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _model = [[LoginModel alloc] init];
        _userNameSignal = RACObserve(self, model.userName);
        _passwordSignal = RACObserve(self, model.password);
        _successObject = [RACSubject subject];
        _failureObject = [RACSubject subject];
        _errorObject = [RACSubject subject];
    }
    return self;
}

- (id)buttonIsValid {
    RACSignal *isValid = [RACSignal combineLatest:@[_userNameSignal,_passwordSignal] reduce:^id(NSString *userName,NSString *password){
        return @(userName.length > 3 && password.length > 3);
    }];
    return isValid;
}
- (void)login {
    _requestData = @[self.model.userName,self.model.password];
    [self.successObject sendNext:_requestData];
}
@end
