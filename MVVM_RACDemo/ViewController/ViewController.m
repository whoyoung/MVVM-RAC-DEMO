//
//  ViewController.m
//  MVVM_RACDemo
//
//  Created by 杨虎 on 2018/4/17.
//  Copyright © 2018年 杨虎. All rights reserved.
//

// Source code referred from http://www.cnblogs.com/ludashi/p/4925042.html
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "LoginViewModel.h"
@interface ViewController ()
@property (nonatomic, weak) UITextField *userNameField;
@property (nonatomic, weak) UITextField *passwordField;
@property (nonatomic, weak) UIButton *loginBtn;

@property (nonatomic, strong) LoginViewModel *viewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self signalSwitch];
//    [self combineSignal];
//    [self mergeSignal];
    
    [self setupComponent];
    [self bindViewModel];
}

- (void)setupComponent {
    UITextField *userNameField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, ScreenWidth-2*30, 44)];
    userNameField.borderStyle = UITextBorderStyleLine;
    userNameField.backgroundColor = [UIColor orangeColor];
    _userNameField = userNameField;
    [self.view addSubview:userNameField];
    
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100+44+20, ScreenWidth-2*30, 44)];
    passwordField.borderStyle = UITextBorderStyleLine;
    passwordField.backgroundColor = [UIColor orangeColor];
    _passwordField = passwordField;
    [self.view addSubview:passwordField];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 100+(44+20)*2, ScreenWidth-2*30, 44)];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[UIColor grayColor]];
    loginBtn.enabled = NO;
    _loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
}

- (void)bindViewModel {
    _viewModel = [[LoginViewModel alloc] init];
    RAC(self.viewModel,model.userName) = self.userNameField.rac_textSignal;
    RAC(self.viewModel,model.password) = self.passwordField.rac_textSignal;
    RAC(self.loginBtn,enabled) = [self.viewModel buttonIsValid];
    
    [self btnClick];
    
    @weakify(self);
    [self.viewModel.successObject subscribeNext:^(NSArray *x) {
        @strongify(self);
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"result" message:[NSString stringWithFormat:@"userName=%@, password=%@",x[0],x[1]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }];
}

- (void)btnClick {
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [_viewModel login];
    }];
}

- (void)mergeSignal {
    RACSubject *letter = [RACSubject subject];
    RACSubject *number = [RACSubject subject];
    RACSubject *chinese = [RACSubject subject];
    
    [[RACSignal merge:@[letter,number,chinese]] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [letter sendNext:@"A"];
    [letter sendNext:@"B"];
    [number sendNext:@"1"];
    [chinese sendNext:@"你好"];
}

- (void)combineSignal {
    RACSubject *letter = [RACSubject subject];
    RACSubject *number = [RACSubject subject];
    
    [[RACSignal combineLatest:@[letter,number] reduce:^(NSString *letter, NSString *number){
        return [letter stringByAppendingString:number];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [letter sendNext:@"A"];
    [letter sendNext:@"B"];
    [number sendNext:@"1"];
    [letter sendNext:@"C"];
    [number sendNext:@"2"];
}

- (void)signalSwitch {
    RACSubject *google = [RACSubject subject];
    RACSubject *baidu = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    RACSignal *switchSignal = [signalOfSignal switchToLatest];
    
    [[switchSignal map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"https://www.%@.com",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signalOfSignal sendNext:baidu];
    [baidu sendNext:@"baidu"];
    [google sendNext:@"google"];
    NSLog(@"--------seperator line--------");
    [signalOfSignal sendNext:google];
    [baidu sendNext:@"baidu"];
    [google sendNext:@"google"];
}

- (void)uppercaseString {
    //    RACSequence *sequence = [@[@"you", @"are", @"beautiful"] rac_sequence];
    //    RACSignal *signal =  sequence.signal;
    //    RACSignal *capitalizedSignal = [signal map:^id(NSString * value) {
    //        return [value capitalizedString];
    //        }];
    //    [signal subscribeNext:^(NSString * x) {
    //        NSLog(@"signal --- %@", x);
    //        }];
    //    [capitalizedSignal subscribeNext:^(NSString * x) {
    //        NSLog(@"capitalizedSignal --- %@", x);
    //        }];
    
    [[[@[@"you", @"are", @"beautiful"] rac_sequence].signal
      map:^id(NSString * value) {
          NSLog(@"signal --- %@", value);
          return [value capitalizedString];
      }] subscribeNext:^(id x) {
          NSLog(@"capitalizedSignal --- %@", x);
      }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
